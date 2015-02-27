import starling.display.Sprite;
import starling.text.TextField;
import StateMachine;
import MathEngine;
import starling.display.Image;

class Classmate extends Sprite
{
	public var me :Image;
	private var dialogue : Array<String>;
	private var state : StateMachine;
	private var p : Player;
	private var world : Overworld;

	private function new(s:Array<String>, st:StateMachine, texStr: String, world:Overworld)
	{
		super();
		dialogue = s;
		p = null;
		state = st;
		
		this.world = world;

		me = new Image(Root.assets.getTexture(texStr));
		me.scaleX = 2;
		me.scaleY = 2;
		me.smoothing = "none";
		addChild(me);
	}

	public function startDialogue(ply:Player)
	{	world.addChild(state); p = ply;}

	private function nextDialogue(st:StateMachine)
	{
		world.removeChild(state);
		state = st;
		world.addChild(state);
	}

	private function endDialogue()
	{
		world.removeChild(state);
		if(p != null)
		{
			p.stopTalking();
			p = null;
		}
		resetDialogue();
	}

	//must be overriden
	private function resetDialogue(){}

	public function setPosition(xPos:UInt, yPos: UInt)
	{
		x = xPos * Overworld.GRID_SIZE;
		y = yPos * Overworld.GRID_SIZE;
	}

	public function getPosition() : Dynamic
	{
		return {xPos : Std.int(x / Overworld.GRID_SIZE), yPos : Std.int(y / Overworld.GRID_SIZE)};
	}
}




class TalkMate extends Classmate
{
	private var currentIndex : Int;

	public function new(s:Array<String>, texStr:String = "a_1", world:Overworld)
	{
		super(s, new StateMachine(
		[new StateText(200,200,s[0]),
		new StateButton("Next",setNext,endDialogue)],200), texStr, world);
		currentIndex = 0;
	}

	private function setNext()
	{
		if(++currentIndex >= dialogue.length)
			endDialogue();
		else
		{
			nextDialogue(new StateMachine(
			[new StateText(200,200,dialogue[currentIndex]),
			new StateButton("Next",setNext,endDialogue)],200));
		}
	}

	override private function resetDialogue()
	{
		currentIndex = 0;
		state = new StateMachine(
		[new StateText(200,200,dialogue[currentIndex]),
		new StateButton("Next",setNext,endDialogue)],200);
	}
}

class BattleMate extends Classmate
{
	private var operation : OPERATION;
	private var difficulty : DIFFICULTY;
	private var ques : MathProblem;
	private var currentIndex : Int;
	private var curQuestion : UInt;
	private var questionNum : UInt;
	private var bubbleImage : Image;
	private var canChallenge : Bool;
	private var nextBattle : BattleMate;

	public function new(s:Array<String>, op:OPERATION, diff:DIFFICULTY, texStr: String = "a_1", qN : UInt = 1,
	canChallenge:Bool, world:Overworld)
	{
		super(s, new StateMachine(
		[new StateText(175,50,s[0]),
		new StateButton("Next",setNext,endDialogue)],50), texStr, world);
		currentIndex = curQuestion = 0; questionNum = qN;
		operation = op;
		difficulty = diff;
		bubbleImage = new Image(Root.assets.getTexture("bubble"));
		bubbleImage.x -= Overworld.GRID_SIZE;
		bubbleImage.y -= Overworld.GRID_SIZE;
		addChild(bubbleImage);
		this.canChallenge = canChallenge;
		this.canChallenge ? bubbleImage.visible = true : bubbleImage.visible = false;
	}

	private function battle()
	{
		world.removeChild(state);
		if (canChallenge) {
			state = new StateMachine(
				[new StateText(175,50,dialogue[currentIndex]),
				new StateButton("Yes",startBattle,endDialogue),
				new StateButton("No", endDialogue, endDialogue)], 50);
		} else {
			state = new StateMachine(
				[new StateText(175,50,"Not until you're stronger!"),
				new StateButton("Next",endDialogue,endDialogue)],50);
		}
		
		world.addChild(state);
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
		world.removeChild(state);
		ques = MathEngine.generateProblem(operation,difficulty);
		state = new StateMachine(
			[new StateText(125,50,ques.question),
			new StateInput(),
			new StateButton("Answer",checkAnswer,checkAnswer)],
			50);
		world.addChild(state);
	}

