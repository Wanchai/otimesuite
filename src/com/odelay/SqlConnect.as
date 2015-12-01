package com.odelay{
	import flash.data.*;
	import flash.errors.*;
	import flash.events.*;
	import flash.filesystem.*;
	/**
	 * ...
	 * @author Tmhk
	 *
	 * Usage :
	 * public var db:SqlConnect;
	 * var db = new SqlConnect("FileName.db");
	 * db = new SqlConnect("OTime.db");
	 * db.addEventListener("ready", XXX);
	 * db.reqArr = "CREATE TABLE XXX";
	 */
	public class SqlConnect extends SQLConnection {
		
        private var sqlStmt:SQLStatement = new SQLStatement();
        private var _reqArr:Array = [];
        private var _rezArr:Array = [];
		
		// After INSERT, got the last ID
		public var lastID:Number = -1;
		
		public function SqlConnect(dbName:String) {
			addEventListener(SQLEvent.OPEN, openHandler);
			addEventListener(SQLUpdateEvent.INSERT, insertHandler);
			addEventListener(SQLErrorEvent.ERROR, errorHandler);
			
			openAsync(File.applicationStorageDirectory.resolvePath(dbName));
		}
		// Array where requests queue
		public function set reqArr(value:String):void {
			_reqArr.push(value);
			
			if (!sqlStmt.executing) {
				// In case of empty field
				if (_reqArr[0] == undefined) {
					_reqArr.shift();
				}
				sqlStmt.text = _reqArr.shift();
				sqlStmt.execute();
			}
		}
		private function reqResult(e:SQLEvent):void {
			var rez:SQLResult = sqlStmt.getResult();
			// Select request
			if (sqlStmt.text.search("SELECT") != -1) {
				_rezArr = rez.data;
				this.dispatchEvent(new Event("requestResult"));
			}
			// re launch the process if a request is waiting
			if (_reqArr.length > 0 && !sqlStmt.executing) {
				sqlStmt.text = _reqArr.shift();
				sqlStmt.execute();
			}
		}
		// Called after INSERT request
		private function insertHandler(e:SQLUpdateEvent):void {
			lastID = e.rowID;
			this.dispatchEvent(new Event("insertResult"));
		}
		// Opens the .db file
		private function openHandler(e:SQLEvent):void {
			sqlStmt.sqlConnection = this;
			sqlStmt.addEventListener(SQLEvent.RESULT, reqResult);
			sqlStmt.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			this.dispatchEvent(new Event("ready"));
		}
		private function errorHandler(e:SQLErrorEvent):void {
			trace("Error message:", e.error.message);
			trace("Details:", e.error.details);
			//this.dispatchEvent(new Event("errorSQL"));
		}
		// Contains SELECT result GET/SET
		public function get rezArr():Array { return _rezArr; }
		
		public function set rezArr(value:Array):void {
			_rezArr = value;
		}
	}
}