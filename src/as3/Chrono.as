package as3 {
	/**
	 * @author Thomas @ThomasOdelay www.agence-odelay.com
	 * @version 0.1
	 * ----------------------------------------------------------------------------
	 * "  LICENSE" (Revision 42):
	 * <thomas@agence-odelay.com> wrote this file. As long as you retain this notice you
	 * can do whatever you want with this stuff. If we meet some day, and you think
	 * this stuff is worth it, you can buy me a beer in return Thomas Malicet
	 * ----------------------------------------------------------------------------
	 */
	
	import com.odelay.SkinnableAlert;
	import com.odelay.SqlConnect;
	import com.odelay.supportclasses.AlertEvent;
	import com.odelay.Utils;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import skins.AlertSkin2;
	
	public class Chrono extends Timer {
		
		[Bindable]
		public var thisLap:String = "00:00:00.0";
		[Bindable]
		public var lap:int = 0;
		[Bindable]
		public var previous:String = "";
		[Bindable]
		public var previous2:String = "";
		[Bindable]
		public var startBtnLabelTxt:String = "Start";
		[Bindable]
		public var startBtnLabelSel:Boolean = false;
		[Bindable]
		public var total:String = "00:00:00.0";
		
		private var runUID:Number;
		
		public var db:SqlConnect;
		
		private var time:Number = 0;
		private var totalNum:Number = 0;
		private var runs:Array = [];
		private var runName:String = "";
		private var root:*;
		
		public function Chrono(foo:*) {
			super(100);
			setRunUID();
			addEventListener("timer", timerHandler);
			db = new SqlConnect("OTime.db");
			root = foo;
		}
		
		private function setRunUID():void{
			runUID = int(new Date().time / 1000);
			runName = new Date(runUID*1000).toLocaleString();
		}
		// Datas
		public function saveRuns ():void {
			if (currentCount > 0) SkinnableAlert.show("Save this session: " + runName, 2, root, save_closeHandler, AlertSkin2);
		}
		
		private function save_closeHandler(e:AlertEvent):void {
			if (e.result == 1) saveRunsHand();
		}
		private function saveRunsHand():void {
			addLap();
			for each (var item:Object in runs) {
				db.reqArr = "INSERT INTO runs (uid, name, lap, time) VALUES (" + item.uid + ", '" + item.name + "', " + item.lap + ", " + item.time + ")";
			}
			setRunUID();
			resetHand();
		}
		// Counting
        private function timerHandler(event:TimerEvent):void {
           time++;
		   totalNum++;
		   thisLap = Utils.calculDisplayTime(time, true);
		   total = Utils.calculDisplayTime(totalNum, true);
        }
		// Commands
		public function addLap():void {
			if (currentCount > 0) {
				lap++;
				previous2 = previous;
				previous = Utils.calculDisplayTime(time, true);
				runs.push( { uid:runUID, name:runName, lap: lap, time:time } );
				time = 0;
			}
		}
		public function launch(e:Event):void {
			if (e.target.selected) {
				startCount();
			}else {
				pauseCount();
			}
		}
		
		private function pauseCount():void{
			this.stop();
			startBtnLabelTxt = "Start";
			startBtnLabelSel = false;
		}
		
		private function startCount():void {
			// If first start
			if (currentCount == 0) setRunUID();
			this.start();
			startBtnLabelTxt = "Pause";
			startBtnLabelSel = true;
		}
		
		public function resetAll():void {
			if (currentCount > 0) SkinnableAlert.show("Are you sure you want to reset?", 2, root, alrt_closeHandler, AlertSkin2);
		}
		protected function alrt_closeHandler(e:AlertEvent):void {
			if (e.result == 1) resetHand();
		}
		private function resetHand():void {
			this.reset();
			time = totalNum = lap = 0;
			thisLap = total = "00:00:00.0"
			previous = previous2 = runName = "";
			pauseCount();
			runs = [];
		}
	}
}