import starling.display.*;
import starling.core.Starling;
import MathEngine;
import Classmate;
import starling.textures.Texture;

class Overworld extends Sprite
{
	private var map : Array<Array<UInt>>;
	private var classmates : Array<Classmate>;
	private var desks : Array<Image>;
	private var quad : Quad;
	public inline static var GRID_SIZE = 32;

	public function new(?row:UInt, ?col:UInt)
	{
		super();

		addChild(new Image(Root.assets.getTexture("classroom")));

		quad = new Quad(
		row == null ? Starling.current.stage.stageWidth : row*GRID_SIZE,
		col == null ? Starling.current.stage.stageHeight : col*GRID_SIZE,0xdddddd);
		map = new Array<Array<UInt>>();
		classmates = new Array();
		desks = new Array();

		quad.alpha = 0.75;
		addChild(quad);

		//grid
		var h = 0;
		while(h <= quad.height)
		{
			var q = new Quad(quad.width,2.5,0xffff00);
			q.y = h;
			addChild(q);
			h += GRID_SIZE;
		}
		var r = 0;
		while(r <= quad.width)
		{
			var q = new Quad(2.5,quad.height,0xffff00);
			q.x = r;
			addChild(q);
			r += GRID_SIZE;
		}

		//map to store all objects on overworld
		for(i in 0...Std.int(quad.width/GRID_SIZE))
		{
			map[i] = new Array();
			map[i] = [for(j in 0...Std.int(quad.height/GRID_SIZE)) 0];
		}

		addChild(new Player(this));
		
		//this mate doesn't battle
		addMate(0,4,["I love math!"], "jordan_r");
		addMate(14, 8, ["You're doing great!"], "boy_l");
		
		// all desks
		addDesk(3, 2, "desk_1");
		addDesk(8, 2, "desk_2");
		addDesk(12, 2, "desk_1");
		addDesk(3, 6, "desk_1");
		addDesk(8, 6, "desk_2");		
		addDesk(12, 6, "desk_2");		
		
		//these ones does
		addMate(8, 0, ["Are you sure about this?", "Want to battle?"], MULTIPLY, HARD, "prof");
		
		addMate(3,3,["Can you beat me?", "Want to battle?"], PLUS, MEDIUM, "cherie_f");
		addMate(8,3,["My skills are good!", "Want to battle?"], MINUS, MEDIUM, "nancy_l");
		addMate(12,3,["Think you're smarter?", "Want to battle?"], MULTIPLY, MEDIUM, "temi_f");
		
		addMate(3, 7, ["No way you'll beat me!", "Want to battle?"], DIVIDE, EASY, "girl_b");
		addMate(8, 7, ["I love pink!", "Want to battle?"], PLUS, EASY, "punk_f");
		addMate(12, 7, ["Math is hard.", "Want to battle?"], MINUS, EASY, "blonde_r");
	}

	private function addMate(xPos: UInt, yPos : UInt, s : Array<String>, ?op:OPERATION, ?diff:DIFFICULTY, ?mateTexture: String)
	{
		var mate = (op == null || diff == null) ? new TalkMate(s, mateTexture) : new BattleMate(s,op,diff,mateTexture);
		mate.setPosition(xPos,yPos);
		map[xPos][yPos] = 1;
		classmates.push(mate);
		addChild(mate);
	}
	
	private function addDesk(xPos: UInt, yPos: UInt, type: String) {
		var desk = new Image(Root.assets.getTexture(type));
		desk.smoothing = "none";
		desk.scaleX = 2.5;
		desk.scaleY = 2.5;
		desk.x = xPos * Overworld.GRID_SIZE;
		desk.y = yPos * Overworld.GRID_SIZE;
		map[xPos][yPos] = 1;
		desks.push(desk);
		addChild(desk); 
	}

	//check if position on grid is okay to move to
	public function goodSpot(xPos:Float,yPos:Float) : Bool
	{
		return xPos >= quad.x &&
		yPos >= quad.y &&
		xPos < quad.x + quad.width &&
		yPos < quad.y + quad.height &&
		map[Std.int(xPos/GRID_SIZE)][Std.int(yPos/GRID_SIZE)] == 0;
	}

	//start dialogue if player is next to classmate
	public function talkToClassmate(p:Player) : Bool
	{
		for(mate in classmates)
		{
			if((mate.x == p.x || mate.x == p.x-GRID_SIZE ||
			mate.x == p.x+GRID_SIZE) && (mate.y == p.y ||
			mate.y == p.y-GRID_SIZE || mate.y == p.y+GRID_SIZE))
			{
				mate.startDialogue(p);
				return true;
			}
		}
		return false;
	}
}