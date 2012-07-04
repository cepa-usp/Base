package cepa.scorm 
{
	/**
	 * ...
	 * @author Arthur
	 */
	public class ScormCmiScore 
	{
		private var root:ScormHandler;
		private var _min:Number = 0;
		private var _max:Number = 1;
		private var _raw:Number = 0;
		private var _scaled:Number = 0; // -1 a 1;
		
		
		public function ScormCmiScore(root:ScormHandler) 
		{
			this.root = root;			
		}
		
		public function get min():Number 
		{
			return _min;
		}
		
		public function set min(value:Number):void 
		{
			_min = value;
			root.setValue("cmi.score.min", value.toString());
		}
		
		public function get max():Number 
		{
			return _max;			
		}
		
		public function set max(value:Number):void 
		{
			_max = value;
			root.setValue("cmi.score.max", value.toString());
		}
		
		public function get raw():Number 
		{
			return _raw;
		}
		
		public function set raw(value:Number):void 
		{
			_raw = value;
			root.setValue("cmi.score.raw", value.toString());
		}
		
		/**
		 *  Indica o aproveitamento do usuário na atividade, numa escala fixa de -1 a 1 (readonly)
		 */
		public function get scaled():Number 
		{
			return _scaled;

		}
		
		
		public function set scaled(value:Number):void 
		{
			_scaled = value;
			root.setValue("cmi.score.scaled", value.toString());
		}
		
	}

}