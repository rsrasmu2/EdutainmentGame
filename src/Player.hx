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

class Player extends TextField
{
	private var moving : Bool;
	private var world : Overworld;
	private var stageSize : UInt;
	private var dirHeld : DIRECTION;

	public function new(gs:UInt, st:Overworld)
	{
		super(gs,gs,"P","Arial",20);
		stageSize = gs;
		world = st;
		dirHeld = NONE;
		moving = false;

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
		if(moving) return;
		var xPos = x;
		var yPos = y;
		switch(d)
		{
			case UP:
				yPos -= stageSize;
			case DOWN:
				yPos += stageSize;
			case LEFT:
				xPos -= stageSize;
			case RIGHT:
				xPos += stageSize;
			default: return;
		}
		if((xPos != x || yPos != y) && world.goodSpot(xPos,yPos))
			tweenTo(xPos,yPos);
	}

	private function tweenTo(xPos : Float, yPos : Float)
	{
		trace(xPos,yPos);
		moving = true;
		Starling.juggler.tween(this, 0.25,
		{
			transition: Transitions.LINEAR,
			x: xPos, y : yPos,
			onComplete: function()
			{	moving = false;}
		});
	}
}