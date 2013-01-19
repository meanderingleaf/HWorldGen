package com;
import nme.display.Bitmap;
import nme.display.BitmapData;
import com.htest.astar.SNode;
import com.htest.astar.Pather;
import flash.geom.Point;

/**
 * ...
 * @author tf
 */

class MapGen 
{

	private var debugBitmap:Bitmap;
	private var bdat:BitmapData;
	private var finalDat:BitmapData;
	public var finalMap:Bitmap;
	public var finalString:String;
	private var p:Pather;
	
	public function new() 
	{
		
		//base bitmap & data to work off of
		bdat = new BitmapData(40, 40);
		bdat.perlinNoise(4, 4, 10, 5, false, false, 7, true);
		debugBitmap = new Bitmap(bdat);
		debugBitmap.scaleX = debugBitmap.scaleY = 5;
		
		//generate noise for a 'hightmap'
		var landdat:BitmapData = new BitmapData(40, 40);
		landdat.perlinNoise(20, 20, 1, 5, false, true, 7, true);
		var lmap:Bitmap = new Bitmap(landdat);
		
		//convert the heightmap into bodies of water. Set everything < 0x666666 to blue, everything else is invisible
		var lakedat:BitmapData = new BitmapData(40, 40);
		lakedat.threshold(landdat, landdat.rect, new Point(0, 0), "<",  0xFF666666, 0xFF0000FF, 0xFFFFFFFF, false); 
		lakedat.threshold(landdat, landdat.rect, new Point(0, 0), ">=",  0xFF666666, 0x00000000, 0xFFFFFFFF, false); 
		var lakemap:Bitmap = new Bitmap(lakedat);
		
		//okay, we have our heightmap & lake data, combine them.
		
		//draw the heightmap
		finalDat = new BitmapData(40, 40);
		finalDat.copyPixels(landdat, landdat.rect, new Point(0, 0));
		
		//colorize the hightmap
		setTiles();
		
		//draw the water map
		finalDat.draw(lakedat);
		
		//convert to A* map stuff
		var m:Array<Array<SNode>> = toSMap();
		
		//make a class that will run the A* stuff
		p = new Pather();
		
		//get the path of nodes from the pather
		var parth:Array<SNode> = p.findPath(m[10][0], m[25][39], m);
		
		//send the path to be drawn to the bitmap data
		//draws a river to the bitmap
		drawPath(parth);
		
		//not quite doing what I want, applies a 'blur' to the map to change the edges between areas
		//needs a couple of entra rules to keep some of the sharp transitions I desire
		//blendTiles();
		
		//add debug data
		//addChild (debugBitmap);
		//addChild(lakemap);
		//lakemap.scaleX = lakemap.scaleY = 5;
		//addChild(lmap);
		//lmap.scaleX = lmap.scaleY = 5;
		//addChild(finalMap);
		
		//final map debug
		finalMap = new Bitmap(finalDat);
		finalMap.scaleX = finalMap.scaleY = 7;
		finalMap.x = 400;
		
		//change the bitmap data to an array of ints
		var tmarp:Array<Array<Int>> = toTMap();
		
		//and then to a string that Flixel understands
		finalString = twoString(tmarp);
	}
	
	
	private function twoString(arr:Array<Array<Int>>):String {
		var s:String =  "";
		
		for (i in 0 ... arr.length) {
			s += arr[i].join(",") + "\n";
		}
		
		return s;
	}
	
	private function blendTiles():Void {
		for (x in 0...finalDat.width) {
			for (y in 0...finalDat.height) {
				var colour:Int = finalDat.getPixel(x, y);
				var r:Int = (colour >> 16) & 0xff;
				var g:Int = (colour >> 8) & 0xff;
				var b:Int = colour & 0xff;
				
				if (b > 125) {
					//check left & right, top & bottom
					for (xx in x-1 ... x+2) {
						for (yy in y-1 ... y+2) {
							//if(xx != x && yy != y) {
								var ncolour:Int = finalDat.getPixel(xx, yy);
								var nr:Int = (ncolour >> 16) & 0xff;
								var ng:Int = (ncolour >> 8) & 0xff;
								var nb:Int = ncolour & 0xff;
								
								if (nb < 125) {
									
									nb = 124;
									var fcolor:Int =  ( ( nr << 16 ) | ( ng << 8 ) | nb );
									finalDat.setPixel(xx, yy, fcolor);
								}
							//}
						}
					}
					
				}
				
			}
		}
	}
	
