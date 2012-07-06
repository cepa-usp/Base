package cepa.dao
{
	import cepa.ai.AI;
	import cepa.ai.AIEvent;
	import cepa.ai.IPlayInstance;
	import cepa.dao.scorm.ScormHandler;
	import cepa.eval.ProgressiveEvaluator;
	/**
	 * ...
	 * @author Arthur
	 */
	public class ScormAgent 
	{
		
		private var ai:AI;
		private var scorm:ScormHandler = new ScormHandler();
		private var evaluator:ProgressiveEvaluator;
		public function ScormAgent(ai:AI, evaluator:ProgressiveEvaluator) 
		{
			this.ai = ai;
			this.evaluator = evaluator;
			ai.eventDispatcher.addEventListener(AIEvent.REQUEST_INITIALIZE, onInitializeRequest)
		}
		
		private function onInitializeRequest(e:AIEvent):void 
		{ 
			scorm.connect();		
			if (scorm.scormConnected) {
				debugScreen.msg("Scorm connected! Avisando " + observers.length + " observers")	
				
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
				
				
				
				for each(var obs:AIObserver in observers) obs.onScormConnected();	
			} else {
				debugScreen.msg("Scorm not connected!")
				for each(var obs:AIObserver in observers) obs.onScormConnectionError();	
			}				
		}
		
		


		public function saveSuspendData():void {
			debugScreen.msg("Salvando suspended data");
			var ai_data:Object = new Object();
			ai_data.eval = evaluator.getData();			
			if (ai_instance != null) {
				ai_data.general = ai_instance.getData();
			}
			
			var str:String = JSON.encode(ai_data);
			debugScreen.msg("JSON criado");
			debugScreen.msg("scorm.scormConnected==" + scorm.scormConnected.toString());
			if (scorm.scormConnected) {
				debugScreen.msg("Salvando no SCORM");
				scorm.cmi.suspend_data = str;
				scorm.save();
			} 
			if(ExternalInterface.available){
				ExternalInterface.call("save2LS", str)
				debugScreen.msg("Salvando em localstorage");
			}
			
		}
		public function loadSuspendData():void {
			var obj:Object;
			var str:String;
			
			debugScreen.msg("scorm.scormConnected=" + scorm.scormConnected);
			
			if (scorm.scormConnected) {
				str = scorm.cmi.suspend_data;
				debugScreen.msg(str);
			} else {				
				str = ExternalInterface.call("getLocalStorageString");
				debugScreen.msg("Recuperando suspend_data de localstorage");
			}		
			
			if (str == "") {
				debugScreen.msg("localstorage vazio");
			} else {			
				debugScreen.msg("decodificando JSON");
				obj = JSON.decode(str);
				debugScreen.msg("ok");
				try {
					debugScreen.msg("Lendo dados gerais");
					ai_instance.readData(obj.general);	
					debugScreen.msg("ok");
				} catch (e:Error) {
					debugScreen.msg("Erro recuperando dados gerais");
				}
				
				try {
					debugScreen.msg("Lendo dados de avaliação");
					_evaluator.readData(obj.eval);
					debugScreen.msg("ok");
					
				} catch (e:Error) {
					debugScreen.msg("Erro recuperando dados de avaliacao");
				}
				
			}
		}
			
		private function saveScorm(play:IPlayInstance):void 
		{	
			ai.debugScreen.msg("================saveScorm()==================\n")
			
			ai.saveSuspendData();
			if (!ai.scorm.scormConnected) {
				ai.debugScreen.msg("Scorm não conectado, saindo.")				
				return;
			}
			
			ai.debugScreen.msg("Exit = suspend")				
			ai.scorm.cmi.exit = CmiConstants.EXIT_SUSPEND;
			ai.scorm.save();
			ai.debugScreen.msg("Saved")
			if (play.playMode == AIConstants.PLAYMODE_EVALUATE) {
				ai.debugScreen.msg("PlayMode = evaluate")
				/*
				 *  Quando o usuário terminar de responder todos os cinco exercícios requeridos, no modo de avaliação, 
				 * fazer cmi.completion_status = “completed” e cmi.progress_measure = 1, indicando que a atividade foi concluída. 
				 */
				if (numTrialsByMode(AIConstants.PLAYMODE_EVALUATE) >= minimumTrialsForParticipScore) {
					ai.debugScreen.msg("chegou a " + minimumTrialsForParticipScore + " tentativas, vai mudar status pra complete")
					ai.scorm.cmi.progress_measure = 1;	
					ai.scorm.cmi.completion_status = CmiConstants.COMPLETION_STATUS_COMPLETE;
					ai.debugScreen.msg("ai.scorm.scorm.set(\"completion_status\", \"complete\")");
					ai.scorm.scorm.set("completion_status", "complete");
					
				} else {
					ai.debugScreen.msg("ainda não atingiu " + minimumTrialsForParticipScore + " tentativas, apenas " + numTrialsByMode(AIConstants.PLAYMODE_EVALUATE))
				}
				var scr:Number = score;
				ai.scorm.cmi.score.raw = parseFloat(Number(scr * 100).toFixed());
				ai.scorm.cmi.score.scaled = parseFloat(Number(scr).toFixed(2));
				ai.debugScreen.msg("ai.scorm.cmi.score.raw <= " + ai.scorm.cmi.score.raw );
				
				
				/*
				 * No caso desta AI, quando o usuário atingir pontuação igual ou superior a PASSING_SCORE (= 75%, para começar), 
				 * fazer cmi.success_status = “passed”, sinalizando para o LMS que ele foi aprovado na AI. 
				 * Caso contrário, fazer cm.success_status = “failed”. obs.: para o PASSING_SCORE de 75%, pode-se concluir que o usuário precisa obter uma média aritmética dos exercícios igual ou superior a 0,5 (50%), em modo de avaliação, para passar, considerando que ele tenha feito a quantidade mínima de exercícios requerida (cinco, nesta AI).
				 */
				if (scr >= minimumScoreForAcceptance) {
					ai.scorm.cmi.success_status	= CmiConstants.SUCCESS_STATUS_PASSED;
					ai.debugScreen.msg("score maior do que o mínimo, salvando cmi.success_status <= passed")
				} else {
					ai.scorm.cmi.success_status = CmiConstants.SUCCESS_STATUS_FAILED;
					ai.debugScreen.msg("score menor do que o mínimo, salvando cmi.success_status <= failed")
					
				}
				ai.scorm.save();
				
				//encodePlayInstances();
			} else {
				
			}
			
			
		}			
				
	}

}