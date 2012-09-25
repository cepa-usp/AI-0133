package graph
{
	import cepa.graph.DataStyle;
	import cepa.graph.GraphFunction;
	import cepa.graph.rectangular.SimpleGraph;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Coord extends Sprite
	{
		private var state:int;
		
		/*layers*/
		private var sprButtons:Sprite;
		private var sprSelection:Sprite;
		private var sprGraphic:SimpleGraph;
		private var selectionRect:Rectangle;
		
		//private var zoomInBtn:ZoomIn;
		//private var zoomOutBtn:ZoomOut;
		//private var selectBtn:SelectBtn;
		private var glow:GlowFilter = new GlowFilter(0xFDE0D9, 1)
		
		public function Coord(xmin:Number, xmax:Number, xsize:Number, ymin:Number, ymax:Number, ysize:Number) : void {
			
			bindLayers(xmin, xmax, xsize, ymin, ymax, ysize);
			//addButtons();
		}
		
		/*private function addButtons():void 
		{
			selectBtn = new SelectBtn();
			zoomInBtn = new ZoomIn();
			zoomOutBtn = new ZoomOut();
			
			selectBtn.mouseChildren = false;
			zoomInBtn.mouseChildren = false;
			zoomOutBtn.mouseChildren = false;
			
			addChild(selectBtn);
			addChild(zoomInBtn);
			addChild(zoomOutBtn);
			
			selectBtn.x = -20;
			selectBtn.y = 20;
			selectBtn.gotoAndStop(2);
			
			zoomInBtn.x = -20;
			zoomInBtn.y = 50;
			zoomInBtn.gotoAndStop(1);
			
			zoomOutBtn.x = -20;
			zoomOutBtn.y = 80;
			zoomOutBtn.gotoAndStop(1);
			
			bindGlow(selectBtn);
			bindGlow(zoomInBtn);
			bindGlow(zoomOutBtn);
			
			bindAction(selectBtn, CoordState.SELECT);
			bindAction(zoomInBtn, CoordState.ZOOM_IN);
			bindAction(zoomOutBtn, CoordState.ZOOM_OUT);

			
		}*/
		
		/*private function bindAction(s:MovieClip, state:int):void {
			s.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void 
				{ 
					
					selectBtn.gotoAndStop(1);
					zoomInBtn.gotoAndStop(1);
					zoomOutBtn.gotoAndStop(1);
					
					changeState(state) 
					s.gotoAndStop(2)
					e.stopImmediatePropagation()
					
				}
			)
				

		}*/
		
		//private function bindGlow(s:MovieClip):void {
			//s.addEventListener(MouseEvent.MOUSE_OVER, turnOnButton)
			//s.addEventListener(MouseEvent.MOUSE_OUT, turnOffButton)
		//}
		//private function turnOnButton(e:MouseEvent):void {			
			//Sprite(e.target).filters = [glow];
			//
		//}
		//private function turnOffButton(e:MouseEvent):void {
			//Sprite(e.target).filters = [];
		//}
		
		
		private function bindLayers(xmin:Number, xmax:Number, xsize:Number, ymin:Number, ymax:Number, ysize:Number):void {
			sprButtons = new Sprite();
			sprSelection = new Sprite();
			sprGraphic = new SimpleGraph(xmin, xmax, xsize, ymin, ymax, ysize)
			sprGraphic.enableTicks(SimpleGraph.AXIS_X, true);
			sprGraphic.enableTicks(SimpleGraph.AXIS_Y, true);
			sprGraphic.setTicksDistance(SimpleGraph.AXIS_X, 1)
			sprGraphic.setTicksDistance(SimpleGraph.AXIS_Y, 1)
			addChild(sprGraphic);
			addChild(sprSelection);
			addChild(sprButtons);
			sprGraphic.mouseChildren = false;
		
		}	

		
		
		
		
		public function pixel2x(px:Number):Number {
			return sprGraphic.pixel2x(px);
		}
		public function pixel2y(py:Number):Number {
			return sprGraphic.pixel2y(py);
		}
		public function x2pixel(px:Number):Number {
			return sprGraphic.x2pixel(px);
		}
		public function y2pixel(py:Number):Number {
			return sprGraphic.y2pixel(py);
		}
		public function get xmin():Number {
			return sprGraphic.xmin;
		}
		public function get xmax():Number {
			return sprGraphic.xmax;
		}
		public function get ymin():Number {
			return sprGraphic.ymin;
		}
		public function get ymax():Number {
			return sprGraphic.ymax;
		}
		
		
		//public function zoomIn(e:MouseEvent):void {
			//var pt:Point = new Point(pixel2x(e.localX), pixel2y(e.localY))
			//zoom( -0.5, pt)
			//notifyChanges()
			//
		//}
		
		public function notifyChanges():void {
			dispatchEvent(new Event(Event.CHANGE))
		}
		
		
		//public function zoomOut(e:MouseEvent):void {
			//var pt:Point = new Point(pixel2x(e.localX), pixel2y(e.localY))			
			//zoom(0.5, pt)
			//notifyChanges()
		//}		
		
		//public function startSelection(e:MouseEvent):void {
//			if(this.hitTestPoint(stage.mouseX, stage.mouseY)){
				//stage.addEventListener(MouseEvent.MOUSE_UP, stopSelection);
				//stage.addEventListener(MouseEvent.MOUSE_MOVE, changeSelection);
				//selectionRect = new Rectangle(this.mouseX, this.mouseY, 0, 0)
//			}
		//}
		//public function changeSelection(e:MouseEvent):void {	
				//var pt:Point = globalToLocal(new Point(e.stageX, e.stageY));
				//selectionRect.width = pt.x - selectionRect.x;
				//selectionRect.height = pt.y - selectionRect.y;
				//drawSelection();
			//
		//}
		//public function drawSelection():void {
			//var g:Graphics = sprSelection.graphics;
			//g.clear();
			//g.lineStyle(1, 0xA080FF, 0.8);
			//g.beginFill(0xA080FF, 0.1);
			//g.drawRect(selectionRect.x, selectionRect.y, selectionRect.width, selectionRect.height)
			//
		//}
		//public function stopSelection(e:MouseEvent):void {
			//stage.removeEventListener(MouseEvent.MOUSE_UP, stopSelection);
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE, changeSelection);
//
			//var g:Graphics = sprSelection.graphics;
			//g.clear();
			//
			//var selEv:SelectionEvent = new SelectionEvent(SelectionEvent.SELECT)
			//var ptIni:Point = localToGlobal(new Point(selectionRect.x, selectionRect.y))
			//selEv.globalRect = new Rectangle(ptIni.x, ptIni.y, selectionRect.width, selectionRect.height)
			//dispatchEvent(selEv)
			//
		//}
		
		//private function zoom(factor:Number, center_pt:Point):void {
			//var sx:Number = sprGraphic.xmax - sprGraphic.xmin;
			//var sy:Number = sprGraphic.ymax - sprGraphic.ymin;
			//var zoomdiv:int = 1;
			//if (sx <= 2.00000 || sy <= 2.00000) {
				//zoomdiv = 10;
				//sprGraphic.setSubticksDistance(SimpleGraph.AXIS_X, 0.1)
				//sprGraphic.setSubticksDistance(SimpleGraph.AXIS_Y, 0.1)
			//} else {
				//sprGraphic.setSubticksDistance(SimpleGraph.AXIS_X, 0.5)
				//sprGraphic.setSubticksDistance(SimpleGraph.AXIS_Y, 0.5)				
			//}
			//trace(zoomdiv, sx, sy)
//
			//sprGraphic.draw()
			//var newminx:Number = center_pt.x - sx / 2 - factor/zoomdiv
			//var newmaxx:Number = center_pt.x + sx / 2 + factor/zoomdiv
			//var newminy:Number = center_pt.y - sy / 2 - factor/zoomdiv
			//var newmaxy:Number = center_pt.y + sy / 2 + factor/zoomdiv
			//if (newminx >= newmaxx) {
				//trace("opa")
			//}
			//try {
				//sprGraphic.setRange(newminx, newmaxx, newminy, newmaxy)
				//sprGraphic.draw()
			//} catch (e:Error) {
				//
			//}
//
		//}
		public function changeBounds(xmin:Number, xmax:Number, ymin:Number, ymax:Number):void {
			sprGraphic.xmin = xmin;
			sprGraphic.xmax = xmax;
			sprGraphic.ymin = ymin;
			sprGraphic.ymax = ymax;
			sprGraphic.draw();
			notifyChanges();
		}
		
		//private function zoomInClick(e:MouseEvent):void {
			//if (e.shiftKey) {
				//zoomOut(e);
			//} else {
				//zoomIn(e);
			//}
		//}

		//private function zoomOutClick(e:MouseEvent):void {
			//if (!e.shiftKey) {
				//zoomOut(e);
			//} else {
				//zoomIn(e);
			//}
		//}
		
		
		//public function changeState(new_state:int):void {
			//removeEventListener(MouseEvent.CLICK, zoomInClick)
			//removeEventListener(MouseEvent.CLICK, zoomOutClick)
			//removeEventListener(MouseEvent.MOUSE_DOWN, startSelection)
			//state = new_state;
			//
			//switch(state) {
				//case CoordState.NONE:
					//break;
				//case CoordState.ZOOM_IN:
					//addEventListener(MouseEvent.CLICK, zoomInClick)
					//break;
				//case CoordState.ZOOM_OUT:
					//addEventListener(MouseEvent.CLICK, zoomOutClick)
					//break;					
				//case CoordState.SELECT:
					//addEventListener(MouseEvent.MOUSE_DOWN, startSelection)
					//break;										
			//}
		//}
		
		//private var fs:Vector.<GraphFunction>;
		//public var hasCurves:Boolean = false;
		//
		//public function addCurves():void
		//{
			//fs = Vector.<GraphFunction>([
			//new GraphFunction (sprGraphic.xmin, sprGraphic.xmax, levelCurve0),
			//new GraphFunction (sprGraphic.xmin, sprGraphic.xmax, levelCurve1),
			//new GraphFunction (sprGraphic.xmin, sprGraphic.xmax, levelCurve2),
			//new GraphFunction (sprGraphic.xmin, sprGraphic.xmax, levelCurve3),
			//new GraphFunction (sprGraphic.xmin, sprGraphic.xmax, levelCurve4),
			//new GraphFunction (sprGraphic.xmin, sprGraphic.xmax, levelCurve5),
			//new GraphFunction (sprGraphic.xmin, sprGraphic.xmax, levelCurve6),
			//new GraphFunction (sprGraphic.xmin, sprGraphic.xmax, levelCurve7)
			//]);
		//
			//var style:DataStyle = new DataStyle();
			//style.color = 0xC0C0C0;
			//
			//for each (var f:GraphFunction in fs) sprGraphic.addFunction(f, style);
			//sprGraphic.draw();
			//
			//hasCurves = true;
		//}
		
		//public function removeCurves():void
		//{
			//for each (var f:GraphFunction in fs) sprGraphic.removeFunction(f);
			//sprGraphic.draw();
			//hasCurves = false;
		//}
		
		//public var cs:Array = [1, 2.25, 4, 6.25, 9, 12.25, 16, 20.25];//1/4,
		
		
		//private function levelCurve0 (x:Number) : Number {
			//return cs[0] / x;
		//}
		//
		//private function levelCurve1 (x:Number) : Number {
			//return cs[1] / x;
		//}
		//
		//private function levelCurve2 (x:Number) : Number {
			//return cs[2] / x;
		//}
		//
		//private function levelCurve3 (x:Number) : Number {
			//return cs[3] / x;
		//}
		//
		//private function levelCurve4 (x:Number) : Number {
			//return cs[4] / x;
		//}
		//
		//private function levelCurve5 (x:Number) : Number {
			//return cs[5] / x;
		//}
		//
		//private function levelCurve6 (x:Number) : Number {
			//return cs[6] / x;
		//}
		//
		//private function levelCurve7 (x:Number) : Number {
			//return cs[7] / x;
		//}
		//
		//private function levelCurve8 (x:Number) : Number {
			//return cs[8] / x;
		//}
		
	}
	
	
}


