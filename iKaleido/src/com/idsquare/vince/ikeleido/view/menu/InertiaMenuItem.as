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
	 * The item in the Pavo menu, extending MenuItem, its animation is inertia.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.menu.InertiaMenuItem
	 * 
	 * 
	 * edit 0
	 *
	 */	
	public class InertiaMenuItem extends MenuItem
	{
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  .
		 */
		public function InertiaMenuItem() 
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
			if($ang == this._targetPosition.rotation)
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
			var $augment = this._direction * (GlobalModelManager.PMENU_VELOCITY + this._inertiaCnt * GlobalModelManager.PMENU_INERTIA);
			$ang += $augment;
			
			// alpha's augment amount is calculated by rotation, use current devides by the overall difference
			var $ratio:Number = $ang / this._difference;
			
			// Math.min();
			this.alpha = $ratio;
			
			// the convert from degree to radian, to calculate the x&y position
			var $de:Number = -($ang * Math.PI / 180);
			
			if(this._direction >0)
			{
				this.rotation = Math.min($ang, this._targetPosition.rotation);
				this.x = Math.min( (GlobalModelManager.PMENU_RADIUS - (Math.cos($de) * GlobalModelManager.PMENU_RADIUS)), this._targetPosition.x);
				this.y = Math.max((Math.sin($de) * GlobalModelManager.PMENU_RADIUS), this._targetPosition.y);
			}
			else
			{
				this.rotation = Math.max($ang, this._targetPosition.rotation);
				this.x = Math.max( (GlobalModelManager.PMENU_RADIUS - (Math.cos($de) * GlobalModelManager.PMENU_RADIUS)), this._targetPosition.x);
				this.y = Math.min((Math.sin($de) * GlobalModelManager.PMENU_RADIUS), this._targetPosition.y);
			}
			
			this._inertiaCnt++;
		}
				
		

	}
	
}
