package com.exa4lib.ui.window
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	public class SimpleWindow extends Sprite
	{
		protected var $content:DisplayObjectContainer;
		
		public function SimpleWindow()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, hAddedToStage);
		}
		
		private function draw():void{
			with(graphics){
				beginFill(0x000000);
				drawRect(0,0, 320, 240);
				endFill();
			}
		}
		
		private function hAddedToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, hAddedToStage);
			this.draw();
		}
	}
}