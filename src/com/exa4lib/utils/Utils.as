package com.exa4lib.utils
{
	public class Utils
	{
		public function Utils()
		{
		}
		
		public static function dumpObject(obj:Object, indent:uint=0):void{
			if(obj == null) return;
			var indentStr:String = '\t';
			if(!indent) trace('[Object]')
			for(var i:uint=0; i < indent; i++){
				indentStr += "\t";
			}
			for( var property:String in obj){
				if(typeof(obj[property]) == 'object'){
					trace(indentStr+' '+property+': [Object]');
					dumpObject(obj[property], indent+1)
				}else{
					trace(indentStr+' '+property+': '+obj[property]);
				}
			}
		}
	}
}