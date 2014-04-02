/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.events 
{
	import flash.events.Event;
	
	/**
	 * The custom Event diapatched during App Initialization process.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.events.LoadingEvent
	 * 
	 * 
	 * edit 0
	 *
	 */
	 
	public class LoadingEvent extends Event 
	{
		
	// CONSTANTS:		
	
		public static const CONFIG_LOADED:String = "configLoaded";
		public static const DATABASE_LOADED:String = "databaseLoaded";
		public static const SKIN_LOADED:String = "skinLoaded";
		public static const MENU_ICON_LOADED:String = "menuIconLoaded";
		public static const GALLERY_COVER_LOADED:String = "galleryCoverLoaded";
		public static const MOVIEGALLERY_THUMB_LOADED:String = "movgalleryThumbLoaded";
		public static const INIT_FINISHED:String = "initFinished";
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *
		 * @param	$type	.
		 * @param	$bubbles	.
		 * @param	$cancelable	.
		 * 
		 */	
		public function LoadingEvent($type:String, $bubbles:Boolean = true, $cancelable:Boolean = false) 
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
            return new LoadingEvent(this.type, this.bubbles, this.cancelable);  
        }
		
		
		/**
		 * 
		 * @return	The description text.
		 * 
		 * @see		
		 */
		public override function toString():String  
        {  
            return formatToString("LoadingEvent", "type", "bubbles", "cancelable");  
        }		

	}
	
}
