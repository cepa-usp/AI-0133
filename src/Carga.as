package 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Carga extends MovieClip
	{
		
		public function Carga() 
		{
			
		}
		
		public function setDirection(dirIn:Boolean):void
		{
			if (dirIn) {
				this.gotoAndStop("IN");
			}else {
				this.gotoAndStop("OUT");
			}
		}
		
		public function setIntensity(value:Number):void
		{
			//Muda a cor de acordo com a intensidade do campo.
			this.alpha = value;
		}
		
	}

}