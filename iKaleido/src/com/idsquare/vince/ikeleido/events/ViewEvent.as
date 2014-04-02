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
	 * @see			com.idsquare.vince.ikeleido.events.ViewEvent
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class ViewEvent extends Event
	{
	// CONSTANTS:		
	
		public static const MEDIA_VIEW:String = "mediaView";
		//public static const KELEIDO_BUILT:String = "keleidoBuilt";
		
		public var aid:uint;
		
		public var phid:uint;
		
		public var mediaType:String;

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *
		 * @param	$type	.
		 * @param	$aid	album id, unsigned integer.
		 * @param	$phid	photo index in the album, unsigned integer.
		 * @param	$mediaType	media type, "IMAGE" or "VIDEO".
		 * @param	$bubbles	.
		 * @param	$cancelable	.
		 * 
		 */
		public function ViewEvent($type:String, $aid:uint, $phid:uint, $mediaType:String, $bubbles:Boolean = true, $cancelable:Boolean = false) 
		{
			super($type, $bubbles, $cancelable);
			this.aid = $aid;
			this.phid = $phid;
			this.mediaType = $mediaType;
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
            return new ViewEvent(this.type, this.aid, this.phid, this.mediaType, this.bubbles, this.cancelable);  
        }
		
		
		/**
		 * 
		 * @return	The description text.
		 * 
		 * @see		
		 */
		public override function toString():String  
        {  
            return formatToString("ViewEvent", "aid", "phid", "mediaType", "type", "bubbles", "cancelable");  
        }	
	

	}
	
}
