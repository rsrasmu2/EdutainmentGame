import flash.system.ImageDecodingPolicy;
import starling.display.*;
import starling.text.TextField;
import starling.events.*;
import flash.ui.*;
import starling.core.*;
import starling.animation.*;

enum DIRECTION
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
	NONE;
}

typedef Health = {hitpoints : Int, text : TextField}
class Player extends Sprite
{
	private var moving : Bool;
	private var world : Overworld;
	private var dirHeld : DIRECTION;
	private var talking : Bool;
	private var health : Health;
	
	private var playerFront: Image;
	private var playerBack: Image;
	private var playerLeft: Image;
	private var playerRight: Image;
	
	private var animateUp:MovieClip;
	private var animateDown:MovieClip;
	private var animateLeft:MovieClip;
	private var animateRight:MovieClip;
	
	public function new(st:Overworld)
	{
		super();
		
		world = st;
		dirHeld = NONE;
		
		moving = false;

		movieSetUp();
		addChild(playerFront);
		
		health = {hitpoints : 50, text : new TextField(50,50,"50")};
		addChild(health.text);

		
		
		addEventListener(Event.ENTER_FRAME,
		function(e:Event)
		{
			move(dirHeld);
		});
		addEventListener(KeyboardEvent.KEY_DOWN,
		function(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case Keyboard.UP: dirHeld = UP;
				case Keyboard.DOWN: dirHeld = DOWN;
				case Keyboard.LEFT: dirHeld = LEFT;
				case Keyboard.RIGHT: dirHeld = RIGHT;
				case Keyboard.ESCAPE: Menu.menu.reset();
				case Keyboard.ENTER: talking = world.talkToClassmate(this);
			}
		});
		addEventListener(KeyboardEvent.KEY_UP,
		function(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case Keyboard.UP: if(dirHeld == UP) dirHeld = NONE;
				case Keyboard.DOWN: if(dirHeld == DOWN) dirHeld = NONE;
				case Keyboard.LEFT: if(dirHeld == LEFT) dirHeld = NONE;
				case Keyboard.RIGHT: if(dirHeld == RIGHT) dirHeld = NONE;
			}
		});
	}
	
	private function move(d:DIRECTION)
	{
		if(moving || talking) return;
		var xPos = x;
		var yPos = y;
		switch(d)
		{
			case UP:
				yPos -= Overworld.GRID_SIZE;
			case DOWN:
				yPos += Overworld.GRID_SIZE;
			case LEFT:
				xPos -= Overworld.GRID_SIZE;
			case RIGHT:
				xPos += Overworld.GRID_SIZE;
			default: return;
		}
		if((xPos != x || yPos != y) && world.goodSpot(xPos,yPos))
			tweenTo(xPos,yPos, d);
	}

	private function tweenTo(xPos : Float, yPos : Float, dir: DIRECTION)
	{
		moving = true;
		switch(dir) {
			case UP:
				removeStatic();
				addChild(playerBack);
				addChild(animateUp);
				Starling.juggler.add(animateUp);
			case DOWN:
				removeStatic();
				addChild(playerFront);
				addChild(animateDown);
				Starling.juggler.add(animateDown);
			case LEFT:
				removeStatic();
				addChild(playerLeft);
				addChild(animateLeft);
				Starling.juggler.add(animateLeft);
			case RIGHT:
				removeStatic();
				addChild(playerRight);
				addChild(animateRight);
				Starling.juggler.add(animateRight);
			default: return;
		}
		Starling.juggler.tween(this, 0.1,
		{
			transition: Transitions.LINEAR,
			x: xPos, y : yPos,
			onComplete: function()
			{	moving = false;
				removeChild(animateUp);
				removeChild(animateDown);
				removeChild(animateLeft);
				removeChild(animateRight);
			}
		});
	}

	public function stopTalking()
	{	talking = false;}

	public function takeDamage(d:UInt)
	{
		health.hitpoints -= d;
		if(health.hitpoints <= 0) Menu.menu.gameOver();
		else health.text.text = Std.string(health.hitpoints);
	}
	
	private function movieSetUp() {
		
		playerFront = new Image(Root.assets.getTexture("b_front_"));
		playerFront.width = 25;
		playerFront.height = 26;
		playerFront.smoothing = "none";
		playerBack = new Image(Root.assets.getTexture("b_back_")); 
		playerBack.width = 25;
		playerBack.height = 26;
		playerBack.smoothing = "none";
		playerLeft = new Image(Root.assets.getTexture("b_left_1")); 
		playerLeft.width = 23;
		playerLeft.height = 27;
		playerLeft.smoothing = "none";
		playerRight = new Image(Root.assets.getTexture("b_right_1")); 
		playerRight.width = 23;
		playerRight.height = 27;
		playerRight.smoothing = "none";
				
		animateUp = new MovieClip(Root.assets.getTextures("b_back_"), 4);
		animateUp.width = 25;
		animateUp.height = 26;
		animateDown = new MovieClip(Root.assets.getTextures("b_front_"), 4);
		animateDown.width = 25;
		animateDown.height = 26;
		animateLeft = new MovieClip(Root.assets.getTextures("b_left_"), 4);
		animateLeft.width = 23;
		animateLeft.height = 27;
		animateRight = new MovieClip(Root.assets.getTextures("b_right_"), 4);
		animateRight.width = 23;
		animateRight.height = 27;
	}
	
	private function removeStatic() {
		
		removeChild(playerFront);
		removeChild(playerBack);
		removeChild(playerLeft);
		removeChild(playerRight);
		
	}
}