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
	 * @see			com.idsquare.vince.ikeleido.events.ModuleEvent
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class ModuleEvent extends Event 
	{
	// CONSTANTS:		
	
		public static const MOD_BUILT:String = "modBuilt";
		public static const KELEIDO_BUILT:String = "keleidoBuilt";

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *
		 * @param	$type	.
		 * @param	$bubbles	.
		 * @param	$cancelable	.
		 * 
		 */
		public function ModuleEvent($type:String, $bubbles:Boolean = true, $cancelable:Boolean = false) 
		{
			super($type, $bubbles, $cancelable);
		}
		
	// OVERRIDES:		
	
		/**
		 * should be declared as Event or ModuleEvent ?
		 * 
		 * @return	The new created ModuleEvent instance.
		 * 
		 * @see		
		 */
		public override function clone():Event  
        {  
            return new ModuleEvent(this.type, this.bubbles, this.cancelable);  
        }
		
		
		/**
		 * 
		 * @return	The description text.
		 * 
		 * @see		
		 */
		public override function toString():String  
        {  
            return formatToString("ModuleEvent", "type", "bubbles", "cancelable");  
        }	

	}
	
}
