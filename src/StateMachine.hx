import starling.display.*;
import starling.textures.Texture;
import starling.events.*;
import starling.text.TextField;
import starling.core.Starling;
import flash.ui.*;

enum ACTION
{
	UP;
	DOWN;
	CONFIRM;
	BACK;
}

class StateMachine extends Sprite
{
	private var states : Array<Dynamic>;
	private var space : UInt;
	private var current : Int;
	private var total : Int;

	public function new(st:Array<Dynamic>, sp:UInt = 100)
	{
		super();
		x = Starling.current.stage.stageWidth/2;
		states = st;
		space = sp;
		total = st.length;
		initCurrent();
		addEventListener(Event.ADDED_TO_STAGE, function()
		{
			initCurrent();
			addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent)
			{
				switch(e.keyCode)
				{
					case Keyboard.ENTER: action(CONFIRM);
					case Keyboard.ESCAPE: action(BACK);
					case Keyboard.UP: action(UP);
					case Keyboard.DOWN: action(DOWN);
				}
			});
			reposition();
		});
		addEventListener(Event.REMOVED_FROM_STAGE, function()
		{
			removeEventListeners(KeyboardEvent.KEY_DOWN);
		});
	}

	private function reposition()
	{
		removeChildren();
		var yPos = Overworld.GRID_SIZE;
		for(st in states)
		{
			st.y = yPos;
			yPos += space;
			addChild(st);
		}
		updateColor();
	}

	private function updateColor()
	{
		for(i in 0...states.length)
		{
			if(Std.is(states[i], StateText))
				continue;
			if(i == current)
				states[i].fontColor = 0xff0000;
			else
				states[i].fontColor = 0x000000;
		}
	}

	private function initCurrent()
	{
		current = 0;
		while(Std.is(states[current], StateText)) ++current;
		updateColor();
	}

	private function action(act:ACTION)
	{
		switch(act)
		{
			case UP:
				change(true);
			case DOWN:
				change(false);
			case CONFIRM:
				if(Std.is(states[current], StateButton))
					states[current].confirm();
			case BACK:
				if(Std.is(states[current], StateButton))
					states[current].back();
		}
	}

	private function change(up:Bool)
	{
		do
		{
			current += up ? -1 : 1;
			current = (current + total) % total;

		}while(Std.is(states[current], StateText));
		updateColor();
	}
}

class StateText extends TextField
{
	public function new(w:Int,h:Int,s:String,f:Int = 20)
	{
		super(w,h,s,"Fipps",f);
		addEventListener(Event.ADDED, function()
		{
			x = -width/2;
		});
	}
}

class StateButton extends Button
{
	private var con : Void->Void;//confirm function
	private var bac : Void->Void;//back function

	public function new(s:String, c:Void->Void, ?b:Void->Void)
	{
		super(Texture.empty(20*s.length,20),s);
		con = c;
		bac = b;
		color = 0;
		fontSize = 20;
		fontName = "Fipps";

		addEventListener(Event.TRIGGERED, confirm);
		addEventListener(Event.ADDED, function()
		{
			/*
				The trace has to be here in order for the text
				to be centered, but I don't know why.
			*/
			trace(width);
			haxe.Log.clear();
			x = -width/2;
		});
	}

	public function confirm()
	{	if(con != null) con();}

	public function back()
	{	if(bac != null) bac();}
}