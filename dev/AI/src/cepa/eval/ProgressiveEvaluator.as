package cepa.eval 
{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.DefaultEvaluator;
	import cepa.ai.EvaluatorEvent;
	import cepa.ai.IEvaluation;
	import cepa.ai.IPlayInstance;
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONEncoder;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Arthur
	 */
	


	public class ProgressiveEvaluator extends DefaultEvaluator 
	{
		
		private var _instancesDetails:Vector.<Object> = new Vector.<Object>();
		private var _minimumScoreForAcceptance:Number = 0.75;
		private var _minimumTrialsForParticipScore:int = 5;
		private var ai:AI;
		private var _playmode:int = AIConstants.PLAYMODE_FREEPLAY;
		
		/**
		 * 
		 * @param	delegateCreateNewPlay a function which returns any IPlayInstance instance;
		 */
		public function ProgressiveEvaluator(ai:AI, delegateCreateNewPlay:Function)
		{
			super(delegateCreateNewPlay);
			var btStats:BtStats = new BtStats();
			btStats.addEventListener(MouseEvent.CLICK, onStatsClicked)
			this.ai = ai;
			ai.container.menuBar.addButton(btStats, "Estatísticas"); 
			var o:Object = delegateCreateNewPlay.call();
			if (!(o is IPlayInstance)) throw Error("delegateCreateNewPlay needs to return an IPlayInstance object");
		}
		
		private function onStatsClicked(e:MouseEvent):void 
		{
			var scr:StatsScreen = new StatsScreen();
			scr.valendoMC.stop();
			scr.closeButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { ai.container.closeScreen(scr) } );
			ai.container.createScreen(scr);
			ai.container.infoBar.info = "tela de estatísticas!"
			
			scr.nNaoValendo.text = numTrialsByMode(AIConstants.PLAYMODE_FREEPLAY).toString()
			scr.nTotal.text = numTrials.toString();
			scr.scoreValendo.text = score.toString();
			scr.scoreTotal.text = scoreGeneralMean.toString();
		//public var nTotal : TextField;
		//public var nValendo : TextField;
		//public var scoreMin : TextField;
		//public var scoreTotal : TextField;
		//public var scoreValendo : TextField;
		//public var valendoMC : MovieClip;
		
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
		override public function evaluate():void
		{
			eventDispatcher.dispatchEvent(new EvaluatorEvent(EVALUATION_STARTED, this))
			playInstances.push(currentPlay);
			instancesDetails.push({playMode:this._playmode})
			eventDispatcher.dispatchEvent(new EvaluatorEvent(EVALUATION_FINISHED, this))
		}
		
		/* INTERFACE cepa.ai.IEvaluation */
		
		override public function getData():Object 
		{
			var obj:Object = this.getPlayInstancesData();
			obj.playinstancesdetails = new Object();

			for (var i:int = 0; i < playInstances.length; i++) {
				obj.playinstancesdetails[String(i)] = instancesDetails[i];
			}
			return obj;
		}

		
		override public function readData(obj:Object):void
		{
			this.instancesDetails = new Vector.<Object>();		
			try {
				var len:int = obj.length;
				for (var i:int = 0; i < len; i++) {
					instancesDetails.push(obj.playinstancesdetails[i.toString()]);
				}				
			} catch (e:Error) {
				
			}
			
		}

		
		/* INTERFACE cepa.ai.IEvaluation */
		
		public function get score():Number 
		{
			var s:Number = 0;
			return participationScore + scoreValidMean/2;
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