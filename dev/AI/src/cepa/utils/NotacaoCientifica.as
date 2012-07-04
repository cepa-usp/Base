package cepa.utils 
{
	/**
	 * ...
	 * @author Arthur
	 */
	public class NotacaoCientifica 
	{
		
		public static const BASE_RESTRICT:String = "0123456789,.";
		public static const EXP_RESTRICT:String  = "0123456789\\-+";
			
		
		private var _mantissa:Number = 0;
		private var _exponent:int = 1;
		private var _unit:SI_Unit = null;
		private var _hasUnit:Boolean = false;
		private var _value:Number = 0;
		private var _num_digits:int = 1;
		
		public function NotacaoCientifica() 
		{
			
		}
		
		public function test():void {
			trace("1", new NotacaoCientifica().setExpValues(1, 0).toString());
			trace("10", new NotacaoCientifica().setExpValues(1, 1).toString());
			trace("100", new NotacaoCientifica().setExpValues(1, 2).toString());
			trace("100", new NotacaoCientifica().setExpValues(10, 1).toString());
			trace("100", new NotacaoCientifica().setExpValues(100, 0).toString());
			trace("12345", new NotacaoCientifica().setExpValues(1234.5, 1).toString());
			trace("12345", new NotacaoCientifica().setExpValues(1.2345, 4).toString());
			trace("100", new NotacaoCientifica().setValue(100).toString());
			trace("12345", new NotacaoCientifica().setValue(12345).toString());
			trace("0.0123", new NotacaoCientifica().setValue(0.0123).toString());
			trace("0.0123", new NotacaoCientifica().setValue(0.0123).toString());
			trace("0.0123", new NotacaoCientifica().setExpValues(0.0123, 0).toString());
			trace("0.0123", new NotacaoCientifica().setExpValues(1.23, -2).toString());
		}
		
		public function setValue(number:Number):NotacaoCientifica 
		{
			this.value = number;
			return this;
		}
		
		public function setExpValues(mant:Number, exp:int):NotacaoCientifica {
			changeValue(mant, exp);
			return this;
		}
		
		public function get mantissa():Number 
		{
			return _mantissa;
		}
		
		public function set mantissa(value:Number):void 
		{
			changeValue(value, _exponent);
		}
		
		public function get exponent():int 
		{
			return _exponent;
		}
		
		public function set exponent(value:int):void 
		{
			changeValue(_mantissa, value);
		}
		
		public function get unit():SI_Unit 
		{
			return _unit;
		}
		
		public function set unit(value:SI_Unit):void 
		{
			_unit = value;
		}
		
		public function get hasUnit():Boolean 
		{
			return _hasUnit;
		}
		
		public function set hasUnit(vl:Boolean):void 
		{
			_hasUnit = value;
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(vl:Number):void 
		{
			_value = vl;
			adjust();
		}
		
		public function get num_digits():int 
		{
			return _num_digits;
		}
		
		public function set num_digits(value:int):void 
		{
			_num_digits = value;
		}
		

		
		private function changeValue(base:Number, exp:int):void {
			value = base * Math.pow(10, exp);
		}
		
		private function adjust():void {
			var num:Number = _value;
			var exp = Math.floor(Math.log(Math.abs(num)) / Math.LN10); 
			if (num == 0) exp = 0;
			var tenToPower:Number = Math.pow(10, exp);
			var mant:Number = num / tenToPower;
			_exponent = exp;
			_mantissa = mant;

		}
		
		public  function toString():String {
			return _mantissa.toString() + " x 10^(" + _exponent.toString() + ") => " + _value.toString();
		}
		
	}

}