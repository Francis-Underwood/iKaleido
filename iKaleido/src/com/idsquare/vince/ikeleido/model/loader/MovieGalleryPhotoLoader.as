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
	 * Loader responsive to load user-uploaded mgallery photos.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.model.loader.MovieGalleryPhotoLoader
	 * 
	 * 
	 * edit 0
	 *
	 */

	public class MovieGalleryPhotoLoader extends EventDispatcher
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
		public function MovieGalleryPhotoLoader() 
		{
			// do nothing
		}
		
		/**
		 * Start the process of the chained loading action of image files.
		 *  Call loadMenuItemIcon().
		 *
		 * @see		
		 */
		public function loadMovGallery():void 
		{
			this._total = GlobalModelManager.movies.length;
			this._cnter = 0;
			if (this._total == 0)
			{
				// log 
				return;
			}
			// start the procedure 
			this.loadMovieThumb();
		}
		
		private function loadMovieThumb():void 
		{
			this._req = new URLRequest(GlobalModelManager.MOVIE_THUMB_PATH +
									   GlobalModelManager.movies[this._cnter].thumb.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.movieThumbLoadedHandler);
			this._ldr.load(this._req);
		}
		
		
	// HANDLERS:
	
		private function movieThumbLoadedHandler($e:Event):void 
		{
			var $bm:Bitmap = new Bitmap($e.target.content.bitmapData);
			
			var $holder:Sprite = new Sprite();
			$holder.addChild($bm);
			
			//$holder.x = GlobalModelManager.photoAlbumOptions.cusPosX;
			//$holder.y = GlobalModelManager.photoAlbumOptions.cusPosY;
			
			GlobalModelManager.movies[this._cnter].image = $holder;
			
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				// loading finished
				var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.MOVIEGALLERY_THUMB_LOADED);
				this.dispatchEvent($evt);
			}
			else
			{
				this.loadMovieThumb();
			}
		}
		
		

	}
	
}
