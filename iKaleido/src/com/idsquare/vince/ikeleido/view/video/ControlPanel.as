/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.video 
{
	import flash.display.Sprite;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.utils.ColorUtil;
	
	public class ControlPanel extends Sprite
	{
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */
		public function ControlPanel() 
		{
			ColorUtil.setColor(bar.bar, GlobalModelManager.VideoPlayer_Options.darkColor, 0.6);
			ColorUtil.setColor(bar.loadbar.bar, GlobalModelManager.VideoPlayer_Options.lightColor, 0.8);
			ColorUtil.setColor(bar.playbar.bar, GlobalModelManager.VideoPlayer_Options.accentColor);
			ColorUtil.setColor(volumeCtrl.slider.fill, GlobalModelManager.VideoPlayer_Options.accentColor);
		}
		
		


	}
	
}
