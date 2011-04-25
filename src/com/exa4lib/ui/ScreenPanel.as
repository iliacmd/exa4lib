package com.exa4lib.ui{
	
	import flash.display.Shape;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class ScreenPanel extends UIComponent{
		
		private var background:Shape;
		private var _width:Number;
		private var widthChanged:Boolean;
		private var _height:Number;
		private var heightChanged:Boolean;
		
		public function ScreenPanel()
		{
			super();
			trace('construct');
			this.addEventListener(FlexEvent.CREATION_COMPLETE, hCreationComplete);
			this.addEventListener(FlexEvent.PREINITIALIZE, hPreInitialize);
		}
		
		[Bindable("widthChanged")]
		override public function get width():Number{
			return _width;
		}
		
		override public function set width(value:Number):void{
			_width = value;
			widthChanged = true;
			invalidateProperties();
			dispatchEvent( new Event('widthChanged') );
		}
		
		override protected function createChildren():void{
			super.createChildren();
			trace('children');
			background = new Shape;
			this.addChild( background );
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			trace(unscaledWidth);
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
			if(widthChanged){
				invalidateSize();
				invalidateDisplayList();
			}
			trace('commit');
		}
		
		override protected function measure():void{
			super.measure();
			trace('measure');
		}
		
		private function hCreationComplete(e:FlexEvent):void{
			trace('create complete');			
		}
		
		private function hPreInitialize(e:FlexEvent):void{
			trace('pre initialize');
		}
		
	}
}