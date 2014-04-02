/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	
	/**
	 * The top container of the background.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.Background
	 * 
	 * 
	 * edit 0
	 *
	 */
		
	public class Background extends Sprite
	{
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  Create .
		 */
		public function Background() 
		{
			var $numOfPie:uint = GlobalModelManager.background.skin.length;
			
			/****************************************
			 * form its visual body
			 ***************************************/
						
			if ($numOfPie > 0)
			{
				for (var $j:int=$numOfPie-1; $j>=0; $j--)	// add each predesign element to 
				{
					var $bm:Bitmap = new Bitmap(GlobalModelManager.background.skin[$j].ui);
					$bm.smoothing = GlobalModelManager.background.skin[$j].smooth;
						
					var $holder:Sprite = new Sprite();
					$holder.addChild($bm);
					$holder.x = GlobalModelManager.background.skin[$j].x;
					$holder.y = GlobalModelManager.background.skin[$j].y;
					$holder.alpha = GlobalModelManager.background.skin[$j].alpha;
					$holder.rotation = GlobalModelManager.background.skin[$j].rotation;
					$holder.blendMode = GlobalModelManager.background.skin[$j].blendmode;
						
					this.addChild($holder);
				}
			}
			
			
			// if apply
			var $cusBg:Bitmap = new Bitmap(GlobalModelManager.background.options.ui);
			$cusBg.smoothing = GlobalModelManager.background.options.smooth;
			var $cBgholder:Sprite = new Sprite();
			$cBgholder.addChild($cusBg);
			$cBgholder.x = GlobalModelManager.background.options.x;
			$cBgholder.y = GlobalModelManager.background.options.y;
			$cBgholder.alpha = GlobalModelManager.background.options.alpha;
			$cBgholder.rotation = GlobalModelManager.background.options.rotation;
			$cBgholder.blendMode = GlobalModelManager.background.options.blendmode;
			/**/
			
			this.addChildAt($cusBg, 0);
			
		}

	}
	
}
