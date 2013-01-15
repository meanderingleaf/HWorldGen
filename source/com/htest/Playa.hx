package com.htest;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tf
 */

class Playa extends FlxSprite
{

	private var walkSpeed:Int;
	
	public function new() 
	{
		super();
		walkSpeed = 50;
		this.drag.x = 130;
		this.drag.y = 130;
		
		loadGraphic("assets/gwensprite.png", true, false, 15, 26);
		addAnimation("Default", [3], 5);
		addAnimation("Up", [0, 1], 5);
		addAnimation("Down", [2, 3], 5);
		addAnimation("Right", [4, 5], 5);
		addAnimation("Left", [6, 7], 5);
	}
	
	override public function update():Void {
		
		
		if (FlxG.keys.W && FlxG.keys.D) {
			play("Up");
			velocity.y = -this.walkSpeed * .75;
			velocity.x = this.walkSpeed * .75;
		} else if (FlxG.keys.W && FlxG.keys.A) {
			play("Up");
			velocity.y = -this.walkSpeed * .75;
			velocity.x = -this.walkSpeed * .75;
		} else if (FlxG.keys.S && FlxG.keys.D) {
			play("Down");
			velocity.y = this.walkSpeed * .75;
			velocity.x = this.walkSpeed * .75;
		} else if (FlxG.keys.S && FlxG.keys.A) {
			play("Down");
			velocity.y = this.walkSpeed * .75;
			velocity.x = -this.walkSpeed * .75;
		} else if (FlxG.keys.W) {
			play("Up");
			this.facing = FlxObject.UP;
			velocity.y = -this.walkSpeed;
		} else if (FlxG.keys.A) {
			play("Left");
			this.facing = FlxObject.LEFT;
			velocity.x = -walkSpeed;
		} else if (FlxG.keys.S) {
			play("Down");
			this.facing = FlxObject.DOWN;
			velocity.y = walkSpeed;
		} else if (FlxG.keys.D) {
			play("Right");
			this.facing = FlxObject.RIGHT;
			velocity.x = walkSpeed;
		} else {
			this.frame = this.frame;
		}
		
		super.update();
	}
	
}