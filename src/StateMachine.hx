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
		makeBorder();

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
		removeChildren(5);
		var yPos = Overworld.GRID_SIZE;
		for(st in states)
		{
			st.y = yPos;
			yPos += space;
			addChild(st);
		}
		updateColor();
	}

	private function makeBorder()
	{
		var w = 0; var h = 0;var sz = 5;
		for(st in states)
		{
			if(st.width > w) w = st.width;
			h += st.height + space;
		}
		var quad = new Quad(w,h,0);
		quad.x = -w/2;
		addChild(quad);

		var quad1 = new Quad(w,sz,0x008000);
		quad1.x = -w/2;
		addChild(quad1);

		var quad2 = new Quad(w,sz,0x008000);
		quad2.x = -w/2;
		quad2.y = h;
		addChild(quad2);

		var quad3 = new Quad(sz,h,0x008000);
		quad3.x = -w/2;
		addChild(quad3);

		var quad4 = new Quad(sz,h,0x008000);
		quad4.x = -w/2 + w;
		addChild(quad4);
	}

	private function updateColor()
	{
		for(i in 0...states.length)
		{
			if(!Std.is(states[i], StateButton))
				continue;
			if(i == current)
				states[i].fontColor = 0xff0000;
			else
				states[i].fontColor = 0xffffff;
		}
	}

	private function initCurrent()
	{
		current = 0;
		while(!Std.is(states[current], StateButton)) ++current;
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

		}while(!Std.is(states[current], StateButton));
		updateColor();
	}

	public function getAnswer() : Int
	{
		for(st in states)
		{
			if(Std.is(st, StateInput))
			{
				return Std.int(st.text);
				break;
			}
		}
		return -1;
	}
}

class StateText extends TextField
{
	public function new(w:Int,h:Int,s:String,f:Int = 20)
	{
		super(w,h,s,"Fipps",f,0xffffff);
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
		fontSize = 20;
		fontName = "Fipps";

		addEventListener(Event.TRIGGERED, confirm);
		addEventListener(Event.ADDED, function()
		{
			width;
			x = -width/2;
		});
	}

	public function confirm()
	{	if(con != null) con();}

	public function back()
	{	if(bac != null) bac();}
}

class StateInput extends TextField
{
	public function new()
	{
		super(50,50,"","Flipps",20,0xffffff);
		addEventListener(Event.ADDED, function()
		{
			x = -width/2;
			addEventListener(KeyboardEvent.KEY_DOWN, addInput);

		});
		addEventListener(Event.REMOVED, function()
		{
			removeEventListeners(KeyboardEvent.KEY_DOWN);
		});
	}

	private function addInput(e:KeyboardEvent)
	{
		if(e.keyCode >= 48 && e.keyCode <= 57)
			text += Std.string(e.keyCode-48);
		else if(e.keyCode == Keyboard.BACKSPACE)
			text = text.substring(0);
	}
}