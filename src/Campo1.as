package  
{
	import flash.display.*;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Campo1 implements ICampo 
	{
		public function Campo1() 
		{
			
		}
		
		/* INTERFACE ICampo */
		
		public function xcomp(x:Number, y:Number):Number 
		{
			return 0;
		}
		
		public function ycomp(x:Number, y:Number):Number 
		{
			return 0;
		}
		
		public function zcomp(x:Number, y:Number):Number 
		{
			return x;
		}
		
	}
	
}