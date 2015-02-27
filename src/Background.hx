import starling.display.Image;
import starling.display.Sprite;

import starling.events.Event;
/**
 * ...
 * @author Nancy McCollough
 */
class Background extends Sprite
{
	var parallax: Float;
	var image1: Image;
	var image2: Image;

	public function new()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(event:Event):Void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		image1 = new Image(Root.assets.getTexture("bg"));
		image2 = new Image(Root.assets.getTexture("bg"));
		addChild(image1);
		addChild(image2);

		image1.scaleX = image1.scaleY = 640/512;
		image2.scaleX = image2.scaleY = 640/512;

		/*parallax scrolling?
		image1.y = 0;
		image2.y = image1.height;*/

		//regular scrolling
		image2.x = image1.width;

		parallax = .2;

		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

	}

	private function onEnterFrame(event:Event):Void
	{
		/*parallax scrolling?
		image1.y -= parallax;
		if (image1.y < -image1.height)
			image1.y = 0;*/

		//regular scrolling
		image1.x -= parallax;
		image2.x -= parallax;
		if(image1.x < -image1.width)
		{
			image1.x = 0;
			image2.x = image1.width;
		}
	}

}