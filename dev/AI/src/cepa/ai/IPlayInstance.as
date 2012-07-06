package cepa.ai 
{
	
	/**
	 * ...
	 * @author Arthur
	 */
	public interface IPlayInstance 
	{		
		function returnAsObject():Object;	
		function bind(obj:Object):void;		
		function getScore():Number;
		function create():IPlayInstance;
		function evaluate():void;
	}

	
}