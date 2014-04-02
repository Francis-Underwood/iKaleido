/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.photogallery 
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
	import flash.filters.*;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	
	/**
	 * The container of sigle photo thumbnail.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.photogallery.PhotoThumbnail
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class PhotoThumbnail extends Sprite 
	{
		/**
		 * @public
		 */
		public var uid:uint;
		/**
		 * @public
		 */
		public var activeY:uint;
		/**
		 * @private
		 */
		private var _options:Object;
		
	// CONSTRUCTOR:
		/**
		 * Constructor.
		 */
		public function PhotoThumbnail($options:Object, $format:TextFormat) 
		{
			this._options = $options;
			
			/* draw background */
			this.graphics.beginFill(GlobalModelManager.photoThumbUiOptions.frameColor);
			this.graphics.drawRect(0, 0, GlobalModelManager.photoThumbUiOptions.frameWidth, GlobalModelManager.photoThumbUiOptions.frameHeight);
			this.graphics.endFill();
			
			/* draw shadow */
			var $shadow:DropShadowFilter = new DropShadowFilter();
			$shadow.distance = GlobalModelManager.photoThumbUiOptions.shadDistance;
			$shadow.color = GlobalModelManager.photoThumbUiOptions.shadColor;
			$shadow.blurX = GlobalModelManager.photoThumbUiOptions.shadBlrX;
			$shadow.blurY = GlobalModelManager.photoThumbUiOptions.shadBlrY;
			$shadow.quality = GlobalModelManager.photoThumbUiOptions.shadQuality;
			this.filters = [$shadow];
			
			/* load picture */
			var $ldr:Loader = new Loader();
			var $req:URLRequest = new URLRequest(GlobalModelManager.PHOTO_THUMB_PATH + this._options.thumb.toString());
			$ldr.load($req);
			$ldr.x = GlobalModelManager.photoThumbUiOptions.cusPosX;
			$ldr.y = GlobalModelManager.photoThumbUiOptions.cusPosY;
			this.addChild($ldr);
			
			/* render title text */
			var $title:TextField = new TextField();
			$title.multiline = false;
			$title.selectable = false;
			$title.wordWrap = false;
			$title.autoSize = TextFieldAutoSize.LEFT;
			$title.text = this._options.title.toString();
			$title.x = GlobalModelManager.photoThumbUiOptions.labelLeft;
			$title.y = GlobalModelManager.photoThumbUiOptions.labelTop;
			$title.setTextFormat($format);
			this.addChild($title);
			
			/* init attributes */
			this.mouseChildren = false;
			
		}

	}
	
}
