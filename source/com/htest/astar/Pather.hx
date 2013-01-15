package com.htest.astar;

/**
 * ...
 * @author tf
 */

class Pather 
{
	private var openSet:Array<SNode>;
	private var closedSet:Array<SNode>;
	
	private static inline var COST_ORTHOGONAL:Float = 1;
	private static inline var COST_DIAGONAL:Float = 1.414;
	
	private var map:Array<Array<SNode>>;
	private var width:Int;
	private var height:Int;
	
	private var end:SNode;
	
	public function new() 
	{
		
	}
	
	public function findPath(start:SNode, send:SNode, smap:Array<Array<SNode>>):Array<SNode> {
		var path:Array<SNode> =  new Array<SNode>();
		var curNode:SNode = start;
		end = send;
		map = smap;
		width = map.length;
		height = map[0].length;
		
		openSet = new Array<SNode>();
		closedSet = new Array<SNode>();
		
		//setup curNode
		curNode.h = dist(curNode,end);
		//openSet.push(curNode);
		
		var itr:Int = 0;
		
		while (curNode != end) {
			//trace(curNode.x + "," + curNode.y);
			var neighbors:Array<SNode> = getNeighbors(curNode);
			var l:Int = neighbors.length;
			var testNode:SNode;
			var g:Float;
			var h:Float;
			var f:Float;
			
			for (i in 0...neighbors.length) {
				testNode = neighbors[i];
				g = curNode.g + (testNode.terrain*1000);
				h = dist(testNode, end);
				f = g + h;
				//trace(h+","+testNode.terrain*1000);
				
				if (!inOpen(testNode) && !inClosed(testNode)) {
					testNode.parent = curNode;
					testNode.g = g;
					testNode.h = h;
					openSet.push(testNode);
				} else {
					if (f < testNode.f) {
						//trace("setting");
						testNode.g = g;
						testNode.parent = curNode;
					}
				}
			}
			//trace("closing: " + curNode.x + "," + curNode.y);
			closedSet.push(curNode);

			QuickSortNodes.run(openSet);
			curNode = openSet.shift();
			itr ++;
		}
		
		//trace("PATH");
		itr = 0;
		while (curNode != start) {
			//trace(curNode.x + "," + curNode.y);
			path.push(curNode);
			curNode = curNode.parent;
			itr ++;
		}
		path.push(start);
		
		return path;
	}
	
	private function inOpen(t:SNode):Bool {
		for (s in openSet)
			if (s == t) return true;
			
		return false;
	}
	
	private function inClosed(t:SNode):Bool {
		for (s in closedSet) {
			
			if (s == t) {
				//trace("testing" + s.x + "," + s.y);
				return true;
			}
		}
			
		return false;
	}
	
	private function getNeighbors(node:SNode):Array<SNode>
	{
		var x:Int = node.x;
		var y:Int = node.y;
		var n:SNode;
		var a:Array<SNode> = new Array<SNode>();
		
		
		// N
		if (x > 0) {
			
			n = map[x-1][y];
			//n.g += n.terrain;
			a.push(n);
		}
		// E
		if (x < width-1) {
			n = map[x+1][y];
			//n.g += n.terrain;
			a.push(n);
		} 
		// N
		if (y > 0) {
			n = map[x][y-1];
			//n.g += n.terrain;
			a.push(n);
		}
		// S
		if (y < height-1) {
			n = map[x][y+1];
			//n.g += n.terrain;
			a.push(n);
		}
		
		// Don't cut corners here,
		// but make diagonal travelling possible.
		
		// NW
		if (x > 0 && y > 0) {
			n = map[x-1][y-1];				
			//n.g += n.terrain + 1;
			a.push(n);
		}
		// NE
		if (x < width-1 && y > 0) {
			n = map[x+1][y-1];
			//n.g += n.terrain + 1;
			a.push(n);
		}
		// SW
		if (x > 0 && y < height-1) {
			n = map[x-1][y+1];
			//n.g += n.terrain + 1;
			a.push(n);
		}
		// SE
		if (x < width-1 && y < height-1) {
			n = map[x+1][y+1];
			//n.g += n.terrain + 1;
			a.push(n);
		}
		
		
		return a;
	}
	
	private function dist(n1:SNode, n2:SNode=null):Float {
		if (n2 == null) n2 = end;
		return Math.sqrt(Math.pow((n1.x-n2.x),2)+Math.pow((n1.y-n2.y),2));
	}
	
	private static function removeFromArray(a:Array<SNode>, e:SNode):Bool
	{
		var i:Int;
		for (i in 0...a.length) {
			if (a[i] == e) {
				a.splice(i,1);
				return true;
			}
		}
		return false;
	}
}