package com.htest;
import flash.geom.Point;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxU;



/**
 * ...
 * @author tf
 */

class ChaseAtty 
{
	
	private var chaseTarget:Dynamic;
	private var speed:Int;

	public function new(ct:Dynamic, sped:Int) {
		chaseTarget = ct;
		speed =  sped;
	}
	
	public function apply(t:Dynamic):Void {
		
		var dp:FlxPoint = new FlxPoint(t.x - chaseTarget.x, t.y - chaseTarget.y);
		var l:Float = FlxU.getDistance(new FlxPoint(0, 0), dp);
		
		//normalize
		dp.x /= l;
		dp.y /= l;
		
		//trace(dp.x);
		
		t.velocity.x = speed * -dp.x;
		t.velocity.y = speed * -dp.y;
	}
	
}