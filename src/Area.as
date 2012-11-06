package 
{
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import graph.Coord;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Area extends Sprite
	{
		private var areaAnwer:MovieClip;
		private var spr_Area:Sprite;
		//private var spr_Mask:Sprite;
		private var spr_Mask:Mask2;
		private var raio:Number = 100;
		
		private var larguraFlecha:Number = 6;
		private var alturaFlecha:Number = 12;
		
		private var rMin:Number = 20;
		private var rMax:Number = 200;
		
		private var velRotation:Number = 2;
		
		private var evaluationMode:Boolean;
		
		private var campo:ICampo;
		private var coord:Coord;
		//private var fundo:CoresFundo;
		private var fundo:Sprite;
		private var leftDir:Dir;
		private var rightDir:Dir;
		private var topDir:Dir;
		private var bottonDir:Dir;
		
		private var maxRotationFrame:Number = 30;
		private var areaMax:Number;
		
		public var currentExercice:Object;
		private var exercices:Vector.<Object> = new Vector.<Object>();
		private var widthAnswer:Number = 200;
		private var heightAnswer:Number = 150;
		private var direction:Carga;
		public var showVisualAnswer:Boolean = false;
		
		public function Area(campo:ICampo, coord:Coord, evaluationMode:Boolean = false) 
		{
			this.campo = campo;
			this.coord = coord;
			this.evaluationMode = evaluationMode;
			
			var dX:Number = coord.xmax - coord.xmin;
			var dY:Number = coord.ymax - coord.ymin;
			areaMax = coord.xmax * dX * dY - (coord.xmin * dX * dY);
			
			areaAnwer = new AreaAnswer();
			addChild(areaAnwer);
			areaAnwer.visible = false;
			
			drawArea();
			if (evaluationMode) {
				createExercices();
				sortExercise();
			}else{
				addListeners();
			}
		}
		
		private function drawArea():void 
		{
			//fundo = new CoresFundo();
			fundo = new Sprite();
			//fundo.alpha = 0.5;
			addChild(fundo);
			direction = new Carga();
			fundo.addChild(direction);
			leftDir = new Dir();
			rightDir = new Dir();
			topDir = new Dir();
			bottonDir = new Dir();
			fundo.addChild(topDir);
			fundo.addChild(rightDir);
			fundo.addChild(bottonDir);
			fundo.addChild(leftDir);
			rightDir.rotation = 90;
			bottonDir.rotation = 180;
			leftDir.rotation = 270;
			
			fundo.alpha = 0;
			var widDir:Number = 645 / 2;
			
			topDir.x = -widDir;
			rightDir.y = -widDir;
			bottonDir.x = widDir;
			leftDir.y = widDir;
			
			topDir.velocity = 100;
			rightDir.velocity = 100;
			bottonDir.velocity = 100;
			leftDir.velocity = 100;
			
			//spr_Mask = new Sprite();
			//addChild(spr_Mask);
			spr_Mask = new Mask2();
			addChild(spr_Mask);
			spr_Mask.cacheAsBitmap = true;
			fundo.mask = spr_Mask;
			spr_Area = new Sprite();
			addChild(spr_Area);
			redrawArea();
		}
		
		private function addListeners():void 
		{
			spr_Area.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
		}
		
		private const fluxoIn:String = "fluxoIn";
		private const fluxoOut:String = "fluxoOut";
		private const horario:String = "horario";
		private const antiHorario:String = "antiHorario";
		private const none:String = "none";
		
		//private var exercices:Vector.<>
		private function createExercices():void 
		{
			exercices.push( { tipo:"move", iniPos:new Point(100, 200), finalPos:new Point(500, 200), answerCampo:fluxoIn, answerRotation:horario } );//esquerda -> direita
			exercices.push( { tipo:"move", iniPos:new Point(500, 300), finalPos:new Point(100, 300), answerCampo:fluxoOut, answerRotation:antiHorario } );//direita -> esquerda
			
			exercices.push( { tipo:"move", iniPos:new Point(150, 350), finalPos:new Point(150, 150), answerCampo:none, answerRotation:none } );//cima -> baixo
			exercices.push( { tipo:"move", iniPos:new Point(150, 150), finalPos:new Point(150, 350), answerCampo:none, answerRotation:none } );//baixo -> cima
			
			exercices.push( { tipo:"move", iniPos:new Point(100, 350), finalPos:new Point(500, 150), answerCampo:fluxoIn, answerRotation:horario } );//diagonal ascendente esquerda -> direita
			exercices.push( { tipo:"move", iniPos:new Point(100, 150), finalPos:new Point(500, 350), answerCampo:fluxoIn, answerRotation:horario } );//diagonal descendente esquerda -> direita
			
			exercices.push( { tipo:"move", iniPos:new Point(500, 350), finalPos:new Point(100, 150), answerCampo:fluxoOut, answerRotation:antiHorario } );//diagonal ascendente direita -> esquerda
			exercices.push( { tipo:"move", iniPos:new Point(500, 150), finalPos:new Point(100, 350), answerCampo:fluxoOut, answerRotation:antiHorario } );//diagonal descendente direita -> esquerda
			
			exercices.push( { tipo:"resize", pos:new Point(200, 150), initialWidth:50, finalWidth:300, tweenProp:0, answerCampo:fluxoOut, answerRotation:antiHorario } );
			exercices.push( { tipo:"resize", pos:new Point(200, 300), initialWidth:400, finalWidth:80, tweenProp:0, answerCampo:fluxoIn, answerRotation:horario } );
			
			exercices.push( { tipo:"resize", pos:new Point(420, 300), initialWidth:80, finalWidth:450, tweenProp:0, answerCampo:fluxoIn, answerRotation:horario } );
			exercices.push( { tipo:"resize", pos:new Point(420, 150), initialWidth:250, finalWidth:50, tweenProp:0, answerCampo:fluxoOut, answerRotation:antiHorario } );
			
			exercices.push( { tipo:"resize", pos:new Point(350, 150), initialWidth:60, finalWidth:250, tweenProp:0, answerCampo:none, answerRotation:none } );
			exercices.push( { tipo:"resize", pos:new Point(350, 300), initialWidth:420, finalWidth:50, tweenProp:0, answerCampo:none, answerRotation:none } );
			
			exercices.push( { tipo:"resize", pos:new Point(300, 150), initialWidth:75, finalWidth:350, tweenProp:0, answerCampo:fluxoOut, answerRotation:antiHorario } );
			exercices.push( { tipo:"resize", pos:new Point(370, 300), initialWidth:300, finalWidth:80, tweenProp:0, answerCampo:fluxoOut, answerRotation:antiHorario } );
			
			exercices.push( { tipo:"resize", pos:new Point(370, 150), initialWidth:90, finalWidth:420, tweenProp:0, answerCampo:fluxoIn, answerRotation:horario } );
			exercices.push( { tipo:"resize", pos:new Point(300, 300), initialWidth:320, finalWidth:60, tweenProp:0, answerCampo:fluxoIn, answerRotation:horario } );
		}
		
		public function sortExercise():void 
		{
			var sort:int = Math.floor(Math.random() * exercices.length);
			//var sort:int = 17;
			
			currentExercice = exercices[sort];
			if (currentExercice.tipo == "move") {
				moveTo();
			}else {
				this.x = currentExercice.pos.x;
				this.y = currentExercice.pos.y;
				resizeTo();
			}
			areaAnwer.gotoAndStop(currentExercice.answerRotation);
			animationRunning = true;
		}
		
		//Funções para movimentação da área nos exercícios.
		private var tweenX:Tween;
		private var tweenY:Tween;
		private function moveTo():void
		{
			this.x = currentExercice.iniPos.x;
			this.y = currentExercice.iniPos.y;
			
			tweenX = new Tween(this, "x", None.easeNone, this.x, currentExercice.finalPos.x, 3, true);
			tweenY = new Tween(this, "y", None.easeNone, this.y, currentExercice.finalPos.y, 3, true);
			
			tweenY.addEventListener(TweenEvent.MOTION_CHANGE, showAnswer, false, 0, true);
			tweenY.addEventListener(TweenEvent.MOTION_FINISH, restartMoveTo, false, 0, true);
		}
		
		private function restartMoveTo(e:TweenEvent):void 
		{
			phiInicial = NaN;
			fundo.rotation = 0;
			tweenY.removeEventListener(TweenEvent.MOTION_CHANGE, showAnswer);
			tweenY.removeEventListener(TweenEvent.MOTION_FINISH, restartMoveTo);
			
			moveTo();
		}
		
		private function showAnswer(e:TweenEvent):void 
		{
			if (isNaN(phiInicial)) {
				phiInicial = campo.zcomp(coord.pixel2x(this.x), 0) * widthArea * heightArea;
			}else{
				var phiAtual:Number = campo.zcomp(coord.pixel2x(this.x), 0) * widthArea * heightArea;
				var deltaPhi:Number = phiAtual - phiInicial;
				var dTheta:Number = maxRotationFrame / areaMax * deltaPhi;
				if(showVisualAnswer){
					if (deltaPhi != 0) {
						setFundoVisible(true);
						rotate(dTheta);
					}else {
						setFundoVisible(false);
					}
				}else {
					fundo.alpha = 0;
				}
				phiInicial = phiAtual;
			}
		}
		
		private var animationRunning:Boolean = false;
		public function stopAnimation():void
		{
			spr_Area.visible = false;
			areaAnwer.visible = true;
			if (currentExercice.tipo == "move") {
				if (tweenY.isPlaying) tweenY.stop();
				if (tweenX.isPlaying) tweenX.stop();
				tweenY.removeEventListener(TweenEvent.MOTION_CHANGE, showAnswer);
				tweenY.removeEventListener(TweenEvent.MOTION_FINISH, restartMoveTo);
			}else {
				if (tweenSize.isPlaying) tweenSize.stop();
				tweenSize.removeEventListener(TweenEvent.MOTION_CHANGE, resizePolygon);
				tweenSize.removeEventListener(TweenEvent.MOTION_FINISH, restartResizeTo);
			}
			animationRunning = false;
		}
		
		public function startAnimation():void
		{
			if (animationRunning) return;
			
			areaAnwer.visible = false;
			spr_Area.visible = true;
			
			if (currentExercice.tipo == "move") {
				tweenY.addEventListener(TweenEvent.MOTION_CHANGE, showAnswer);
				tweenY.addEventListener(TweenEvent.MOTION_FINISH, restartMoveTo);
				tweenY.resume();
				tweenX.resume();
			}else {
				tweenSize.addEventListener(TweenEvent.MOTION_CHANGE, resizePolygon);
				tweenSize.addEventListener(TweenEvent.MOTION_FINISH, restartResizeTo);
				tweenSize.resume();
			}
			animationRunning = true;
		}
		
		//Fim das funções para movimentação da área nos exercícios.
		
		//Funções para alteração de tamanho da área nos exercícios.
		
		private var tweenSize:Tween;
		private var prop:Number = 150 / 200;
		private function resizeTo():void 
		{
			widthArea = currentExercice.initialWidth;
			heightArea = widthArea * prop;
			
			redrawArea();
			
			tweenSize = new Tween(currentExercice, "tweenProp", None.easeNone, currentExercice.initialWidth, currentExercice.finalWidth, 3, true);
			tweenSize.addEventListener(TweenEvent.MOTION_CHANGE, resizePolygon);
			tweenSize.addEventListener(TweenEvent.MOTION_FINISH, restartResizeTo);
		}
		
		private function restartResizeTo(e:TweenEvent):void 
		{
			phiInicial = NaN;
			fundo.rotation = 0;
			tweenSize.removeEventListener(TweenEvent.MOTION_CHANGE, resizePolygon);
			tweenSize.removeEventListener(TweenEvent.MOTION_FINISH, restartResizeTo);
			
			resizeTo();
		}
		
		private function resizePolygon(e:TweenEvent):void 
		{
			widthArea = currentExercice.tweenProp;
			heightArea = widthArea * prop;
			
			redrawArea();
			showAnswer(null);
		}
		
		private var movingArea:Boolean;
		private var posClick:Point;
		private var phiInicial:Number;
		
		private function downHandler(e:MouseEvent):void 
		{
			var pWidth:Number = Point.distance(new Point(this.mouseX, 0), new Point(0, 0));
			var pHeight:Number = Point.distance(new Point(0, this.mouseY), new Point(0, 0));
			posClick = new Point(this.mouseX, this.mouseY);
			
			if ((pWidth < 0.6 * (widthArea / 2)) && (pHeight < 0.6 * (heightArea / 2))) {
				movingArea = true;
			}else {
				movingArea = false;
			}
			
			phiInicial = campo.zcomp(coord.pixel2x(this.x), 0) * widthArea * heightArea;
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			addEventListener(Event.ENTER_FRAME, moveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		//private function moveHandler(e:MouseEvent):void 
		private function moveHandler(e:Event):void 
		{
			var phiAtual:Number;
			var deltaPhi:Number;
			
			if (movingArea) {
				var pos:Point = new Point(this.x, this.y);
				var newPos:Point = new Point(Math.min(Math.max(stage.mouseX - posClick.x, 0), 640), Math.min(Math.max(stage.mouseY - posClick.y, 0), 480));
				this.x = newPos.x;
				this.y = newPos.y;
			}else {
				newPos = new Point(this.mouseX, this.mouseY);
				var dInicial:Number = Point.distance(posClick, new Point(0, 0));
				var dFinal:Number = Point.distance(newPos, new Point(0, 0));
				
				var prop:Number = dFinal / dInicial;
				
				var newWidthArea = Math.min(Math.max(prop * widthArea, 80), 600);
				var newHeightArea = Math.min(Math.max(prop * heightArea, 60), 450);
				
				if (newWidthArea >= 80 && newWidthArea <= 600) {
					widthArea = newWidthArea;
					heightArea = newHeightArea;
					posClick = newPos;
					redrawArea();
				}
			}
			phiAtual = campo.zcomp(coord.pixel2x(this.x), 0) * widthArea * heightArea;
			deltaPhi = phiAtual - phiInicial;
			var dTheta:Number = maxRotationFrame / areaMax * deltaPhi;
			if (deltaPhi != 0) {
				setFundoVisible(true);
				rotate(dTheta);
			}else {
				setFundoVisible(false);
			}
			phiInicial = phiAtual;
		}
		
		private var tweenAlpha:Tween;
		private function setFundoVisible(value:Boolean):void
		{
			if (value) {
				if (tweenAlpha != null) {
					if (tweenAlpha.isPlaying) {
						tweenAlpha.stop();
						tweenAlpha = null;
					}
				}
				fundo.alpha = 1;
			}else {
				if (tweenAlpha != null) {
					if(!tweenAlpha.isPlaying) tweenAlpha = new Tween(fundo, "alpha", None.easeNone, fundo.alpha, 0, 0.3, true);
				}else {
					tweenAlpha = new Tween(fundo, "alpha", None.easeNone, fundo.alpha, 0, 0.3, true);
				}
				
			}
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			removeEventListener(Event.ENTER_FRAME, moveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			phiInicial = NaN;
			posClick = null;
			
			setFundoVisible(false);
		}
		
		private var widthArea:Number = 200;
		private var heightArea:Number = 150;
		
		private function redrawArea():void
		{
			spr_Area.graphics.clear();
			spr_Mask.graphics.clear();
			
			spr_Area.graphics.lineStyle(2, 0xC15E02);
			spr_Area.graphics.beginFill(0xC15E02, 0.2);
			spr_Area.graphics.drawRect( -widthArea / 2, -heightArea / 2, widthArea, heightArea);
			
			spr_Mask.width = spr_Area.width;
			spr_Mask.height = spr_Area.height;
			
			//areaAnwer.scaleX = widthArea/200;
			//areaAnwer.scaleY = heightArea/150;
			
			topDir.y = -heightArea / 2;
			rightDir.x = widthArea / 2;
			bottonDir.y = heightArea / 2;
			leftDir.x = -widthArea / 2;
		}
		
		private function rotate(dTheta:Number):void 
		{
			var widDir:Number = 645 / 2;
			if (dTheta < 0) {
				direction.gotoAndStop("OUT");
				topDir.scaleX = -1;
				rightDir.scaleX = -1;
				bottonDir.scaleX = -1;
				leftDir.scaleX = -1;
				
				topDir.x = widDir;
				rightDir.y = widDir;
				bottonDir.x = -widDir;
				leftDir.y = -widDir;
			}else {
				direction.gotoAndStop("IN");
				topDir.scaleX = 1;
				rightDir.scaleX = 1;
				bottonDir.scaleX = 1;
				leftDir.scaleX = 1;
				
				topDir.x = -widDir;
				rightDir.y = -widDir;
				bottonDir.x = widDir;
				leftDir.y = widDir;
			}
			
			var vel:Number = Math.min(Math.max(Math.abs(dTheta), 1), 6);
			
			topDir.run(vel);
			rightDir.run(vel);
			bottonDir.run(vel);
			leftDir.run(vel);
		}
		
	}

}