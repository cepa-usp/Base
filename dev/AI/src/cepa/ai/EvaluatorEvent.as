package cepa.ai
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class EvaluatorEvent extends Event 
	{
		
		private var evalData:Object = null;
		private var eval:IEvaluation;
		
		public function EvaluatorEvent(type:String, eval:IEvaluation, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.evalData = eval.getData();
			this.eval = eval;
			
		} 
		
		public override function clone():Event 
		{ 
			return new EvaluatorEvent(type, eval, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EvaluatorEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}