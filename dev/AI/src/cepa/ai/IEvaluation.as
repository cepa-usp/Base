package cepa.ai 
{
	
	/**
	 * ...
	 * @author Arthur
	 */
	public interface IEvaluation 
	{
		function addPlayInstance(playInstance:IPlayInstance);
		function get score():Number;
		function getData():Object;
		function readData(obj:Object);
	}
	
}