	private function setTiles():Void {
		for (x in 0...finalDat.width) {
			for (y in 0...finalDat.height) {
				var val:Int = finalDat.getPixel(x, y);
				var setColor:Int = 0x000000;
				
				//'pretty'
				/*
				if (val < 0x888888) {
					setColor = 0x99FF99;
				} else if (val < 0x999999) {
					setColor = 0x66EE66;
				} else if (val < 0xAAAAAA) {
					setColor = 0x229922;
				} else if (val < 0xBBBBBB ) {
					setColor = 0x009900;
				} else if (val < 0xCCCCCC ) {
					setColor = 0x006600;
				} else if (val < 0xDDDDDD ) {
					setColor = 0x003300;
				} else {
					setColor = 0x003300;
				}
				*/
				
				if (val < 0x888888) {
					setColor = 0x00FF00;
				} else if (val < 0x999999) {
					setColor = 0x00CC00;
				} else if (val < 0xAAAAAA) {
					setColor = 0x00AA00;
				} else if (val < 0xBBBBBB ) {
					setColor = 0x008800;
				} else if (val < 0xCCCCCC ) {
					setColor = 0x005500;
				} else if (val < 0xDDDDDD ) {
					setColor = 0x003300;
				} else {
					setColor = 0x001100;
				}
				//setColor = 0x000000;
				finalDat.setPixel(x, y, setColor);
			}
		}
	}
	
	private function drawPath(pa:Array<SNode>, numBridges:Int = 2):Void {
		
		for (p in pa) {
			finalDat.setPixel(p.x, p.y, 0x0000FF);
		}
		
		var bridgeCount:Int = 0;
		var bridgeCutoff:Int = 0;
		
		while (bridgeCount < numBridges) {
			
			var ind:Int = Math.floor(Math.random() * pa.length);
			var po:SNode = pa[ind];
			
			if (finalDat.getPixel(po.x + 1, po.y) != 0x0000FF && finalDat.getPixel(po.x - 1, po.y) != 0x0000FF ) {
				bridgeCount ++;
				finalDat.setPixel(po.x, po.y, 0xFF0000);
			}
			
			if (finalDat.getPixel(po.x, po.y + 1) != 0x0000FF && finalDat.getPixel(po.x, po.y - 1) != 0x0000FF) {
				bridgeCount ++;
				finalDat.setPixel(po.x, po.y, 0x990000);
			}
			
			if (++bridgeCutoff > numBridges * 2) break;
		}
	}
	
	private function toTMap():Array<Array<Int>> {
		
		var ret:Array<Array<Int>> = new Array<Array<Int>>();
		
		for (x in 0 ... finalDat.width) {
			ret.push( new Array<Int>() );
			for(y in 0 ... finalDat.height) {
				var colour:Int = finalDat.getPixel(x, y);
				
				//shift bits
				var r:Int = (colour >> 16) & 0xff;
				var g:Int = (colour >> 8) & 0xff;
				var b:Int = colour & 0xff;
				
				var til:Int = 1;
				
				if (b > 0) {
					til = Math.round(b / 50) + 10;
				}
				
				if (g > 0) {
					if (b > 0) 	til = Math.round(g / 50); //place 'blend' version of the tile
					else 		til = Math.round(g / 50);
					
					trace(til);
				}
				
				
				//speshul tiles
				if (r > 0) {
					til = 22;
				}
				
				//if (r > 0) {
				//	til = Math.round(r / 50) + 20;
				//}

				ret[x][y] = til;
				
			}
		}
		return ret;
	}
	
	//A* stuff
	private function toSMap():Array<Array<SNode>> {
		var ret:Array<Array<SNode>> = new Array<Array<SNode>>();
	
		var x:Int = 0;
		
		while(x < bdat.width) {
			ret.push( new Array<SNode>() );
			
			var y:Int = 0;
			while(y < bdat.height) {
				var px:UInt = bdat.getPixel(x, y);
				var bound:Float = px / 0xFFFFFF;
				ret[x].push( new SNode(x, y, bound) );
				y++;
			}
			x++;
		}
		
		return ret;
	}
	
}