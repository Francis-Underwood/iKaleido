/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.menu 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import com.idsquare.vince.ikeleido.events.PavoMenuItemEvent;
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.utils.TextPrinter;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/* for test only */
	import com.hexagonstar.util.debug.Debug;
	
	/**
	 * The item in the Pavo menu, this is implemented with GreenSocker TweenLite version.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.menu.PavoTweenMenuItem
	 * 
	 * 
	 * edit 0
	 *
	 */
	 	
	public class PavoTweenMenuItem extends Sprite
	{
	// public vars for keeping track:	
		/**
		 * @public
		 */
		public var id:uint;	
		/**
		 * @public
		 */
		public var moduleId:uint;	
		/**
		 * @public
		 */
		public var hasSubMenu:Boolean;	
		/**
		 * @public
		 */
		public var uid:uint;	
		
	// private vars for positioning:	
		/**
		 * @protected
		 */
		protected var _targetPosition:Object;
		/**
		 * The absolute difference between the current and target values  
		 * 
		 * @protected
		 */
		protected var _difference:uint;
		
		/**
		 * @private
		 */
		private var _txtPrinter:TextPrinter;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  .
		 */	
		public function PavoTweenMenuItem() 
		{
			this._txtPrinter = TextPrinter.getInstance();
			
			var $dd:uint = GlobalModelManager.topMenu.skin.length;
			
			/****************************************
			 * form its visual body
			 ***************************************/
			if ($dd > 0)
			{
				for (var $j:int=$dd-1; $j>=0; $j--)	// add each predesign element to 
				{
					var $bm:Bitmap = new Bitmap(GlobalModelManager.topMenu.skin[$j].ui);
					$bm.smoothing = GlobalModelManager.topMenu.skin[$j].smooth;
						
					var $holder:Sprite = new Sprite();
					$holder.addChild($bm);
					$holder.x = GlobalModelManager.topMenu.skin[$j].x;
					$holder.y = GlobalModelManager.topMenu.skin[$j].y;
					$holder.alpha = GlobalModelManager.topMenu.skin[$j].alpha;
					$holder.rotation = GlobalModelManager.topMenu.skin[$j].rotation;
					$holder.blendMode = GlobalModelManager.topMenu.skin[$j].blendmode;
						
					this.addChild($holder);
				}
			}
				
		}
		
		
		/**
		 * 
		 * Add label, print it into Bitmap, then add it.
		 *  Called by its parent.
		 *
		 * @param	$label	the text
		 *
		 * @see	
		 *
		 */
		public function addLabel($label:String):void
		{
			if (($label==null) || ($label==""))
			{
				return;
			}
			
			/* print its label */
			this._txtPrinter.setStyle(
										  {
											font: GlobalModelManager.menuLabelFormat.font,
											size: GlobalModelManager.menuLabelFormat.fontsize,
											color: GlobalModelManager.menuLabelFormat.fontcolor,
											bold: GlobalModelManager.menuLabelFormat.fontbold,
											embedFonts: !GlobalModelManager.menuLabelFormat.devicefont
										}
									 );
				 
			var $labelBm:Bitmap = this._txtPrinter.printText($label);
			$labelBm.smoothing = true;
			$labelBm.x = GlobalModelManager.topMenu.options.itemWidth + GlobalModelManager.topMenu.options.cusLabelLeft;
			$labelBm.y = GlobalModelManager.topMenu.options.cusLabelTop;
			this.addChildAt($labelBm, GlobalModelManager.topMenu.options.cusLabelZindex);
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
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);			
			var $duration:Number = this._difference / GlobalModelManager.menuAnimation.tweenSpeedOC;	// 60 rad per second
			TweenLite.to(
						 	this, 
							$duration, 
							{
								alpha: this._targetPosition.alpha,
								rotation: this._targetPosition.rotation,
								ease: Quart.easeOut, 
								onUpdate: this.onRotationUpdate,
								onComplete: this.onRotationComplete,
								onCompleteParams: ["show"]
							}
						 ); 
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
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
			var $duration:Number = this._difference / GlobalModelManager.menuAnimation.tweenSpeedOC;	// 60 rad per second
			TweenLite.to(
						 	this, 
							$duration, 
							{
								alpha: this._targetPosition.alpha,
								rotation: this._targetPosition.rotation,
								ease: Cubic.easeIn, 
								onUpdate: this.onRotationUpdate,
								onComplete: this.onRotationComplete,
								onCompleteParams: ["hide"]
							}
						 );
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
			this._targetPosition = $targetPosition;
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
			var $duration:Number = this._difference / GlobalModelManager.menuAnimation.tweenSpeedTo;	// 20 rad per second
			TweenLite.to(
						 	this, 
							$duration, 
							{
								rotation: this._targetPosition.rotation,
								ease: Cubic.easeOut, 
								onUpdate: this.onRotationUpdate,
								onComplete: this.onRotationComplete,
								onCompleteParams: ["sweep"]
							}
						 );
		}
		
	// CALLBACK:
	
		/**
		 * Call back method, run on each frame.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function onRotationUpdate():void
		{
			var $rad:Number = this.rotation * GlobalModelManager.FACTOR_DEG_TO_RAD;
			this.x = GlobalModelManager.menuAnimation.radius - Math.cos($rad) * GlobalModelManager.menuAnimation.radius;
			this.y = Math.sin($rad) * GlobalModelManager.menuAnimation.radius;
		}
		
		
		/**
		 * Call back method, executed when the Tween is done.
		 *  Dispatch corresponding event.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function onRotationComplete($type:String):void
		{
			var $evt:PavoMenuItemEvent;
			
			if($type=="show")
			{
				$evt = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_SHOWED);
				this.dispatchEvent($evt);
			}
			else if($type=="hide")
			{
				$evt = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_HIDED);
				this.dispatchEvent($evt);
			}
			
			else if($type=="sweep")
			{
				$evt = new PavoMenuItemEvent(PavoMenuItemEvent.MENUITEM_SWEPT);
				this.dispatchEvent($evt);
			}
			/**/
		}
	
		
	// HANDLERS:
	
		
		

	}
	
}
