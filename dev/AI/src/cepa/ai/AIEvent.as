package cepa.ai
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class AIEvent extends Event 
	{
		static public const TUTORIAL_CLICK:String = "tutorialClick";
		static public const RESET_CLICK:String = "resetClick";
		static public const REQUEST_INITIALIZE:String = "requestInitialize";
		static public const CREDITS_CLICK:String = "creditsClick";
		static public const INSTRUCT_CLICK:String = "instructClick";
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