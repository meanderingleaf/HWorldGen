package com.htest;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
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
	
	public static function placeBushes(m:FlxTilemap, s:FlxState):Void {
		for ( x in 0 ... m.widthInTiles ) {
			for ( y in 0 ... m.heightInTiles ) {
				if (m.getTile(x, y) == 4  || m.getTile(x, y) == 5 ) {
					if (Math.random() < .1) {
						var t:FlxSprite = makeBush();
						t.x = (x-1) * 20;
						t.y = (y-1) * 20;
						s.add( t );
					}
				}
			}	
		}
	}
	
	public static function placeHouses(m:FlxTilemap, s:FlxState):Void {
		
		var num_houses:Int = 2;
		
		for ( x in 0 ... m.widthInTiles ) {
			for ( y in 0 ... m.heightInTiles ) {
				//TODO: figure out algo here
			}	
		}
	}
	
	public static function placeTrees(m:FlxTilemap, s:FlxState):Void {
		//loop through da map
		for ( x in 0 ... m.widthInTiles ) {
			for ( y in 0 ... m.heightInTiles ) {
				if (m.getTile(x, y) == 2 ) {
					if ( Math.random() < 0.5 ) {
						//place tree
						var t:FlxSprite = makeTree();
						t.x = (x-1) * 20;
						t.y = (y-1) * 20;
						s.add( t );
					}
				}
				
				if (m.getTile(x, y) == 3) {
					if ( Math.random() < 0.2 ) {
						//place tree
						var t:FlxSprite = makeTree();
						t.x = (x-1) * 20;
						t.y = (y-1) * 20;
						s.add( t );
					}
				}
			}
		}
	}
	
	private static function makeBush():FlxSprite {
		
		var bd:BitmapData = new BitmapData(25, 20, true, 0x00000000);
		var g:Sprite = new Sprite();
		g.graphics.lineStyle(4, 0x330000);
		g.graphics.moveTo(12, 20);
		g.graphics.lineTo(12, 10);
		
		g.graphics.lineStyle(1, 0x330000);
		for ( i in 0 ... 7 ) {
			g.graphics.moveTo(12, 10);
			var dx:Int = Std.int( Math.random() * 15 ) + 5;
			var dy:Int = 16 - Std.int( Math.random() * 7 );
			
			g.graphics.lineStyle(2, 0x330000);
			g.graphics.lineTo(dx, dy);
			
			g.graphics.lineStyle(0, 0x000000, 0);
			var c:Int = ( 0 << 16 ) | ( Std.int((i / 14) * 255) << 8 ) | 0;
			g.graphics.beginFill(c, 1);
			g.graphics.drawCircle(dx, dy, 3);
		}
		
		bd.draw(g);
		
		var t:FlxSprite = new FlxSprite();
		t.pixels = bd;
		
		return t;
	}
	
	private static function makeTree():FlxSprite {
		var t:FlxSprite = new FlxSprite();
		
		var bd:BitmapData = new BitmapData(25, 40, true, 0x00000000);
		var g:Sprite = new Sprite();
		var tree_height:Int = 25;
		
		g.graphics.lineStyle(4, 0x330000);
		g.graphics.moveTo(10, 35);
		g.graphics.lineTo(10, tree_height);
		
		g.graphics.lineStyle(0, 0x000000, 0);
		g.graphics.beginFill(0x000000, .3);
		g.graphics.drawCircle(10, 35, 5);
		
		g.graphics.lineStyle(1, 0x330000);
		for ( i in 0 ... 14 ) {
			g.graphics.moveTo(10, tree_height);
			var dx:Int = Std.int( Math.random() * 20 ) + 3;
			var dy:Int = tree_height - Std.int( Math.random() * 15 );
			
			g.graphics.lineStyle(2, 0x330000);
			g.graphics.lineTo(dx, dy);
			
			g.graphics.lineStyle(0, 0x000000, 0);
			var c:Int = ( 0 << 16 ) | ( Std.int((i / 14) * 255) << 8 ) | 0;
			g.graphics.beginFill(c, 1);
			g.graphics.drawCircle(dx, dy, 3);
		}
		
		bd.draw(g);
		
		var t:FlxSprite = new FlxSprite();
		t.pixels = bd;
		
		
		//t.loadGraphic("assets/boik.png");
		return t;
	}
	
}