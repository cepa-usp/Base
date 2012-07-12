package 
{
	import BaseAssets.BaseMain;
	import BaseAssets.tutorial.CaixaTexto;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends BaseMain
	{
		var texts:Array = ["Precisávamos de uma área para registrar informações que pudessem ser acessadas via web por qualquer computador e por qualquer colaborador. Bem, o STOA é uma rede já existente, modelada e suportada pelo pessoal de ATP, acessível a qualquer  colaborador USP. O STOA foi, assim, uma escolha natural.",
							"aughaiahuiah akjaolijan akjalçja akijaalihslah aiughsik",
							"lahlahalhalaaç, apçjaan ",
							""];
							
		private var pos:int = 0;
		
		public function Main() 
		{
			
		}
		
		override protected function init():void 
		{
			stage.addEventListener(MouseEvent.CLICK, changeInfo);
		}
		
		private function changeInfo(e:MouseEvent):void 
		{
			infoBar.info = texts[pos];
			pos++;
			if (pos > texts.length - 1) pos = 0;
		}
		
		
		override public function reset(e:MouseEvent = null):void
		{
			
		}
		
		//---------------- Tutorial -----------------------
		
		private var balao:CaixaTexto;
		private var pointsTuto:Array;
		private var tutoBaloonPos:Array;
		private var tutoPos:int;
		private var tutoSequence:Array = ["Este é um sistema solar fictício.", 
										  "Um ou mais planetas não obedece à terceira lei de Kepler.",
										  "A quantidade de planetas que não obedecem à terceira lei de Kepler será indicado aqui.",
										  "Quando você estiver pronto(a) para ser avaliado(a), pressione para mudar para o modo de avaliação.",
										  "Pressione para começar um novo exercício.",
										  "Pressione para exibir/ocultar a resposta."];
		
		
		override public function iniciaTutorial(e:MouseEvent = null):void  
		{
			tutoPos = 0;
			if(balao == null){
				balao = new CaixaTexto();
				layerTuto.addChild(balao);
				balao.visible = false;
				
				pointsTuto = 	[new Point(230, 220),
								new Point(55, 30),
								new Point(82, 60),
								new Point(655, 325),
								new Point(125, 32),
								new Point(85, 102)];
								
				tutoBaloonPos = [[CaixaTexto.RIGHT, CaixaTexto.CENTER],
								[CaixaTexto.LEFT, CaixaTexto.CENTER],
								[CaixaTexto.BOTTON, CaixaTexto.FIRST],
								[CaixaTexto.RIGHT, CaixaTexto.FIRST],
								["", ""],
								[CaixaTexto.TOP, CaixaTexto.CENTER]];
			}
			balao.removeEventListener(Event.CLOSE, closeBalao);
			
			balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
			balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			balao.addEventListener(Event.CLOSE, closeBalao);
		}
		
		private function closeBalao(e:Event):void 
		{
			tutoPos++;
			if (tutoPos >= tutoSequence.length) {
				balao.removeEventListener(Event.CLOSE, closeBalao);
				balao.visible = false;
			}else {
				balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
				balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			}
		}
	}

}