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
	 * @see			com.idsquare.vince.ikeleido.events.MenuEvent
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class MenuEvent extends Event  
	{

	// CONSTANTS:		
	
		public static const MOD_CHANGE:String = "modChange";
	// 
		public var uid:uint;
	
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *
		 * @param	$type	.
		 * @param	$bubbles	.
		 * @param	$cancelable	.
		 * 
		 */		
		public function MenuEvent($type:String, $uid:uint, $bubbles:Boolean = true, $cancelable:Boolean = false) 
		{
			super($type, $bubbles, $cancelable);
			this.uid = $uid;
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
            return new MenuEvent(this.type, this.uid, this.bubbles, this.cancelable);  
        }
		
		
		/**
		 * 
		 * @return	The description text.
		 * 
		 * @see		
		 */
		public override function toString():String  
        {  
            return formatToString("MenuEvent", "uid", "type", "bubbles", "cancelable");  
        }	
		
		

	}
	
}
