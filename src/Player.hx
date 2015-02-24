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
class Player extends TextField
{
	private var moving : Bool;
	private var world : Overworld;
	private var dirHeld : DIRECTION;
	private var talking : Bool;
	private var health : Health;

	public function new(st:Overworld)
	{
		super(Overworld.GRID_SIZE,Overworld.GRID_SIZE,"P","Fipps",20);
		world = st;
		dirHeld = NONE;
		moving = false;
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
			tweenTo(xPos,yPos);
	}

	private function tweenTo(xPos : Float, yPos : Float)
	{
		moving = true;
		Starling.juggler.tween(this, 0.1,
		{
			transition: Transitions.LINEAR,
			x: xPos, y : yPos,
			onComplete: function()
			{	moving = false;}
		});
	}

	public function stopTalking()
	{	talking = false;}
}