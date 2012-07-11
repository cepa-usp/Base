package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class JogoEvent extends Event 
	{
		private var _points:int = 0;
		static public const GOOD:String = "good";
		static public const BAD:String = "bad"
		static public const STOPPED:String = "stopped";
		public function JogoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new JogoEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("JogoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get points():int 
		{
			return _points;
		}
		
		public function set points(value:int):void 
		{
			_points = value;
		}
		
	}
	
}