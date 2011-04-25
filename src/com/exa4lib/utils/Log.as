package com.exa4lib.utils{
	import flash.text.TextField;

	public class Log{
		
		public static var outTrace:Boolean = true;
		public static var outputList:Array = new Array;	
		public static var logList:Array = new Array;
		
		public function Log()
		{
		}
		
		public static function addOutput(view:TextField):void{
			outputList.push(view);
			outLogList(view);
		}
		
		public static function outLogList(view:TextField):void{
			for each( var line:String in logList){
				view.appendText(line + "\n");
			}
		}
		
		public static function message(msg:String, from:Object=null):void{
			var message:String = getPath(from)+' : '+msg;
			logList.push(message);
			if(outputList.length){
				for each( var output:TextField in outputList ){
					output.appendText(message+"\n");
				}
			}			
			if(outTrace){
				trace( message );
			}
		}
		
		private static function getPath(from:Object):String{
			if(!from) return '';
			var path:String = from.toString().replace("[object ", "[");
			return  path;
		}
	}
}