package 
{
	
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIContainer;
	import cepa.ai.AIEvent;
	import cepa.ai.AIObserver;
	import cepa.dao.ScormAgent;
	import cepa.eval.ProgressiveEvaluator;
	import cepa.tutorial.Tutorial;
	import cepa.utils.NotacaoCientifica;
	import com.pipwerks.SCORM;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
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
			ai.initialize();
			ai.eventDispatcher.addEventListener(AIEvent.TUTORIAL_CLICK, faztutorial);
		}
		
		private function faztutorial(e:Event):void {
			var t:Tutorial = new Tutorial();
			t.adicionarBalao("oiba", new Point(100, 100), 1, 1);
			t.adicionarBalao("oba", new Point(150, 100), 1, 1);
			t.adicionarBalao("oa", new Point(100, 150), 1, 1);
			t.iniciar(this.stage);
		}
		
		
	}
	
}