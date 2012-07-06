package BaseAssets
{
	import BaseAssets.screens.AboutScreen;
	import BaseAssets.screens.FeedBackScreen;
	import BaseAssets.screens.GlassPane;
	import BaseAssets.screens.InstScreen;
	import BaseAssets.screens.StatsScreen;
	import cepa.utils.ToolTip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class BaseMain extends Sprite
	{
		/**
		 * Borda da atividade.
		 */
		private var bordaAtividade:Borda;
		
		/**
		 * Menu com os botões.
		 */
		protected var botoes:Botoes;
		
		//Telas da atividade:
		private var creditosScreen:AboutScreen;
		private var orientacoesScreen:InstScreen;
		protected var feedbackScreen:FeedBackScreen;
		protected var statsScreen:StatsScreen;
		
		private var glassPane:GlassPane;
		
		/**
		 * Atividade possui tela de desempenho?
		 */
		private var hasStats:Boolean = true;
		
		/*
		 * Filtro de conversão para tons de cinza.
		 */
		protected const GRAYSCALE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0.2225, 0.7169, 0.0606, 0, 0,
			0.2225, 0.7169, 0.0606, 0, 0,
			0.2225, 0.7169, 0.0606, 0, 0,
			0.0000, 0.0000, 0.0000, 1, 0
		]);
		
		//Camadas:
		private var layerBorda:Sprite;
		private var layerDebug:Sprite;
		private var layerDialogo:Sprite;
		private var layerGlass:Sprite;
		protected var layerTuto:Sprite;
		private var layerMenu:Sprite;
		private var layerAtividade:Sprite;
		
		public function BaseMain() 
		{
			if (stage) baseInit();
			else addEventListener(Event.ADDED_TO_STAGE, baseInit);
		}
		
		private function baseInit(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, baseInit);
			
			scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			criaCamadas();
			criaTelas();
			adicionaListeners();
			
			init();
		}
		
		protected function init():void {
			
		}
		
		/**
		 * Cria as camadas que serão utilizadas.
		 */
		protected function criaCamadas():void 
		{
			layerBorda = new Sprite();
			layerDebug = new Sprite();
			layerDialogo = new Sprite();
			layerGlass = new Sprite();
			layerTuto = new Sprite();
			layerMenu = new Sprite();
			layerAtividade = new Sprite();
			
			super.addChild(layerAtividade);
			super.addChild(layerMenu);
			super.addChild(layerTuto);
			super.addChild(layerGlass);
			super.addChild(layerDialogo);
			super.addChild(layerDebug);
			super.addChild(layerBorda);
		}
		
		/**
		 * Cria as telas e adiciona no palco.
		 */
		protected function criaTelas():void 
		{
			glassPane = new GlassPane(stage.stageWidth, stage.stageHeight);
			layerGlass.addChild(glassPane);
			glassPane.visible = false;
			
			creditosScreen = new AboutScreen(glassPane);
			layerDialogo.addChild(creditosScreen);
			orientacoesScreen = new InstScreen(glassPane);
			layerDialogo.addChild(orientacoesScreen);
			feedbackScreen = new FeedBackScreen(glassPane);
			layerDialogo.addChild(feedbackScreen);
			
			if(hasStats){
				statsScreen = new StatsScreen(glassPane);
				layerDialogo.addChild(statsScreen);
			}
			
			botoes = new Botoes();
			botoes.x = stage.stageWidth - botoes.width - 10;
			botoes.y = stage.stageHeight - botoes.height - 10;
			botoes.filters = [new DropShadowFilter(3, 45, 0x000000, 1, 5, 5)];
			layerMenu.addChild(botoes);
			
			bordaAtividade = new Borda();
			MovieClip(bordaAtividade).scale9Grid = new Rectangle(20, 20, 610, 460);
			MovieClip(bordaAtividade).scaleX = stage.stageWidth / 650;
			MovieClip(bordaAtividade).scaleY = stage.stageHeight / 500;
			layerBorda.addChild(bordaAtividade);
		}
		
		/**
		 * Adiciona os eventListeners nos botões.
		 */
		protected function adicionaListeners():void 
		{
			botoes.tutorialBtn.addEventListener(MouseEvent.CLICK, iniciaTutorial);
			botoes.orientacoesBtn.addEventListener(MouseEvent.CLICK, openOrientacoes);
			botoes.creditos.addEventListener(MouseEvent.CLICK, openCreditos);
			botoes.resetButton.addEventListener(MouseEvent.CLICK, reset);
			if (hasStats) {
				botoes.btEstatisticas.addEventListener(MouseEvent.CLICK, openStats);
			}else {
				lock(botoes.btEstatisticas);
			}
			
			createToolTips();
		}
		
		/**
		 * Cria os tooltips nos botões
		 */
		private function createToolTips():void 
		{
			var intTT:ToolTip = new ToolTip(botoes.tutorialBtn, "Reiniciar tutorial", 12, 0.8, 150, 0.6, 0.1);
			var instTT:ToolTip = new ToolTip(botoes.orientacoesBtn, "Orientações", 12, 0.8, 100, 0.6, 0.1);
			var resetTT:ToolTip = new ToolTip(botoes.resetButton, "Reiniciar", 12, 0.8, 100, 0.6, 0.1);
			var infoTT:ToolTip = new ToolTip(botoes.creditos, "Créditos", 12, 0.8, 100, 0.6, 0.1);
			
			addChild(intTT);
			addChild(instTT);
			addChild(resetTT);
			addChild(infoTT);
			
			if (hasStats) {
				var statsTT:ToolTip = new ToolTip(botoes.btEstatisticas, "Desempenho", 12, 0.8, 100, 0.6, 0.1);
				addChild(statsTT);
			}
		}
		
		protected function lock(bt:*):void
		{
			bt.filters = [GRAYSCALE_FILTER];
			bt.alpha = 0.5;
			bt.mouseEnabled = false;
		}
		
		protected function unlock(bt:*):void
		{
			bt.filters = [];
			bt.alpha = 1;
			bt.mouseEnabled = true;
		}
		
		/**
		 * Abrea a tela de orientações.
		 */
		private function openOrientacoes(e:MouseEvent):void 
		{
			orientacoesScreen.openScreen();
		}
		
		/**
		 * Abre a tela de créditos.
		 */
		private function openCreditos(e:MouseEvent):void 
		{
			creditosScreen.openScreen();
		}
		
		/**
		 * Abre a tela de estatísticas.
		 */
		protected function openStats(e:MouseEvent):void 
		{
			statsScreen.openScreen();
		}
		
		/**
		 * Inicia o tutorial da atividade.
		 */
		public function iniciaTutorial(e:MouseEvent = null):void 
		{
			
		}
		
		/**
		 * Reinicia a atividade, colocando-a no seu estado inicial.
		 */
		public function reset(e:MouseEvent = null):void 
		{
			
		}
		
		override public function addChild(child:DisplayObject):flash.display.DisplayObject 
		{
			return layerAtividade.addChild(child);
		}
		
	}

}