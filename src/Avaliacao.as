package  
{
	import cepa.ai.IPlayInstance;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Avaliacao implements IPlayInstance
	{
		private var corrente:Boolean;
		private var fluxo:Boolean;
		private var score:Number;
		private var _playMode:int;
		
		public function Avaliacao(corrente:Boolean, fluxo:Boolean) 
		{
			this.fluxo = fluxo;
			this.corrente = corrente;
			
		}
		
		/* INTERFACE cepa.ai.IPlayInstance */
		
		public function get playMode():int 
		{
			return _playMode;
		}
		
		public function set playMode(value:int):void 
		{
			_playMode = value;
		}
		
		public function returnAsObject():Object 
		{
			var obj:Object = { };
			obj.fluxo = fluxo;
			obj.corrente = corrente;
			obj.score = score;
			obj.playMode = _playMode;
			
			return obj;
		}
		
		public function bind(obj:Object):void 
		{
			fluxo = obj.fluxo;
			corrente = obj.corrente;
			score = obj.score;
			_playMode = obj.playMode;
		}
		
		public function getScore():Number 
		{
			return score;
		}
		
		public function evaluate():void 
		{
			score = 0;
			if (corrente) score += 0.5;
			if (fluxo) score += 0.5;
		}
		
	}

}