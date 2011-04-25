package com.exa4lib.ui.shapes
{
	import flash.display.Sprite;
	
	public class Box extends Sprite
	{
		public function Box(color:uint=0x000000, alpha:Number=1, w:Number=100, h:Number=100)
		{
			super();
			with( this.graphics ){
				beginFill(color, alpha);
				drawRect(0,0, w, h);
				endFill();
			}
		}
	}
}