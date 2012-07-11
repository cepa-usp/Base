package  
{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIEvent;
	import cepa.ai.AIState;
	import cepa.ai.IEvaluation;
	import cepa.ai.IPlayInstance;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Arthur
	 */
	public class AtividadeTeste extends AI
	{
		
		public function AtividadeTeste(stagesprite:Sprite) 
		{
			super(stagesprite) 
			this.eventDispatcher.addEventListener(AIConstants.STATE_READY, onStateReady);
			jogo = new JogoBolinha();
			jogo.addEventListener(JogoEvent.GOOD, onGood);
			jogo.addEventListener(JogoEvent.BAD, onBad);
			jogo.addEventListener(JogoEvent.STOPPED, onStopped);
			container.addChild(jogo);
			container.addChild(txPontos);
			txPontos.text = "0";
			txPontos.selectable = false;
			txVidas.selectable = false;
			txVidas.text = vidas.toString();
			txPontos.x = 50;
			txPontos.width = 150;
			txPontos.y = 50;
			container.addChild(txVidas);
			txVidas.x = 50;
			txVidas.y = 70;
			txVidas.width = 50;
			
		}
		
		private function onStateReady(e:Event):void 
		{
			trace("ready")
			
			changeGameState(GAME_CREATINGPLAY);
			
		}
		
		private function onStopped(e:JogoEvent):void 
		{
			
		}
		
		private function onBad(e:JogoEvent):void 
		{
			vidas -= 1; 
			txVidas.text = "vidas: " + vidas.toString();
			if (vidas == 0) {
				jogo.stop = true;
				this.evaluator.evaluate(this.currentPlay);
				changeGameState(GAME_EVALUATING);
			}
		}
		
		private function onGood(e:JogoEvent):void 
		{
			pontos += e.points;
			trace(e.points, pontos);
			txPontos.text = "pontos: " + pontos.toString();
		}
		
		private var jogo:JogoBolinha ;
		private const GAME_CREATINGPLAY:int = 1;
		private const GAME_INTERACTING:int = 2;
		private const GAME_EVALUATING:int = 3;

		private var gameState:int = 0;
		private var pontos:int = 0;
		private var vidas:int = 5;
		private var txPontos:TextField = new TextField();
		private var txVidas:TextField = new TextField();
		
		
		
		private function changeGameState(vlr:int) {
			switch(vlr) {
				case GAME_CREATINGPLAY:
					playGame();
					break;
				case GAME_INTERACTING:
					break;
				case GAME_EVALUATING:
					this.currentPlay
					break;
			}
		}
		

		private function playGame() {
			jogo.drawGame();
			var play:JogoPlay = new JogoPlay();
			this.currentPlay = play;
			changeGameState(GAME_INTERACTING);
			
		}

		
		
		
		

		
	}

}