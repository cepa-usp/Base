package cepa.ai
{
	import cepa.ai.gui.GlassPane;
	import cepa.ai.gui.InfoBar;
	import cepa.ai.gui.MenuBar;
	import cepa.tooltip.ToolTip;
	import com.adobe.protocols.dict.Database;
	import com.eclecticdesignstudio.motion.Actuate;
	import com.pipwerks.SCORM;
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class AIContainer extends Sprite
	{

		private var layerUI:Sprite = new Sprite();
		private var ai:AI;
		private var margin:int = 25;
		private var glassPane:GlassPane;
		private var _menuBar:MenuBar;
		private var _infoBar:InfoBar;
		private var hasInfoBar:Boolean = true;		
		private var aboutScreen:Sprite;
		private var border:Sprite = new Sprite();
		private var infoScreen:Sprite;
		private var rect:Rectangle = new Rectangle(0, 0, 700, 500);
		
		public function AIContainer(stagesprite:Sprite, ai:AI)
		{	
			
			this.ai = ai;
			stagesprite.addChild(this);
			this.scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);			
			createUI();
			//setAboutScreen(new AboutScreenUI());
			adjustBorder();
		}
		
		public function disableComponent(display:*):void {
			try {
				display.alpha = 0.5;
				display.mouseEnabled = false;
				display.filters = [AIConstants.DISABLE_FILTER];
			} catch (e:Error) {
				//nada
				trace(e.getStackTrace());
			}
		}		
		public function enableComponent(display:*):void {
			try {
				display.alpha = 1;
				display.mouseEnabled = true;
				display.filters = [];
			} catch (e:Error) {
				//nada
				trace(e.getStackTrace());
			}
		}		
		
		/**
		 * Coloca a moldura na atividade, acertando as bordas arredondadas de acordo com o tamanho dela.
		 */
		public function adjustBorder():void {
			var b:Borda = new Borda();			
			b.scale9Grid = new Rectangle(20, 20, b.width - 40, b.height - 40);
			b.width = this.stage.stageWidth;
			b.height = this.stage.stageHeight;
			border.addChild(b);
			
		}

	
		public function createUI():void {
			addChild(layerUI);
			addInfoBar();
			addMenuBar();
			

		}		

		public function addMenuBar():void {
			// exibir mensagem quando passar mouse nos botoes do menu			
			// mandar reset pros AI.observers.onResetClick e onTutorialClick
			menuBar = new MenuBar();
			menuBar.x = rect.width - menuBar.BTN_WIDTH - 10;
			menuBar.y = rect.height - 10;

			// creditos
			var creditButton:CreditBtn = new CreditBtn();
			creditButton.addEventListener(MouseEvent.CLICK, function() {
				ai.eventDispatcher.dispatchEvent(new AIEvent(AIEvent.CREDITS_CLICK, ai));
			});
			creditButton.name = "about";
			menuBar.addButton(creditButton, "Licença e créditos");
			setAboutScreen(new AboutScreen())
			
			
			// reset
			var resetButton:ResetBtn = new ResetBtn();
			resetButton.addEventListener(MouseEvent.CLICK, function() {
				ai.eventDispatcher.dispatchEvent(new AIEvent(AIEvent.RESET_CLICK, ai));
			});						
			menuBar.addButton(resetButton, "Reiniciar");
			
			// instrucoes
			var instrButton:InstructionBtn = new InstructionBtn();
			instrButton.addEventListener(MouseEvent.CLICK, function() {
				ai.eventDispatcher.dispatchEvent(new AIEvent(AIEvent.INSTRUCT_CLICK, ai));
			});					
			instrButton.name = "info";
			menuBar.addButton(instrButton, "Orientações");
			


			// tutorial
			var tutButton:InfoBtn = new InfoBtn();
			tutButton.addEventListener(MouseEvent.CLICK, function() {
				ai.eventDispatcher.dispatchEvent(new AIEvent(AIEvent.TUTORIAL_CLICK, ai));
			});
			menuBar.addButton(tutButton, "Reiniciar tutorial");
			layerUI.addChild(menuBar);

		}
		

		private function addInfoBar():void 
		{
			if (hasInfoBar) {
				infoBar = new InfoBar(rect.width, rect.width - 70);
				infoBar.y = stage.stageHeight;
				layerUI.addChild(infoBar);
			}
		}		
		
		public function setAboutScreen(sprite:Sprite):void {
			if(aboutScreen!=null) layerUI.removeChild(aboutScreen);
			aboutScreen = sprite;
			aboutScreen.x = stage.stageWidth/2;
			aboutScreen.y = stage.stageHeight / 2;
			aboutScreen.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { closeScreen(aboutScreen) } );				
			menuBar.getButton("about").addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				openScreen(aboutScreen);
			});
			
			layerUI.addChild(aboutScreen);
			layerUI.addChild(border);
			aboutScreen.alpha = 0;
			aboutScreen.visible = false;

			closeScreen2(aboutScreen);
		}
		
		public function createScreen(screen:Sprite) {
			screen.x = stage.stageWidth/2;
			screen.y = stage.stageHeight / 2;
			//screen.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { closeScreen(screen) } );				
			layerUI.addChild(screen);
			layerUI.addChild(border);
			screen.alpha = 0;
			screen.visible = false;

			openScreen(screen);
		}
		public function setInfoScreen(sprite:Sprite):void {
			if(infoScreen!=null) layerUI.removeChild(infoScreen);
			infoScreen = sprite;
			var bt:CloseButton = new CloseButton();

			bt.x = infoScreen.width - 30;
			bt.y = 30;
			infoScreen.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{closeScreen(infoScreen)});	
			
			menuBar.getButton("info").addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				openScreen(infoScreen);
			});
			layerUI.addChild(infoScreen);
			layerUI.addChild(border);
			infoScreen.alpha = 0;
			infoScreen.visible = false;
			closeScreen2(infoScreen);
			
			 
		}
		public function closeScreen(spriteScreen:Sprite):void {
			Actuate.tween(spriteScreen, 0.6, { alpha:0, scaleX:0.01, scaleY:0.01 } ).onComplete(function():void {
				spriteScreen.visible = false;
				spriteScreen.dispatchEvent(new Event(Event.CLOSE));
			});
		}
		private function closeScreen2(spriteScreen:Sprite):void {
			
				//spriteScreen.alpha = 0;
				spriteScreen.visible = false;
				
			
		}		
		public function openScreen(spriteScreen:Sprite):void {
			spriteScreen.scaleX = 1;
			spriteScreen.scaleY = 1;
			var w:Number = spriteScreen.width;
			var h:Number = spriteScreen.height;
			
			spriteScreen.x = stage.stageWidth/2;
			spriteScreen.y =  stage.stageHeight / 2;

			
			spriteScreen.scaleX = 0.01;
			spriteScreen.scaleY = 0.01;
			spriteScreen.alpha = 0;
			spriteScreen.visible = true;
			Actuate.tween(spriteScreen, 0.6, { alpha:1, scaleX:(stage.stageWidth/w), scaleY:(stage.stageHeight/h) } );
		}

	
		
		private function addTooltip(spr:Sprite, tx:String) {
			new ToolTip(spr, tx);
		}
		
		public  function makeButton(spr:Sprite):void {
			spr.buttonMode = true;
			spr.mouseChildren = false;
			spr.mouseEnabled = true;
			spr.scaleX = 1;
			spr.scaleY = 1;
			spr.addEventListener(MouseEvent.MOUSE_OVER, highlightButton);
			spr.addEventListener(MouseEvent.MOUSE_OUT, unHighlightButton);
		}
		
		private function unHighlightButton(e:MouseEvent):void 		{
			Actuate.tween(e.target, 0.4, { scaleX:1.0, scaleY:1.0 } );
		}
		
		private function highlightButton(e:MouseEvent):void 		{
			Actuate.tween(e.target, 0.4, {scaleX:1.2, scaleY:1.2 });
		}
		

		
		
		

		
		public function setOptionsMenuVisible(value:Boolean):void {
			Actuate.tween(menuBar, 0.8, { alpha:(value?(this.height - infoBar.height):this.height)});
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{			
			var c:DisplayObject =  super.addChild(child);
			setChildIndex(layerUI, numChildren - 1);
			return c;
		}
		
		public function get menuBar():MenuBar 
		{
			return _menuBar;
		}
		
		public function set menuBar(value:MenuBar):void 
		{
			_menuBar = value;
		}
		
		public function get infoBar():InfoBar 
		{
			return _infoBar;
		}
		
		public function set infoBar(value:InfoBar):void 
		{
			_infoBar = value;
		}


	}

}