import starling.display.*;
import starling.core.*;
import StateMachine;
import flash.media.*;
import starling.events.*;
import starling.textures.Texture;

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
	private var bg:Background;

	private var mainMusic : GameMusic;
	private var gameMusic : GameMusic;
	private var volume : Float;

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

		bg = new Background();
		addChild(bg);

		volume = 0.5;
		mainMusic = new GameMusic("Edutainment",this);
		gameMusic = new GameMusic("Edutainment2",this);
		addChild(mainMusic);
		addChild(gameMusic);

		main = new StateMachine(
			[new StateText(200,100,"Mathsters"),
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

		setMenu(MAIN);
	}

	private function setMenu(m:MENU_TYPE)
	{
		removeChildren(3);
		switch(m)
		{
			case MAIN:
				mainMusic.play(volume);
				gameMusic.stop();
				current = main;
			case INSTRUCTIONS:
				current = instr;
			case CREDITS:
				current = cred;
			case OVERWORLD:
				removeChild(bg);
				gameMusic.play(volume);
				mainMusic.stop();
				current = null;
				addChild(new Overworld(16,16));
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
	{	addChildAt(bg,0);setMenu(MAIN);}

	public function incVol(chn : SoundChannel)
	{
		volume += 0.1;
		if(volume > 1.0) volume = 1.0;
		chn.soundTransform = new SoundTransform(volume);
	}

	public function decVol(chn : SoundChannel)
	{
		volume -= 0.1;
		if(volume < 0.0) volume = 0.0;
		chn.soundTransform = new SoundTransform(volume);
	}
}

class GameMusic extends Sprite
{
	private var sound : Sound;
	private var channel : SoundChannel;
	private var isPlaying : Bool;
	private var inc : Button;
	private var dec : Button;

	public function new(s:String,m:Menu)
	{
		super();
		sound = Root.assets.getSound(s);
		channel = null;
		isPlaying = false;
		inc = new Button(Texture.empty(50,50),"+");
		inc.x = Starling.current.stage.stageWidth - inc.width;
		inc.y = Starling.current.stage.stageHeight - inc.height;
		inc.fontName = "Fipps";
		inc.fontSize = 20;
		inc.addEventListener(Event.TRIGGERED, function()
		{
			m.incVol(channel);
		});
		dec = new Button(Texture.empty(50,50),"-");
		dec.x = inc.x - dec.width;
		dec.y = inc.y;
		dec.fontName = "Fipps";
		dec.fontSize = 20;
		dec.addEventListener(Event.TRIGGERED, function()
		{
			m.decVol(channel);
		});
	}

	public function play(vol : Float)
	{
		if(!isPlaying)
		{
			channel = sound.play();
			channel.soundTransform = new SoundTransform(vol);
			isPlaying = true;
			if(!channel.hasEventListener(flash.events.Event.SOUND_COMPLETE))
			{
				channel.addEventListener(flash.events.Event.SOUND_COMPLETE,
				function(e:flash.events.Event)
				{
					isPlaying = false;
					play(vol);
				});
			}
			addChild(inc);
			addChild(dec);
		}
	}

	public function stop()
	{
		if(isPlaying)
		{
			channel.stop();
			isPlaying = false;
			removeChild(inc);
			removeChild(dec);
		}
	}
}