import starling.display.*;
import starling.core.Starling;

class Overworld extends Sprite
{
	private var map : Array<Array<UInt>>;
	private var quad : Quad;
	private inline static var GRID_SIZE = 32;

	public function new(?row:UInt, ?col:UInt)
	{
		super();

		quad = new Quad(
		row == null ? Starling.current.stage.stageWidth : row*GRID_SIZE,
		col == null ? Starling.current.stage.stageHeight : col*GRID_SIZE,0x333333);
		quad.alpha = 0.75;
		addChild(quad);

		var r = 0;
		while(r <= quad.width)
		{
			var q = new Quad(2.5,quad.height,0xffff00);
			q.x = r;
			addChild(q);
			r += GRID_SIZE;
		}
		var h = 0;
		while(h <= quad.height)
		{
			var q = new Quad(quad.width,2.5,0xffff00);
			q.y = h;
			addChild(q);
			h += GRID_SIZE;
		}
		addChild(new Player(GRID_SIZE,this));
	}

	//check if position on grid is okay to move to
	public function goodSpot(xPos:Float,yPos:Float) : Bool
	{
		return xPos >= quad.x &&
		yPos >= quad.y &&
		xPos < quad.x + quad.width &&
		yPos < quad.y + quad.height;
	}
}