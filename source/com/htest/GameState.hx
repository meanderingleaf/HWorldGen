package com.htest;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGame;
import org.flixel.FlxObject;
import org.flixel.FlxRect;
import org.flixel.FlxState;
import org.flixel.FlxTilemap;
import com.MapGen;

/**
 * ...
 * @author tf
 */

class GameState extends FlxState
{

	public var map:FlxTilemap;
	public var mapStr:String;
	public var player:Playa;
	public var dog:Dog;
	
	private var mg:MapGen;
	
	public function new() 
	{
		super();
		mg = new MapGen();
	}
	
	override public function create():Void {
		trace('hi');
		map = new FlxTilemap();
		add(map);
		map.loadMap(mg.finalString, "gfx/tiles.png", 20, 20, 0, 0, 1, 9);
		//map.setTileProperties(0, FlxObject.NONE, null, null, map.totalTiles);
		map.setTileProperties(21, FlxObject.NONE);
		map.setTileProperties(22, FlxObject.NONE);
		map.setTileProperties(23, FlxObject.NONE);
		
		trace(FlxG.cameras.length);
		player = new Playa();
		add(player);
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
		FlxG.camera.setBounds(0, 0, map.width, map.height);
		FlxG.worldBounds = new FlxRect(0, 0, map.width, map.height);
		
		dog = new Dog();
		dog.x = 1;
		dog.y = 1;
		dog.addAtty(new ChaseAtty(player, 30));
		add(dog);
	}
	
	override public function update():Void {
		super.update();
		FlxG.collide(map, player);
		FlxG.collide(map, dog);
	}
	
}