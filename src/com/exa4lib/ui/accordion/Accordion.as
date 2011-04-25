package com.exa4lib.ui.accordion
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Accordion extends Sprite
	{
		protected var $items:Array;
		protected var $container:Sprite;
		protected var $selected:AccordionItem;
		protected var $invalidateLayout:Boolean = false;
		
		public function Accordion()
		{
			super();
			$items = new Array;
			$container = new Sprite;
			this.addChild( $container );
			this.addEventListener( "open_item", hOpen);
			this.addEventListener( "close_item", hClose);	
			this.addEventListener( MouseEvent.CLICK, hMouseClick);
			this.addEventListener( Event.ENTER_FRAME, hUpdateDisplayList);
		}
		
		public function addItem(item:AccordionItem):void{
			$items.push( item );
		}
		
		public function build():void{
			var step:uint = 0;
			for each( var item:AccordionItem in $items){
				item.index = step;
				if(step > 0){
					item.y = AccordionItem($items[step-1]).y+AccordionItem($items[step-1]).height;
				}
				$container.addChild( item );
				step++;
			}
		}
		
		protected function hOpen(e:Event):void{
			if(e.target is AccordionItem){
				var item:AccordionItem = e.target as AccordionItem;
				if($selected){					
					$selected.close();
				}
				//trace('open');
				if( item.index < $items.length ){
					for( var n:uint=e.target.index+1; n < $items.length; n++){
						$items[n].moveY = $items[n].y+item.heightOpen;;
						$invalidateLayout = true;
					}
				}
				$selected = item;				
			}
		}
		
		protected function hClose(e:Event):void{
			if(e.target is AccordionItem){
				//trace('close');
				var item:AccordionItem = e.target as AccordionItem;
				if( item.index < $items.length ){
					for( var n:uint=e.target.index+1; n < $items.length; n++){
						$items[n].moveY = $items[n].y-item.heightOpen;
						$invalidateLayout = true;						
					}
				}
				if($selected == e.target){
					$selected = null;
				}
			}			
		}	
		
		protected function hMouseClick(e:MouseEvent):void{
			if( e.target.parent is AccordionItem){
				var item:AccordionItem = e.target.parent as AccordionItem;
				if(item.isOpen() ){
					if(!item.pending) item.close();
				}else{
					if(!item.pending) item.open();
				}
			}
		}
		
		protected function updateLayout():void{
			for( var n:uint=0; n < $items.length; n++){
				if(!isNaN($items[n].moveY)){
					TweenLite.to($items[n], 1, {y: ($items[n].moveY) } ) ;
					$items[n].moveY = undefined;
				}
			}
		}
		
		protected function  hUpdateDisplayList(e:Event):void{
			if($invalidateLayout){
				updateLayout();
				//$invalidateLayout = false;
			}
		}
	}
}