package com.htest;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tf
 */

class Dog extends FlxSprite
{

	private var attys:Array<Dynamic>;
	
	public function new() 
	{
		super();
		attys = new Array<Dynamic>();
	}
	
	public function addAtty(a:Dynamic):Void {
		attys.push(a);
	}
	
	override public function update():Void {
		super.update();
		
		for (a in attys) {
			a.apply(this);
		}
	}
	
}