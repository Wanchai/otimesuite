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
	
	import com.odelay.SqlConnect;
	import com.odelay.supportclasses.AlertEvent;
	import com.odelay.Utils;
	import flash.events.Event;
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayList;
		
	public class ChronoGraph {
		
		[Bindable]
		public var dataList:ArrayList = new ArrayList();
		
		public var dataGraph:ArrayList = new ArrayList([]);
		public var series:Array = [];
		
		private var uid:int = 0;
		private var db:SqlConnect;
		
		public function ChronoGraph() {
			db = new SqlConnect("OTime.db");
			db.addEventListener("ready", getSessions);
			db.addEventListener("requestResult", showSessions);
		}
		public function getSessions (e:Event):void {
			db.reqArr = "SELECT * FROM runs";
			dataList = new ArrayList();
		}
		private function showSessions(e:Event):void {
			
			for each (var item:Object in db.rezArr) {
				if (item.lap == 1) {
					dataList.addItem( { data: item.uid, label : item.name } );
				}
			}
		}
		public function changeDDL(e:Event):void {
			uid = e.currentTarget.selectedItem.data;
			for each (var item:Object in db.rezArr) {
				if (uid == item.uid) {
					if (dataGraph.source[item.lap - 1] == undefined) dataGraph.source[item.lap - 1] = { };
					dataGraph.source[item.lap - 1].lap = item.lap;
					dataGraph.source[item.lap - 1]["run" + item.uid] = item.time;
				}
			}
			
			var ls:LineSeries = new LineSeries();
			ls.yField = "run" + uid;
			ls.setStyle("form", "segment");
			series.push(ls);
			
			dispatchEvent(new Event("addLine"));
		}
		public function resetGraph():void {
			dataGraph.source = [];
			series = [new LineSeries()];
			dispatchEvent(new Event("addLine"));
		}
		public function alrt_closeHandler(e:AlertEvent):void {
			if (e.result == 1) deleteSess();
		}
		
		private function deleteSess():void{
			db.reqArr = "DELETE FROM runs WHERE uid=" + uid ;
			getSessions(new Event("nul"));
		}
	}
}