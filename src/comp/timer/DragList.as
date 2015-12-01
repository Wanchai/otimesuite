package comp.timer {
	/**
	 * ...
	 * @author ThomasOdelay www.agence-odelay.com
	 */
	
	[Event(name = "emptyList", type = "flash.events.Event")]
	[Event(name = "firstRemoved", type = "flash.events.Event")]
	
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import spark.components.List;
	
	public class DragList extends List{
		
		public function DragList(){
			dragEnabled = true;
			dropEnabled = true;
			dragMoveEnabled = true;
			allowMultipleSelection = false;
			
			itemRendererFunction = customItemRendererFunction;
			percentWidth = 95;
			
			setStyle("contentBackgroundAlpha", 0);
			setStyle("borderAlpha", 0);
			
			dataProvider = new ArrayList();
		}
		public function customItemRendererFunction(item:*):IFactory {
			return new ClassFactory(DragListItemRen);
		}
	}
}