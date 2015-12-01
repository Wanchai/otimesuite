package com.odelay {
	/**
	 * ...
	 * @author ThomasOdelay www.agence-odelay.com
	 */
	public class Utils{
		
		public function Utils() {
			
		}
		public static function padTime(tim:Number):String{
			return (tim<10) ? "0"+tim : String(tim);
		}
		
		public static function print_a(obj:*, indent:String = null):String{
			if (indent == null) indent = "";
			var out:String = "";
			for (var item:String in obj) {
				if (typeof(obj[item]) == "object" ){
					out += indent+"[" + item + "] => Object\n";
				}else{
					out += indent+"[" + item + "] => " + obj[item]+"\n";
				}
				out += print_a(obj[item], indent+"   ");
			}
			return out;
		}
		
		public static function calculDisplayTime(sec:Number, cent:Boolean = false):String {
			var myDate1:Date;
			if (cent) {
				myDate1 = new Date(sec * 100);
				//trace("myDate1.toLocaleTimeString() : " + myDate1.toLocaleTimeString());
				//return padTime(myDate1.getUTCMinutes()) + "m" + padTime(myDate1.getUTCSeconds()) + "s" + int(myDate1.getUTCMilliseconds() / 100);
				return myDate1.toUTCString().substr(10, 8) + "." + int(myDate1.getUTCMilliseconds() / 100);
			} else {
				myDate1 = new Date(sec * 1000);
				
				if (myDate1.getUTCHours() > 0) {
					return myDate1.getUTCHours() + "h" + padTime(myDate1.getUTCMinutes()) + "m" + padTime(myDate1.getUTCSeconds()) +"s";
				}else {
					return padTime(myDate1.getUTCMinutes()) + "m" + padTime(myDate1.getUTCSeconds()) +"s";
				}
			}
		}
	}
}