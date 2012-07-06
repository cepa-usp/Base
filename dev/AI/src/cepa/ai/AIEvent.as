package cepa.ai
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class AIEvent extends Event 
	{
		private var _ai:AI;
		public function AIEvent(type:String, ai:AI, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.ai = ai;
			
		} 
		
		public override function clone():Event 
		{ 
			return new AIEvent(type, ai, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AIEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get ai():AI 
		{
			return _ai;
		}
		
		public function set ai(value:AI):void 
		{
			_ai = value;
		}
		
	}
	
	
	
}