package cepa.scorm 
{
	import cepa.ai.AI;
	import com.pipwerks.SCORM;
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Arthur
	 */
	public class ScormHandler
	{
		private var _scormConnected:Boolean;
		private var _scorm:SCORM;		
		private var _performAutoSave:Boolean = false;
		private var _cmi:ScormCmi;

		
		
		
		public function ScormHandler() 
		{
			 _cmi = new ScormCmi(this);
			 if(ExternalInterface.available) scorm = new SCORM();			 
		}

	
		/**
		 * Connects to LMS
		 */
		public function connect():void {
			if (!ExternalInterface.available) return;
			_scormConnected = scorm.connect();
			initialTime = new Date().time;
		}
		

	
		/**
		 * Disconnects from LMS;
		 */
		public function disconnect():void {
			if (scormConnected) scorm.disconnect();
			endTime = new Date().time;
			calculateCmiSessionTime();
		}
		
		
		/**
		 * Returns true if scorm is connected to LMS
		 */
		public function get scormConnected():Boolean 
		{
			return _scormConnected;
		}
		
		
		
		public function setValue(key:String, value:String) {
			scorm.set(key, value);
			this.autosave();
		}
		
		public function get cmi():ScormCmi 
		{
			return _cmi;
		}
		
		public function set cmi(value:ScormCmi):void 
		{
			_cmi = value;
		}
		
		public function get scorm():SCORM 
		{
			return _scorm;
		}
		
		public function set scorm(value:SCORM):void 
		{
			_scorm = value;
		}
		
		public function get performAutoSave():Boolean 
		{
			return _performAutoSave;
		}
		
		public function set performAutoSave(value:Boolean):void 
		{
			_performAutoSave = value;
		}
		public function autosave():void {
			if (performAutoSave) save();
		}
		
		public function fetch():void {			
			this.cmi.completion_status = scorm.get("cmi.completion_status");			
			this.cmi.credit = scorm.get("cmi.credit");
			this.cmi.suspend_data = scorm.get("cmi.suspend_data");			
			this.cmi.entry = scorm.get("cmi.entry");
			this.cmi.exit = scorm.get("cmi.exit");
			this.cmi.learner_name = scorm.get("cmi.learner_name");
			this.cmi.location = scorm.get("cmi.location");
			this.cmi.max_time_allowed = scorm.get("cmi.max_time_allowed");
			this.cmi.mode = scorm.get("cmi.mode");
			this.cmi.progress_measure = Number(scorm.get("cmi.progress_measure"));
			this.cmi.scaled_passing_score = Number(scorm.get("cmi.scaled_passing_score"));
			this.cmi.session_time = scorm.get("cmi.session_time");
			this.cmi.success_status = scorm.get("cmi.success_status");
			
			this.cmi.total_time = scorm.get("cmi.total_time");
			this.cmi.score.max = Number(scorm.get("cmi.score.max"));
			this.cmi.score.min = Number(scorm.get("cmi.score.min"));
			this.cmi.score.raw = Number(scorm.get("cmi.score.raw"));
			this.cmi.score.scaled = Number(scorm.get("cmi.score.scaled"));										

			
		}
		
		public function save():void {
			scorm.save();
		}
		

		private var initialTime:Number = 0;
		private var endTime:Number = 0;
		private function calculateCmiSessionTime():void {
			var milis:Number = endTime - initialTime;
			var strTime:String = Math.floor(milis / (1000 * 60 * 60)) + "H" + 
				(Math.floor(milis / (1000 * 60)) % 60) + "M" + 
				(milis / (1000) % 60) + "S";
				this.cmi.session_time = strTime;
				save();
		}

	}

}