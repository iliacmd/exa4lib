package com.exa4lib.ui.scroller
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.EndVectorPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.effects.Tween;
	
	public class ScrollPlace extends Sprite
	{
		public static const ScrollBarAUTO:String = 'ScrollBarAUTO';
		public static const ScrollBarON:String   = 'ScrollBarON';
		public static const ScrollBarOFF:String  = 'ScrollBarOFF';
		
		protected var $holder:DisplayObjectContainer;
		protected var $place:Sprite;
		protected var $scrollTrack:Sprite;
		protected var $scrollThumb:Sprite;
		protected var $scrollPositionVPercent:Number;
		protected var $holderHeight:Number;
		protected var $maxScrollV:Number;
		protected var $placeWidth:Number = 100;
		protected var $placeHeight:Number = 100;
		protected var $scrollBarWidth:Number = 2;
		protected var $scrollTrackAlpha:Number = 1; 
		protected var $scrollTrackColor:uint = 0xefefef; 
		protected var $scrollThumbAlpha:Number = 1; 		
		protected var $scrollThumbColor:uint = 0xcccccc; 
		protected var $scrollThumbSize:Number = 30; 
		protected var $backgroundAlpha:Number = 1; 		
		protected var $backgroundColor:uint = 0xffffff; 
		protected var $scrollBarPadding:Number = 0;
		protected var $verticalScrollBarPolicy:String;
		protected var $propertyChanged:Boolean = false;
		
		
		public var draging:Boolean = false;
		public var speedScroll:Number = 20;
		
		/**
		 * var content:Sprite = new Sprite();
		 * var place:ScrollPlace = new ScrollPlace(content);
		 * 
		 **/
		
		public function ScrollPlace(source:Sprite)
		{
			
			$place = new Sprite;

			this.addChild($place);
			
			this.createScrollBar();
			this.updateScrollBar();
			
			vScrollBarPolicy = ScrollBarAUTO;
			
			this.addEventListener(Event.ENTER_FRAME, hEnterFrame);
			this.addEventListener(Event.ADDED_TO_STAGE, hAddedToStage);
			
			this.source = source; 

		}
		
		override public function set width(w:Number):void{
			$placeWidth = w;
			$propertyChanged = true;
			updateScrollBarPolicy();	
		}
		
		override public function set height(h:Number):void{
			$placeHeight = h;
			$propertyChanged = true;	
			updateScrollBarPolicy();			
		}		
		
		public function setStyle(styleName:String, value:*):void{
			$propertyChanged = true;
			this['$'+styleName] = value;
		}
		
		public function set vScrollBarPolicy(pollicy:String):void{
			$verticalScrollBarPolicy = pollicy;
		}
		
		public function set source(src:DisplayObjectContainer):void{
			if(!src) return;
			if($place.numChildren > 0){
				this.removeEventListener(MouseEvent.MOUSE_WHEEL, hHolderMouseWheel);
				$place.removeChildAt(0);
			} 
			$holder = src;
			$holderHeight = $holder.height;
			updateScrollBarPolicy();
			this.addEventListener(MouseEvent.MOUSE_WHEEL, hHolderMouseWheel);
			$maxScrollV = ($holder.height > $placeHeight)?$holder.height-$placeHeight:0;
			$place.addChild( $holder );
			//$holder.addEventListener(Event.ADDED, hAddedToHolder);			
			$scrollThumb.y = 0;
			$holder.y = 0;			
		}
		
		private function hAddedToHolder(e:Event):void{
			this.$propertyChanged = true;	
		}
		
		protected function hEnterFrame(e:Event):void{
			if($holderHeight != $holder.height){
				$holderHeight = $holder.height;
				$maxScrollV = ($holder.height > $placeHeight)?$holder.height-$placeHeight:0;
				updateScrollBarPolicy();
				$scrollThumb.y = 0;
				$holder.y = 0;
			}
			if(draging){
				this.scroll();
			}				
			this.update();
		}
		
		protected function createScrollBar():void{
			$scrollTrack = new Sprite;
			with($scrollTrack.graphics){
				clear();
				lineStyle();
				beginFill($scrollTrackColor, $scrollTrackAlpha);
				drawRect(0,0,$scrollBarWidth,1);
				endFill();
			}
			this.addChild($scrollTrack);
			$scrollThumb = new Sprite;
			with($scrollThumb.graphics){
				clear();
				lineStyle();
				beginFill($scrollThumbColor, $scrollThumbAlpha);
				drawRect(0,0,$scrollBarWidth,1);
			}
			$scrollThumb.addEventListener(MouseEvent.MOUSE_DOWN, hThumbMouseDown);
			//$scrollThumb.addEventListener(MouseEvent.MOUSE_UP, hThumbMouseUp);
			//$scrollTrack.addEventListener(MouseEvent.MOUSE_UP, hThumbMouseUp);
			//$scrollTrack.addEventListener(MouseEvent.MOUSE_OUT, hThumbMouseUp);
			this.addChild($scrollThumb);
		}
		
		protected function hAddedToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, hAddedToStage);
			stage.addEventListener(MouseEvent.MOUSE_UP, hThumbMouseUp);	
		}
		
		protected function hThumbMouseDown(e:MouseEvent):void{	
			var bounds:Rectangle = new Rectangle($place.x+$place.scrollRect.width+$scrollBarPadding, $place.y, 0, $place.scrollRect.height-$scrollThumb.height)
			$scrollThumb.startDrag(false, bounds );
			draging = true;
		}
		
		protected function hThumbMouseUp(e:MouseEvent):void{
			if(draging){
				$scrollThumb.stopDrag();
				draging = false;
			}
		}		
		
		protected function  hHolderMouseWheel(e:MouseEvent):void{
			if(e.delta < 0){
				this.scroll(speedScroll);
			}else{
				this.scroll(-speedScroll);
			}
		}
		
		protected function scroll(value:Number=0):void{
			$scrollThumb.y += value;
			if($scrollThumb.y < 0) $scrollThumb.y = 0;
			if($scrollThumb.y >= $scrollTrack.height-$scrollThumb.height)
			$scrollThumb.y = $scrollTrack.height-$scrollThumb.height;
			
			$scrollPositionVPercent = Math.round( (($scrollThumb.y)/($scrollTrack.height-$scrollThumb.height)) * 100 );
			TweenLite.to($holder, 1, {y: -($maxScrollV*$scrollPositionVPercent)/100 });
		}
		
		protected function updateScrollBar():void{
			
			if($propertyChanged){
				with($scrollTrack.graphics){
					clear();
					lineStyle();
					beginFill($scrollTrackColor, $scrollTrackAlpha);
					drawRect(0,0,$scrollBarWidth,1);
					endFill();
				}				
				with($scrollThumb.graphics){
					clear();
					lineStyle();
					beginFill($scrollThumbColor, $scrollThumbAlpha);
					drawRect(0,0,$scrollBarWidth, $scrollThumbSize);
				}
				
				$scrollTrack.x = $scrollThumb.x = $placeWidth+$scrollBarPadding;
				$scrollTrack.height = $placeHeight;
				$scrollThumb.height = $scrollThumbSize;

				$scrollTrack.width = $scrollBarWidth;
				$scrollThumb.width = $scrollBarWidth;
			}			
		}
		
		protected function updatePlace():void{			
			if( $propertyChanged ){
				with($place.graphics){
					clear();
					lineStyle();
					beginFill( $backgroundColor,  $backgroundAlpha );
					drawRect(0,0, $placeWidth, $placeHeight);
				}
				$place.scrollRect = new Rectangle(0,0, $placeWidth, $placeHeight);	
				$maxScrollV = ($holder.height > $placeHeight)?$holder.height-$placeHeight:0;					
			}		
		}		
		
		private function update():void{
			updateScrollBar();
			updatePlace();
			
			if($propertyChanged){
				$propertyChanged = false;
			}	
			
		}

		protected function updateScrollBarPolicy():void{
			switch($verticalScrollBarPolicy){
				case ScrollBarAUTO:
					if($holderHeight > $placeHeight){
						$scrollThumb.visible = true;
						$scrollTrack.visible = true;
					}else{
						$scrollThumb.visible = false;
						$scrollTrack.visible = false;
					}
					break;
				case ScrollBarON: 
					$scrollThumb.visible = true;
					$scrollTrack.visible = true;
					break;
				case ScrollBarOFF:
					$scrollThumb.visible = false;
					$scrollTrack.visible = false;
					break
			}
		}
		
	}
}