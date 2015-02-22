import starling.display.Sprite;
import starling.text.TextField;
import StateMachine;

class Classmate extends Sprite
{
	private var dialogue : String;
	private var state : StateMachine;
	private var text : TextField;
	private var p : Player;

	public function new(s:String, doesBattle:Bool = false)
	{
		super();
		dialogue = s;
		p = null;
		state = new StateMachine(
			(doesBattle ?

			//battle state machine
			[new StateText(100,100,s),
			new StateText(50,50,"Battle?"),
			new StateButton("Yes",startBattle,endDialogue),
			new StateButton("No", endDialogue,endDialogue)] :

			//regular talking state machine
			[new StateText(100,100,s),
			new StateButton("Exit",endDialogue,endDialogue)]));
		state.x = 0;
		state.y = Overworld.GRID_SIZE;
		state.reposition();

		text = new TextField(Overworld.GRID_SIZE,Overworld.GRID_SIZE,"C","Fipps",20);
		addChild(text);
	}

	public function startDialogue(ply:Player)
	{	addChild(state); p = ply;}

	private function endDialogue()
	{	removeChild(state); p.stopTalking(); p = null;}

	private function startBattle()
	{
		trace("Not coded yet...");
		endDialogue();
	}

	public function setPosition(xPos:UInt, yPos: UInt)
	{
		x = xPos * Overworld.GRID_SIZE;
		y = yPos * Overworld.GRID_SIZE;
	}
}