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
	/* for test only */
	import com.hexagonstar.util.debug.Debug;
	
	/**
	 * The item in the Pavo menu, this is combined(inertia & decaying algorithm) version.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.menu.PavoMenuItem
	 * 
	 * 
	 * edit 0
	 *
	 */
	 	
	dynamic public class PavoMenuItem extends Sprite
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
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  .
		 */	
		public function PavoMenuItem() 
		{
			// nothing
		}
		
		
		
		/**
		 * 
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
			//this._direction = (this._targetPosition.rotation > this.rotation) ? 1 : -1;
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
			//this._inertiaCnt = 0;
			this.addEventListener(Event.ENTER_FRAME, enterFrameFadeIn);
		}
		
		
		/**
		 * 
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
			
			//Debug.traceObj(this._so_TmItem_Positions[this._openedTopItemId]);
			this._targetPosition = $targetPosition;
			this._direction = (this._targetPosition.rotation > this.rotation) ? 1 : -1;
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
			this._inertiaCnt = 0;
			this.addEventListener(Event.ENTER_FRAME, sweepToEnterFrameHandler);
		}
		
		
	// HANDLERS:
	
		/**
		 * .
		 *  decaying algorithm.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function enterFrameFadeIn($e:Event):void
		{
			var $ang:Number = this.rotation;
			// when should stop it
			if ( Math.abs($ang - this._targetPosition.rotation) < 1 )
			{
				this.alpha = this._targetPosition.alpha;
				this.removeEventListener(Event.ENTER_FRAME, this.enterFrameFadeIn);
				// direction is always > 0
				var $evtShowed:PavoMenuItemEvent = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_SHOWED);
				this.dispatchEvent($evtShowed);
				/*
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
				*/
				
				return;
			}
			
			// calculate the augment of angle, by decaying algorithm
			var $augment = (this._targetPosition.rotation-$ang) / GlobalModelManager.menuAnimation.decayDevider;
			$ang += $augment;
			
			// alpha's augment amount is calculated by rotation, use current devides by the overall difference
			var $ratio:Number = $ang / this._difference;
			
			// Math.min() ? no need to sanity the data
			this.alpha = $ratio;
			
			// the convert from degree to radian, to calculate the x&y position
			var $de:Number = -($ang * Math.PI / 180);
			this.rotation = $ang;
			this.x = GlobalModelManager.menuAnimation.radius - (Math.cos($de) * GlobalModelManager.menuAnimation.radius);
			this.y = Math.sin($de) * GlobalModelManager.menuAnimation.radius;
		}
		
		
		/**
		 * .
		 *  inertia algorithm.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function enterFrameFadeOut($e:Event):void
		{
			var $ang:Number = this.rotation;
			// when should stop it
			if ($ang <= this._targetPosition.rotation)
			{
				this.alpha = this._targetPosition.alpha;
				this.removeEventListener(Event.ENTER_FRAME, this.enterFrameFadeOut);
				var $evt:PavoMenuItemEvent = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_HIDED);
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
			this.rotation = Math.max($ang, this._targetPosition.rotation);
			this.x = Math.max( (GlobalModelManager.menuAnimation.radius - (Math.cos($de) * GlobalModelManager.menuAnimation.radius)), this._targetPosition.x);
			this.y = Math.min((Math.sin($de) * GlobalModelManager.menuAnimation.radius), this._targetPosition.y);
			
			this._inertiaCnt++;
			
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
				//this.alpha = this._targetPosition.alpha;
				this.removeEventListener(Event.ENTER_FRAME, this.sweepToEnterFrameHandler);
				var $evt:PavoMenuItemEvent = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_SWEPT);
				this.dispatchEvent($evt);
				return;
			}
			
			// calculate the augment of angle,, by inertia algorithm
			var $augment = this._direction * (GlobalModelManager.menuAnimation.inertiaVelocity + this._inertiaCnt * GlobalModelManager.menuAnimation.inertiaAccelerator);
			$ang += $augment;
			
			//var $ratio:Number = $ang / this._difference;
		
			// Math.max() ? no need to sanity the data
			//this.alpha = $ratio;
			
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
				
		

	}
	
}
