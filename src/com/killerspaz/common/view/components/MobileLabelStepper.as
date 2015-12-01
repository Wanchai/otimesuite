/**
 * MobileLabelStepper.as
 * John Gorena
 * www.killerspaz.com
 * version 1.0
 *
 * This class extends the base MobileNumericStepper to allow for label replacements 
 *  for their number counterparts.
 * 
 * As an example, the month of the year can be represented as 0-11, but that's
 *  not as friendly as Jan-Dec. 
 *
 * Copyright (c) 2011 John Gorena
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.killerspaz.common.view.components
{
	public class MobileLabelStepper extends MobileNumericStepper
	{
		public static const TYPE_AM_PM:String			= 'ampm';
		public static const TYPE_MONTH:String			= 'month';
		public static const TYPE_DAY:String				= 'day';
		public static const TYPE_DAY_OF_WEEK:String		= 'dayOfWeek';
		public static const TYPE_YEAR:String			= 'year';
		public static const TYPE_24HOUR:String			= '24hour';
		public static const TYPE_12HOUR:String			= '12hour';
		public static const TYPE_MIN:String				= 'min';
		public static const TYPE_SEC:String				= 'sec';
		
		private static const labels_ampm:Object 		= { 0: 'AM', 1: 'PM' };
		
		private static const labels_months:Object 		= {
			0: 'Jan', 1: 'Feb', 2: 'Mar', 3: 'Apr', 4: 'May', 5: 'Jun',
			6: 'Jul', 7: 'Aug', 8: 'Sep', 9: 'Oct', 10: 'Nov', 11: 'Dec'
		};
		
		private static const labels_day_of_week:Object 	= {
			0: 'Sun', 1: 'Mon', 2: 'Tue', 3: 'Wed', 4: 'Thu', 5: 'Fri', 6: 'Sat'
		};
		
		/**
		 * Basic object that hashes it's index on the displayType to an object/array/dictionary keyed to represent 
		 * automatic bounds.
		 * 
		 * Check out the AM/PM and Month implementations
		 */ 
		public static var BOUNDS_MAP:Object				= {};
		BOUNDS_MAP[MobileLabelStepper.TYPE_AM_PM] 		= [0, 1];
		BOUNDS_MAP[MobileLabelStepper.TYPE_MONTH] 		= [0, 11];
		BOUNDS_MAP[MobileLabelStepper.TYPE_DAY] 		= [1, 31];
		BOUNDS_MAP[MobileLabelStepper.TYPE_DAY_OF_WEEK]	= [0, 6];
		BOUNDS_MAP[MobileLabelStepper.TYPE_24HOUR] 		= [0, 23];
		BOUNDS_MAP[MobileLabelStepper.TYPE_12HOUR] 		= [1, 12];
		BOUNDS_MAP[MobileLabelStepper.TYPE_MIN] 		= [0, 59];
		BOUNDS_MAP[MobileLabelStepper.TYPE_SEC] 		= [0, 59];
		BOUNDS_MAP[MobileLabelStepper.TYPE_YEAR] 		= [1900,	new Date().getFullYear()];

		/**
		 * Basic object that hashes it's index on the displayType to an object/array/dictionary keyed to represent 
		 * label replacements.
		 * 
		 * Check out the AM/PM and Month implementations
		 */ 
		public static var LABEL_MAP:Object				= {};
		//Set some default mappings...
		LABEL_MAP[MobileLabelStepper.TYPE_AM_PM] 		= labels_ampm;
		LABEL_MAP[MobileLabelStepper.TYPE_MONTH] 		= labels_months;
		LABEL_MAP[MobileLabelStepper.TYPE_DAY_OF_WEEK]	= labels_day_of_week;
		
		protected var _changedMinMax:Boolean 			= false;
		protected var _displayType:String				= TYPE_MONTH;
		
		public function get displayValue():String
		{
			var hasLabelReplacement:Boolean = LABEL_MAP.hasOwnProperty(this._displayType);
			
			return (hasLabelReplacement) ? LABEL_MAP[this._displayType][this._currVal] : this._currVal.toString();
		}
		
		/**
		 * Sets the displayType of the Stepper. 
		 * BOUNDS_MAP and LABEL_MAP key off this value.
		 */
		public function get displayType():String			{ return this._displayType; }
		public function set displayType(val:String):void
		{
			if (val === this._displayType) {
				return;
			}
			
			this._displayType 		= val;
			
			this.invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			//Keep track if min/max has ever been changed. This || will always stay true once it turns true.
			this._changedMinMax = this._changedMinMax || this._maxMinChanged;
			
			super.commitProperties();
			
			//If not overridden, consider auto min/max overrides
			if (false === this._changedMinMax) {
				//Update MIN/MAX for display type
				this.min = BOUNDS_MAP[this._displayType][0];
				this.max = BOUNDS_MAP[this._displayType][1];
			}
			
			//Update Display with displayValue
			if (null !== this.txtNum) { 
				this.txtNum.editable	= false;
				this.txtNum.text     	= this.displayValue;
			}
		}
	}
}