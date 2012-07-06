package cepa.eval 
{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.IEvaluation;
	import cepa.ai.IPlayInstance;
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONEncoder;
	
	/**
	 * ...
	 * @author Arthur
	 */
	


	public class ProgressiveEvaluator implements IEvaluation 
	{
		private var _playInstances:Vector.<IPlayInstance> = new Vector.<IPlayInstance>();
		private var _instancesDetails:Vector.<Object> = new Vector.<Object>();
		private var _minimumScoreForAcceptance:Number = 0.75;
		private var _minimumTrialsForParticipScore:int = 5;
		private var _playmode:int = AIConstants.PLAYMODE_FREEPLAY;

		private var ai:AI;
		
		public function ProgressiveEvaluator(ai:AI)
		{
			this.ai = ai;
		}
			
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
				i += (instancesDetails[j].playMode==mode?1:0);
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
				if(instancesDetails[j].playMode==AIConstants.PLAYMODE_EVALUATE){
					cases++;
					scoreSum += playInstances[j].getScore();
				}
			}
			
			return scoreSum / Math.max(cases, _minimumTrialsForParticipScore);
		};	
		
	
		

		
		/* INTERFACE cepa.ai.IEvaluation */
		
		/**
		 * Depois que um exercício for realizado, ele entrará nessa pilha. Neste momento, o avaliador deverá persistir os dados no scorm
		 * @param	playInstance 
		 */
		public function evaluate(play:IPlayInstance) 
		{
			playInstances.push(play);
		}
		
		/* INTERFACE cepa.ai.IEvaluation */
		
		public function getData():Object 
		{
			
			var obj:Object = new Object();			
			obj.playinstances = new Object();
			obj.playinstancesdetails = new Object();
			obj.length = playInstances.length;

			for (var i:int = 0; i < playInstances.length; i++) {
				obj.playinstances[String(i)] = playInstances[i].returnAsObject();
				obj.playinstancesdetails[String(i)] = instancesDetails[i];
			}
			return obj;
		}

		
		public function readData(obj:Object) 
		{
			this.playInstances = new Vector.<IPlayInstance>();
			this.instancesDetails = new Vector.<Object>();
			
			try {
				var len:int = obj.length;
				for (var i:int = 0; i < len; i++) {
					var ply:IPlayInstance = ai.createPlayInstance();
					ply.bind(obj.playinstances[i.toString()]);
					playInstances.push(ply);
					instancesDetails.push(obj.playinstancesdetails[i.toString()]);
				}				
			} catch (e:Error) {
				ai.debugScreen.msg("Não é um objeto")
				ai.debugScreen.msg(e.getStackTrace())
				ai.debugScreen.msg(e.message)
				ai.debugScreen.msg(e.name)
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
		
		public function get instancesDetails():Vector.<Object> 
		{
			return _instancesDetails;
		}
		
		public function set instancesDetails(value:Vector.<Object>):void 
		{
			_instancesDetails = value;
		}
		
		public function get playmode():int 
		{
			return _playmode;
		}
		
		public function set playmode(value:int):void 
		{
			_playmode = value;
		}
		
	}

}