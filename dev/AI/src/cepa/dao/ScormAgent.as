package cepa.dao
{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIEvent;
	import cepa.ai.IPlayInstance;
	import cepa.dao.scorm.CmiConstants;
	import cepa.dao.scorm.ScormHandler;
	import cepa.eval.ProgressiveEvaluator;
	import com.adobe.serialization.json.JSON;
	/**
	 * ...
	 * @author Arthur
	 */
	public class ScormAgent 
	{
		
		private var ai:AI;
		private var scorm:ScormHandler = new ScormHandler();
		private var evaluator:ProgressiveEvaluator;
		private var debugScreen:Object = new Object();
		public function ScormAgent(ai:AI, evaluator:ProgressiveEvaluator) 
		{
			debugScreen.msg = function(s:String):void {
				trace(s);
			}
			this.ai = ai;
			this.evaluator = evaluator;
			ai.eventDispatcher.addEventListener(AIConstants.STATE_LOADING, onInitializeRequest)
		}
		
		private function onInitializeRequest(e:AIEvent):void 
		{ 
			scorm.connect();		
			if (scorm.scormConnected) {				
				try {
					scorm.fetch();
					debugScreen.msg("Scorm fetched")
				} catch (e:Error) {
					debugScreen.msg("Error fetching scorm")
					debugScreen.msg(e.message);
					debugScreen.msg(e.name);
					debugScreen.msg(e.getStackTrace());
				}
				loadSuspendData();
				ai.setState(AIConstants.STATE_READY);
			} else {
				debugScreen.msg("Scorm not connected!")
				ai.setState(AIConstants.STATE_READY);
			}				
		}
		
		


		public function saveSuspendData():void {
			debugScreen.msg("Salvando suspended data");
			var ai_data:Object = new Object();
			ai_data.eval = evaluator.getData();			
			ai_data.general = ai.getData();
			
			var str:String = JSON.encode(ai_data);
			if (scorm.scormConnected) {
				debugScreen.msg("Salvando no SCORM");
				scorm.cmi.suspend_data = str;
				scorm.save();
			} 
		}
		public function loadSuspendData():void {
			var obj:Object;
			var str:String;
			
			debugScreen.msg("scorm.scormConnected=" + scorm.scormConnected);
			
			if (scorm.scormConnected) {
				str = scorm.cmi.suspend_data;
				debugScreen.msg(str);
			}
			if (str == "") {
				debugScreen.msg("cmi.suspend_data vazio");
			} else {			
				debugScreen.msg("decodificando JSON");
				obj = JSON.decode(str);
				debugScreen.msg("ok");
				try {
					debugScreen.msg("Lendo dados gerais");
					ai.setData(obj.general);	
					debugScreen.msg("ok");
				} catch (e:Error) {
					debugScreen.msg("Erro recuperando dados gerais");
				}
				
				try {
					debugScreen.msg("Lendo dados de avaliação");
					evaluator.readData(obj.eval);
					debugScreen.msg("ok");
					
				} catch (e:Error) {
					debugScreen.msg("Erro recuperando dados de avaliacao");
				}
				
			}
		}
			
		
		
		private function saveNewPlay():void 
		{	
			if (!scorm.scormConnected) {
				return;
			}
			scorm.cmi.exit = CmiConstants.EXIT_SUSPEND;
			scorm.save();

			if (evaluator.playmode == AIConstants.PLAYMODE_EVALUATE) {	
				/*
				 *  Quando o usuário terminar de responder todos os cinco exercícios requeridos, no modo de avaliação, 
				 * fazer cmi.completion_status = “completed” e cmi.progress_measure = 1, indicando que a atividade foi concluída. 
				 */
				if (evaluator.numTrialsByMode(AIConstants.PLAYMODE_EVALUATE) >= evaluator.minimumTrialsForParticipScore) {
					scorm.cmi.progress_measure = 1;	
					scorm.cmi.completion_status = CmiConstants.COMPLETION_STATUS_COMPLETE;
				}
				var scr:Number = evaluator.score;
				scorm.cmi.score.raw = parseFloat(Number(scr * 100).toFixed());
				scorm.cmi.score.scaled = parseFloat(Number(scr).toFixed(2));
			
				
				/*
				 * No caso desta AI, quando o usuário atingir pontuação igual ou superior a PASSING_SCORE (= 75%, para começar), 
				 * fazer cmi.success_status = “passed”, sinalizando para o LMS que ele foi aprovado na AI. 
				 * Caso contrário, fazer cm.success_status = “failed”. obs.: para o PASSING_SCORE de 75%, pode-se concluir que o usuário precisa obter uma média aritmética dos exercícios igual ou superior a 0,5 (50%), em modo de avaliação, para passar, considerando que ele tenha feito a quantidade mínima de exercícios requerida (cinco, nesta AI).
				 */
				if (scr >=evaluator.minimumScoreForAcceptance) {
					scorm.cmi.success_status	= CmiConstants.SUCCESS_STATUS_PASSED;
				} else {
					scorm.cmi.success_status = CmiConstants.SUCCESS_STATUS_FAILED;
				}
				scorm.save();
				
				//encodePlayInstances();
			} else {
				
			}
			
			
		}			
				
	}

}