package  cepa.ai
{
	import cepa.ai.IPlayInstance;
	import flash.events.EventDispatcher;
	/**
	 * Esse é um avaliador simples, apenas registra todos os elementos. Deve ser estendido.
	 * @author Arthur
	 */
	public class DefaultEvaluator implements IEvaluation 
	{
		static public const NEWPLAY_CREATED:String = "newplayCreated";
		static public const EVALUATION_STARTED:String = "evaluationStarted";
		static public const EVALUATION_FINISHED:String = "evaluationFinished";
		
		protected var delegateCreateNewPlay:Function;
		private var _playInstances:Vector.<IPlayInstance> = new Vector.<IPlayInstance>();
		private var _currentPlay:IPlayInstance = null;
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();
		
		public function DefaultEvaluator(delegateCreateNewPlay:Function) 
		{
			this.delegateCreateNewPlay = delegateCreateNewPlay;
		}
		
		public function get playInstances():Vector.<IPlayInstance> 
		{
			return _playInstances;
		}
		
		public function set playInstances(value:Vector.<IPlayInstance>):void 
		{
			_playInstances = value;
		}
		
		public function get currentPlay():IPlayInstance 
		{
			return _currentPlay;
		}
		
		public function get eventDispatcher():EventDispatcher 
		{
			return _eventDispatcher;
		}
		
		public function set eventDispatcher(value:EventDispatcher):void 
		{
			_eventDispatcher = value;
		}
		
		
		
		/* INTERFACE cepa.ai.IEvaluation */
		
		public function createNewPlay():void 
		{
			_currentPlay = delegateCreateNewPlay.call();
			_eventDispatcher.dispatchEvent(new EvaluatorEvent(NEWPLAY_CREATED, this))
		}
		
		public function evaluate():void 
		{
			_eventDispatcher.dispatchEvent(new EvaluatorEvent(EVALUATION_STARTED, this))
			
		}
		
		protected function getPlayInstancesData():Object {
			var obj:Object = new Object();			
			obj.playinstances = new Object();
			obj.length = playInstances.length;

			for (var i:int = 0; i < playInstances.length; i++) {
				obj.playinstances[String(i)] = playInstances[i].returnAsObject();
			}
			return obj;		
		}
		
		protected function readPlayInstancesData(obj:Object) 
		{
			this.playInstances = new Vector.<IPlayInstance>();

			try {
				var len:int = obj.length;
				for (var i:int = 0; i < len; i++) {
					var ply:IPlayInstance = delegateCreateNewPlay.call();
					ply.bind(obj.playinstances[i.toString()]);
					playInstances.push(ply);
				}				
			} catch (e:Error) {
				
			}
			
		}		
		
		public function getData():Object 
		{
			return getPlayInstancesData();
		}
		
		public function readData(obj:Object):void
		{
			readPlayInstancesData(obj);
		}
		
		

	
		
	}

}