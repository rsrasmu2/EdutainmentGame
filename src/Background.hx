import starling.display.Image;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;

import starling.events.Event;
/**
 * ...
 * @author Nancy McCollough
 */
class Background extends Sprite
{
	var parallax: Float;
	var imageHeight: Float;
	var image1: Image;
	var image2: Image;

	public function new()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	public function onAddedToStage(event:Event):Void {

		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		image1 = new Image(Root.assets.getTexture("bg"));
		image2 = new Image(Root.assets.getTexture("bg"));
		addChild(image1);
		addChild(image2);

		image1.scaleX = image1.scaleY = 640/512;
		image2.scaleX = image2.scaleY = 640/512;
		image1.y = 0;
		image2.y = image1.height;
		imageHeight = image1.height;

		parallax = .2;

		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

	}

	public function onEnterFrame(event:Event):Void {

		image1.y -= parallax;
		if (image1.y < -imageHeight) {
			image1.y = 0;
		}
	}

}