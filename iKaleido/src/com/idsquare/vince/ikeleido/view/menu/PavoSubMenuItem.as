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
	 * The item in the Pavo menu, this is combined(inertia & decay algorithm) version.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.menu.PavoSubMenuItem
	 * 
	 * 
	 * edit 0
	 *
	 */
	dynamic public class PavoSubMenuItem extends Sprite
	{
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
		/**
		 * The absolute difference between the current and target values  
		 * 
		 * @protected
		 */
		protected var _vanishAlphaFrame:Array = [0.7, 0.55, 0.4, 0.2, 0.12, 0.04];
		protected var _numOfVFrame:uint = 6;
		protected var _cntAlphaFrame:uint = 6;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  .
		 */
		public function PavoSubMenuItem() 
		{
			// nothing
		}


		/**
		 * 
		 * Start the process of sweeping to the target position.
		 *  Called by its parent, this case is that, when the top-level is opened already,
		 *  and slide the item from one to another position, because sub-menu is being
		 *  opened or closed.
		 *
		 * @param	$targetPosition	the object of position {x, y, rotation}
		 *
		 * @see	
		 *
		 */
		public function sweepTo($targetPosition:Object):void
		{
			//trace(this.rotation);
			//Debug.traceObj($targetPosition);
			
			this._targetPosition = $targetPosition;
			this._direction = (this._targetPosition.rotation > this.rotation) ? 1 : -1;
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
			this._inertiaCnt = 0;
			this.addEventListener(Event.ENTER_FRAME, sweepToEnterFrameHandler);
			/*
			this.x = $targetPosition.x;
			this.y = $targetPosition.y;
			this.rotation = $targetPosition.rotation;
			this.alpha = $targetPosition.alpha;
			*/
		}
		
		
		/**
		 * 
		 * Start the process of sweeping to the target position.
		 *  Called by its parent, this case is that, when the top-level is opened already,
		 *  and slide the item from one to another position, because sub-menu is being
		 *  opened or closed.
		 *
		 * @param	$targetPosition	the object of position {x, y, rotation}
		 *
		 * @see	
		 *
		 */
		public function disapper():void
		{
			this._cntAlphaFrame = 0;
			this.addEventListener(Event.ENTER_FRAME, vanishingEnterFrameHandler);
		}
		
		
		/**
		 * .
		 *  inertia algorithm.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function sweepToEnterFrameHandler($e:Event):void
		{
			var $ang:Number = this.rotation;
			// when should stop it
			if ($ang == this._targetPosition.rotation)
			{
				this.alpha = this._targetPosition.alpha;
				this.removeEventListener(Event.ENTER_FRAME, this.sweepToEnterFrameHandler);
				var $evt:PavoMenuItemEvent = new PavoMenuItemEvent(PavoMenuItemEvent.SUBMENU_ITEM_SWEPT);
				this.dispatchEvent($evt);
				return;
			}
			
			// calculate the augment of angle,, by inertia algorithm
			var $augment = this._direction * (GlobalModelManager.menuAnimation.inertiaVelocity + this._inertiaCnt * GlobalModelManager.menuAnimation.inertiaAccelerator);
			$ang += $augment;
			
			var $ratio:Number = $ang / this._difference;
		
			// Math.max() ? no need to sanity the data
			this.alpha = $ratio;
			
			var $de:Number = -($ang * Math.PI / 180);
			// direction is always < 0
			if(this._direction >0)
			{
				this.rotation = Math.min($ang, this._targetPosition.rotation);
				this.x = Math.min( (GlobalModelManager.menuAnimation.radius - (Math.cos($de) * GlobalModelManager.menuAnimation.radius)), this._targetPosition.x);
				this.y = Math.max((Math.sin($de) * GlobalModelManager.menuAnimation.radius), this._targetPosition.y);
			}
			else
			{
				this.rotation = Math.max($ang, this._targetPosition.rotation);
				this.x = Math.max( (GlobalModelManager.menuAnimation.radius - (Math.cos($de) * GlobalModelManager.menuAnimation.radius)), this._targetPosition.x);
				this.y = Math.min((Math.sin($de) * GlobalModelManager.menuAnimation.radius), this._targetPosition.y);
			}
			
			this._inertiaCnt++;
			
		}
		
		
		
		/**
		 * .
		 *  custom algorithm.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function vanishingEnterFrameHandler($e:Event):void
		{
			if(this._cntAlphaFrame == this._numOfVFrame)
			{
				this.alpha = 0;
				this.removeEventListener(Event.ENTER_FRAME, this.vanishingEnterFrameHandler);
				this.parent.removeChild(this);
			}
			
			this.alpha = this._vanishAlphaFrame[this._cntAlphaFrame];
			this._cntAlphaFrame++;
		}
		

	}
	
}
