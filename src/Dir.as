package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Dir extends Sprite
	{
		[Embed(source="dir.png")]
		private var SrcDir:Class;
		
		private var bmp:Bitmap
		private var bmpDest:Bitmap = new Bitmap();
		private var _velocity:int  = 100;
		private var intvl:int;
		private var midx:int = 0;
		private var bmpdt:BitmapData = new BitmapData(645, 15, true);  //43
		private var bmpdtsrc:BitmapData = new BitmapData(645, 15, true);  //43
		
		public function Dir() 
		{
			//graphics.lineStyle(1, 0x000000);
			//graphics.drawRect(0, 0, 645, 15)
			bmp = new SrcDir();
			//bmp.bitmapData
			addChild(bmpDest)
			for (var i:int = 0; i < 43; i++) {
				bmpdtsrc.copyPixels(bmp.bitmapData, new Rectangle(0, 0, 15, 15), new Point(15*i, 0))	
			}
			
			//bmpDest.bitmapData = 
			//bmpDest.bitmapData.copyPixels(bmp.bitmapData, new Rectangle(0, 0, 15, 15), new Point(0,0))
			//start();
		}
		
		public function start():void {
			setInterval(run, _velocity)
		}
		
		public function run(sun:int = 2):void {
			var idx:int = midx % 15;
			bmpDest.bitmapData = bmpdt.clone();
			bmpDest.bitmapData.copyPixels(bmpdtsrc, new Rectangle(0, 0, 645 - idx, 15), new Point(idx, 0))			
			bmpDest.bitmapData.copyPixels(bmpdtsrc, new Rectangle(645-idx, 0, 15, 15), new Point(0, 0))
			//trace(idx)
			midx+=sun;
			//addChild(bmpDest)
		}
		
		public function stop():void {
			clearInterval(intvl)
		}
		
		public function get velocity():int 
		{
			return _velocity;
		}
		
		public function set velocity(value:int):void 
		{
			_velocity = value;
			//stop()
			//start();
		}
		
	}
	
}