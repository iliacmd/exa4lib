package com.exa4lib.ui.accordion
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AccordionItem extends Sprite
	{
		public var openState:DisplayObject;
		public var overState:DisplayObject;
		public var closeState:DisplayObject;
		public var pending:Boolean = false;
		
		protected var $container:Sprite;
		protected var $mask:Shape;
		protected var $openHeight:Number = 100;
		protected var $currentState:DisplayObject;
		
		public var index:uint = 0;
		public var moveX:Number;
		public var moveY:Number;
		
		public function AccordionItem(openState:DisplayObject, overState:DisplayObject, closeState:DisplayObject, content:DisplayObjectContainer=null)
		{
			super();
			
			$container = new Sprite;
			$mask = new Shape;
			$container.addChild( $mask );
			this.drawMask();
			this.addChild( $container );
			
			this.openState = openState;
			this.overState = overState;
			this.closeState = closeState;
			this.openState.visible = this.overState.visible = this.closeState.visible = false;
			
			this.addChild( this.openState );
			this.addChild( this.overState );
			this.addChild( this.closeState );
			
			this.closeState.visible = true;
			$currentState = closeState;
			
			$container.y = this.closeState.height;
			$container.mask = $mask;
			$mask.width = this.closeState.width;
			$mask.height = 0;
			
			if(content) $container.addChild( content );
		}
		
		override public function get height():Number{
			return $currentState.height;
		} 
		
		public function get heightContainer():Number{
			return $container.mask.height;
		} 		
		
		public function get heightOpen():Number{
			return $openHeight;
		}
		
		public function open():void{
			$currentState = openState;	
			this.openState.visible = true;
			this.closeState.visible = false;
			pending = true;
			TweenLite.to($container.mask, 1, {height: $openHeight, onComplete: function():void{ pending=false } });
			dispatchEvent( new Event('open_item', true) );
		}
		
		public function close():void{
			$currentState = closeState;	
			this.closeState.visible = true;
			this.openState.visible = false;
			pending = true;
			TweenLite.to($container.mask, 1, {height: 0,  onComplete: function():void{ pending=false } });
			dispatchEvent( new Event('close_item', true) );
		}
		
		public function isOpen():Boolean{
			return ($currentState == openState)
		}
		
		protected function drawMask():void{
			with($mask.graphics){
				clear();
				beginFill(0x00ff00, 1);
				drawRect(0,0,1,1);
				endFill();
			}
		}
		
		protected function drawContainer():void{
			with($container.graphics){
				clear();
				beginFill(0x000000, 1);
				drawRect(0,0,1,1);
				endFill();
			}
		}
		
		
	}
}