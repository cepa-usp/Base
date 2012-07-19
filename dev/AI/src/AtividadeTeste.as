package  
{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIEvent;
	import cepa.ai.AIState;
	import cepa.ai.IEvaluation;
	import cepa.ai.IPlayInstance;
	import cepa.dao.ScormAgent;
	import cepa.eval.ProgressiveEvaluator;
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
		private var eval:ProgressiveEvaluator;
		
		
		public function AtividadeTeste(stagesprite:Sprite) 
		{
			super(stagesprite) 
			eval  = new ProgressiveEvaluator(this, createPlayInstance);			
			var scormAgent = new ScormAgent(this, eval); 
			eventDispatcher.addEventListener(AIEvent.RESET_CLICK, onResetClicked);
			this.eventDispatcher.addEventListener(AIConstants.STATE_READY, onStateReady);
			
			//drawGame();
			
		}
		
		private function drawGame():void 
		{
			if (container.getChildByName("jogo") != null)  container.removeChild(container.getChildByName("jogo"));
			
			jogo = new JogoBolinha();
			jogo.name = "jogo"
			jogo.addEventListener(JogoEvent.GOOD, onGood);
			jogo.addEventListener(JogoEvent.BAD, onBad);
			jogo.addEventListener(JogoEvent.STOPPED, onStopped);
			txPontos.text = "0";
			txPontos.selectable = false;
			txVidas.selectable = false;
			txVidas.text = vidas.toString();
			txPontos.x = 50;
			txPontos.width = 150;
			txPontos.y = 50;
			
			txVidas.x = 50;
			txVidas.y = 70;
			txVidas.width = 50;

			container.addChild(jogo);
			trace(jogo.stage)
			jogo.addChild(txPontos);
			jogo.addChild(txVidas);
		}
		
		
		
		private function onResetClicked(e:AIEvent):void 
		{
			if(jogo!=null){
				jogo.stop = true;
				jogo.removeEventListener(JogoEvent.GOOD, onGood);
				jogo.removeEventListener(JogoEvent.BAD, onBad);
				jogo.removeEventListener(JogoEvent.STOPPED, onStopped);
			}

			changeGameState(GAME_CREATINGPLAY);
		}
		
		override public function createPlayInstance():IPlayInstance {
			return new JogoPlay();
		}
		
		private function onStateReady(e:Event):void 
		{
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
		private var vidas:int = 1;
		private var txPontos:TextField = new TextField();
		private var txVidas:TextField = new TextField();
		
		
		
		private function changeGameState(vlr:int):void {
			switch(vlr) {
				case GAME_CREATINGPLAY:
					drawGame();
					playGame();
					break;
				case GAME_INTERACTING:
					break;
				case GAME_EVALUATING:
					jogo.stop = true;
					JogoPlay(eval.currentPlay).pontuacao = pontos;
					this.eval.evaluate();
					break;
			}
		}
		
		
		

		private function playGame():void {
			jogo.drawGame();
			vidas = 1;
			pontos = 0;
			eval.createNewPlay();
			changeGameState(GAME_INTERACTING);
			
		}

		
		
		
		

		
	}

}