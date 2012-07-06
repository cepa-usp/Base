package cepa.dao.scorm
{
	import com.adobe.serialization.json.JSON;
	/**
	 * ...
	 * @author Arthur
	 */
	public class ScormCmi 
	{
		private var root:ScormHandler;
		/* scorm variables*/
		private var _location:String = "";
		private var _mode:String = CmiConstants.MODE_NORMAL;
		private var _credit:String = CmiConstants.CREDIT_CREDIT;
		private var _entry:String = CmiConstants.ENTRY_null;
		private var _exit:String = CmiConstants.EXIT_null;
		private var _scaledpassingscore:Number = 0.75;
		private var _progressmeasure:Number = 1;
		private var _successstatus:String = "";
		private var _completionstatus:String = "";
		private var _suspenddata:String = "";
		private var _sessiontime:String = "";
		private var _totaltime:String = "";
		private var _maxtimeallowed:String = "";
		private var _learnername:String = "";
		private var _score:ScormCmiScore;
		
		
		
		
		
		public function ScormCmi(root:ScormHandler) 
		{
			this.root = root;
			this.score = new ScormCmiScore(root);
			
		}
		
		public function get location():String 
		{
			return _location;
		}
		
		public function setSuspendData(obj:Object):void {
			var strJson:String = JSON.encode(obj);
			suspend_data = strJson;
		}
		
		public function set location(value:String):void 
		{
			_location = value;
			root.setValue("cmi.location", value);
		}
		
		public function get mode():String 
		{
			return _mode;			
		}
		
		public function set mode(value:String):void 
		{
			_mode = value;
			//root.setValue("cmi.mode", value);			
		}
		
		public function get credit():String 
		{
			return _credit;
		}
		
		public function set credit(value:String):void 
		{
			_credit = value;
			//root.setValue("cmi.credit", value);
		}
		
		public function get entry():String 
		{
			return _entry;
		}
		
		public function set entry(value:String):void 
		{
			_entry = value;
			//root.setValue("cmi.entry", value);
		}
		
		public function get exit():String 
		{
			return _exit;
		}
		
		public function set exit(value:String):void 
		{
			_exit = value;
			root.setValue("cmi.exit", value);
		}
		
		public function get scaled_passing_score():Number 
		{
			return _scaledpassingscore;
		}
		
		public function set scaled_passing_score(value:Number):void 
		{
			_scaledpassingscore = value;
			root.setValue("cmi.scaled_passing_score", value.toString());
		}
		
		public function get progress_measure():Number 
		{
			return _progressmeasure;
		}
		
		public function set progress_measure(value:Number):void 
		{
			_progressmeasure = value;
			root.setValue("cmi.progress_measure", value.toString());
		}
		
		public function get success_status():String 
		{
			return _successstatus;
			
		}
		
		public function set success_status(value:String):void 
		{
			_successstatus = value;
			root.setValue("cmi.success_status", value.toString());
		}
		
		public function get completion_status():String 
		{
			return _completionstatus;
		}
		
		public function set completion_status(value:String):void 
		{
			_completionstatus = value;
			root.setValue("cmi.completion_status", value.toString());
		}
		
		public function get suspend_data():String 
		{
			return _suspenddata;
		}
		
		public function set suspend_data(value:String):void 
		{
			_suspenddata = value;
			root.setValue("cmi.suspend_data", value.toString());
		}
		
		public function get session_time():String 
		{
			return _sessiontime;
		}
		
		public function set session_time(value:String):void 
		{
			_sessiontime = value;
			root.setValue("cmi.session_time", value.toString());
		}
		
		public function get total_time():String 
		{
			return _totaltime;
		}
		
		public function set total_time(value:String):void 
		{
			_totaltime = value;
			root.setValue("cmi.total_time", value.toString());
		}
		
		public function get max_time_allowed():String 
		{
			return _maxtimeallowed;
		}
		
		public function set max_time_allowed(value:String):void 
		{
			_maxtimeallowed = value;
			root.setValue("cmi.max_time_allowed", value.toString());
		}
		
		public function get learner_name():String 
		{
			return _learnername;
		}
		
		public function set learner_name(value:String):void 
		{
			_learnername = value;
			root.setValue("cmi.learner_name", value.toString());
		}
		
		public function get score():ScormCmiScore 
		{
			return _score;
		}
		
		public function set score(value:ScormCmiScore):void 
		{
			_score = value;
		}
		
		
		
	}

}