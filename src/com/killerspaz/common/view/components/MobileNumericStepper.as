/**
 * MobileNumericStepper.as
 * John Gorena
 * www.killerspaz.com
 * version 1.0
 *
 * Numeric Stepper component to be used in a Mobile environment.
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
  import flash.events.Event;
  import flash.events.FocusEvent;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import flashx.textLayout.formats.TextAlign;
  
  import mx.events.DragEvent;
  
  import spark.components.Button;
  import spark.components.Group;
  import spark.components.TextInput;
  import spark.components.supportClasses.SkinnableComponent;
  import spark.layouts.HorizontalAlign;
  import spark.layouts.VerticalLayout;

  /**
   *  A styleName to describe the buttons within
   * 
   *  @default 140
   */
  [Style(name="buttonStyleName", type="String")]
  
  
  /**
   *  Dispatched when the value of the numeric stepper changes
   *
   *  @eventType flash.events.Event.CHANGE
   */
  [Event(type="flash.events.Event",name="change")]
  
  public class MobileNumericStepper extends SkinnableComponent
  {
    public var loopAtLimits:Boolean                   = true;
    
	[SkinPart(required="true")]
    public var btnDn:Button                           = null;
	[SkinPart(required="true")]
	public var btnUp:Button                          = null;
	[SkinPart(required="true")]
	public var txtNum:TextInput                      = null;

	protected var _currVal:int                        = 0;
    
    protected var _max:int                            = int.MAX_VALUE;
    protected var _min:int                            = 0;
    
    protected var _currValChanged:Boolean             = true; //update on creation
    protected var _maxMinChanged:Boolean              = false;
    protected var _buttonRotate:Boolean               = true;
    
    private var _stepTimer:Timer                      = null;
    private var _stepTimerInitialDelay:int            = 500;
    private var _stepTimerRunningDelay:int            = 100;
    private var _currDirection:int                    = 0;
    
    public function get min():int                     { return this._min; }
    public function get max():int                     { return this._max; }
    public function get value():int                   { return this._currVal; }
    public function get stepTimerInitialDelay():int   { return this._stepTimerInitialDelay; }
    public function get stepTimerRunningDelay():int   { return this._stepTimerRunningDelay; }
    public function get buttonRotate():Boolean		  { return this._buttonRotate; }
	
    /**
     * Defines the minimum value the stepper will allow
     */ 
    public function set min(val:int):void
    {
      this._min           = val;
      this._maxMinChanged = true;
      
      this.invalidateProperties();
    }
    
    /**
     * Defines the maximum value the stepper will allow
     */ 
    public function set max(val:int):void
    {
      this._max           = val;
      this._maxMinChanged = true;
      
      this.invalidateProperties();
    }
    
    /**
     * Defines the value of the MobileNumericStepper.
     */
    public function set value(val:int):void
    {
      this._stepValue(val - this._currVal);
    }
    
    /**
     * Defines the delay before starting repeating functionality
     */ 
    public function set stepTimerInitialDelay(val:int):void
    {
      this._stepTimerInitialDelay = val;
    }
    
    /**
     * Defines the delay during repeating functionality
     */ 
    public function set stepTimerRunningDelay(val:int):void
    {
      //Updates on next tick...
      this._stepTimerRunningDelay = val;
    }
	
	public function set buttonRotate(val:Boolean):void
	{
		this._buttonRotate = val;
		this.invalidateProperties();
	}
    
    public function MobileNumericStepper():void
    {
      super();
      
      this._currVal                               = this._min;
    }
    
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		switch (instance) {
			case this.btnUp:
				this.btnUp.addEventListener(MouseEvent.MOUSE_DOWN, this._onClickStepper, false, 0, true);
				this.btnUp.addEventListener(MouseEvent.MOUSE_UP,   this._onClickStepper, false, 0, true);
			break;
			case this.btnDn:
				this.btnDn.addEventListener(MouseEvent.MOUSE_DOWN, this._onClickStepper, false, 0, true);
				this.btnDn.addEventListener(MouseEvent.MOUSE_UP,   this._onClickStepper, false, 0, true);
			break;
			case this.txtNum:
			  	this.txtNum.addEventListener(Event.CHANGE,         this._onChangeNum,    false, 0, true);
			  	this.txtNum.addEventListener(FocusEvent.FOCUS_IN,  this._onFocus,    false, 0, true);
			break;
		}
	}
    
    override protected function commitProperties():void
    {
      super.commitProperties();

	  if (true === this._maxMinChanged) {
        this._maxMinChanged = false;
        this._stepValue(0, false); //re-eval boundaries without stepping anywhere...
      }
      
      if (true === this._currValChanged) {
        this._currValChanged  = false;
        this.txtNum.text     = this._currVal.toString();
        
        this.dispatchEvent(new Event(Event.CHANGE));
      }
	  
	  this.btnDn.rotation		= (this._buttonRotate) ? 180 : 0;
    }
    
    /**
     * Handler to determine which stepper was clicked...
     */ 
    protected function _onClickStepper(event:MouseEvent):void
    {
      if (MouseEvent.MOUSE_DOWN === event.type) {
        this._currDirection = (this.btnDn === event.target) ? -1 : 1;
        this._stepValue(this._currDirection);
        
        this._createTimer();
		
		this.btnUp.addEventListener(MouseEvent.MOUSE_OUT,  this._onFocus, 	false, 0, true);
		this.btnDn.addEventListener(MouseEvent.MOUSE_OUT,  this._onFocus, 	false, 0, true);
		
		//FIXME: Work on cancelling a drag when long pressing...
		this.stage.addEventListener(DragEvent.DRAG_START, this._onDrag, false, 0, true);
		this.stage.addEventListener(DragEvent.DRAG_START, this._onDrag, true, 0, true);
      } else {
		this._killTimer();
		this.stage.removeEventListener(DragEvent.DRAG_START, this._onDrag);
		
		this.btnUp.removeEventListener(MouseEvent.MOUSE_OUT,  this._onFocus);
		this.btnDn.removeEventListener(MouseEvent.MOUSE_OUT,  this._onFocus);
      }
    }
	
	protected function _createTimer():void
	{
		if (null !== this._stepTimer) {
			return;
		}
		
		this._stepTimer = new Timer(this._stepTimerInitialDelay);
		this._stepTimer.addEventListener(TimerEvent.TIMER, this._onTimer, false, 0, true);
		this._stepTimer.start();
	}
	
	protected function _killTimer():void
	{
		//HACK: If done JUUUUUST right, when clicking on an arrow and then clicking in the text field causes a weird
		//      moment in time where the timer is null, thus would cause an NPE here
		if (null === this._stepTimer) {
			return;
		}
		
		this._stepTimer.removeEventListener(TimerEvent.TIMER, this._onTimer);
		this._stepTimer.stop();
		this._stepTimer = null;
	}		
    
    private function _onTimer(event:TimerEvent):void
    {
      if (null === this._stepTimer) {
        return;
	  }
		
      this._stepTimer.delay = this._stepTimerRunningDelay;
      this._stepValue(this._currDirection);
    }
    
    /**
     * Handler for when a user changes the value manually.
     */ 
    protected function _onChangeNum(event:Event):void
    {
      //Don't eval on empty text!
      if ('' === this.txtNum.text) {
        return;
      }
      
      //Step the difference between what the user entered, and what our curr val is.
      this._stepValue(parseInt(this.txtNum.text) - this._currVal, false);
    }
    
    /**
     * Handler for when a user changes focus from the text field
     */ 
    protected function _onFocus(event:Event = null):void
    {
	  if (FocusEvent.FOCUS_IN === event.type) {
		  this.txtNum.addEventListener(FocusEvent.FOCUS_OUT, this._onFocus, false, 0, true);
		  return;
	  }
	  
	  this.btnUp.removeEventListener(MouseEvent.MOUSE_OUT,  this._onFocus);
	  this.btnDn.removeEventListener(MouseEvent.MOUSE_OUT,  this._onFocus);
	  this.txtNum.removeEventListener(FocusEvent.FOCUS_OUT, this._onFocus);
		
	  this._killTimer();
	  
      //Ensure the value is valid when the user changes focus from the text field.
      //Ex: User deletes all text, we no longer have a valid value.
      this._stepValue(0);
    }
    
    /**
     * Steps the value by <n> steps.
     * Will also do bounds checking, and autocorrect.
     */ 
    protected function _stepValue(steps:int, loopAround:Boolean = true):void
    {
      this._currVal += steps;
      
      if (this._currVal < this._min) {
        this._currVal = (loopAround && this.loopAtLimits) ? this._max : this._min;
      }
      
      if (this._currVal > this._max) {
        this._currVal = (loopAround && this.loopAtLimits) ? this._min : this._max;
      }
      
      this._currValChanged  = true;
      this.invalidateProperties();
    }
	
	protected function _onDrag(event:DragEvent):void
	{
		event.stopImmediatePropagation();
		event.preventDefault();
	}
    
  }
}