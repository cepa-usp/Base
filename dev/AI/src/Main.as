package 
{
	
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIContainer;
	import cepa.ai.AIObserver;
	import cepa.dao.ScormAgent;
	import cepa.eval.ProgressiveEvaluator;
	import cepa.utils.NotacaoCientifica;
	import com.pipwerks.SCORM;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var ai:AtividadeTeste = new AtividadeTeste(this);
			var eval:ProgressiveEvaluator = new ProgressiveEvaluator(ai);
			var scormAgent:ScormAgent = new ScormAgent(ai, eval); 
			ai.initialize();
			
		}
		
	}
	
}