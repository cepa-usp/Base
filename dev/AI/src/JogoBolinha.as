package  
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class JogoBolinha extends Sprite 
	{
		private var _velocidade:Number = 3;
		private var _epsilon:Number = 0.95;
		private var ballsize:Number = 50;
		private var _stop:Boolean = false;
		
		
		//private function init(e:Event = null):void 
		//{
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			//drawGame()			
		//}		
		
		public function JogoBolinha() 
		{
			//if (stage) init();
			//else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}

		
		public function get velocidade():Number 
		{
			return _velocidade;
		}
		
		public function set velocidade(value:Number):void 
		{
			_velocidade = value;
		}
		
		public function get stop():Boolean 
		{
			return _stop;
		}
		
		public function set stop(value:Boolean):void 
		{
			_stop = value;
		}
		
		public function get epsilon():Number 
		{
			return _epsilon;
		}
		
		public function set epsilon(value:Number):void 
		{
			_epsilon = value;
		}

		

		public function drawGame():void {
			if (stage==null) return;
			var b:Sprite = new Sprite();
			b.graphics.beginFill(0x008000);
			b.graphics.drawCircle(0, 0, ballsize);					
			b.addEventListener(MouseEvent.CLICK, onBallClick);
			var posx:int = (Math.random() * (this.stage.stageWidth - 30)) + 15
			var posy:int = (Math.random() * (this.stage.stageHeight - 30)) + 15
			b.x = posx;
			b.y = posy;
			b.mouseChildren = false;
			b.buttonMode = true;
			b.alpha = 0.2;
			b.scaleX = 0.01;
			b.scaleY = 0.01;
			addChild(b);
			Actuate.tween(b, velocidade, { scaleX:1, scaleY:1, alpha:1 } ).onComplete(onBallComplete, b).ease(Linear.easeNone);
		}
		
		private function onBallComplete(b:Sprite):void 
		{
			if (b.parent == null) return;
			var e:JogoEvent = new JogoEvent(JogoEvent.BAD);
			e.points = 0;
			removeChild(b);						
			
			dispatchEvent(e);			
			if (!stop) {
				drawGame();	
			} else {
				var e2:JogoEvent = new JogoEvent(JogoEvent.STOPPED);
				dispatchEvent(e2);
			}
			
		}
		

		
		private function onBallClick(e:Event):void 
		{
			velocidade *= epsilon;
			var ee:JogoEvent = new JogoEvent(JogoEvent.GOOD);
			var p:Number = Sprite(e.target).scaleX;
			ee.points = (1 - p) * 1000;
			removeChild(Sprite(e.target));
			dispatchEvent(ee)
			if (!stop) {
				drawGame();	
			} else {
				var eee:JogoEvent = new JogoEvent(JogoEvent.STOPPED);
				dispatchEvent(eee);
			}
		}		
	}

}