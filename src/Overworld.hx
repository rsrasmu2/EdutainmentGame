import starling.display.*;
import starling.core.Starling;
import MathEngine;
import Classmate;
import starling.textures.Texture;

class Overworld extends Sprite
{
	private var map : Array<Array<UInt>>;
	private var classmates : Array<Classmate>;
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
		addMate(3,3,["Welcome to Math RPG!",
		"Talk to the students and answer their questions correctly.",
		"After that, talk to the teacher and answer his questions to win the game!"],
		"jordan_b");

		//these ones does
		addMate(5,0,["Can you beat me?", "Want to battle?"], "cherie_f",PLUS, EASY, 5);
		addMate(10,0,["Can you beat me?", "Want to battle?"], "cherie_f",PLUS, MEDIUM, 3);
		addMate(15,0,["Can you beat me?", "Want to battle?"], "cherie_f",PLUS, HARD, 1);

		addMate(5,5,["My skills are good", "Want to battle?"], "nancy_l",MINUS, EASY, 5);
		addMate(10,5,["My skills are good", "Want to battle?"], "nancy_l",MINUS, MEDIUM, 3);
		addMate(15,5,["My skills are good", "Want to battle?"], "nancy_l",MINUS, HARD, 1);

		addMate(5,10,["Think you're smarter?", "Want to battle?"], "temi_f", MULTIPLY, EASY, 5);
		addMate(10,10,["Think you're smarter?", "Want to battle?"], "temi_f", MULTIPLY, MEDIUM, 3);
		addMate(15,10,["Think you're smarter?", "Want to battle?"], "temi_f", MULTIPLY, HARD, 1);

		addMate(5,15,["Come at me bro!", "Want to battle?"], "rob_r", DIVIDE, EASY, 5);
		addMate(10,15,["Come at me bro!", "Want to battle?"], "rob_r", DIVIDE, MEDIUM, 3);
		addMate(15,15,["Come at me bro!", "Want to battle?"], "rob_r", DIVIDE, HARD, 1);

		var teacher = new Teacher(this);
		teacher.setPosition(19, 10);
		map[19][10] = 1;
		classmates.push(teacher);
		addChild(teacher);
	}

	private function addMate(xPos: UInt, yPos : UInt, s : Array<String>,
	mateTexture: String, ?op:OPERATION, ?diff:DIFFICULTY,  ?num : UInt)
	{
		var mate = (op == null || diff == null || num == null)
		? new TalkMate(s, mateTexture)
		: new BattleMate(s,op,diff,mateTexture,num);
		mate.setPosition(xPos,yPos);
		map[xPos][yPos] = 1;
		classmates.push(mate);
		addChild(mate);
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

	public function removeClassmate(c:Classmate)
	{
		var pos = c.getPosition();
		map[pos.xPos][pos.yPos] = 0;
		classmates.remove(c);
		removeChild(c);
	}

	public function allClassmatesBeaten() : Bool
	{	return classmates == [];}
}