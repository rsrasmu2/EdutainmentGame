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
	public inline static var GRID_SIZE = 32;

	public function new(?row:UInt, ?col:UInt)
	{
		super();

		var classRoom = new Image(Root.assets.getTexture("classroom"));
		classRoom.scaleX = row*GRID_SIZE/212;
		classRoom.scaleY = col*GRID_SIZE/266;
		addChild(classRoom);

		quad = new Quad(
			row == null ? Starling.current.stage.stageWidth : row*GRID_SIZE,
			col == null ? Starling.current.stage.stageHeight : col*GRID_SIZE,0xdddddd
		);

		/*quad.alpha = 0;
		addChild(quad);*/

		//createGrid(quad);
		createMap();

		addDesks();
		addMates();

		var p = addChild(new Player(this));
		p.x = 1 * GRID_SIZE;
		p.y = 15 * GRID_SIZE;
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
		for(i in 0...Std.int(quad.width/GRID_SIZE)){
			map[i][0] = 1;
			map[i][1] = 1;
		}
	}

	private function addMates()
	{
		classmates = new Array();

		//this mate doesn't battle
		addMate(3,5,["Welcome to Math RPG!",
		"Talk to the students and answer their questions correctly.",
		"After that, talk to the teacher and answer his questions to win the game!"],
		"jordan_b");

		//these ones does
		var ae = addMate(5,15,["Can you beat me?", "Want to battle?"], "cherie_f",PLUS, EASY, 5, true);
		var am = addMate(10,15,["Can you beat me?", "Want to battle?"], "cherie_f",PLUS, MEDIUM, 3, false);
		var ah = addMate(13,15,["Can you beat me?", "Want to battle?"], "cherie_f",PLUS, HARD, 1, false);
		cast(ae,BattleMate).setNextBattle(cast(am,BattleMate));
		cast(am,BattleMate).setNextBattle(cast(ah,BattleMate));

		var se = addMate(5,12,["My skills are good", "Want to battle?"], "nancy_l",MINUS, EASY, 5, true);
		var sm = addMate(10,12,["My skills are good", "Want to battle?"], "nancy_l",MINUS, MEDIUM, 3, false);
		var sh = addMate(13,12,["My skills are good", "Want to battle?"], "nancy_l",MINUS, HARD, 1, false);
		cast(se,BattleMate).setNextBattle(cast(sm,BattleMate));
		cast(sm,BattleMate).setNextBattle(cast(sh,BattleMate));

		var me = addMate(5,7,["Think you're smarter?", "Want to battle?"], "temi_f", MULTIPLY, EASY, 5, true);
		var mm = addMate(10,7,["Think you're smarter?", "Want to battle?"], "temi_f", MULTIPLY, MEDIUM, 3, false);
		var mh = addMate(13,7,["Think you're smarter?", "Want to battle?"], "temi_f", MULTIPLY, HARD, 1, false);
		cast(me,BattleMate).setNextBattle(cast(mm,BattleMate));
		cast(mm,BattleMate).setNextBattle(cast(mh,BattleMate));

		var de = addMate(5,2,["Come at me bro!", "Want to battle?"], "rob_r", DIVIDE, EASY, 5, true);
		var dm = addMate(10,2,["Come at me bro!", "Want to battle?"], "rob_r", DIVIDE, MEDIUM, 3, false);
		var dh = addMate(13,2,["Come at me bro!", "Want to battle?"], "rob_r", DIVIDE, HARD, 1, false);
		cast(de,BattleMate).setNextBattle(cast(dm,BattleMate));
		cast(dm,BattleMate).setNextBattle(cast(dh,BattleMate));

		//these ones does
		/*addMate(8, 0, ["Are you sure about this?", "Want to battle?"], MULTIPLY, HARD, "prof");

		addMate(3,3,["Can you beat me?", "Want to battle?"], PLUS, MEDIUM, "cherie_f");
		addMate(8,3,["My skills are good!", "Want to battle?"], MINUS, MEDIUM, "nancy_l");
		addMate(12,3,["Think you're smarter?", "Want to battle?"], MULTIPLY, MEDIUM, "temi_f");

		addMate(3, 7, ["No way you'll beat me!", "Want to battle?"], DIVIDE, EASY, "girl_b");
		addMate(8, 7, ["I love pink!", "Want to battle?"], PLUS, EASY, "punk_f");
		addMate(12, 7, ["Math is hard.", "Want to battle?"], MINUS, EASY, "blonde_r");*/

		//var teacher = new Teacher(this);
		//teacher.setPosition(19, 10);
		//map[19][10] = 1;
		//classmates.push(teacher);
		//addChild(teacher);
	}

	private function addDesks() {
		desks = new Array();

		// all desks
		addDesk(3, 4, "desk_1");
		addDesk(8, 4, "desk_2");
		addDesk(12, 4, "desk_1");
		addDesk(3, 8, "desk_1");
		addDesk(8, 8, "desk_2");
		addDesk(12, 8, "desk_2");
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
		map[pos.xPos][pos.yPos] = 0;
		classmates.remove(c);
		removeChild(c);
	}

	public function allClassmatesBeaten() : Bool
	{	return classmates == [];}
}