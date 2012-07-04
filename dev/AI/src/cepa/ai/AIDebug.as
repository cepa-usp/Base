package cepa.ai 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class AIDebug extends Sprite 
	{
				
		private var txt:TextField = new TextField();

		private var vis:Boolean = false;
		private var stagesprite:Stage;
		public function AIDebug(ai:AI, stagesprite:Sprite) 
		{
			this.stagesprite = stagesprite.stage;
			this.graphics.beginFill(0x0C3016, 0.7);
			txt.textColor = 0xFFFFFF;
			this.graphics.drawRect(0, 0, this.stagesprite.stageWidth, this.stagesprite.stageHeight);
			stagesprite.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.name = "debugscreen"
			this.addChild(txt);
			txt.width = this.stagesprite.stageWidth - 200;
			txt.x = 200;
			txt.height = this.stagesprite.stageHeight;
			txt.text = "Início\n\n"
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
		if (e.ctrlKey == true && e.shiftKey == true && e.keyCode == Keyboard.F4) {
				vis = (!vis);
				if (vis) {
					stagesprite.addChild(this);
					
					this.visible = true;
					
				} else {
					stagesprite.removeChild(this);
				}
				
			}
		}
		public function msg(value:String) {
			txt.text += value + "\n"
		}
		
		
		
		
	}

}