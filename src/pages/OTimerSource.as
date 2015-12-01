/*import flash.media.Sound;
import flash.media.SoundChannel;
import flash.events.*;
import flash.utils.Timer;
import flash.net.*;
import flash.display.*;
import flash.text.*;
import mx.core.IVisualElement;
import mx.events.*;
import mx.controls.Alert;
import spark.components.Button;*/

import mx.managers.PopUpManager;
import comp.timer.*;
import com.odelay.*;
import com.odelay.supportclasses.AlertEvent;
import skins.AlertSkin;
import skins.AlertSkin2;

[Embed(source = "../../lib/11015.mp3")]
[Bindable]
public var sndCls:Class;
	
public var db:SqlConnect;

private var remain:int;
private var myTimer:Timer = new Timer(1000, 0);
private var mySound:Sound = new sndCls() as Sound;
private var channel:SoundChannel = new SoundChannel();
private var titl:PresetTitleWindow;
private var obj:Object;

public function init():void {
	db = new SqlConnect("OTime.db");
	db.addEventListener("ready", getPresets);
	db.addEventListener("requestResult", showPresets);
	db.addEventListener("insertResult", displayAddedPresetBtn);
	//
	ddg.addEventListener("emptyList", emptyListHand);
	ddg.addEventListener("firstRemoved", removeCurrent);
	timeBox.addEventListener("timeAdded", timeAddedHand);
}
private function timeAddedHand(e:Event):void {
	ddg.dataProvider.addItem(timeBox.newData);
	startTimer();
	timeBox.empty();
}
// Preset page
public function addPreset():void {
	titl = PresetTitleWindow(PopUpManager.createPopUp(this, PresetTitleWindow , true)) ;
	titl.timeBox2.addEventListener("timeAdded", presetAddHand);
	titl.y = this.stage.stageHeight/2 - titl.height/2;
}
private function presetAddHand(e:Event):void {
	obj = e.currentTarget.newData;
	var myPattern:RegExp = /"/g;
	db.reqArr = "INSERT INTO presets (texte, num, time) VALUES (\"" + obj.texte.replace(myPattern, "'") + "\", " + obj.num + ", '" + obj.time + "')";
	titl.removeEventListener("close", closeHandler);
	titl.timeBox2.removeEventListener("timeAdded", presetAddHand);
	PopUpManager.removePopUp(titl);
	e.currentTarget.empty();
}
private function displayAddedPresetBtn(e:Event):void {
	obj.id = db.lastID;
	addPresetButton(obj);
	obj = { };
}
private function presetClickHand(e:Event):void {
	ddg.dataProvider.addItem(e.currentTarget.data);
	startTimer();
	goLeft.play();
}
private function closeHandler(event:Event):void {
	event.target.removeEventListener("close", closeHandler);
	titl.timeBox2.removeEventListener("timeAdded", presetAddHand);
	PopUpManager.removePopUp(event.target as PresetTitleWindow);
}
private function showPresets(e:Event):void {
	for each (var item:Object in db.rezArr) {
		addPresetButton(item);
	}
}
private function getPresets(e:Event):void {
	db.reqArr = "SELECT * FROM presets";
}
private function addPresetButton(data:Object):void {
	var btn:PresetButton = new PresetButton();
	btn.lab1.text = (data.texte) ? data.texte : "";
	btn.lab2.text = "" + Utils.calculDisplayTime(data.num);
	btn.data = data;
	btn.y = 56 * presetCont.numElements;
	
	btn.addEventListener("playPreset", presetClickHand);
	btn.addEventListener("delPreset", dropMe);
	
	presetCont.addElement(btn);
}
private function flushPresets():void {
	presetCont.removeAllElements();
}
private var delPresBtn:PresetButton = null;
private function dropMe(e:Event):void {
	delPresBtn = (e.currentTarget as PresetButton)
	SkinnableAlert.show("Delete this preset?", 2, scr2, closeHand2, AlertSkin2);
}
private function closeHand2(e:AlertEvent):void {
	if (e.result == 1) {
		db.reqArr = "DELETE FROM presets WHERE id="+ delPresBtn.data.id ;
		presetCont.removeElement(delPresBtn);
		flushPresets();
		getPresets(new Event(""));
		delPresBtn = null;
	}
}
// Front page
private function removeCurrent(e:Event):void {
	myTimer.stop();
	remain = 0;
	timer.text = "00m00s";
	startTimer();
}
private function emptyListHand(e:Event):void {
	myTimer.stop();
	remain = 0;
	timer.text = "00m00s";
}
public function startTimer():void {
	if (remain == 0 && ddg.dataProvider.length > 0) {
		remain = ddg.dataProvider.getItemAt(0).num;
		timer.text = Utils.calculDisplayTime(remain) ;
		myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
		myTimer.stop();
		myTimer.start();
	}
}
private function timerHandler(e:Event):void {
	remain --;
	timer.text = Utils.calculDisplayTime(remain) ;
	if (remain == 0) {
		myTimer.stop();
		itsOver();
	}
}
private function pauseTimer(e:Event):void {
	if (remain > 0) {
		if (pauseBtn.selected) {
			myTimer.stop();
			pauseBtn.label = "Continue";
		}else {
			myTimer.start();
			pauseBtn.label = "Pause";
		}
	}else {
		pauseBtn.selected = false;
		pauseBtn.label = "Pause";
	}
}
// --- ALARM
private function itsOver():void {
	ddg.dataProvider.removeItemAt(0);
	playSound();
}
private function playSound():void {
	SkinnableAlert.show("Time's up!", 1, scr1, closeHand, AlertSkin);
	channel = mySound.play();
}
private function closeHand(e:AlertEvent):void{
	channel.stop();
	startTimer();
}