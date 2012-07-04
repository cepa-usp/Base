package cepa.ai 
{
	import cepa.scorm.ScormComm;
	import cepa.scorm.ScormHandler;
	import cepa.tutorial.CaixaTexto;
	import cepa.tutorial.Tutorial;
	import com.adobe.serialization.json.JSON;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
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
		private var _scorm:ScormHandler = new ScormHandler();
		private var _observers:Vector.<AIObserver> = new Vector.<AIObserver>();
		private var _debugMode:Boolean = false;
		private var _evaluator:IEvaluation;
		private var _debugTutorial:Boolean = false;		
		private var _debugScreen:AIDebug;
		private var _data:Object = new Object();
		private var _aiinstance:AIInstance = null;
		
		public function AI(stagesprite:Sprite) 
		{
			
			container = new AIContainer(stagesprite, this);
			stagesprite.addEventListener(Event.UNLOAD, function(e:Event):void {
				terminate();
			});
			if (stagesprite is AIInstance) ai_instance = AIInstance(stagesprite);
			debugScreen = new AIDebug(this, stagesprite);
			//initialize();
		}
		
		public function saveSuspendData():void {
			debugScreen.msg("Salvando suspended data");
			var ai_data:Object = new Object();
			ai_data.eval = evaluator.getData();			
			if (ai_instance != null) {
				ai_data.general = ai_instance.getData();
			}
			
			var str:String = JSON.encode(ai_data);
			debugScreen.msg("JSON criado");
			debugScreen.msg("scorm.scormConnected==" + scorm.scormConnected.toString());
			if (scorm.scormConnected) {
				debugScreen.msg("Salvando no SCORM");
				scorm.cmi.suspend_data = str;
				scorm.save();
			} 
			if(ExternalInterface.available){
				ExternalInterface.call("save2LS", str)
				debugScreen.msg("Salvando em localstorage");
			}
			
		}
		public function loadSuspendData():void {
			var obj:Object;
			var str:String;
			
			debugScreen.msg("scorm.scormConnected=" + scorm.scormConnected);
			
			if (scorm.scormConnected) {
				str = scorm.cmi.suspend_data;
				debugScreen.msg(str);
			} else {				
				str = ExternalInterface.call("getLocalStorageString");
				debugScreen.msg("Recuperando suspend_data de localstorage");
			}		
			
			if (str == "") {
				debugScreen.msg("localstorage vazio");
			} else {			
				debugScreen.msg("decodificando JSON");
				obj = JSON.decode(str);
				debugScreen.msg("ok");
				try {
					debugScreen.msg("Lendo dados gerais");
					ai_instance.readData(obj.general);	
					debugScreen.msg("ok");
				} catch (e:Error) {
					debugScreen.msg("Erro recuperando dados gerais");
				}
				
				try {
					debugScreen.msg("Lendo dados de avaliação");
					_evaluator.readData(obj.eval);
					debugScreen.msg("ok");
					
				} catch (e:Error) {
					debugScreen.msg("Erro recuperando dados de avaliacao");
				}
				
			}
			
			
			
			
			
		}

		
		public function addObserver(obs:AIObserver):void {
			observers.push(obs);
		}
		public function initialize() {
			scorm.connect();		
			if (scorm.scormConnected) {
				debugScreen.msg("Scorm connected! Avisando " + observers.length + " observers")	
				
				try {
					scorm.fetch();
					debugScreen.msg("Scorm fetched")
				} catch (e:Error) {
					debugScreen.msg("Error fetching scorm")
					debugScreen.msg(e.message);
					debugScreen.msg(e.name);
					debugScreen.msg(e.getStackTrace());
				}
				loadSuspendData();
				
				
				
				for each(var obs:AIObserver in observers) obs.onScormConnected();	
			} else {
				debugScreen.msg("Scorm not connected!")
				for each(var obs:AIObserver in observers) obs.onScormConnectionError();	
			}			
			
		}
		public function terminate():void {
			scorm.disconnect();
		}
		
		public function onTutorialClick(e:Event):void 
		{
			for each(var obs:AIObserver in observers) obs.onTutorialClick();
		}
		public function onStatsClick(e:Event):void 
		{
			for each(var obs:AIObserver in observers) obs.onStatsClick();
		}		
		public function onResetClick(e:Event):void 
		{
			for each (var obs:AIObserver in observers) obs.onResetClick();
		}		
		
		public function addPlayInformation(object:Object):void 
		{
			object
		}
		
		public function get container():AIContainer 
		{
			return _container;
		}
		
		public function set container(value:AIContainer):void 
		{
			_container = value;
		}		
		
		public function get observers():Vector.<AIObserver> 
		{
			return _observers;
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
		
		public function get evaluator():IEvaluation 
		{
			return _evaluator;
		}
		
		public function set evaluator(value:IEvaluation):void 
		{
			_evaluator = value;
		}
		
		public function get scorm():ScormHandler 
		{
			return _scorm;
		}
		
		public function set scorm(value:ScormHandler):void 
		{
			_scorm = value;
		}
		
		public function get debugScreen():AIDebug 
		{
			return _debugScreen;
		}
		
		public function set debugScreen(value:AIDebug):void 
		{
			_debugScreen = value;
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		public function get ai_instance():AIInstance 
		{
			return _aiinstance;
		}
		
		public function set ai_instance(value:AIInstance):void 
		{
			_aiinstance = value;
		}
		
		private var tx:String = "";
		private function createTutorialItem(e:MouseEvent):void 
		{
			trace("debug tutorial: on")
			tx += ("t.adicionarBalao('texto', new Point(" + e.stageX.toString() + "," +  e.stageY.toString() + "), CaixaTexto.RIGHT, CaixaTexto.FIRST);\n")
			System.setClipboard(tx);
		}
		
		
		
	}

}