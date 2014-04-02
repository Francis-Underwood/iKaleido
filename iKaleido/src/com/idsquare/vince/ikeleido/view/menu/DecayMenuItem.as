/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.menu 
{
	import flash.events.Event;
	
	import com.idsquare.vince.ikeleido.events.PavoMenuItemEvent;
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	
	/**
	 * The item in the Pavo menu, extending MenuItem, its animation is decaying.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.menu.DecayMenuItem
	 * 
	 * 
	 * edit 0
	 *
	 */		
	public class DecayMenuItem extends MenuItem
	{
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  .
		 */
		public function DecayMenuItem() 
		{
			// nothing
		}
		
		
	// HANDLERS:
	
	// OVERRIDES:
		/**
		 * enterFrame event handler, to tween this to the target position.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		override protected function enterFrameFade($e:Event):void
		{
			var $ang:Number = this.rotation;
			
			// when should stop it
			if( Math.abs($ang - this._targetPosition.rotation) < 1 )
			{
				this.alpha = this._targetPosition.alpha;
				this.removeEventListener(Event.ENTER_FRAME, this.enterFrameFade);
				if(this._direction >0)
				{
					var $evtShowed:PavoMenuItemEvent = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_SHOWED);
					this.dispatchEvent($evtShowed);
				}
				else
				{
					var $evtHided:PavoMenuItemEvent = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_HIDED);
					this.dispatchEvent($evtHided);
				}
				return;
			}
			
			// calculate the augment of angle
			var $augment = (this._targetPosition.rotation-$ang) / GlobalModelManager.PMENU_DEVISION;
			$ang += $augment;
			
			// alpha's augment amount is calculated by rotation, use current devides by the overall difference
			var $ratio:Number = $ang / this._difference;
			
			// Math.min() ? no need to sanity the data
			this.alpha = $ratio;
			
			// the convert from degree to radian, to calculate the x&y position
			var $de:Number = -($ang * Math.PI / 180);
			
			this.rotation = $ang;
			this.x = GlobalModelManager.PMENU_RADIUS - (Math.cos($de) * GlobalModelManager.PMENU_RADIUS);
			this.y = Math.sin($de) * GlobalModelManager.PMENU_RADIUS;
	
		}
						
	

	}
	
}
