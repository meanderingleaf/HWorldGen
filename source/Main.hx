package;

import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.ui.Keyboard;
import org.flixel.FlxGame;

import com.iainlobb.gamepad.Gamepad;
import com.iainlobb.gamepad.OnScreenJoystick;

import com.Glowbals;

/**
 * @author Joshua Granick
 */
class Main extends Sprite 
{
	
	public var pad:Gamepad;
	
	public function new () 
	{
		super();
		
		if (stage != null) 
			init();
		else 
			addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(?e:Event = null):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		initialize();
		
		#if (cpp || neko)
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUP);
		#end
	}
	
	#if (cpp || neko)
	private function onKeyUP(e:KeyboardEvent):Void 
	{
		if (e.keyCode == Keyboard.ESCAPE)
		{
			Lib.exit();
		}
	}
	#end
	
	private function initialize():Void 
	{
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		var demo:FlxGame = new GenMain();
		addChild(demo);
		
		pad = new Gamepad(stage, false);
		
		var thumb:Sprite = new Sprite();
		thumb.graphics.beginFill(0xFF6600);
		thumb.graphics.drawCircle(25,25,25);
		var bg:Sprite = new Sprite();
		bg.graphics.beginFill(0xFF6600, 0.3);
		bg.graphics.drawCircle(50, 50, 50);

		var gamePadView:OnScreenJoystick = new OnScreenJoystick();
		gamePadView.init(pad, 50, thumb, bg);
		gamePadView.x = 440;
		gamePadView.y = 330;
		addChild(gamePadView);
		
		Glowbals.pad = pad;
		Glowbals.padView = gamePadView;
	}
	
	// Entry point
	public static function main() {
		
		Lib.current.addChild(new Main());
	}
	
}