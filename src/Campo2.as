package  
{
	import flash.display.*;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Campo2 implements ICampo 
	{
		public function Campo2() 
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
			return 1;
		}
		
	}
	
}