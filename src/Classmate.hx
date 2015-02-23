import starling.display.Sprite;
import starling.text.TextField;
import StateMachine;
import MathEngine;

class Classmate extends Sprite
{
	private var dialogue : String;
	private var state : StateMachine;
	private var text : TextField;
	private var p : Player;

	private function new(s:String, st:StateMachine)
	{
		super();
		dialogue = s;
		p = null;
		state = st;
		state.x = 0;
	}

	public function startDialogue(ply:Player)
	{	addChild(state); p = ply;}

	private function endDialogue()
	{	removeChild(state); p.stopTalking(); p = null;}

	public function setPosition(xPos:UInt, yPos: UInt)
	{
		x = xPos * Overworld.GRID_SIZE;
		y = yPos * Overworld.GRID_SIZE;
	}
}

class TalkMate extends Classmate
{
	public function new(s:String)
	{
		super(s, new StateMachine(
		[new StateText(100,50,s),
		new StateButton("Exit",endDialogue,endDialogue)],50));
		text = new TextField(Overworld.GRID_SIZE,Overworld.GRID_SIZE,"C","Fipps",20);
		addChild(text);
	}
}

class BattleMate extends Classmate
{
	private var operation : OPERATION;
	private var difficulty : DIFFICULTY;

	public function new(s:String, op:OPERATION, diff:DIFFICULTY)
	{
		super(s,
		new StateMachine(
		[new StateText(100,50,s),
		new StateButton("Yes",startBattle,endDialogue),
		new StateButton("No", endDialogue,endDialogue)],50));
		operation = op;
		difficulty = diff;
		text = new TextField(Overworld.GRID_SIZE,Overworld.GRID_SIZE,"B","Fipps",20);
		addChild(text);
	}

	private function startBattle()
	{
		removeChild(state);
		var ques = MathEngine.generateProblem(operation,difficulty);
		state = new StateMachine(
			[new StateText(125,50,ques.question),
			new StateText(125,50,"Answer is " + ques.answer),
			new StateButton("Cannot answer yet...",endDialogue,endDialogue)],
			50);
		state.x = 0;
		addChild(state);
	}
}