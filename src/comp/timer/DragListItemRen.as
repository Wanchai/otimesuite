package comp.timer {
	/**
	 * ...
	 * @author ThomasOdelay www.agence-odelay.com
	 */
	
	import com.odelay.SkinnableAlert;
	import com.odelay.supportclasses.AlertEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;
	import skins.*;
	import skins.btn.DeleteItemTimerBtn;
	//import skins.ItemRendererSkin;
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.ItemRenderer;
	
	[States("normal", "selected")]
	
	public class DragListItemRen extends ItemRenderer implements IDataRenderer {
		
		public var nameLabel:Label = new Label();
		public var t:Label = new Label();
		public var supprBtn:Button = new Button();
		
		public function DragListItemRen() {
			height = 50;
			percentWidth = 100;
			autoDrawBackground = false;
			
			/* Lines */
			nameLabel.top = nameLabel.left = nameLabel.right = 5;
			nameLabel.percentWidth = 80;
			nameLabel.setStyle("fontFamily", "ding");
			nameLabel.setStyle("fontSize", 25);
			nameLabel.setStyle("paddingLeft", 6);
			//
			t.width = 162;
			t.setStyle("textAlign", "right");
			t.setStyle("fontFamily", "ding");
			t.setStyle("fontSize", 25);
			t.setStyle("paddingRight", 6);
			//
			supprBtn.width = 50;
			supprBtn.setStyle("skinClass", DeleteItemTimerBtn);
			supprBtn.right = 0;
			supprBtn.addEventListener(MouseEvent.CLICK, suppr);
			addEventListener(FlexEvent.DATA_CHANGE, dataChangeHand);
			
			var hb1:SkinnableContainer = new SkinnableContainer();
			hb1.percentWidth = 100;
			hb1.setStyle("skinClass", ItemRendererSkin);
			
			addElement(hb1);
			
			hb1.addElement(t);
			hb1.addElement(nameLabel);
			hb1.addElement(supprBtn);
		}
		private function dataChangeHand(e:Event):void {
			if (data != null) {
				nameLabel.text = data.texte;
				t.text = data.time;
			}
		}
		protected function suppr(evt:MouseEvent):void {
			SkinnableAlert.show("Are you sure you want to delete this item?\r" + data.time, 2, this, alrt_closeHandler, AlertSkin2);
		}
		
		protected function alrt_closeHandler(e:AlertEvent):void {
			switch (e.result) {
				case 1:
					Object(owner).dataProvider.removeItemAt(itemIndex);
					if (Object(owner).dataProvider.length == 0) Object(owner).dispatchEvent(new Event("emptyList"));
					else if (itemIndex == 0) Object(owner).dispatchEvent(new Event("firstRemoved"));
				case 2:
					Object(owner).selectedIndex = -1;
					break;
				default:
					break;
			}
		}
	}
}