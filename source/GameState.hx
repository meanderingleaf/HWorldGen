package;

import browser.text.TextSnapshot;
import com.htest.ChaseAtty;
import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxBasic;
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
import com.htest.ItemPlacement;
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
		
		//setup map
		mg = new MapGen();
		
		//load it in
		map = new FlxTilemap();
		add(map);
		map.loadMap(mg.finalString, "assets/tiles.png", 20, 20, 0, 0, 1, 9);
		
		//map.setTileProperties(0, FlxObject.NONE, null, null, map.totalTiles);
		map.setTileProperties(21, FlxObject.NONE);
		map.setTileProperties(22, FlxObject.NONE);
		map.setTileProperties(23, FlxObject.NONE);
		
		//place items
		ItemPlacement.placeTrees(map, this);
		ItemPlacement.placeBushes(map, this);
		
		//player!
		player = new Playa();
		add(player);
		
		//stage setup
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
		FlxG.camera.setBounds(0, 0, map.width, map.height);
		FlxG.worldBounds = new FlxRect(0, 0, map.width, map.height);
		
		//doggie!
		dog = new Dog();
		dog.x = 1;
		dog.y = 1;
		dog.addAtty(new ChaseAtty(player, 30));
		//add(dog);
		
		//sort();
		
		//var sha:TestShader = new TestShader();
	}
	
	override public function update():Void {
		super.update();
		
		//zelda style sorting
		//very slow
		//this.sort();
		
		FlxG.collide(map, player);
		FlxG.collide(map, dog);
	}
	
	private function sortHandlerByY(Ob1:FlxBasic, Ob2:FlxBasic):Int
	{
		var Obj1:FlxObject = cast(Ob1, FlxObject);
		var Obj2:FlxObject = cast(Ob2, FlxObject);
		
		if (Obj1.y < Obj2.y)
			return _sortOrder;
		else if (Obj1.y > Obj2.y)
			return -_sortOrder;
		else
			return 0;
	}
	
	override public function draw():Void
	{
		// Sort sprites by their 'y' value before drawing them
		this._sortOrder = -1;
		this.members.sort(sortHandlerByY);
		super.draw();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

}