import starling.display.Sprite;
import starling.events.*;
import flash.ui.*;
import StateMachine;

enum MENU_TYPE
{
	MAIN;
	INSTRUCTIONS;
	CREDITS;
}

class Menu extends Sprite
{
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
		main = new StateMachine(
			[new StateText(200,100,"Math RPG"),
			new StateButton("Play", function(){}),
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

		addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER: current.action(CONFIRM);
				case Keyboard.ESCAPE: current.action(BACK);
				case Keyboard.UP: current.action(UP);
				case Keyboard.DOWN: current.action(DOWN);
			}
		});
	}

	public function setMenu(m:MENU_TYPE)
	{
		removeChild(current);
		switch(m)
		{
			case MAIN: current = main;
			case INSTRUCTIONS: current = instr;
			case CREDITS: current = cred;
		}
		addChild(current);
	}

}