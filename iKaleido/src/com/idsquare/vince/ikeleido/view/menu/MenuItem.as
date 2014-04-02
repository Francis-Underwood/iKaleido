/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.menu 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.idsquare.vince.ikeleido.events.PavoMenuItemEvent;
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	
	/**
	 * The item in the Pavo menu, but this is base class to extend.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.menu.MenuItem
	 * 
	 * 
	 * edit 0
	 *
	 */
	 
	public class MenuItem extends Sprite
	{

	// CONSTANTS:	
		//const :Number = 0;
		
	// private vars for positioning:	
		/**
		 * @protected
		 */
		protected var _targetPosition:Object;
		/**
		 * It is actually a number for inertia
		 * its augment means the augment of the offset
		 *
		 * @protected
		 */
		protected var _inertiaCnt:uint;
		/**
		 * It indicates whether the augment is positive or negtive  
		 * 
		 * @protected
		 */
		protected var _direction:int;
		/**
		 * The absolute difference between the current and target values  
		 * 
		 * @protected
		 */
		protected var _difference:uint;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  .
		 */
		public function MenuItem() 
		{
			
		}
		
		
		/**
		 * Start the process of flying to the target position.
		 *  Called by its parent.
		 *
		 * @param	$targetPosition	the object of position {x, y, rotation, alpha}
		 *
		 * @see	
		 *
		 */
		public function flyTo($targetPosition:Object):void
		{
			this._targetPosition = $targetPosition;
			this._direction = (this._targetPosition.rotation > this.rotation) ? 1 : -1;
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
			this._inertiaCnt = 0;
			this.addEventListener(Event.ENTER_FRAME, enterFrameFade);
		}
		

	
	// HANDLERS:
	
	
		/**
		 * enterFrame event handler, to tween this to the target position.
		 *  to be overridden.
		 *
		 * @see	
		 *
		 * @protected
		 */
		protected function enterFrameFade($e:Event):void
		{
			
		}
		
		
		
		
		
		
			
		/**
		 * @Deprecated
		 * Start the process of flying into the stage.
		 *  Called by its parent.
		 *
		 * @param	$targetPosition	the object of position {x, y, rotation, alpha}
		 *
		 * @see	
		 *
		 */
		public function flyIn($targetPosition:Object):void
		{
			this._targetPosition = $targetPosition;
			this._direction = (this._targetPosition.rotation > this.rotation) ? 1 : -1;
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
			this._inertiaCnt = 0;
			this.addEventListener(Event.ENTER_FRAME, enterFrameFadeIn);
		}
		
		
		/**
		 * @Deprecated
		 * Start the process of flying out of the stage.
		 *  Called by its parent.
		 *
		 * @param	$targetPosition	the object of position {x, y, rotation}
		 *
		 * @see	
		 *
		 */
		public function flyOut($targetPosition:Object):void
		{
			this._targetPosition = $targetPosition;
			this._direction = (this._targetPosition.rotation > this.rotation) ? 1 : -1;
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
			this._inertiaCnt = 0;
			this.addEventListener(Event.ENTER_FRAME, enterFrameFadeOut);
		}
	
	
		/**
		 * @Deprecated.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function enterFrameFadeIn($e:Event):void
		{
			var $ang:Number = this.rotation;
			// when should stop it
			if($ang >= this._targetPosition.rotation)
			{
				this.alpha = this._targetPosition.alpha;
				this.removeEventListener(Event.ENTER_FRAME, this.enterFrameFadeIn);
				var $evt:PavoMenuItemEvent = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_SHOWED);
				this.dispatchEvent($evt);
				return;
			}
			
			// calculate the augment of angle
			var $augment = this._direction * (GlobalModelManager.PMENU_VELOCITY + this._inertiaCnt * GlobalModelManager.PMENU_INERTIA);
			$ang += $augment;
			
			// alpha's augment amount is calculated by rotation, use current devides by the overall difference
			var $ratio:Number = $ang / this._difference;
			
			this.alpha = Math.min($ratio, 1);
			
			// the convert from degree to radian, to calculate the x&y position
			var $de:Number = -($ang * Math.PI / 180);
			this.rotation = Math.min($ang, this._targetPosition.rotation);
			this.x = Math.min( (GlobalModelManager.PMENU_RADIUS - (Math.cos($de) * GlobalModelManager.PMENU_RADIUS)), this._targetPosition.x);
			this.y = Math.max((Math.sin($de) * GlobalModelManager.PMENU_RADIUS), this._targetPosition.y);
	
			this._inertiaCnt++;
		}
		
		
		/**
		 * @Deprecated.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function enterFrameFadeOut($e:Event):void
		{
			var $ang:Number = this.rotation;
			// when should stop it
			if($ang <= this._targetPosition.rotation)
			{
				this.alpha = this._targetPosition.alpha;
				this.removeEventListener(Event.ENTER_FRAME, this.enterFrameFadeOut);
				var $evt:PavoMenuItemEvent = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_HIDED);
				this.dispatchEvent($evt);
				return;
			}
			
			var $augment = this._direction * (GlobalModelManager.PMENU_VELOCITY + this._inertiaCnt * GlobalModelManager.PMENU_INERTIA);
			$ang += $augment;
			
			var $ratio:Number = $ang / this._difference;
		
			this.alpha = Math.max($ratio, 0);
			
			var $de:Number = -($ang * Math.PI / 180);
			this.rotation = Math.max($ang, this._targetPosition.rotation);
			this.x = Math.max( (GlobalModelManager.PMENU_RADIUS - (Math.cos($de) * GlobalModelManager.PMENU_RADIUS)), this._targetPosition.x);
			this.y = Math.min((Math.sin($de) * GlobalModelManager.PMENU_RADIUS), this._targetPosition.y);
			
			this._inertiaCnt++;
			
		}
		
		
		
		

	}
	
}
