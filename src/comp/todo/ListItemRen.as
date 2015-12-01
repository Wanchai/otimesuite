package comp.todo {
	/**
	 * ...
	 * @author ThomasOdelay www.agence-odelay.com
	 */
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;
	import mx.states.State;
	import skins.*;
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.supportClasses.ItemRenderer;
	import spark.primitives.BitmapImage;
	import comp.todo.ListBody;
	
	public class ListItemRen extends ItemRenderer implements IDataRenderer {
		
		public var nameLabel:Label = new Label();
		public var check:CheckBox = new CheckBox ();
		public var fond:BitmapImage = new BitmapImage();
		
		[Embed(source = '../../skins/assets/todo/Todo3_05.png')]
		private var img:Class;
		
		[Embed(source = '../../skins/assets/todo/Todo3_03.png')]
		private var img2:Class;
		
		public function ListItemRen() {
			percentWidth = 100;
			
			nameLabel.top = 12;
			nameLabel.left = 60;
			nameLabel.percentWidth = 80;
			nameLabel.setStyle("fontFamily", "ding");
			nameLabel.setStyle("fontSize", 25);
			nameLabel.setStyle("paddingLeft", 6);
			//
			addEventListener(FlexEvent.DATA_CHANGE, dataChangeHand);
			
			check.left = 25;
			check.top = 15;
			check.setStyle("skinClass", CheckBoxSkin);
			
			addEventListener(MouseEvent.CLICK, checkTxt)
			// Keep checked after scroll
			addEventListener("updateComplete", evFoo)
			
			var hb1:Group = new Group();
			hb1.percentWidth = 100;
			
			addElement(hb1);
			hb1.addElement(fond);
			hb1.addElement(check);
			hb1.addElement(nameLabel);
			
			//isChecked();
		}
		
		private function isChecked():void {
			if (this.selected) {
				check.selected = true ;
			}else {
				check.selected = false ;
			}
		}
		private function evFoo(e:Event):void {
			isChecked();
		}
		
		private function checkTxt(e:MouseEvent):void {
			isChecked();
			if (this.selected) {
				ListBody(owner.parent).db.reqArr = "UPDATE tasks SET complete=1 WHERE id=" + data.id;
			}else {
				check.selected = false ;
				//if (data != null)
				ListBody(owner.parent).db.reqArr = "UPDATE tasks SET complete=0 WHERE id=" + data.id;
			}
		}
		private function dataChangeHand(e:Event):void {
			if (data != null) {
				nameLabel.text = data.name;
				if(this.itemIndex == 0) fond.source = img2;
				else fond.source = img;
				
				if (data.complete == 1) {
					//CheckList(owner).selectedIndex = itemIndex;
					CheckList(owner).selectedIndices.push(itemIndex);
					//trace("CheckList(owner).selectedItems : " + CheckList(owner).selectedItems);
				}
			}
		}
	}
}