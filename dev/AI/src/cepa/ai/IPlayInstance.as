package cepa.ai 
{
	
	/**
	 * ...
	 * @author Arthur
	 */
	public interface IPlayInstance 
	{
		
		function get playMode():int;
		/**
		 * Play mode (AIConstants.PLAYMODE_FREEPLAY or AIConstants.PLAYMODE_EVALUATE)
		 */
		function set playMode(value:int):void;
		
		function returnAsObject():Object;
		
		function bind(obj:Object):void;
		
		function getScore():Number;
		
		
		function evaluate():void;
	}

	
}