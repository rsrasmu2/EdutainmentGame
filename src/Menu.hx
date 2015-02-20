import starling.display.Sprite;
import StateMachine;

enum MENU_TYPE
{
	MAIN;
	INSTRUCTIONS;
	CREDITS;
	OVERWORLD;
	BATTLE;
}

class Menu extends Sprite
{
	public static var menu : Menu;
	private var main : StateMachine;
	private var current : StateMachine;
	private var instr : StateMachine;
	private var cred : StateMachine;

	private inline static var creditsText =
	"Credits\nTemitope Alaga\nAdd others' names later...";
	private inline static var instructionsText =
	"Add instructions to game later...";

	public function new()
	{
		super();
		menu = this;
		main = new StateMachine(
			[new StateText(200,100,"Math RPG"),
			new StateButton("Play", function(){setMenu(OVERWORLD);}),
			new StateButton("Instructions", function(){setMenu(INSTRUCTIONS);}),
			new StateButton("Credits", function(){setMenu(CREDITS);})]);

		instr = new StateMachine(
			[new StateText(200,100,"Instructions\n-----------"),
			new StateText(200,100,instructionsText),
			new StateButton("Back", function(){setMenu(MAIN);},function(){setMenu(MAIN);})]);


		cred = new StateMachine(
			[new StateText(200,100,"Credits\n----------"),
			new StateText(200,100,creditsText),
			new StateButton("Back", function(){setMenu(MAIN);},function(){setMenu(MAIN);})]);

		current = main;
		addChild(current);
	}

	private function setMenu(m:MENU_TYPE)
	{
		removeChildren();
		switch(m)
		{
			case MAIN: current = main;
			case INSTRUCTIONS: current = instr;
			case CREDITS: current = cred;
			case OVERWORLD: addChild(new Overworld());
			default: trace("Action has not been defined");
		}
		if(m != OVERWORLD) addChild(current);
	}

	public function reset()
	{	setMenu(MAIN);}
}