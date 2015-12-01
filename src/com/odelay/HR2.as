package com.odelay {
	import mx.graphics.SolidColor;
	import spark.components.VGroup;
	import spark.primitives.Rect;
	/**
	 * ...
	 * @author Tmhk
	 */
	public class HR2 extends VGroup{
		
		private var rec1:Rect = new Rect();
		private var rec2:Rect = new Rect();
		
		public function HR2() {
			percentWidth = 90;
			gap = 0;
			
			rec1.fill = new SolidColor(0x130b09);
			rec1.alpha = 0.5;
			rec1.height = 1;
			rec1.percentWidth = 100;
			
			rec2.fill = new SolidColor(0x7c6a54);
			rec2.alpha = 0.5;
			rec2.height = 1;
			rec2.percentWidth = 100;
			
			addElement(rec1);
			addElement(rec2);
		}
		
	}

}