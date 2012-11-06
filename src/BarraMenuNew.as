package  
{
	import com.eclecticdesignstudio.motion.Actuate;
	import fl.controls.ComboBox;
	import fl.data.SimpleCollectionItem;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class BarraMenuNew extends Sprite
	{
		private var _comboFluxo:ComboBox;
		private var _comboCorrente:ComboBox;
		
		private var _fluxoMCmenu:MovieClip;
		private var _correnteMCmenu:MovieClip;
		
		private var _fluxoResult:MovieClip;
		private var _correnteResult:MovieClip;
		
		private var _openClose:MovieClip;
		private var menuOpen:Boolean = true;
		
		private var inicialX:Number = 5;
		private var finalX:Number = 202;
		
		public function BarraMenuNew() 
		{
			fazConexao();
			praparaCombo();
			preparaMC();
			addListeners();
			
			reset();
			
			if (menuOpen) {
				this.x = finalX;
				_openClose.gotoAndStop("CLOSE");
			}
			else {
				this.x = inicialX;
				_openClose.gotoAndStop("OPEN");
			}
		}
		
		private function preparaMC():void 
		{
			_fluxoMCmenu.mouseChildren = false;
			_fluxoMCmenu.buttonMode = true;
			_fluxoMCmenu.addEventListener(MouseEvent.CLICK, clickMC);
			
			_correnteMCmenu.mouseChildren = false;
			_correnteMCmenu.buttonMode = true;
			_correnteMCmenu.addEventListener(MouseEvent.CLICK, clickMC);
			
			_openClose.addEventListener(MouseEvent.CLICK, openCloseMenu);
			_openClose.buttonMode = true;
		}
		
		private function openCloseMenu(e:MouseEvent):void 
		{
			if (menuOpen) {
				menuOpen = false;
				_openClose.gotoAndStop("OPEN");
				Actuate.tween(this, 0.5, { x:inicialX} );
			}else {
				menuOpen = true;
				_openClose.gotoAndStop("CLOSE");
				Actuate.tween(this, 0.5, { x:finalX } );
			}
		}
		
		private function clickMC(e:MouseEvent):void 
		{
			var mc:MovieClip = MovieClip(e.target);
			
			if (mc.currentFrame < 3) mc.gotoAndStop(mc.currentFrame + 1);
			else mc.gotoAndStop(1);
			
			if (mc == _fluxoMCmenu) _comboFluxo.selectedIndex = mc.currentFrame - 1;
			else _comboCorrente.selectedIndex = mc.currentFrame - 1;
		}
		
		private function addListeners():void 
		{
			_comboFluxo.addEventListener(Event.CHANGE, changeCombo);
			_comboCorrente.addEventListener(Event.CHANGE, changeCombo);
		}
		
		private function praparaCombo():void 
		{
			_comboFluxo = new ComboBox();
			_comboFluxo.x = -177;
			_comboFluxo.y = -23;
			_comboFluxo.width = 125;
			_comboFluxo.addItem( { label:"Nenhum", value:"none"});
			_comboFluxo.addItem( { label:"Entrando na tela", value:"fluxoIn"});
			_comboFluxo.addItem( { label:"Saindo da tela", value:"fluxoOut" } );
			addChild(_comboFluxo);
			
			_comboCorrente = new ComboBox();
			_comboCorrente.x = -177;
			_comboCorrente.y = 33;
			_comboCorrente.width = 125;
			_comboCorrente.addItem( { label:"Nenhum", value:"none"});
			_comboCorrente.addItem( { label:"Sentido horário", value:"horario"});
			_comboCorrente.addItem( { label:"Sentido antihorário", value:"antiHorario" } );
			addChild(_comboCorrente);
		}
		
		private function changeCombo(e:Event):void 
		{
			var combo:ComboBox = ComboBox(e.target);
			if (combo == _comboFluxo) {
				_fluxoMCmenu.gotoAndStop(combo.selectedItem.value);
			}else {
				_correnteMCmenu.gotoAndStop(combo.selectedItem.value);
			}
		}
		
		public function reset():void 
		{
			_comboFluxo.selectedIndex = 0;
			_comboCorrente.selectedIndex = 0;
			
			_fluxoMCmenu.gotoAndStop(_comboFluxo.selectedItem.value);
			_correnteMCmenu.gotoAndStop(_comboCorrente.selectedItem.value);
			
			_fluxoResult.visible = false;
			_correnteResult.visible = false;
			
			unlock();
		}
		
		public function lock():void 
		{
			_comboFluxo.mouseEnabled = false;
			_comboCorrente.mouseEnabled = false;
			
			_fluxoMCmenu.mouseEnabled = false;
			_correnteMCmenu.mouseEnabled = false;
		}
		
		public function unlock():void 
		{
			_comboFluxo.mouseEnabled = true;
			_comboCorrente.mouseEnabled = true;
			
			_fluxoMCmenu.mouseEnabled = true;
			_correnteMCmenu.mouseEnabled = true;
		}
		
		private function fazConexao():void 
		{
			_fluxoMCmenu = fluxoMCmenu;
			_correnteMCmenu = correnteMCmenu;
			_openClose = openClose;
			_fluxoResult = fluxoResult;
			_correnteResult = correnteResult;
		}
		
		public function get comboFluxo():ComboBox 
		{
			return _comboFluxo;
		}
		
		public function get comboCorrente():ComboBox 
		{
			return _comboCorrente;
		}
		
		public function setAnswer(corrente:Boolean, fluxo:Boolean):void
		{
			if (corrente) _correnteResult.gotoAndStop("CERTO");
			else _correnteResult.gotoAndStop("ERRADO");
			
			if (fluxo) _fluxoResult.gotoAndStop("CERTO");
			else _fluxoResult.gotoAndStop("ERRADO");
			
			_correnteResult.visible = true;
			_fluxoResult.visible = true;
		}
		
	}

}