package com.htest.astar;

class QuickSortNodes {
	
	public static function run<T>( a:Array<SNode> ) : Array<SNode> {
		quicksort( a, 0, a.length-1 );
		return a;
	}
	
	public static function quicksort( a:Array<SNode>, lo:Int, hi:Int ):Void{
		var i:Int = lo;
		var j:Int = hi;
		var p = a[Math.floor((lo+hi)/2)].f;
		while( i <= j ){
			while( a[i].f < p ) i++;
			while( a[j].f > p ) j--;
			if( i <= j ){
				var t:SNode = a[i];
				a[i++] = a[j];
				a[j--] = t;
			}
		}
		if( lo < j ) quicksort( a, lo, j);
		if( i < hi ) quicksort( a, i, hi);
	}
}