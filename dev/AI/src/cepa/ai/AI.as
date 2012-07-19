package cepa.ai 
{
	import cepa.tutorial.CaixaTexto;
	import cepa.tutorial.Tutorial;
	import com.adobe.serialization.json.JSON;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class AI 
	{
		
		private var _container:AIContainer;
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();
		private var _state:String = AIConstants.STATE_UNLOADED;
		
		private var _debugMode:Boolean = false;
		private var _debugTutorial:Boolean = false;	
		private var _debugScreen:AIDebug;
		
		
		public function AI(stagesprite:Sprite) 
		{			
			container = new AIContainer(stagesprite, this);
			stagesprite.addEventListener(Event.UNLOAD, function(e:Event):void {
				terminate();
			});
			debugScreen = new AIDebug(this, stagesprite);
			//initialize(); 
		}
		
		public function setState(state:String):void {			
			this._state = state;
			var ev:AIEvent = new AIEvent(state, this);
			eventDispatcher.dispatchEvent(ev);
		}		

		public function initialize():void {
			eventDispatcher.dispatchEvent(new AIEvent(AIConstants.STATE_LOADING, this));
		}

		public function createPlayInstance():IPlayInstance {
			throw new Error("This method needs to be overriden")
		}		

		
		public function onAIStateChanged():void {
			throw new Error("This method needs to be overriden")
		}		
		
		
		public function terminate():void {
			eventDispatcher.dispatchEvent(new Event(AIConstants.STATE_TERMINATED, this));
		}
		


		public function get container():AIContainer 
		{
			return _container;
		}
		
		public function set container(value:AIContainer):void 
		{
			_container = value;
		}		
		
		
		


		
		public function get eventDispatcher():EventDispatcher 
		{
			return _eventDispatcher;
		}
		
		public function set eventDispatcher(value:EventDispatcher):void 
		{
			_eventDispatcher = value;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			setState(value);
		}
		
		/**
		 * Serializa os dados da atividade e devolve em um Object
		 * @return
		 */
		public function getData():Object {
			throw new Error("You must override the 'getData' method ")
		}
		
		
		/**
		 * 
		 * @param	obj
		 */
		public function setData(obj:Object) {
			throw new Error("You must override the 'setData' method ")
		}
		
		
		
		
		
		/* funções de debug */
		
		private var tx:String = "";
		private function createTutorialItem(e:MouseEvent):void 
		{
			trace("debug tutorial: on")
			tx += ("t.adicionarBalao('texto', new Point(" + e.stageX.toString() + "," +  e.stageY.toString() + "), CaixaTexto.RIGHT, CaixaTexto.FIRST);\n")
			System.setClipboard(tx);
		}
				public function get debugMode():Boolean 
		{
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void 
		{
			_debugMode = value;
		}
		
		public function get debugTutorial():Boolean 
		{
			return _debugTutorial;
		}
		
		public function set debugTutorial(value:Boolean):void 
		{
			_debugTutorial = value;
			this.container.addEventListener(MouseEvent.CLICK, createTutorialItem)
		}
		
		public function get debugScreen():AIDebug 
		{
			return _debugScreen;
		}
		
		public function set debugScreen(value:AIDebug):void 
		{
			_debugScreen = value;
		}
		
		
		
		
	}

}