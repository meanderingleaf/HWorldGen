package;

import com.htest.ChaseAtty;
import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPath;
import org.flixel.FlxRect;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;
import com.htest.Dog;
import com.htest.Playa;
import com.MapGen;
import org.flixel.FlxTilemap;

class GameState extends FlxState
{
	
	public var map:FlxTilemap;
	public var mapStr:String;
	public var player:Playa;
	public var dog:Dog;
	
	private var mg:MapGen;
	
	override public function create():Void {
		mg = new MapGen();

		map = new FlxTilemap();
		add(map);
		map.loadMap(mg.finalString, "assets/tiles.png", 20, 20, 0, 0, 1, 9);
		
		//map.setTileProperties(0, FlxObject.NONE, null, null, map.totalTiles);
		map.setTileProperties(21, FlxObject.NONE);
		map.setTileProperties(22, FlxObject.NONE);
		map.setTileProperties(23, FlxObject.NONE);
		
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
	override public function destroy():Void
	{
		super.destroy();
	}

}