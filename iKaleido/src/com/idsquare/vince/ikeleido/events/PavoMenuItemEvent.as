/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.events 
{
	import flash.events.Event;
	
	/**
	 * .
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.events.PavoMenuItemEvent
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class PavoMenuItemEvent extends Event 
	{
		
	// CONSTANTS:		
	
		public static const MENUITEM_SHOWED:String = "menuItemShowed";
		public static const MENUITEM_HIDED:String = "menuItemHided";
		public static const MENUITEM_SWEPT:String = "menuItemSwept";
		public static const SUBMENU_ITEM_SWEPT:String = "subMenuItemSwept";

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *
		 * @param	$type	.
		 * @param	$bubbles	.
		 * @param	$cancelable	.
		 * 
		 */	
		public function PavoMenuItemEvent($type:String, $bubbles:Boolean = true, $cancelable:Boolean = false) 
		{
			super($type, $bubbles, $cancelable);
		}
		
	// OVERRIDES:		
	
		/**
		 * should be declared as Event or LoadingEvent ?
		 * 
		 * @return	The new created LoadingEvent instance.
		 * 
		 * @see		
		 */
		public override function clone():Event  
        {  
            return new PavoMenuItemEvent(this.type, this.bubbles, this.cancelable);  
        }
		
		
		/**
		 * 
		 * @return	The description text.
		 * 
		 * @see		
		 */
		public override function toString():String  
        {  
            return formatToString("PavoMenuItemEvent", "type", "bubbles", "cancelable");  
        }	

	}
	
}
