package com.exa4lib.ui.tooltip
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.controls.Text;
	
	public class ToolTip extends Sprite
	{
		
		protected var $skin: Sprite;
		protected var $label: TextField;
		protected var $rootContainer:DisplayObjectContainer;
		protected var $content:DisplayObjectContainer;
		protected var $timeoutHideLink:Number;
		protected var $timeoutShow:Number;
		protected var $contents:Array;
		protected var $textFormat:TextFormat;
		protected var $defaultAlpha:Number = 1;
		protected var $timeout:Number = 500;
		protected var $link:DisplayObject;	
		protected var $overObject:DisplayObject;
		
		protected var _width:Number = 200;
		protected var _height:Number = 50;
		
		public var html:Boolean = false;		
		public var paddingTop:Number = 5;
		public var paddingLeft:Number = 5;
		public var maxWidth:Number = 0;
		public var maxHeight:Number = 0;
		public var isFadeOut:Boolean = false;
		public var moveToCursor:Boolean = true;
		public var timeout:Number = 2000;
		
		protected  var $colorBG:uint = 0xcccccc;
		protected  var $alphaBG:Number = 1;
		
		public function ToolTip(container:DisplayObjectContainer, skin:Sprite=null)
		{
			this.addEventListener(Event.ADDED_TO_STAGE, hAddedToStage);
			this.alpha = 1;
			$rootContainer = container;
			$content = new Sprite;
			$contents = new Array(); 
			$skin = (skin)?skin:$skin;
			$textFormat = new TextFormat;
			$label = new TextField;
		}
		
		public function set backgroundColor(color:uint):void{
			$colorBG = color;
			BuildBaseSkin();
		}
		
		public function set backgroundAlpha(alpha:Number):void{
			$alphaBG = alpha;
			BuildBaseSkin();
		}		
		
		public function set textFormat(format:TextFormat):void{
			$textFormat = format;
		}
		
		public function clearShowTimeout():void{
			if($timeoutShow) clearTimeout( $timeoutShow );
		}
		
		public function isAssign(linkObject:DisplayObject):Boolean{
			return ( $contents[linkObject.name] != undefined )?true:false;
		}
		
		public function assignTo(linkObject:DisplayObject, content:Object='Undefined text', maxWidth:Number=NaN, maxHeight:Number=NaN, timeout:Number=0):void{
			timeout = (timeout)?timeout:this.timeout;
			$contents[linkObject.name] = new Array;
			$contents[linkObject.name][0] = content;
			$contents[linkObject.name][1] = ( !isNaN(maxWidth) )?maxWidth:this.maxWidth;	
			$contents[linkObject.name][2] = ( !isNaN(maxHeight) )?maxHeight:this.maxHeight;				
			$contents[linkObject.name][3] = timeout;	
			linkObject.addEventListener(MouseEvent.MOUSE_OUT, hMouseOut);
			linkObject.addEventListener(MouseEvent.MOUSE_OVER, hMouseOver);
		}
		
		public function removeTo(linkObject:DisplayObject):void{
			$contents[linkObject.name] = null;
			if(linkObject.hasEventListener(MouseEvent.MOUSE_OUT)) linkObject.removeEventListener(MouseEvent.MOUSE_OUT, hMouseOut);
			if(linkObject.hasEventListener(MouseEvent.MOUSE_OVER)) linkObject.removeEventListener(MouseEvent.MOUSE_OVER,  hMouseOver);
			linkObject = null;
		}		
		
		public function set label(value:String):void{
			if(!value) return;
			if($label && this.contains($label)) removeChild($label);
			$label.defaultTextFormat = $textFormat;
			$label.selectable = false;
			$label.multiline = true;
			$label.x = this.paddingLeft;
			$label.y = this.paddingTop;			
			if(this.html) $label.htmlText = value; else $label.text = value;			
			$label.autoSize = TextFormatAlign.LEFT;			
			$label.wordWrap = (_width)?true:false;
			$label.width = (_width)?_width:$label.width;
			if($skin.numChildren > 0){
				$skin.getChildAt(0).width = ( (this._width)?this._width:$label.width ) + (this.paddingLeft*2);
				$skin.getChildAt(0).height = ( (this._height)?this._height:$label.height ) + (this.paddingTop*2);
			}
			this.addChild( $label );			
		}
		
		public function moveTo(point:Point):void{
			this.visible = true;
			this.x = point.x;
			this.y = point.y;
			this.collider();
			if(this.y < 0) this.y = point.y;
		}
		
		public function show(content:Object, maxWidth:Number, maxHeight:Number, timeout:Number):void{
			$timeout = timeout;	
			this._width = maxWidth;
			this._height = maxHeight;
			$rootContainer.addChild(this);
			if( $content.numChildren > 0 ) $content.removeChildAt(0);
			if(content is String) this.label = content as String;
			else this.addContent( content as DisplayObject );
			this.fadeIn();
		}
		
		protected function collider(futureWidth:Number=0, futureHeight:Number=0):void{
			if(this.stage){
				futureWidth = (futureWidth)?futureWidth:this.width;
				futureHeight = (futureHeight)?futureHeight:this.height;
				if(this.x+futureWidth > this.stage.stageWidth ){
					this.x -= futureWidth;
				}
				if(this.y+futureHeight > this.stage.stageHeight){
					this.y -= futureHeight; 
					if(moveToCursor) this.y -= 30; 
				}
			} 
		}
		
		protected function addContent(content:DisplayObject):void{
			$skin.getChildAt(0).width = this._width;
			$skin.getChildAt(0).height = this._height;				
			$content.addChild( content );			
		}
		
		public function hide(timeout:uint=0):void{
			if(!timeout) timeout = $timeout; 
			clearTimeout($timeoutHideLink);
			if(this.isFadeOut){ 
				if(moveToCursor) fadeOut(); else $timeoutHideLink = setTimeout(	fadeOut, timeout);
			}else{	
				if(moveToCursor) removeTip(); else $timeoutHideLink = setTimeout(removeTip, timeout);
			}	
		}
		
		protected function hAddedToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, hAddedToStage);
			this.addChild( $skin );
			this.addChild( $content );			
			this.x -= this.width;
			if(!moveToCursor){
				this.addEventListener(MouseEvent.MOUSE_OVER, hMouseOverSkin);
				this.addEventListener(MouseEvent.MOUSE_OUT, hMouseOutSkin);
				this.addEventListener(MouseEvent.CLICK, hMouseSkinClick);
			}
		}
		
		protected function removeTip():void{
			if($rootContainer.contains(this))
				$rootContainer.removeChild(this);  
			this.x = -this.width;
			if($label && this.contains($label)) this.removeChild($label);
			this.mouseEnabled = true;
		}
		
		private function BuildBaseSkin():void{
			var sprite:Sprite = new Sprite;
			var shape:Shape = new Shape;
			if($skin && $skin.numChildren > 0) $skin.removeChildAt(0);
			with(shape.graphics){
				beginFill(this.$colorBG, this.$alphaBG);
				drawRect(0,0, this._width, this._height);
				endFill();
			}
			sprite.addChild( shape );
			$skin = sprite;	
		}
		
		protected function fadeIn():void{
			this.alpha = 0;
			var param:Object = {alpha: $defaultAlpha };
			if(!moveToCursor){
				//collider(_width, _height);
				//this.width = 0;
				//param.width = _width;
			} 
			var tw:TweenLite = TweenLite.to(this, 0.3, param );
			tw.vars.onStartParams = [$rootContainer, this];
			tw.vars.onStart = function(container:DisplayObjectContainer, target:ToolTip):void{ }
			if(this.$timeout) tw.vars.onComplete = function():void{ 
				clearTimeout($timeoutHideLink);
				$timeoutHideLink = setTimeout(removeTip, $timeout);
			};
			if(!moveToCursor){
				var point:Point = new Point( $overObject.x+$overObject.width*0.5,	$overObject.y+$overObject.height*0.5 );	
				this.moveTo( 
					$overObject.parent.localToGlobal(point)
				);	
			}
		}
		protected function fadeOut():void{
			TweenLite.to(this, 0.3, {alpha: 0, 
				onStart: function(target:ToolTip):void{ target.mouseEnabled = false; },
				onStartParams: [this],
				onComplete: function(container:DisplayObjectContainer, target:ToolTip):void{
					if(container.contains(target)) container.removeChild(target);  target.x = -target.width;
					if($label && target.contains($label)) removeChild($label);
					target.mouseEnabled = true;
				}, 
				onCompleteParams: [$rootContainer, this] 
			});
		}	
		
		protected function hMouseMove(e:MouseEvent):void{
			if(moveToCursor)
			this.moveTo( 
				DisplayObject(e.target).localToGlobal(
					new Point(DisplayObject(e.target).mouseX+20, 
						      DisplayObject(e.target).mouseY+20)
					) 
				);			
		}
		
		protected function hMouseOver(e:MouseEvent):void{
			if($timeoutHideLink) clearTimeout($timeoutHideLink);
			DisplayObject(e.target).addEventListener(MouseEvent.MOUSE_MOVE, hMouseMove);
			if($contents[DisplayObject(e.target).name]){
				$overObject = e.target as  DisplayObject;
				if(!moveToCursor){
					$timeoutShow = setTimeout( this.show, 700, 
						$contents[DisplayObject(e.target).name][0],
						$contents[DisplayObject(e.target).name][1],
						$contents[DisplayObject(e.target).name][2],
						$contents[DisplayObject(e.target).name][3]
						
					);	
				}else{
					this.show( 
						$contents[DisplayObject(e.target).name][0],
						$contents[DisplayObject(e.target).name][1],
						$contents[DisplayObject(e.target).name][2],
						$contents[DisplayObject(e.target).name][3]
					);
				}
				
			}
		}
		
		protected function hMouseOut(e:MouseEvent):void{
			if($timeoutShow) clearTimeout($timeoutShow);
			DisplayObject(e.target).removeEventListener(MouseEvent.MOUSE_MOVE, hMouseMove);
			hide(500);
		}		
		
		protected function hMouseOverSkin(e:MouseEvent):void{
			clearTimeout($timeoutHideLink);
		}
		
		protected function hMouseSkinClick(e:MouseEvent):void{
			removeTip();
		}		
		
		protected function hMouseOutSkin(e:MouseEvent):void{
			this.hide();
		}
	}
}