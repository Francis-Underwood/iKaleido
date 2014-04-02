/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.model.loader 
{
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.events.LoadingEvent;
	
	/**
	 * Loader responsive to load user-uploaded gallery photos.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.model.loader.GalleryPhotoLoader
	 * 
	 * 
	 * edit 0
	 *
	 */
		
	public class GalleryPhotoLoader extends EventDispatcher
	{
		
	// variables for loading:	
		/**
		 * @private
		 */	
		private var _cnter:int;
		/**
		 * @private
		 */	
		private var _total:int;
		/**
		 * @private
		 */	
		private var _req:URLRequest;
		/**
		 * @private
		 */	
		private var _ldr:Loader;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */
		public function GalleryPhotoLoader() 
		{
			// do nothing
		}
		
		
		/**
		 * Start the process of the chained loading action of image files.
		 *  Call loadMenuItemIcon().
		 *
		 * @see		
		 */
		public function loadGallery():void 
		{
			this._total = GlobalModelManager.albums.length;
			this._cnter = 0;
			if (this._total == 0)
			{
				// log 
				return;
			}
			// start the procedure 
			this.loadAlbumCover();
		}
		
		
		private function loadAlbumCover():void 
		{
			this._req = new URLRequest(GlobalModelManager.ALBUM_COVER_PATH +
									   GlobalModelManager.albums[this._cnter].options.cover.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.albumCoverLoadedHandler);
			this._ldr.load(this._req);
		}
		
	// HANDLERS:
	
		/**
		 * Event handler for the Complete event of loading album cover files.
		 *  For each image file, copy its BitmapData and create a new Sprite to holde it.
		 *  And set the holding Sprite's attributes, store it to GlobalModelManager, 
		 *  and check if all the icons are loaded, if yes, dispatch the event of menuIconLoaded.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */		
		private function albumCoverLoadedHandler($e:Event):void 
		{
			var $bm:Bitmap = new Bitmap($e.target.content.bitmapData);
			//$bm.smoothing = GlobalModelManager.customMenuIcon.top.smooth;
			
			var $holder:Sprite = new Sprite();
			$holder.addChild($bm);
			
			$holder.x = GlobalModelManager.photoAlbumUiOptions.cusPosX;
			$holder.y = GlobalModelManager.photoAlbumUiOptions.cusPosY;
			
			GlobalModelManager.albums[this._cnter].options.image = $holder;
			
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				// loading finished
				var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.GALLERY_COVER_LOADED);
				this.dispatchEvent($evt);
			}
			else
			{
				this.loadAlbumCover();
			}
			
			
		}
		

	}
	
}
