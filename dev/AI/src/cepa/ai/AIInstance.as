package cepa.ai 
{
	
	/**
	 * ...
	 * @author Arthur
	 */
	public interface AIInstance 
	{
		function getData():Object
		function readData(obj:Object);
		function createNewPlayInstance():IPlayInstance;
	}
	
}