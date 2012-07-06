package cepa.ai 
{
	
	/**
	 * ...
	 * @author Arthur
	 */
	public interface IEvaluation 
	{
		function evaluate(playInstance:IPlayInstance);
		function getData():Object;
		function readData(obj:Object);
	}
	
}