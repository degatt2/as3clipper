/*
Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

package com.flassari.geom
{
	import cmodule.AlchemyClipper.CLibInit;
	
	import flash.geom.Point;

	public class Clipper
	{
		private static var _lib:Object;
		
		/**
		 * Clips the subject polygon with the clip polygon with the specified clip type operation.
		 * The clipper library uses only whole integers, all values will be rounded.
		 *  
		 * @param subjectPolygon	An array of Point instances that make up the subject polygon.
		 * @param clipPolygon		An array of Point instances that make up the clip polygon.
		 * @param clipType			The clipping type operation to run.
		 * @param subjectFillType	The fill type of the subject polygon.
		 * @param clipFillType		The fill type of the clip polygon.
		 * @return 					Returns an array of result polygons, which are arrays of Point instances.
		 */
		public static function clipPolygon(subjectPolygon:Array, clipPolygon:Array, clipType:int,
										   subjectFillType:int = PolyFillType.EVEN_ODD, clipFillType:int = PolyFillType.EVEN_ODD):Array
		{
			var subjectVertices:Array = new Array();
			var clipVertices:Array = new Array();
			
			// Flatten the point arrays 
			var point:Point;
			for each (point in subjectPolygon) {
				subjectVertices.push(Math.round(point.x) as int, Math.round(point.y) as int);
			}
			for each (point in clipPolygon) {
				clipVertices.push(Math.round(point.x) as int, Math.round(point.y) as int);
			}
			
			// Only initialize the alchemy library once
			if (!_lib) {
				var loader:CLibInit = new CLibInit;
				_lib = loader.init();
			}
			
			var results:Array = _lib.clipPolygon(subjectVertices, subjectVertices.length, clipVertices, clipVertices.length, clipType);
			
			var ret:Array = [];
			for each (var resultPoly:Array in results) {
				var points:Array = new Array(resultPoly.length / 2);
				for (var i:int = 0; i < resultPoly.length; i += 2) {
					points[i / 2] = new Point(resultPoly[i], resultPoly[i+1]);
				}
				ret.push(points);
			}
			return ret;
		}
	}
}