package cepa.ai 
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author Arthur
	 */
	public class AIConstants 
	{
		public static const PLAYMODE_FREEPLAY:int = 0;
		public static const PLAYMODE_EVALUATE:int = 1;	
		
		public static const STATE_UNLOADED:String = "stateUnloaded";
		public static const STATE_LOADING:String = "stateLoading";
		public static const STATE_READY:String = "stateReady";
		public static const STATE_EVALUATING:String = "stateEvaluating";
		public static const STATE_SHOWING_FEEDBACK:String = "stateFeedback";
		public static const STATE_TERMINATED:String = "stateTerminated";
		static public const CHANGESTATE:String = "changestate";
		
		public static const SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(3, 45, 0x000000, 1, 5, 5);
		public static const DISABLE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
                       0.2225, 0.7169, 0.0606, 0, 0,
                       0.2225, 0.7169, 0.0606, 0, 0,
                       0.2225, 0.7169, 0.0606, 0, 0,
                       0.0000, 0.0000, 0.0000, 1, 0
        ]);		
		
		
		public function AIConstants() 
		{
			
		}
		
	}

}