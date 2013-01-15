package com.htest.astar;

/**
 * ...
 * @author tf
 */

class SNode 
{

	public var g:Float;
	public var h:Float;
	public var terrain:Float;
	public var x:Int;
	public var y:Int;
	
	public var f(get_f,null):Float;
	public var parent:SNode;
	
	public function new(sx:Int, sy:Int, st:Float) 
	{
		x = sx;
		y = sy;
		terrain = st;
		g = terrain;
	}
	
	public function get_f():Float {
		return g + h;
	}
}