package comp.todo {
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
	
	import flash.events.MouseEvent;
    import mx.core.IVisualElement;
    import spark.components.List;

	public class CheckList extends List {
		
        public function CheckList(){
            super();
            allowMultipleSelection = true;
        }

        /**
         * Override the mouseDown handler to act as though the Ctrl key is always down
         */
        override protected function item_mouseDownHandler(event:MouseEvent):void {
            var newIndex:Number = dataGroup.getElementIndex(event.currentTarget as IVisualElement);

            // always assume the Ctrl key is pressed by setting the third parameter of
            // calculateSelectedIndices() to true
            selectedIndices = calculateSelectedIndices(newIndex, event.shiftKey, true);
        }
    }

}