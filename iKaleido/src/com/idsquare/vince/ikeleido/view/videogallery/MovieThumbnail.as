/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.videogallery 
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
	 * The container of sigle movie thumbnail.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.photogallery.MovieThumbnail
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class MovieThumbnail extends Sprite 
	{
		/**
		 * @public
		 */
		public var uid:uint;
		/**
		 * @private
		 */
		private var _options:Object;
		
	// CONSTRUCTOR:
		/**
		 * Constructor.
		 */	
		public function MovieThumbnail($options:Object, $format:TextFormat) 
		{
			this._options = $options;
			
			/* draw background */
			this.graphics.beginFill(GlobalModelManager.movieThumbUiOptions.frameColor);
			this.graphics.drawRect(0, 0, GlobalModelManager.movieThumbUiOptions.frameWidth, GlobalModelManager.movieThumbUiOptions.frameHeight);
			this.graphics.endFill();
			
			/* draw shadow */
			var $shadow:DropShadowFilter = new DropShadowFilter();
			$shadow.distance = GlobalModelManager.movieThumbUiOptions.shadDistance;
			$shadow.color = GlobalModelManager.movieThumbUiOptions.shadColor;
			$shadow.blurX = GlobalModelManager.movieThumbUiOptions.shadBlrX;
			$shadow.blurY = GlobalModelManager.movieThumbUiOptions.shadBlrY;
			$shadow.quality = GlobalModelManager.movieThumbUiOptions.shadQuality;
			this.filters = [$shadow];
			
			
			/* load picture */
			var $ldr:Loader = new Loader();
			var $req:URLRequest = new URLRequest(GlobalModelManager.MOVIE_THUMB_PATH + this._options.thumb.toString());
			$ldr.load($req);
			$ldr.x = GlobalModelManager.movieThumbUiOptions.cusPosX;
			$ldr.y = GlobalModelManager.movieThumbUiOptions.cusPosY;
			this.addChild($ldr);
			
			var $playIcon:PlayIcon = new PlayIcon();
			$playIcon.x = GlobalModelManager.movieThumbUiOptions.frameWidth / 2;
			$playIcon.y = GlobalModelManager.movieThumbUiOptions.frameHeight / 2;
			this.addChild($playIcon);
			
			/* render title text */
			var $title:TextField = new TextField();
			$title.multiline = false;
			$title.selectable = false;
			$title.wordWrap = false;
			$title.autoSize = TextFieldAutoSize.LEFT;
			$title.text = this._options.title.toString();
			$title.x = GlobalModelManager.movieThumbUiOptions.labelLeft;
			$title.y = GlobalModelManager.movieThumbUiOptions.labelTop;
			$title.setTextFormat($format);
			this.addChild($title);
			
			/* init attributes */
			this.mouseChildren = false;
		}
		
	}
	
}
