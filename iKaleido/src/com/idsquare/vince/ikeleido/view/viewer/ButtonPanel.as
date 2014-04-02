/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.viewer 
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
	 * @see			com.idsquare.vince.ikeleido.view.viewer.ButtonPanel
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class ButtonPanel extends Sprite 
	{
		public var closeButton:Sprite;
		
		public var infoButton:Sprite;
		
		public var activeY:int = GlobalModelManager.mediaViewerUiOptions.panelPosY;
		
	// CONSTRUCTOR:
	
		/**
		 * Constructor.
		 */
		public function ButtonPanel() 
		{
			var $bm:Bitmap = new Bitmap(GlobalModelManager.mediaViewerUiOptions.panelui);
			//$bm.smoothing = true;
			var $bg:Sprite = new Sprite();
			$bg.addChild($bm);
			this.addChild($bg);
			
			var $clsBtnBm:Bitmap = new Bitmap(GlobalModelManager.mediaViewerUiOptions.closeButtonui);
			this.closeButton = new Sprite();
			this.closeButton.addChild($clsBtnBm);
			this.closeButton.x = GlobalModelManager.mediaViewerUiOptions.closeButtonPosX;
			this.closeButton.y = GlobalModelManager.mediaViewerUiOptions.closeButtonPosY;
			this.closeButton.mouseChildren = false;
			this.addChild(this.closeButton);
			var $infBtnBm:Bitmap = new Bitmap(GlobalModelManager.mediaViewerUiOptions.infoButtonui);
			this.infoButton = new Sprite();
			this.infoButton.addChild($infBtnBm);
			this.infoButton.x = GlobalModelManager.mediaViewerUiOptions.infoButtonPosX;
			this.infoButton.y = GlobalModelManager.mediaViewerUiOptions.infoButtonPosY;
			this.infoButton.mouseChildren = false;
			this.addChild(this.infoButton);
		}
		
		
		public function lock():void 
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function unlock():void 
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		
		
		
		
		

	}
	
}
