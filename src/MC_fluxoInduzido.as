package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class MC_fluxoInduzido extends Sprite
	{
		private var _btnSelected:MovieClip;
		
		public function MC_fluxoInduzido() 
		{
			certoErrado.visible = false;
			addListeners();
		}
		
		private function addListeners():void 
		{
			btnFluxoOut.mouseChildren = false;
			btnFluxoIn.mouseChildren = false;
			btnNone.mouseChildren = false;
			
			btnFluxoOut.buttonMode = true;
			btnFluxoIn.buttonMode = true;
			btnNone.buttonMode = true;
			
			btnFluxoOut.addEventListener(MouseEvent.CLICK, selectBtn);
			btnFluxoIn.addEventListener(MouseEvent.CLICK, selectBtn);
			btnNone.addEventListener(MouseEvent.CLICK, selectBtn);
		}
		
		private function selectBtn(e:MouseEvent):void 
		{
			var btnClicked:MovieClip = MovieClip(e.target);
			if (_btnSelected == null) {
				_btnSelected = btnClicked;
				_btnSelected.gotoAndStop("SELECTED");
			}else if(btnClicked == _btnSelected){
				_btnSelected.gotoAndStop("NONE");
				_btnSelected = null;
			}else {
				unselectAll();
				_btnSelected = btnClicked;
				_btnSelected.gotoAndStop("SELECTED");
			}
		}
		
		public function unselectAll():void 
		{
			btnFluxoOut.gotoAndStop("NONE");
			btnFluxoIn.gotoAndStop("NONE");
			btnNone.gotoAndStop("NONE");
			_btnSelected = null;
		}
		
		public function lockAll():void
		{
			btnFluxoOut.mouseEnabled = false;
			btnFluxoIn.mouseEnabled = false;
			btnNone.mouseEnabled = false;
		}
		
		public function unlockAll():void
		{
			btnFluxoOut.mouseEnabled = true;
			btnFluxoIn.mouseEnabled = true;
			btnNone.mouseEnabled = true;
		}
		
		public function get btnSelected():MovieClip 
		{
			return _btnSelected;
		}
		
		public function setCertoErrado(value:Boolean):void
		{
			if (value) {
				certoErrado.gotoAndStop("CERTO");
			}else {
				certoErrado.gotoAndStop("ERRADO");
			}
			certoErrado.visible = true;
		}
		
		public function reset():void
		{
			unselectAll();
			unlockAll();
			removeAllFilters()
			certoErrado.visible = false;
		}
		
		private function removeAllFilters():void 
		{
			btnFluxoOut.filters = [];
			btnFluxoIn.filters = [];
			btnNone.filters = [];
		}
		
	}

}