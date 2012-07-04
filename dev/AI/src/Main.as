package 
{
	
	import cepa.ai.AI;
	import cepa.ai.AIContainer;
	import cepa.ai.AIObserver;
	import cepa.utils.NotacaoCientifica;
	import com.pipwerks.SCORM;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite implements AIObserver
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onResetClick():void 
		{
			
		}
		
		public function onScormFetch():void 
		{
			
		}
		
		public function onScormSave():void 
		{
			
		}
		
		public function onStatsClick():void 
		{
			
		}
		
		public function onTutorialClick():void 
		{
			
		}
		
		public function onScormConnected():void 
		{
			
		}
		
		public function onScormConnectionError():void 
		{
			
		}
		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var ai:AI = new AI(this);
			//ai.container.disableComponent(ai.container.optionButtons.orientacoesBtn);
			
			trace(Math.pow(10, -2));
		
			
			var nc:NotacaoCientifica = new NotacaoCientifica();
			

			
			
			
		}
		
	}
	
}