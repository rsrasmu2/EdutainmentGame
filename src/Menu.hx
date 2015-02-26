import starling.display.Sprite;
import StateMachine;

enum MENU_TYPE
{
	MAIN;
	INSTRUCTIONS;
	CREDITS;
	OVERWORLD;
	GAME_OVER;
	GAME_END;
}

class Menu extends Sprite
{
	public static var menu : Menu;
	private var main : StateMachine;
	private var current : StateMachine;
	private var instr : StateMachine;
	private var cred : StateMachine;
	private var gameover : StateMachine;
	private var gameend : StateMachine;

	private inline static var creditsText =
	"Credits\nTemitope Alaga\nJordan Harris\nNancy McCollough\nCherie Parsons\nRobert Rasmussen";
	private inline static var instructionsText =
	"You are a student that is failing math class. Challenge your classmates to math battles and improve! You must answer all their questions correctly if you want your grade to go up. The students in the back are easier, and the students in the front are harder. Once you beat the professor, you will earn your A+! But be careful, when you answer a question wrong, your grade will go down. Don't let it get to 0, or it's game over!";

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

		gameover = new StateMachine(
			[new StateText(200,100,"Game Over"),
			new StateButton("Go back to Main Menu", function(){setMenu(MAIN);},function(){setMenu(MAIN);})]);

		gameend = new StateMachine(
			[new StateText(200,100,"You have completed the game!!!"),
			new StateButton("Go back to Main Menu", function(){setMenu(MAIN);},function(){setMenu(MAIN);})]);

		current = main;
		addChild(current);
	}

	private function setMenu(m:MENU_TYPE)
	{
		removeChildren();
		switch(m)
		{
			case MAIN:
				current = main;
			case INSTRUCTIONS:
				current = instr;
			case CREDITS:
				current = cred;
			case OVERWORLD:
				current = null;
				addChild(new Overworld());
			case GAME_OVER:
				current = gameover;
			case GAME_END:
				current = gameend;
		}
		if(current != null) addChild(current);
	}

	public function gameOver()
	{	setMenu(GAME_OVER);}

	public function endGame()
	{	setMenu(GAME_END);}

	public function reset()
	{	setMenu(MAIN);}
}