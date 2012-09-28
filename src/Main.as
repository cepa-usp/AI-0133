package 
{
	import BaseAssets.BaseMain;
	import BaseAssets.events.BaseEvent;
	import BaseAssets.tutorial.CaixaTexto;
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
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
	import graph.Coord;
	import pipwerks.SCORM;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends BaseMain
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
		
		
		override protected function init():void 
		{
			createLayers();
			configMenuBar();
			createCoord();
			sortCampo();
			createBoard();
			
			layerAtividade.addChild(btValendo);
			btValendo.addEventListener(MouseEvent.CLICK, askForValer);
			feedbackScreen.addEventListener(BaseEvent.OK_SCREEN, fazValer);
			
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
			
			if (ExternalInterface.available) {
				initLMSConnection();
				if (mementoSerialized != null) {
					if(mementoSerialized != "" && mementoSerialized != "null") recoverStatus(mementoSerialized);
				}
			}
			
			if (connected) {
				if (scorm.get("cmi.entry") == "ab-initio") iniciaTutorial();
			}else {
				if (score == 0) iniciaTutorial();
			}
			
			//if (ExternalInterface.available) {
				//var sec:String = root.loaderInfo.parameters["mode"];
			//}
		}
		
		private function askForValer(e:MouseEvent):void 
		{
			feedbackScreen.okCancelMode = true;
			feedbackScreen.setText("A partir de agora a atividade estará valendo nota. Você não poderá mais voltar ao modo de exploração.\nDeseja continuar?");
		}
		
		private function fazValer(e:Event):void 
		{
			valendoNota = true;
			btValendo.visible = false;
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
			menuBar.visible = false;
			createArea();
		}
		
		private function createLayers():void 
		{
			layerAtividade.addChild(fundo);
			boardLayer = new Sprite();
			layerAtividade.addChild(boardLayer);
			
			areaLayer = new Sprite();
			layerAtividade.addChild(areaLayer);
		}
		
		private function configMenuBar():void 
		{
			layerAtividade.addChild(menuBar);
			
			menuBar.y = 446;
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
			
			menuBar.btNovamente.visible = false;
			menuBar.btVerResposta.visible = false;
			menuBar.btVerResposta.verexerc.visible = false;
			menuBar.btVerResposta.verresp.visible = true;
			
			menuBar.btNovamente.addEventListener(MouseEvent.CLICK, reset);
			menuBar.btAvaliar.addEventListener(MouseEvent.CLICK, aval);
			
			addToolTips();
		}
		
		private function addToolTips():void
		{
			var ttAvaliar:ToolTip = new ToolTip(menuBar.btAvaliar, "Avaliar exercício", 12, 0.8, 200, 0.6, 0.6);
			var ttNovamente:ToolTip = new ToolTip(menuBar.btNovamente, "Nova tentativa", 12, 0.8, 200, 0.6, 0.6);
			var ttVerResp:ToolTip = new ToolTip(menuBar.btVerResposta, "Mostrar/esconder resposta", 12, 0.8, 250, 0.6, 0.6);
			
			var ttFluxo:ToolTip = new ToolTip(menuBar.mcFluxo.fluxoMc, "Fluxo induzido", 12, 0.8, 200, 0.6, 0.6);
			var ttCorrente:ToolTip = new ToolTip(menuBar.mcCorrente.correnteMc, "Corrente induzida", 12, 0.8, 200, 0.6, 0.6);
			
			stage.addChild(ttAvaliar);
			stage.addChild(ttNovamente);
			stage.addChild(ttVerResp);
			
			stage.addChild(ttFluxo);
			stage.addChild(ttCorrente);
		}
		
		private var eval:Boolean = false;
		private var newScore:Number;
		private function aval(e:MouseEvent):void 
		{
			if (!eval) {
				if(menuBar.mcFluxo.btnSelected != null && menuBar.mcCorrente.btnSelected != null){
					eval = true;
					menuBar.btAvaliar.visible = false;
					menuBar.btNovamente.visible = true;
					menuBar.btVerResposta.visible = true;
					
					menuBar.mcFluxo.lockAll();
					menuBar.mcCorrente.lockAll();
					
					showAnswer();
					
				}else {
					feedbackScreen.setText("Você precisa selecionar um fluxo induzido e uma corrente induzida para ser avaliado.");
				}
			}
		}
		
		private var filtroCerto:GlowFilter = new GlowFilter(0x008000, 1, 10, 10)
		private function showAnswer():void 
		{
			newScore = 0;
			
			if (menuBar.mcFluxo.btnSelected.name == area.currentExercice.answerCampo) {
				menuBar.mcFluxo.setCertoErrado(true);
				newScore += 50;
			}else {
				menuBar.mcFluxo.setCertoErrado(false);
				menuBar.mcFluxo[area.currentExercice.answerCampo].filters = [filtroCerto];
			}
			
			if(menuBar.mcCorrente.btnSelected.name == area.currentExercice.answerRotation) {
				menuBar.mcCorrente.setCertoErrado(true);
				newScore += 50;
			}else {
				menuBar.mcCorrente.setCertoErrado(false);
				menuBar.mcCorrente[area.currentExercice.answerRotation].filters = [filtroCerto];
			}
			
			if (newScore > score) {
				score = newScore;
				completed = true;
				commit();
			}
		}
		
		private function saveStatusForRecovery():void 
		{
			var status:Object = new Object();
			
			status.completed = completed;
			status.score = score;
			
			//Salvar o status da atividade
			status.valendoNota = valendoNota;
			
			mementoSerialized = com.adobe.serialization.json.JSON.encode(status);
		}
		
		private function recoverStatus(memento:String):void
		{
			var status:Object = com.adobe.serialization.json.JSON.decode(memento);
			if (!connected) {
				completed = status.completed;
				score = status.score;
			}
			
			//Recuperar o status da atividade
			valendoNota = status.valendoNota;
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
		
		override public function reset(e:MouseEvent = null):void 
		{
			menuBar.btAvaliar.visible = true;
			menuBar.btNovamente.visible = false;
			menuBar.btVerResposta.visible = false;
			menuBar.btVerResposta.verexerc.visible = false;
			menuBar.btVerResposta.verresp.visible = true;
			
			menuBar.mcCorrente.reset();
			menuBar.mcFluxo.reset();
			
			createArea(avalMode);
			
			eval = false;
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
		
		
		
		/*------------------------------------------------------------------------------------------------*/
		//SCORM:
		
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos
		private var completed:Boolean;
		private var scorm:SCORM;
		private var scormExercise:int;
		private var connected:Boolean;
		private var score:Number = 0;
		private var pingTimer:Timer;
		private var mementoSerialized:String = "";
		
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		private function initLMSConnection () : void
		{
			completed = false;
			connected = false;
			scorm = new SCORM();
			
			pingTimer = new Timer(PING_INTERVAL);
			pingTimer.addEventListener(TimerEvent.TIMER, pingLMS);
			
			connected = scorm.connect();
			
			if (connected) {
				
				if (scorm.get("cmi.mode" != "normal")) return;
				
				scorm.set("cmi.exit", "suspend");
				// Verifica se a AI já foi concluída.
				var status:String = scorm.get("cmi.completion_status");	
				mementoSerialized = scorm.get("cmi.suspend_data");
				var stringScore:String = scorm.get("cmi.score.raw");
			 
				switch(status)
				{
					// Primeiro acesso à AI
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						break;
					
					// Continuando a AI...
					case "incomplete":
						completed = false;
						break;
					
					// A AI já foi completada.
					case "completed":
						completed = true;
						//setMessage("ATENÇÃO: esta Atividade Interativa já foi completada. Você pode refazê-la quantas vezes quiser, mas não valerá nota.");
						break;
				}
				
				//unmarshalObjects(mementoSerialized);
				scormExercise = int(scorm.get("cmi.location"));
				score = Number(stringScore.replace(",", "."));
				//txNota.text = score.toFixed(1).replace(".", ",");
				
				var success:Boolean = scorm.set("cmi.score.min", "0");
				if (success) success = scorm.set("cmi.score.max", "100");
				
				if (success)
				{
					scorm.save();
					pingTimer.start();
				}
				else
				{
					//trace("Falha ao enviar dados para o LMS.");
					connected = false;
				}
			}
			else
			{
				trace("Esta Atividade Interativa não está conectada a um LMS: seu aproveitamento nela NÃO será salvo.");
				mementoSerialized = ExternalInterface.call("getLocalStorageString");
			}
			
			//reset();
		}
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		private function commit()
		{
			if (connected)
			{
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", score.toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				success = scorm.set("cmi.location", scormExercise.toString());
				
				// Salva no LMS a string que representa a situação atual da AI para ser recuperada posteriormente.
				//mementoSerialized = marshalObjects();
				success = scorm.set("cmi.suspend_data", mementoSerialized.toString());

				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					//setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}else { //LocalStorage
				ExternalInterface.call("save2LS", mementoSerialized);
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent)
		{
			//scorm.get("cmi.completion_status");
			commit();
		}
		
		private function saveStatus(e:Event = null):void
		{
			if (ExternalInterface.available) {
				saveStatusForRecovery();
				if (connected) {
					//Scorm
					if (scorm.get("cmi.mode" != "normal")) return;
					scorm.set("cmi.suspend_data", mementoSerialized);
					commit();
				}else {
					//LocalStorage
					ExternalInterface.call("save2LS", mementoSerialized);
				}
			}
		}
		
	}

}