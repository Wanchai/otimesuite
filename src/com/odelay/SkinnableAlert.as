package com.odelay {
	import com.odelay.skins.AlertSkin;
	import com.odelay.supportclasses.AlertEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.TextArea;
	
	/**
	 * @author Thomas @ThomasOdelay www.agence-odelay.com
	 * @version 0.1
	 * ----------------------------------------------------------------------------
	 * "THE BEER-WARE LICENSE" (Revision 42):
	 * <thomas@agence-odelay.com> wrote this file. As long as you retain this notice you
	 * can do whatever you want with this stuff. If we meet some day, and you think
	 * this stuff is worth it, you can buy me a beer in return Thomas Malicet
	 * ----------------------------------------------------------------------------
	 */
	
	public class SkinnableAlert extends SkinnableComponent {
		
		private var _text:String = "";
		
		public static var labels:Array = ["Ok","",""];
		
		[SkinPart(required="true")]
		public var buttonOne:Button = null;
		
		[SkinPart(required="false")]
		public var buttonTwo:Button = null;
		
		[SkinPart(required="false")]
		public var buttonThree:Button = null;
		
		[SkinPart(required="false")]
		public var closeButton:Button = null;
		
		[SkinPart(required="true")]
		public var txt:TextArea = null;
		
		public function SkinnableAlert() {
			super();
			setStyle("skinClass", AlertSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			
			switch (instance) {
				case this.buttonOne:
					instance.label = labels[0];
					instance.addEventListener(MouseEvent.CLICK, yesHand, false, 0, true);
				break;
				case this.buttonTwo:
					instance.label = labels[1];
					instance.addEventListener(MouseEvent.CLICK, noHand, false, 0, true);
				break;
				case this.buttonThree:
					instance.label = labels[2];
					instance.addEventListener(MouseEvent.CLICK, cancelHand, false, 0, true);
				break;
				case this.closeButton:
					instance.addEventListener(MouseEvent.CLICK, closeHand, false, 0, true);
				break;
				case this.txt:
					instance.text = _text;
				break;
			}
		}
		
		private function yesHand(e:MouseEvent):void {
			dispatchEvent(new AlertEvent("result", 1));
			close();
		}
		private function noHand(e:MouseEvent):void {
			dispatchEvent(new AlertEvent("result", 2));
			close();
		}
		private function cancelHand(e:MouseEvent):void {
			dispatchEvent(new AlertEvent("result", 3));
			close();
		}
		
		private function closeHand(e:Event):void {
			dispatchEvent(new AlertEvent("result", 4));
			close();
		}
		
		private function close():void {
			PopUpManager.removePopUp(this);
		}
		private function btnClickHand(e:MouseEvent):void {
			trace("tast");
		}
		
		public function set text(value:String):void {
			_text = value;
		}
		
		public static function show(text:String = "", type:int = 1, parent:* = null, closeHandler:Function = null, skin:Class = null, label:Array = null):void {
			
			var alert:SkinnableAlert = new SkinnableAlert();
			alert.width = parent.screen.width;
			/*alert.x = parent.screen.width / 2 - alert.width / 2;
			alert.y = parent.screen.height / 2 - alert.height / 2;*/
			
			alert._text = text;
			
			if (label == null && type == 1) {
				labels = ["Ok"];
			}else if (label == null && type == 2) {
				labels = ["Yes", "No"];
			}else if (label == null && type == 3) {
				labels = ["Yes", "No", "Cancel"];
			}else {
				labels = label;
			}
			
			if (!parent) parent = Sprite(FlexGlobals.topLevelApplication);
			
			if (skin != null) alert.setStyle("skinClass", skin);
			
			if (closeHandler != null) alert.addEventListener(AlertEvent.RESULT, closeHandler);
			
			PopUpManager.addPopUp(alert, parent);
			
			alert.addEventListener(FlexEvent.CREATION_COMPLETE, completeHandler);
		}
		private static function completeHandler(event:FlexEvent):void {
			PopUpManager.centerPopUp(SkinnableAlert(event.target));
		}
	}
}