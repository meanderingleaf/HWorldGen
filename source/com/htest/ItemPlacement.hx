package com.htest;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTilemap;

/**
 * ...
 * @author tf
 */

class ItemPlacement 
{

	public function new() 
	{
		
	}
	
	public static function placeTrees(m:FlxTilemap, s:FlxState):Void {
		//loop through da map
		for ( x in 0 ... m.widthInTiles ) {
			for ( y in 0 ... m.heightInTiles ) {
				if (m.getTile(x, y) == 5 || m.getTile(x, y) == 4 ) {
					if ( Math.random() < 0.3 ) {
						//place tree
						var t:FlxSprite = makeTree();
						t.x = x * 25;
						t.y = y * 25;
						s.add( t );
					}
				}
			}
		}
	}
	
	private static function makeTree():FlxSprite {
		var t:FlxSprite = new FlxSprite();
		t.loadGraphic("assets/boik.png");
		return t;
	}
	
}