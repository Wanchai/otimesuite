package com.odelay.supportclasses {
	import flash.events.Event;
	/**
	 * ...
	 * @author Thomas @ThomasOdelay www.agence-odelay.com
	 */
	public class AlertEvent extends Event {
		
		public var result:int = 0;
		
		public static const RESULT:String = "result";
		
		public function AlertEvent(type:String, result:int){
			super(type);
			
			this.result = result;
		}
		override public function clone():Event {
            return new AlertEvent(type, result);
        }

	}

}