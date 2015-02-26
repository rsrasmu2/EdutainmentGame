import starling.display.*;
import starling.core.*;
import StateMachine;
import flash.media.*;
import flash.events.*;

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

	private var mainMusic : GameMusic;
	private var gameMusic : GameMusic;

	private inline static var creditsText =
	"Credits\nTemitope Alaga\nJordan Harris\nNancy McCollough\nCherie Parsons\nRobert Rasmussen";
	private inline static var instructionsText =
	"You are a student that is failing math class. "+
	"Challenge your classmates to math battles and improve! "+
	"You must answer all their questions correctly if you want your grade to go up. "+
	"The students in the back are easier, and the students in the front are harder. "+
	"Once you beat the professor, you will earn your A+! But be careful, when you "+
	"answer a question wrong, your grade will go down. Don't let it get to 0, or it's game over!";

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

		mainMusic = new GameMusic("Edutainment");
		gameMusic = new GameMusic("Edutainment2");

		setMenu(MAIN);
	}

	private function setMenu(m:MENU_TYPE)
	{
		removeChildren();
		switch(m)
		{
			case MAIN:
				mainMusic.play();
				gameMusic.stop();
				current = main;
			case INSTRUCTIONS:
				current = instr;
			case CREDITS:
				current = cred;
			case OVERWORLD:
				gameMusic.play();
				mainMusic.stop();
				current = null;
				addChild(new Overworld(15,18));
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

class GameMusic extends Sprite
{
	private var sound : Sound;
	private var channel : SoundChannel;
	private var isPlaying : Bool;

	public function new(s:String)
	{
		super();
		sound = Root.assets.getSound(s);
		channel = null;
		isPlaying = false;
	}

	public function play()
	{
		if(!isPlaying)
		{
			channel = sound.play();
			isPlaying = true;
			if(!channel.hasEventListener(Event.SOUND_COMPLETE))
			{
				channel.addEventListener(Event.SOUND_COMPLETE,
				function(e:Event)
				{
					isPlaying = false;
					play();
				});
			}
		}
	}

	public function stop()
	{
		if(isPlaying)
		{
			channel.stop();
			isPlaying = false;
		}
	}
}