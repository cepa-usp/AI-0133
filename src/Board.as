package 
{
	import flash.display.Sprite;
	import graph.Coord;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Board extends Sprite
	{
		private var cargasLayer:Sprite;
		
		private var n:int;
		private var m:int;
		private var distance:Number = 32;
		private var cargas:Vector.<Vector.<Carga>> = new Vector.<Vector.<Carga>>();
		private var coord:Coord;
		private var campo:ICampo;
		
		public function Board(n:int, m:int, campo:ICampo, coord:Coord) 
		{
			this.n = n;
			this.m = m;
			this.campo = campo;
			this.coord = coord;
			
			createLayers();
			createBoard(n, m);
		}
		
		private function createLayers():void 
		{
			cargasLayer = new Sprite();
			addChild(cargasLayer);
		}
		
		private function createBoard(n:int, m:int):void 
		{
			var alphaMin:Number = 0;
			var alphaMax:Number = 1;
			
			var minValor:Number = 0;
			var maxValor:Number = 10;
			
			var off:Number = 14;
			var offY:Number = 10;
			
			for (var i:int = 0; i < n; i++) 
			{
				cargas[i] = new Vector.<Carga>();
				for (var j:int = 0; j < m; j++) 
				{
					cargas[i][j] = new Carga();
					cargas[i][j].y = i * distance + offY;
					cargas[i][j].x = j * distance + off;
					
					if(campo is Campo1){
						//var alpha:Number = Math.pow(Math.abs(campo.zcomp(coord.pixel2x(cargas[i][j].x), 0)) / 10, 2);
						var alpha:Number = 0.0095 * Math.pow(Math.abs(campo.zcomp(coord.pixel2x(cargas[i][j].x), 0)), 2) + 0.05;
						var zComp:Number = campo.zcomp(coord.pixel2x(cargas[i][j].x), 0);
					}else {
						alpha = 1;
						zComp = 0;
					}
					cargas[i][j].setDirection((zComp >= 0 ? false:true));
					cargas[i][j].setIntensity(alpha);
					
					cargasLayer.addChild(cargas[i][j]);
				}
				
			}
		}
		
	}

}