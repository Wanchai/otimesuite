package comp {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import skins.btn.*;
	import spark.components.Button;
	import spark.components.VGroup;
	
	/**
	 * ...
	 * @author Tmhk
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	public class ActionMenu extends VGroup {
		
		private var eventObj:Event = new Event("change");
		public var targ:String;
		
		public function ActionMenu() {
			percentHeight = 100;
			percentWidth = 20;
			top = 0;
			addButton("timer");
			addButton("chrono");
			addButton("todo");
			addButton("options");
		}
		

		private function addButton(str:String):void{
			var bt1:Button = new Button();
			bt1.name = str;
			switch (str) {
				case "timer" :
					bt1.setStyle("skinClass", TimerBtnSkin);
				break;
				case "chrono" :
					bt1.setStyle("skinClass", ChronoBtnSkin);
				break;
				case "todo" :
					bt1.setStyle("skinClass", TodoBtnSkin);
				break;
				case "options" :
					bt1.setStyle("skinClass", OptionsBtnSkin);
				break;
				default:
				break;
			}
			
			bt1.addEventListener(MouseEvent.CLICK, changeHand);
			addElement(bt1);
		}
		
		private function changeHand(e:Event):void {
			targ = e.currentTarget.name;
			dispatchEvent(eventObj);
		}
	}
}