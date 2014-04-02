/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view 
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	
	/**
	 * The container of back button.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.BackButton
	 * 
	 * 
	 * edit 0
	 *
	 */
	public class BackButton extends Sprite
	{

		public function BackButton() 
		{
			var $numOfPiee:uint = GlobalModelManager.backButtonSkins.length;
			if ($numOfPiee > 0)
			{
				for (var $k:int=$numOfPiee-1; $k>=0; $k--)	// add each predesign element to 
				{
					var $paBm:Bitmap = new Bitmap(GlobalModelManager.backButtonSkins[$k].ui);
					$paBm.smoothing = GlobalModelManager.backButtonSkins[0].smooth;
														
					var $paHolder:Sprite = new Sprite();
					$paHolder.addChild($paBm);
					$paHolder.x = GlobalModelManager.backButtonSkins[$k].x;
					$paHolder.y = GlobalModelManager.backButtonSkins[$k].y;
					$paHolder.alpha = GlobalModelManager.backButtonSkins[$k].alpha;
					$paHolder.rotation = GlobalModelManager.backButtonSkins[$k].rotation;
					$paHolder.blendMode = GlobalModelManager.backButtonSkins[$k].blendmode;
							
					this.addChild($paHolder);
				}
			}
			
			this.mouseChildren = false;
		}

	}
	
}
