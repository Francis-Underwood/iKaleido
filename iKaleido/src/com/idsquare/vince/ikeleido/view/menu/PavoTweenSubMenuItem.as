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
	
	/**
	 * The item in the Pavo menu, this is implemented with GreenSocker TweenLite version.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.menu.PavoTweenSubMenuItem
	 * 
	 * 
	 * edit 0
	 *
	 */
	public class PavoTweenSubMenuItem extends Sprite
	{
	// public vars for keeping track:	
		/**
		 * @public
		 */
		public var moduleId:uint;
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
		 * It is to store the original rotation value of this.
		 *
		 * @protected
		 */
		protected var _originalRotation:Number;		
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
		public function PavoTweenSubMenuItem() 
		{
			this._txtPrinter = TextPrinter.getInstance();
			
			var $gg:uint = GlobalModelManager.subMenu.skin.length;
			/****************************************
			 * form its visual body
			 ***************************************/
			if ($gg > 0)
			{
				for (var $jh:int=$gg-1; $jh>=0; $jh--)	// add each predesign element to 
				{
					var $sbm:Bitmap = new Bitmap(GlobalModelManager.subMenu.skin[$jh].ui);
					$sbm.smoothing = GlobalModelManager.subMenu.skin[$jh].smooth;
										
					var $sholder:Sprite = new Sprite();
					$sholder.addChild($sbm);
					$sholder.x = GlobalModelManager.subMenu.skin[$jh].x;
					$sholder.y = GlobalModelManager.subMenu.skin[$jh].y;
					$sholder.alpha = GlobalModelManager.subMenu.skin[$jh].alpha;
					$sholder.rotation = GlobalModelManager.subMenu.skin[$jh].rotation;
					$sholder.blendMode = GlobalModelManager.subMenu.skin[$jh].blendmode;
										
					this.addChild($sholder);
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
											font: GlobalModelManager.menuLabelFormat.subFont,
											size: GlobalModelManager.menuLabelFormat.subFontsize,
											color: GlobalModelManager.menuLabelFormat.subFontcolor,
											bold: GlobalModelManager.menuLabelFormat.subFontbold,
											embedFonts: !GlobalModelManager.menuLabelFormat.devicefont
										}
									 );
				 
			var $labelBm:Bitmap = this._txtPrinter.printText($label);
			$labelBm.smoothing = true;
			$labelBm.x = GlobalModelManager.subMenu.options.itemWidth + GlobalModelManager.subMenu.options.cusLabelLeft;
			$labelBm.y = GlobalModelManager.subMenu.options.cusLabelTop;
			this.addChildAt($labelBm, GlobalModelManager.subMenu.options.cusLabelZindex);
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
			this._originalRotation = this.rotation;
			this._difference = Math.abs(this._targetPosition.rotation - this.rotation);
							
			var $duration:Number = this._difference / GlobalModelManager.menuAnimation.subTweenSpeedTo;	// 24 rad per second
			TweenLite.to(
						 	this, 
							$duration, 
							{
								alpha: this._targetPosition.alpha,
								rotation: this._targetPosition.rotation,
								ease: Quart.easeOut, 
								onUpdate: this.onRotationUpdate,
								onComplete: this.onRotationComplete,
								onCompleteParams: ["sweep"]
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
		public function disapper():void
		{
			var $duration:Number = this._difference / GlobalModelManager.menuAnimation.subTweenSpeedTo;	// 24 rad per second
			TweenLite.to(
						 	this, 
							$duration, 
							{
								alpha: 0,
								rotation: this._originalRotation,
								ease: Quart.easeOut, 
								onUpdate: this.onRotationUpdate,
								onComplete: this.onRotationComplete,
								onCompleteParams: ["disappear"]
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
			
			if($type=="sweep")
			{
				$evt = new PavoMenuItemEvent(PavoMenuItemEvent.SUBMENU_ITEM_SWEPT);
				this.dispatchEvent($evt);
			}
			else if($type=="disappear")
			{
				this.parent.removeChild(this);
			}
			
		}
		

	}
	
}
