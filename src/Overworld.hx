import starling.display.*;
import starling.core.Starling;
import MathEngine;
import Classmate;

class Overworld extends Sprite
{
	private var map : Array<Array<UInt>>;
	private var classmates : Array<Classmate>;
	private var desks : Array<Image>;
	private var quad : Quad;
	private var teacher : Teacher;
	public inline static var GRID_SIZE = 32;

	public function new(?row:UInt, ?col:UInt)
	{
		super();

		var classRoom = new Image(Root.assets.getTexture("classroom"));
		classRoom.scaleX = row * GRID_SIZE / 212;
		classRoom.scaleY = col * GRID_SIZE / 266;
		classRoom.smoothing = "none";
		addChild(classRoom);

		quad = new Quad(
			row == null ? Starling.current.stage.stageWidth : row*GRID_SIZE,
			col == null ? Starling.current.stage.stageHeight : col*GRID_SIZE,0xdddddd
		);

		/*quad.alpha = 0;
		addChild(quad);*/

		//createGrid(quad);
		createMap();
		addMates();

		//block off front of the room
		for(i in 0...row)
		{
			for(j in 0...2)
			{	map[i][j] = 1;}
		}

		addDesk(3, 13, "desk_1");
		var p = addChild(new Player(this));
		p.x = 3 * GRID_SIZE;
		p.y = 14 * GRID_SIZE;
	}

	private function createGrid(quad:Quad)
	{
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
	}

	private function createMap()
	{
		map = new Array<Array<UInt>>();

		//map to store all objects on overworld
		for(i in 0...Std.int(quad.width/GRID_SIZE))
		{
			map[i] = new Array();
			map[i] = [for(j in 0...Std.int(quad.height/GRID_SIZE)) 0];
		}
	}

	private function addMates()
	{
		classmates = new Array();
		desks = new Array();

		//this mate doesn't battle
		addMate(6,14,["Welcome to Mathsters!",
		"Talk to the students and answer their questions correctly.",
		"After that, talk to the teacher and answer his questions to win the game!"],
		"jordan_b");

		//these ones does
		var ae = addMate(3,11,["I love pink!", "Want to battle?"], "punk_f",PLUS, EASY, 5, true);
		var am = addMate(3,8,["Can you beat me?", "Want to battle?"], "temi_b",PLUS, MEDIUM, 3, false);
		var ah = addMate(3,5,["I'm great at addition.", "Want to battle?"], "cherie_f",PLUS, HARD, 1, false);
		cast(ae,BattleMate).setNextBattle(cast(am,BattleMate));
		cast(am,BattleMate).setNextBattle(cast(ah,BattleMate));

		var se = addMate(6,11,["I'm not so good...", "Want to battle?"], "blonde_l",MINUS, EASY, 5, true);
		var sm = addMate(6,8,["I'll get you!", "Want to battle?"], "boy_r",MINUS, MEDIUM, 3, false);
		var sh = addMate(6,5,["Algebraic!", "Want to battle?"], "nancy_l",MINUS, HARD, 1, false);
		cast(se,BattleMate).setNextBattle(cast(sm,BattleMate));
		cast(sm,BattleMate).setNextBattle(cast(sh,BattleMate));

		var me = addMate(10,11,["Why is 6 afaid of 7?", "Want to battle?"], "boy_b", MULTIPLY, EASY, 5, true);
		var mm = addMate(10,8,["You're so acute!", "Want to battle?"], "girl_l", MULTIPLY, MEDIUM, 3, false);
		var mh = addMate(10,5,["Think you're smarter?", "Want to battle?"], "temi_f", MULTIPLY, HARD, 1, false);
		cast(me,BattleMate).setNextBattle(cast(mm,BattleMate));
		cast(mm,BattleMate).setNextBattle(cast(mh,BattleMate));

		var de = addMate(13,11,["Come at me bro!", "Want to battle?"], "girl_b", DIVIDE, EASY, 5, true);
		var dm = addMate(13,8,["What's your sine?", "Want to battle?"], "nancy_f", DIVIDE, MEDIUM, 3, false);
		var dh = addMate(13,5,["Mathematical!", "Want to battle?"], "rob_r", DIVIDE, HARD, 1, false);
		cast(de,BattleMate).setNextBattle(cast(dm,BattleMate));
		cast(dm,BattleMate).setNextBattle(cast(dh,BattleMate));

		teacher = new Teacher(this);
		teacher.setPosition(8, 2);
		map[8][2] = 1;
		classmates.push(teacher);
		addChild(teacher);
	}

	private function addMate(xPos: UInt, yPos : UInt, s : Array<String>,
	mateTexture: String, ?op:OPERATION, ?diff:DIFFICULTY,  ?num : UInt, ?canChallenge : Bool) : Classmate
	{
		var mate = (op == null || diff == null || num == null || canChallenge == null)
		? new TalkMate(s, mateTexture, this)
		: new BattleMate(s,op,diff,mateTexture,num,canChallenge,this);
		mate.setPosition(xPos,yPos);
		map[xPos][yPos] = 1;
		classmates.push(mate);
		if (Std.random(2) == 1) {
			addDesk(xPos, yPos - 1, "desk_1");
		} else {
			addDesk(xPos, yPos - 1, "desk_2");
		}
		addChild(mate);
		return mate;
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
		switch (p.currentDir) {
			case UP:
				for (mate in classmates) {
					if (mate.x == p.x && mate.y == p.y-GRID_SIZE) {
						mate.startDialogue(p);
						return true;
					}
				}
				return false;
			case DOWN:
				for (mate in classmates) {
					if (mate.x == p.x && mate.y == p.y+GRID_SIZE) {
						mate.startDialogue(p);
						return true;
					}
				}
				return false;
			case LEFT:
				for (mate in classmates) {
					if (mate.x == p.x-GRID_SIZE && mate.y == p.y) {
						mate.startDialogue(p);
						return true;
					}
				}
				return false;
			case RIGHT:
				for (mate in classmates) {
					if (mate.x == p.x+GRID_SIZE && mate.y == p.y) {
						mate.startDialogue(p);
						return true;
					}
				}
				return false;
			default:
				return false;
		}
	}

	public function removeClassmate(c:Classmate)
	{
		var pos = c.getPosition();
		var x = pos.xPos;
		var y = pos.yPos;
		classmates.remove(c);
		removeChild(c);
		addMate(x, y, ["Aw, I lost."], c.myTexture);

		if (allClassmatesBeaten()) {
			teacher.enableChallenge();
		}
	}

	public function allClassmatesBeaten() : Bool
	{	return classmates.length == 2;}
}