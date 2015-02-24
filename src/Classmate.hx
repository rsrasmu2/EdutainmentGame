import starling.display.Sprite;
import starling.text.TextField;
import StateMachine;
import MathEngine;
import starling.display.Image;

class Classmate extends Sprite
{
	private var dialogue : Array<String>;
	private var state : StateMachine;
	//private var text : TextField;
	private var textureString: String;
	private var p : Player;

	private function new(s:Array<String>, st:StateMachine, ?texStr: String)
	{
		super();
		dialogue = s;
		p = null;
		state = st;
		textureString = texStr;
		if (textureString == null) { textureString = "a_1"; }
		state.x = 0;
		
	}

	public function startDialogue(ply:Player)
	{	addChild(state); p = ply;}

	private function nextDialogue(st:StateMachine)
	{
		removeChild(state);
		state = st; state.x = 0;
		addChild(state);
	}

	private function endDialogue()
	{
		removeChild(state);
		p.stopTalking();
		p = null;
		resetDialogue();
	}

	//must be overriden
	private function resetDialogue(){}

	public function setPosition(xPos:UInt, yPos: UInt)
	{
		x = xPos * Overworld.GRID_SIZE;
		y = yPos * Overworld.GRID_SIZE;
	}
}




class TalkMate extends Classmate
{
	private var currentIndex : Int;

	public function new(s:Array<String>, ?texStr:String)
	{
		super(s, new StateMachine(
		[new StateText(175,50,s[0]),
		new StateButton("Next",setNext,endDialogue)],50), texStr);
		currentIndex = 0;
		var me = new Image(Root.assets.getTexture(textureString));
		me.width = 25;
		me.height = 26;
		me.smoothing = "none";
		//text = new TextField(Overworld.GRID_SIZE,Overworld.GRID_SIZE,"C","Fipps",20);
		addChild(me);
	}

	private function setNext()
	{
		if(++currentIndex >= dialogue.length)
			endDialogue();
		else
		{
			nextDialogue(new StateMachine(
			[new StateText(175,50,dialogue[currentIndex]),
			new StateButton("Next",setNext,endDialogue)],50));
		}
	}

	override private function resetDialogue()
	{
		currentIndex = 0;
		state = new StateMachine(
		[new StateText(175,50,dialogue[currentIndex]),
		new StateButton("Next",setNext,endDialogue)],50);
		state.x = 0;
	}
}






class BattleMate extends Classmate
{
	private var operation : OPERATION;
	private var difficulty : DIFFICULTY;
	private var ques : MathProblem;
	private var currentIndex : Int;

	public function new(s:Array<String>, op:OPERATION, diff:DIFFICULTY, ?texStr: String)
	{
		super(s, new StateMachine(
		[new StateText(175,50,s[0]),
		new StateButton("Next",setNext,endDialogue)],50), texStr);
		currentIndex = 0;
		operation = op;
		difficulty = diff;
		var me = new Image(Root.assets.getTexture(textureString));
		me.width = 25;
		me.height = 26;
		me.smoothing = "none";
		//text = new TextField(Overworld.GRID_SIZE,Overworld.GRID_SIZE,"C","Fipps",20);
		addChild(me);
	}
	
	private function battle()
	{
		removeChild(state);
		state = new StateMachine(
		[new StateText(175,50,dialogue[currentIndex]),
		new StateButton("Yes",startBattle,startBattle),
		new StateButton("No", endDialogue, endDialogue)], 50);
		//text = new TextField(Overworld.GRID_SIZE,Overworld.GRID_SIZE,"B","Fipps",20);
		state.x = 0;
		addChild(state);
	}
	
	private function setNext()
	{
		if (++currentIndex >= dialogue.length - 1)
			battle();
		else
		{
			nextDialogue(new StateMachine(
			[new StateText(175,50,dialogue[currentIndex]),
			new StateButton("Next",setNext,battle)],50));
		}
	}

	private function startBattle()
	{
		removeChild(state);
		ques = MathEngine.generateProblem(operation,difficulty);
		state = new StateMachine(
			[new StateText(125,50,ques.question),
			new StateInput(),
			new StateButton("Answer",checkAnswer,checkAnswer)],
			/*new StateText(125,50,"Answer is " + ques.answer),
			new StateButton("Cannot answer yet...",endDialogue,endDialogue)],*/
			50);
		state.x = 0;
		addChild(state);
	}

	override private function resetDialogue()
	{
		currentIndex = 0;
		state = new StateMachine(
		[new StateText(175,50,dialogue[currentIndex]),
		new StateButton("Next",setNext,endDialogue)],50);
		state.x = 0;
	}

	private function checkAnswer()
	{
		var ans = state.getAnswer();
		removeChild(state);
		state = new StateMachine(
		[new StateText(150,100,
		ques.answer == ans ? "You got the question right!"
		: "You got the question wrong..."),
		new StateButton("Exit",endDialogue,endDialogue)],100);
		addChild(state);
		state.x = 0;
	}
	
	override private function endDialogue()
	{
		removeChild(state);
		p.stopTalking();
		p = null;
		resetDialogue();
	}
}