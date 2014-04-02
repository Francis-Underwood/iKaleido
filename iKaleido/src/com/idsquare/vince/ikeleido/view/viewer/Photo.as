/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.viewer 
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.view.MediaPreloader;
	import com.idsquare.vince.ikeleido.view.viewer.TextHolder;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * The top container of Pavo Menu and all the modules.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.viewer.Photo
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class Photo extends Sprite
	{
		/**
		 * @private
		 */
		private var _bgWidth:uint = GlobalModelManager.photoOptions.width;
		/**
		 * @private
		 */
		private var _bgHeight:uint = GlobalModelManager.photoOptions.height;
		/**
		 * @private
		 */
		private var _imgLoader:Loader;
		/**
		 * @private
		 */
		private var _preloader:MediaPreloader;
		/**
		 * @private
		 */
		private var _description:TextHolder;
		/**
		 * @private
		 */
		private var _desc:String;
		
	// CONSTRUCTOR:
	
		/**
		 * Constructor.
		 */		
		public function Photo($url:String, $desc:String) 
		{
			/* set up backgrounds */
			var $bg:Sprite = new Sprite();
			$bg.graphics.beginFill(GlobalModelManager.photoOptions.bgColor);
			$bg.graphics.drawRect(0, 0, this._bgWidth, this._bgHeight);
			$bg.graphics.endFill();
			$bg.alpha = GlobalModelManager.photoOptions.bgAlpha;
			this.addChild($bg);
			
			/* load the photo content */
			this._imgLoader = new Loader();
			var $req:URLRequest = new URLRequest($url);
			this._imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.photoLoadedHandler);
			this._imgLoader.load($req);
			
			this._preloader = new MediaPreloader();
			this._preloader.x = this._bgWidth/2 + MediaPreloader.OFFSET_HOR;
			this._preloader.y = this._bgHeight/2 + MediaPreloader.OFFSET_VER;
			this.addChild(this._preloader);
			
			this._desc = $desc;
			
			this._description = new TextHolder();
			this._description.visible = false;
			
			/* forbid mouse event from its children */
			this.mouseChildren = false;
		}
		
		/**
		 * Toggle the description.
		 */
		public function toggleDesc():void
		{
			this._description.visible = !this._description.visible;
		}
		
		/**
		 * Show the description.
		 */
		public function showDesc():void
		{
			this._description.visible = true;
		}
		
		/**
		 * Hide the description.
		 */
		public function hideDesc():void
		{
			this._description.visible = false;
		}
		
		
		
		/*
		public function get photoPosX():int
		{
			return this._imgLoader.x;
		}
		
		public function get photoPosY():int
		{
			return this._imgLoader.y;
		}
		
		public function get photoWidth():uint
		{
			return this._imgLoader.width;
		}
		*/
		
	// HANDLERs	
	
		/**
		 * Handler of the photo loading complete event. Arrange the photo, resize and position the description.
		 * 
		 * @param	$e	event	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function photoLoadedHandler($e:Event):void
		{
			//var $bm:Bitmap = new Bitmap($e.target.content.bitmapData);
			
			//var $ldr:Loader = $e.target.loader as Loader;
			this._imgLoader.x = (this._bgWidth - this._imgLoader.width) / 2;
			this._imgLoader.y = (this._bgHeight - this._imgLoader.height) / 2;
						
			if (this.stage)
			{
				this._imgLoader.alpha = 0;
				this.addChild(this._imgLoader);
				
				TweenLite.to(
						 	this._imgLoader, 
							0.25, 
							{
								alpha: 1,
								ease: Cubic.easeOut
							}
						 );
						 
				TweenLite.to(
						 	this._preloader, 
							0.25, 
							{
								alpha: 0,
								ease: Cubic.easeOut, 
								onComplete: this.onPreloaderHided
							}
						 );		 
			}
			else
			{
				this.removeChild(this._preloader);
				this.addChild(this._imgLoader);
			}
			
			
			this._description.bgWidth = this._imgLoader.width;
			this._description.x = this._imgLoader.x;
			this._description.y = this._imgLoader.y;
			this._description.text = this._desc;
			
			this.addChild(this._description);
		}
		
	// CALLBACKs	
	
		private function onPreloaderHided():void
		{
			this.removeChild(this._preloader);
		}
		

	}
	
}
