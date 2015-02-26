import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.text.*;

class Root extends Sprite {

	public static var assets: AssetManager;
	
	public function new() {
		super();
	}

	public function start(startup:Startup) {
		assets = new AssetManager();
		assets.enqueue("assets/BittyFont.fnt", "assets/BittyFont.png");
		assets.enqueue("assets/sprites.png", "assets/sprites.xml");
		assets.enqueue("assets/classroom.png");
		assets.enqueue("assets/bubble.png");
		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {
				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:0.5, alpha: 0, onComplete: function() {
						startup.removeChild(startup.loadingBitmap);
					}
				});
				TextField.registerBitmapFont(new BitmapFont(assets.getTexture("BittyFont.png"),
															assets.getXml("BittyFont.fnt")),"Fipps");
				addChild(new Menu());
			}
		});
	}
}