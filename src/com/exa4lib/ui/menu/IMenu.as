package com.exa4lib.ui.menu
{
	public interface IMenu
	{
		function getItem():IMenuItem;
		function getItemAt(index:int):IMenuItem;
		function selectItem(item:IMenuItem):void
		function selectItemAt(index:int):void;;
		function getSelectedItem(index:int):IMenuItem;
		
		function addItem(item:IMenuItem):void;
		function removeItem(item:IMenuItem):void;
		
		
	}
}