package 
{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIObserver;
	import cepa.eval.ProgressiveEvaluator;
	import cepa.eval.StatsScreen;
	import cepa.tutorial.CaixaTextoNova;
	import cepa.tutorial.Tutorial;
	import cepa.utils.ToolTip;
	import com.adobe.serialization.json.JSON;
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
	import graph.Coord;
	import pipwerks.SCORM;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends Sprite implements AIObserver
	{
		//Camadas:
		private var boardLayer:Sprite;
		private var areaLayer:Sprite;
		
		private var board:Board;
		private var area:Area;
		private var areaAvaliacao:Area;
		private var coord:Coord;
		
		private var campoAtual:ICampo;
		private var avalMode:Boolean;
		
		private var valendoNota:Boolean = false;
		private var minTentativas:int = 5;
		
		private var layerAtividade:Sprite;
		
		private var ai:AI;
		private var statsScreen:StatsScreen;
		
		/*
		 * Filtro de conversão para tons de cinza.
		 */
		protected const GRAYSCALE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0.2225, 0.7169, 0.0606, 0, 0,
			0.2225, 0.7169, 0.0606, 0, 0,
			0.2225, 0.7169, 0.0606, 0, 0,
			0.0000, 0.0000, 0.0000, 1, 0
		]);
		
		public function Main()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			ai = new AI(this);
			ai.container.optionButtons.addAllButtons();
			ai.container.messageLabel.visible = false;
			ai.container.setAboutScreen(new AboutScreen133());
			ai.container.setInfoScreen(new InstScreen133());
			ai.addObserver(this);
			ai.evaluator = new ProgressiveEvaluator(ai);
			ProgressiveEvaluator(ai.evaluator).feedback.x = stage.stageWidth / 2;
			ProgressiveEvaluator(ai.evaluator).feedback.y = stage.stageHeight / 2;
			
			statsScreen = new StatsScreen(ProgressiveEvaluator(ai.evaluator), ai);
			statsScreen.stats.x = stage.stageWidth / 2;
			statsScreen.stats.y = stage.stageHeight / 2;
			statsScreen.bindButton(ai.container.optionButtons.btStatistics);
			
			
			createLayers();
			configMenuBar();
			createCoord();
			sortCampo();
			createBoard();
			
			//var flashVars:Object = LoaderInfo(this.stage.loaderInfo).parameters;
			//var sec:String = flashVars.mode;
			
			var sec:String = "avaliacao";
			if (sec == "avaliacao") {
				avalMode = true;
				initEvaluationMode();
			}else {
				avalMode = false;
				initFreeMode();
			}
			
			/*if (connected) {
				if (scorm.get("cmi.entry") == "ab-initio") iniciaTutorial();
			}else {
				if (score == 0) iniciaTutorial();
			}*/
			
			//if (ExternalInterface.available) {
				//var sec:String = root.loaderInfo.parameters["mode"];
			//}
			
			ai.debugMode = true;
			ai.initialize();
		}
		
		protected function lock(bt:*):void
		{
			bt.filters = [GRAYSCALE_FILTER];
			bt.alpha = 0.5;
			bt.mouseEnabled = false;
		}
		
		protected function unlock(bt:*):void
		{
			bt.filters = [];
			bt.alpha = 1;
			bt.mouseEnabled = true;
		}
		
		private function askForValer(e:MouseEvent):void 
		{
			ProgressiveEvaluator(ai.evaluator).askEvaluation(menuBar.btValendo, fazValer);
			
			//ProgressiveEvaluator(ai.evaluator).currentPlayMode = AIConstants.PLAYMODE_EVALUATE;
			//menuBar.btValendo.visible = false;
			//trace("valendo");
			//feedbackScreen.okCancelMode = true;
			//feedbackScreen.addEventListener(BaseEvent.OK_SCREEN, fazValer);
			//feedbackScreen.setText("A partir de agora a atividade estará valendo nota. Você não poderá mais voltar ao modo de exploração.\nDeseja continuar?");
		}
		
		private function fazValer():void 
		{
			if(ProgressiveEvaluator(ai.evaluator).currentPlayMode == AIConstants.PLAYMODE_EVALUATE){
				valendoNota = true;
				//lock(menuBar.btValendo);
			}
		}
		
		private function createCoord():void 
		{
			coord = new Coord( -10, 10, 700, -8, 8, 500);
		}
		
		private function sortCampo():void 
		{
			campoAtual = new Campo1();
		}
		
		private function initEvaluationMode():void 
		{
			createArea(true);
		}
		
		private function initFreeMode():void 
		{
			lock(menuBar.visible);
			createArea();
		}
		
		private function createLayers():void 
		{
			layerAtividade = new Sprite();
			addChild(layerAtividade);
			setChildIndex(layerAtividade, 0);
			
			var fundo:Fundo = new Fundo();
			layerAtividade.addChild(fundo);
			boardLayer = new Sprite();
			layerAtividade.addChild(boardLayer);
			
			areaLayer = new Sprite();
			layerAtividade.addChild(areaLayer);
		}
		
		private var menuBar:BarraMenuNew;
		private function configMenuBar():void 
		{
			menuBar = new BarraMenuNew();
			menuBar.y = 66;
			layerAtividade.addChild(menuBar);
			
			menuBar.btAvaliar.gotoAndStop(1);
			menuBar.btAvaliar.buttonMode = true;
			menuBar.btAvaliar.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { menuBar.btAvaliar.gotoAndStop(2) } );
			menuBar.btAvaliar.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { menuBar.btAvaliar.gotoAndStop(1) } );
			
			menuBar.btNovamente.gotoAndStop(1);
			menuBar.btNovamente.buttonMode = true;
			menuBar.btNovamente.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { menuBar.btNovamente.gotoAndStop(2) } );
			menuBar.btNovamente.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { menuBar.btNovamente.gotoAndStop(1) } );
			
			menuBar.btVerResposta.gotoAndStop(1);
			menuBar.btVerResposta.buttonMode = true;
			menuBar.btVerResposta.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { menuBar.btVerResposta.gotoAndStop(2) } );
			menuBar.btVerResposta.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { menuBar.btVerResposta.gotoAndStop(1) } );
			
			menuBar.btVerResposta.addEventListener(MouseEvent.CLICK, showHideAnswer);
			
			lock(menuBar.btNovamente);
			menuBar.btVerResposta.visible = false;
			menuBar.btVerResposta.verexerc.visible = false;
			menuBar.btVerResposta.verresp.visible = true;
			
			menuBar.btNovamente.addEventListener(MouseEvent.CLICK, reset);
			menuBar.btAvaliar.addEventListener(MouseEvent.CLICK, aval);
			menuBar.btValendo.addEventListener(MouseEvent.CLICK, askForValer);
			
			addToolTips();
		}
		
		private function addToolTips():void
		{
			var ttAvaliar:ToolTip = new ToolTip(menuBar.btAvaliar, "Avaliar exercício", 12, 0.8, 200, 0.6, 0.6);
			var ttNovamente:ToolTip = new ToolTip(menuBar.btNovamente, "Novo exercício", 12, 0.8, 200, 0.6, 0.6);
			var ttVerResp:ToolTip = new ToolTip(menuBar.btVerResposta, "Mostrar/esconder resposta", 12, 0.8, 250, 0.6, 0.6);
			var ttValendo:ToolTip = new ToolTip(menuBar.btValendo, "Mudar para o modo de avaliação", 12, 0.8, 250, 0.6, 0.6);
			
			var ttFluxo:ToolTip = new ToolTip(menuBar.fluxoMc, "Fluxo induzido", 12, 0.8, 200, 0.6, 0.6);
			var ttCorrente:ToolTip = new ToolTip(menuBar.correnteMc, "Corrente induzida", 12, 0.8, 200, 0.6, 0.6);
			
			stage.addChild(ttAvaliar);
			stage.addChild(ttNovamente);
			stage.addChild(ttVerResp);
			stage.addChild(ttValendo);
			
			stage.addChild(ttFluxo);
			stage.addChild(ttCorrente);
		}
		
		private var eval:Boolean = false;
		private var newScore:Number;
		private function aval(e:MouseEvent):void 
		{
			if (!eval) {
				eval = true;
				menuBar.btAvaliar.visible = false;
				unlock(menuBar.btNovamente);
				menuBar.btVerResposta.visible = true;
				menuBar.lock();
				
				showAnswer();
			}
		}
		
		private var filtroCerto:GlowFilter = new GlowFilter(0x008000, 1, 10, 10)
		private function showAnswer():void 
		{
			var fluxo:Boolean = BarraMenuNew(menuBar).comboFluxo.selectedItem.value == area.currentExercice.answerCampo;
			var corrente:Boolean = BarraMenuNew(menuBar).comboCorrente.selectedItem.value == area.currentExercice.answerRotation;
			
			var aval:Avaliacao = new Avaliacao(corrente, fluxo);
			aval.evaluate();
			newScore = 0;
			
			BarraMenuNew(menuBar).setAnswer(corrente, fluxo);
			
			ai.evaluator.addPlayInstance(aval);
			
			//if (!fluxo) menuBar.mcFluxo[area.currentExercice.answerCampo].filters = [filtroCerto];
			//if(!corrente) menuBar.mcCorrente[area.currentExercice.answerRotation].filters = [filtroCerto];
		}
		
		private function showHideAnswer(e:MouseEvent):void 
		{
			if (menuBar.btVerResposta.verresp.visible) {
				menuBar.btVerResposta.verresp.visible = false;
				menuBar.btVerResposta.verexerc.visible = true;
				area.showVisualAnswer = true;
			}else {
				menuBar.btVerResposta.verresp.visible = true;
				menuBar.btVerResposta.verexerc.visible = false;
				area.showVisualAnswer = false;
			}
		}
		
		public function reset(e:MouseEvent = null):void 
		{
			menuBar.btAvaliar.visible = true;
			lock(menuBar.btNovamente);
			menuBar.btVerResposta.visible = false;
			menuBar.btVerResposta.verexerc.visible = false;
			menuBar.btVerResposta.verresp.visible = true;
			
			menuBar.reset();
			
			createArea(avalMode);
			
			eval = false;
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onResetClick():void 
		{
			reset();
		}
		
		public function onScormFetch():void 
		{
			
		}
		
		public function onScormSave():void 
		{
			
		}
		
		private var tutorial:Tutorial;
		public function onTutorialClick():void 
		{
			if (tutorial == null) {
				tutorial = new Tutorial();
				tutorial.adicionarBalao("Testando.", new Point(30, 100), CaixaTextoNova.LEFT, CaixaTextoNova.FIRST);
				tutorial.adicionarBalao("Testando 2.", new Point(60, 200), CaixaTextoNova.LEFT, CaixaTextoNova.CENTER);
				tutorial.adicionarBalao("Testando 3.", new Point(90, 300), CaixaTextoNova.LEFT, CaixaTextoNova.LAST);
				tutorial.adicionarBalao("Testando 4.", new Point(100, 400), CaixaTextoNova.RIGHT, CaixaTextoNova.FIRST);
				tutorial.adicionarBalao("Testando 5.", new Point(120, 500), CaixaTextoNova.RIGHT, CaixaTextoNova.LAST);
			}
			
			tutorial.iniciar(stage, true);
		}
		
		public function onScormConnected():void 
		{
			
		}
		
		public function onScormConnectionError():void 
		{
			
		}
		
		public function onStatsClick():void 
		{
			
		}
		
		private function createBoard():void 
		{
			board = new Board(17, 22, campoAtual, coord);
			boardLayer.addChild(board);
		}
		
		private function createArea(aval:Boolean = false):void 
		{
			if (area != null) {
				areaLayer.removeChild(area);
				area = null;
			}
			area = new Area(campoAtual, coord, aval);
			areaLayer.addChild(area);
			if(!aval){
				area.x = 300;
				area.y = 200;
			}
		}
		
		
		
		//---------------- Tutorial -----------------------
		/*
		private var balao:CaixaTexto;
		private var pointsTuto:Array;
		private var tutoBaloonPos:Array;
		private var tutoPos:int;
		private var tutoSequence:Array;
		
		override public function iniciaTutorial(e:MouseEvent = null):void  
		{
			blockAI();
			
			tutoPos = 0;
			if(balao == null){
				balao = new CaixaTexto();
				layerTuto.addChild(balao);
				balao.visible = false;
				
				tutoSequence = ["Veja aqui as orientações.",
								"Selecione o fluxo e a corrente que serão induzidos de acordo com a área.",
								"Pressione \"Avaliar\" para verificar sua resposta.",
								"Ao pressionar avaliar você poderá verificar a resposta através do botão \"Visualizar/Ocultar resposta\".",
								"Ao pressionar \"Valendo nota\" suas respostas serão computadas. Você NÃO pode voltar ao modo de exploração.",
								"Responda no mínimo " + minTentativas + " exercícios para finalizar a atividade.",
								"Para iniciar uma nova tentativa pressione o botão \"Reset\"."];
				
				pointsTuto = 	[new Point(645, 405),
								new Point(240 , 500),
								new Point(324 , 446),
								new Point(180 , 180),
								new Point(220 , 220),
								new Point(240 , 240),
								new Point(543,456)];
								
				tutoBaloonPos = [[CaixaTexto.RIGHT, CaixaTexto.CENTER],
								[CaixaTexto.BOTTON, CaixaTexto.FIRST],
								["", ""],
								["", ""],
								["", ""],
								["", ""],
								[CaixaTexto.BOTTON, CaixaTexto.LAST]];
			}
			balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			
			balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
			balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			balao.addEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			balao.addEventListener(BaseEvent.CLOSE_BALAO, iniciaAi);
		}
		
		private function closeBalao(e:Event):void 
		{
			tutoPos++;
			if (tutoPos >= tutoSequence.length) {
				balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
				balao.visible = false;
				iniciaAi(null);
			}else {
				balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
				balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			}
		}
		
		private function iniciaAi(e:BaseEvent):void 
		{
			balao.removeEventListener(BaseEvent.CLOSE_BALAO, iniciaAi);
			balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			unblockAI();
		}
		*/
		
	}

}