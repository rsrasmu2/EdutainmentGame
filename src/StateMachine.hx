import starling.display.*;
import starling.textures.Texture;
import starling.events.*;
import starling.text.TextField;
import starling.core.Starling;

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
	private var current : Int;
	private var total : Int;

	public function new(st:Array<Dynamic>)
	{
		super();
		x = Starling.current.stage.stageWidth/2;
		y = 0;
		states = st;
		total = st.length;
		current = total;
		change(false);
		makeTextFields();
	}

	private function makeTextFields()
	{
		var yPos = 50;
		trace(yPos);
		for(st in states)
		{
			if(Std.is(st, StateButton))
			{
				st.setY(yPos);
				st.add(this);
				yPos += 100;
			}
			else
			{
				st.y = yPos;
				yPos += 100;
				addChild(st);
			}
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
				states[i].setC(0xff0000);
			else
				states[i].setC(0x000000);
		}
	}

	public function action(act:ACTION)
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
			(current + total) % total;

		}while(Std.is(states[current], StateText));
		updateColor();
	}
}

class StateText extends TextField
{
	public function new(w:Int,h:Int,s:String,f:Int = 20)
	{
		super(w,h,s,"Verdana",f);
		addEventListener(Event.ADDED, function()
		{
			x -= width/2;
		});
	}
}

class StateButton
{
	private var con : Void->Void;//confirm function
	private var bac : Void->Void;//back function
	private var button : Button;

	public function new(s:String, c:Void->Void, ?b:Void->Void)
	{
		button = new Button(Texture.empty(20*s.length,20),s);
		con = c;
		bac = b;
		button.color = 0;
		button.fontSize = 20;
		button.addEventListener(Event.TRIGGERED, confirm);
	}

	public function confirm()
	{	con();}

	public function back()
	{	if(bac != null) bac();}

	public function setY(y:Int)
	{	button.y = y;}

	public function setC(c:UInt)
	{	button.fontColor = c;}

	public function add(parent:StateMachine)
	{
		parent.addChild(button);
		button.x -= button.width/2;
	}
}