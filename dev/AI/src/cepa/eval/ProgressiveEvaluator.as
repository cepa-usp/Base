package cepa.eval 
{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.IEvaluation;
	import cepa.ai.IPlayInstance;
	import cepa.scorm.CmiConstants;
	import cepa.scorm.ScormHandler;
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONEncoder;
	import com.pipwerks.SCORM;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class ProgressiveEvaluator implements IEvaluation 
	{
		private var _playInstances:Vector.<IPlayInstance> = new Vector.<IPlayInstance>();
		private var ai:AI;
		private var _minimumScoreForAcceptance:Number = 0.75;
		private var _minimumTrialsForParticipScore:int = 5;


		/**
		 * Returns total amount of trials
		 */
		public function get numTrials():int {
			return playInstances.length;
		}
		
		/**
		 * Returns number of trials for each mode (defined by AIConstants.PLAYMODE_*)
		 */
		public function numTrialsByMode(mode:int):int {
			var i:int = 0;
			for (var j:int = 0; j < playInstances.length; j++) {
				i += (playInstances[j].playMode==mode?1:0);
			}
			return i;
		}
		
		public function get participationScore():Number {
			var validtrials:int = numTrialsByMode(AIConstants.PLAYMODE_EVALUATE);
			return (validtrials >= minimumTrialsForParticipScore?0.5:0);			

		}
		

		/**
		 * Score mean considering all valid and invalid trials
		 */
		public function get scoreGeneralMean():Number {
			var scoreSum:Number = 0;
			var cases:int = 0;
			for (var j:int = 0; j < playInstances.length; j++) {
				cases++;
				scoreSum += playInstances[j].getScore();
			}
			return scoreSum / cases;
		};
		

		/**
		 * Score mean considering all valid and invalid trials
		 */
		public function get scoreValidMean():Number {
			var scoreSum:Number = 0;
			var cases:int = 0;
			for (var j:int = 0; j < playInstances.length; j++) {
				if(playInstances[j].playMode==AIConstants.PLAYMODE_EVALUATE){
					cases++;
					scoreSum += playInstances[j].getScore();
				}
			}
			
			return scoreSum / Math.max(cases, _minimumTrialsForParticipScore);
		};	
		
	
		
		public function ProgressiveEvaluator(ai:AI)
		{
			this.ai = ai;

		}
		
		/* INTERFACE cepa.ai.IEvaluation */
		
		/**
		 * Depois que um exercício for realizado, ele entrará nessa pilha. Neste momento, o avaliador deverá persistir os dados no scorm
		 * @param	playInstance 
		 */
		public function addPlayInstance(play:IPlayInstance) 
		{
			playInstances.push(play);
			saveScorm(play)
			
		}
		
		/* INTERFACE cepa.ai.IEvaluation */
		
		public function getData():Object 
		{
			
			var obj:Object = new Object();
			obj.length = playInstances.length;
			for (var i:int = 0; i < playInstances.length; i++) {
				obj[String(i)] = playInstances[i].returnAsObject();
			}
			return obj;
		}

		
		public function readData(obj:Object) 
		{
			this.playInstances = new Vector.<IPlayInstance>();
			
			try {
				var len:int = obj.length;
				
				ai.debugScreen.msg("carregou: " + len.toString());
				for (var i:int = 0; i < len; i++) {
					var ply:IPlayInstance = ai.ai_instance.createNewPlayInstance()
					
					//ai.debugScreen.msg(JSON.encode(b[i]));
					ply.bind(obj[i.toString()]);
					playInstances.push(ply);
					//a.push(playInstances[i].returnAsObject);
				}				
				ai.debugScreen.msg("leu plays: " + i.toString())
				} catch (e:Error) {
				ai.debugScreen.msg("Não é um objeto")
				ai.debugScreen.msg(e.getStackTrace())
				ai.debugScreen.msg(e.message)
				ai.debugScreen.msg(e.name)
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
		
		/* INTERFACE cepa.ai.IEvaluation */
		
		public function get score():Number 
		{
			var s:Number = 0;
			return participationScore + scoreValidMean/2;
		}
		
		
		public function get playInstances():Vector.<IPlayInstance> 
		{
			return _playInstances;
		}
		
		public function set playInstances(value:Vector.<IPlayInstance>):void 
		{
			_playInstances = value;
		}
		
		public function get minimumScoreForAcceptance():Number 
		{
			return _minimumScoreForAcceptance;
		}
		
		public function set minimumScoreForAcceptance(value:Number):void 
		{
			_minimumScoreForAcceptance = value;
		}
		
		public function get minimumTrialsForParticipScore():int 
		{
			return _minimumTrialsForParticipScore;
		}
		
		public function set minimumTrialsForParticipScore(value:int):void 
		{
			_minimumTrialsForParticipScore = value;
		}
		
	}

}