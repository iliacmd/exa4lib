package com.exa4lib.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLLoader extends EventDispatcher
	{
		private var loader:URLLoader;
		private var resultCallback:Function;
		public function XMLLoader( req:URLRequest, reusltHandler:Function )
		{
			super(null);
			this.resultCallback = reusltHandler;
			loader = new URLLoader ( req );
			loader.addEventListener(Event.COMPLETE, hComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, hIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, hSecurityError);
		}
		
		private function hComplete(e:Event):void{
			var data:String = loader.data;
			var xml:XML = null;
			if(!data){ 
				trace('[XMLLoader]: Recive empty data');
				return;
			}
			try{
				xml = new XML(data);
			}catch(e:Error){
				trace('[XMLLoader]: Error parse XML('+e.message+')');
			}				
			resultCallback.call(this, xml);	
		}
		private function hIOError(e:IOErrorEvent):void{
			trace('[XMLLoader]: IOError('+e.text+')');
		}
		private function hSecurityError(e:SecurityErrorEvent):void{
			trace('[XMLLoader]: SecurityError('+e.text+')');
		}		
	}
}