	override private function resetDialogue()
	{
		currentIndex = 0;
		state = new StateMachine(
		[new StateText(175,50,dialogue[currentIndex]),
		new StateButton("Next",setNext,endDialogue)],50);
	}

	private function checkAnswer()
	{
		var ans = state.getAnswer();
		world.removeChild(state);
		var result = ques.answer == ans;

		if(result)
		{
			if(++curQuestion >= questionNum)
			{
				state = new StateMachine(
				[new StateText(150,100,
				"You got all my questions right!"),
				new StateButton("Exit",endPlayer,endPlayer)],100);
			}
			else
			{
				ques = MathEngine.generateProblem(operation,difficulty);
				state = new StateMachine(
				[new StateText(200,100, "Correct. Next question."),
				new StateText(125,50,ques.question),
				new StateInput(),
				new StateButton("Answer",checkAnswer,checkAnswer)],
				50);
			}
		}
		else
		{
			state = new StateMachine(
				[new StateText(200,100, "Wrong. Try again..."),
				new StateText(125,50,ques.question),
				new StateInput(),
				new StateButton("Answer",checkAnswer,checkAnswer)],
				50);
			p.takeDamage(switch(difficulty)
			{
				case EASY: 5;
				case MEDIUM: 10;
				case HARD: 20;
			});
		}
		world.addChild(state);
	}

	override private function endDialogue()
	{
		world.removeChild(state);
		p.stopTalking();
		p = null;
		resetDialogue();
	}

	private function endPlayer()
	{
		p.levelUp(5);
		if (nextBattle != null) {
			nextBattle.enableChallenge();
		}
		endDialogue();
		cast(parent, Overworld).removeClassmate(this);
	}
	
	public function setNextBattle(bm : BattleMate) {
		nextBattle = bm;
	}
	
	public function enableChallenge() {
		canChallenge = true;
		bubbleImage.visible = true;
	}
}

class Teacher extends BattleMate
{

	public function new(world : Overworld)
	{
		super(["Challenge the teacher?"], PLUS, HARD, "prof", 20, false, world);
	}

	override private function checkAnswer()
	{
		var ans = state.getAnswer();
		world.removeChild(state);
		var result = ques.answer == ans;

		if(result)
		{
			if(++curQuestion >= questionNum)
			{	Menu.menu.endGame();}
			else
			{
				ques = MathEngine.generateProblem(randomOP(),HARD);
				state = new StateMachine(
				[new StateText(150,100, "Correct. Next question."),
				new StateText(125,50,ques.question),
				new StateInput(),
				new StateButton("Answer",checkAnswer,checkAnswer)],
				50);
			}
		}
		else
		{
			state = new StateMachine(
				[new StateText(150,100, "Wrong. Try again..."),
				new StateText(125,50,ques.question),
				new StateInput(),
				new StateButton("Answer",checkAnswer,checkAnswer)],
				50);
			p.takeDamage(20);
		}
		world.addChild(state);
	}

	private function randomOP() : OPERATION
	{
		return switch(Std.random(4))
		{
			case 0: PLUS;
			case 1: MINUS;
			case 2: MULTIPLY;
			default: DIVIDE;
		}
	}

	override private function battle()
	{
		world.removeChild(state);
		state = new StateMachine((world.allClassmatesBeaten() ?
		[new StateText(175,50,"Are you sure?"),
		new StateButton("Yes",startBattle,endDialogue),
		new StateButton("No", endDialogue, endDialogue)] :
		[new StateText(200,50,"You must beat all the students before challenging me!"),
		new StateButton("Next",endDialogue,endDialogue)])
		,50);
		world.addChild(state);
	}

	override private function startBattle()
	{
		world.removeChild(state);
		ques = MathEngine.generateProblem(randomOP(),HARD);
		state = new StateMachine(
			[new StateText(125,50,ques.question),
			new StateInput(),
			new StateButton("Answer",checkAnswer,checkAnswer)],
			50);
		world.addChild(state);
	}
}