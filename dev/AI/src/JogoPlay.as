package  
{
	import cepa.ai.IPlayInstance;
	/**
	 * ...
	 * @author Arthur
	 */
	public class JogoPlay implements IPlayInstance
	{
		private var _pontuacao:int = 0;
		public function JogoPlay() 
		{
			
		}
		
		/* INTERFACE cepa.ai.IPlayInstance */
		
		public function returnAsObject():Object 
		{
			return {pontuacao:this.pontuacao}
		}
		
		public function bind(obj:Object):void 
		{
			this.pontuacao = obj.pontuacao;
		}
		
		public function getScore():Number 
		{
			return Number(pontuacao);
		}
		
		public function create():IPlayInstance 
		{
			return new JogoPlay();
		}
		
		public function evaluate():void 
		{
			//nada
		}
		
		public function get pontuacao():int 
		{
			return _pontuacao;
		}
		
		public function set pontuacao(value:int):void 
		{
			_pontuacao = value;
		}
		
	}

}