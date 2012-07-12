package cepa.ai 
{
	
	/**
	 * ...
	 * @author Arthur
	 */
	public interface IEvaluation 
	{
		/**
		 * Sets the current IPlayInstance
		 * @param	play
		 */
		function createNewPlay():void;
		
		/**
		 * Perform evaluation based on current IPlayInstance
		 */	
		function evaluate():void;
		
		/**
		 * Marshals evaluator data
		 * @return
		 */
		function getData():Object;
		
		/**
		 * Unmarshals data from object to evaluator
		 * @param	obj
		 */
		function readData(obj:Object):void;
	}
	
}