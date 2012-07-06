package BaseAssets.components
{
	import cepa.utils.ToolTip;
	import com.eclecticdesignstudio.motion.Actuate;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class MenuBar extends Sprite
	{
		public const BTN_WIDTH:Number = 44;
		private const BTN_HEIGHT:Number = 40;
		private const BTN_TWEEN_TIME:Number = 0.2;
		
		private var buttons:Vector.<Sprite> = new Vector.<Sprite>();
		//private var background:Sprite = new Sprite();
		private var background:MenuBarBackground;
		
		public function MenuBar() 
		{
			
		}
		
		public function addButton(spr:Sprite, func:Function, descricao:String = null):void
		{
			spr.x = BTN_WIDTH / 2;
			spr.y = -((BTN_HEIGHT / 2) + buttons.length * BTN_HEIGHT);
			
			buttons.push(spr);
			makeButton(spr, func);
			if (descricao != null) createToolTip(spr, descricao);
			
			drawBackground();
			
			addChild(spr);
		}
		
		private function createToolTip(spr:Sprite, descricao:String):void 
		{
			var btnTT:ToolTip = new ToolTip(spr, descricao, 12, 0.8, 150, 0.6, 0.1);
			stage.addChild(btnTT);
		}
		
		private function makeButton(spr:Sprite, func:Function):void 
		{
			spr.buttonMode = true;
			spr.addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			spr.addEventListener(MouseEvent.MOUSE_OUT, outBtn);
			spr.addEventListener(MouseEvent.CLICK, func);
		}
		
		private function overBtn(e:MouseEvent):void 
		{
			var btn:Sprite = Sprite(e.target);
			//btn.scaleX = btn.scaleY = 1.2;
			Actuate.tween(btn, BTN_TWEEN_TIME, { scaleX:1.2, scaleY:1.2 } );
		}
		
		private function outBtn(e:MouseEvent):void 
		{
			var btn:Sprite = Sprite(e.target);
			//btn.scaleX = btn.scaleY = 1;
			Actuate.tween(btn, BTN_TWEEN_TIME, { scaleX:1, scaleY:1 } );
		}
		
		private function drawBackground():void 
		{
			if (background == null) {
				background = new MenuBarBackground();
				background.filters = [new DropShadowFilter(3, 45, 0x000000, 1, 5, 5)];
				addChild(background);
				setChildIndex(background, 0);
				//background.scale9Grid = new Rectangle(5, -BTN_HEIGHT + 10, BTN_WIDTH - 10, BTN_HEIGHT - 10);
			}
			
			background.scaleY = buttons.length;
			
			//background.graphics.clear();
			//background.graphics.beginFill(0xDBDBDB, 1);
			//background.graphics.drawRoundRect(0, 0, BTN_WIDTH, -BTN_HEIGHT * buttons.length, 5, 5);
			//background.graphics.drawRoundRectComplex(0, 0, BTN_WIDTH, -BTN_HEIGHT * buttons.length, 5, 5, 5, 5);
			//background.graphics.drawRect(0, 0, BTN_WIDTH, -BTN_HEIGHT * buttons.length);
			
			//MovieClip(bordaAtividade).scale9Grid = new Rectangle(20, 20, 610, 460);
			//MovieClip(bordaAtividade).scaleX = stage.stageWidth / 650;
			//MovieClip(bordaAtividade).scaleY = stage.stageHeight / 500;
		}
		
	}

}