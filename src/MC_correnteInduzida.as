package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class MC_correnteInduzida extends Sprite
	{
		private var _btnSelected:MovieClip;
		
		public function MC_correnteInduzida() 
		{
			certoErrado.visible = false;
			addListeners();
		}
		
		private function addListeners():void 
		{
			btnHorario.mouseChildren = false;
			btnAntiHorario.mouseChildren = false;
			btnNone.mouseChildren = false;
			
			btnHorario.buttonMode = true;
			btnAntiHorario.buttonMode = true;
			btnNone.buttonMode = true;
			
			btnHorario.addEventListener(MouseEvent.CLICK, selectBtn);
			btnAntiHorario.addEventListener(MouseEvent.CLICK, selectBtn);
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
			btnHorario.gotoAndStop("NONE");
			btnAntiHorario.gotoAndStop("NONE");
			btnNone.gotoAndStop("NONE");
			_btnSelected = null;
		}
		
		public function lockAll():void
		{
			btnHorario.mouseEnabled = false;
			btnAntiHorario.mouseEnabled = false;
			btnNone.mouseEnabled = false;
		}
		
		public function unlockAll():void
		{
			btnHorario.mouseEnabled = true;
			btnAntiHorario.mouseEnabled = true;
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
			removeAllFilters();
			certoErrado.visible = false;
		}
		
		private function removeAllFilters():void 
		{
			btnHorario.filters = [];
			btnAntiHorario.filters = [];
			btnNone.filters = [];
		}
		
	}

}