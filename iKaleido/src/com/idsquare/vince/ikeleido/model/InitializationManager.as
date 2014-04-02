/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.model 
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.model.loader.ConfigLoader;
	import com.idsquare.vince.ikeleido.model.loader.DatabaseLoaderXML;
	import com.idsquare.vince.ikeleido.model.loader.SkinLoader;
	import com.idsquare.vince.ikeleido.model.loader.MenuIconLoader;
	import com.idsquare.vince.ikeleido.model.loader.GalleryPhotoLoader;
	import com.idsquare.vince.ikeleido.model.loader.MovieGalleryPhotoLoader;
	import com.idsquare.vince.ikeleido.view.Preloader;
	import com.idsquare.vince.ikeleido.events.LoadingEvent; 
	
	
	/**
	 * The manager controls all loading actions.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.model.InitializationManager
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class InitializationManager extends EventDispatcher
	{
		
	// loading utilities:
		/**
		 * @private
		 */
		private var _confLdr:ConfigLoader = new ConfigLoader();
		/**
		 * @private
		 */
		private var _dbLdr:DatabaseLoaderXML = new DatabaseLoaderXML();
		/**
		 * @private
		 */
		private var _skinLdr:SkinLoader = new SkinLoader();
		/**
		 * @private
		 */
		private var _menuIconLdr:MenuIconLoader = new MenuIconLoader();
		/**
		 * @private
		 */
		private var _photoGalleryLdr:GalleryPhotoLoader = new GalleryPhotoLoader();
		/**
		 * @private
		 */
		private var _movGalleryLdr:MovieGalleryPhotoLoader = new MovieGalleryPhotoLoader();
		/**
		 * @private
		 */
		private var _pre:MovieClip;
		
			
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */
		public function InitializationManager($p:Preloader) 
		{
			this._pre = $p;
		}
		
		
		/**
		 * Start flow of initialization, which is a serial of loading operations.
		 * 
		 * @see		
		 *
		 */	
		public function initialize():void 
		{
			this._pre.prompt = "loading config...";
			this._confLdr.addEventListener(LoadingEvent.CONFIG_LOADED, this.confLoadedHandler);
			this._confLdr.load();
		}
		
		
	// HANDLERS:
	
		/**
		 * Event handler for the CONFIG_LOADED event dispatched by ConfigLoader.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */	
		private function confLoadedHandler($e:LoadingEvent):void
		{
			this._confLdr.removeEventListener(LoadingEvent.CONFIG_LOADED, this.confLoadedHandler);
			this._pre.prompt = "loading user data...";
			this._dbLdr.addEventListener(LoadingEvent.DATABASE_LOADED, this.dbLoadedHandler);
			this._dbLdr.load();
		}
		
		
		/**
		 * Event handler for the DATABASE_LOADED event dispatched by DatabaseLoader.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */	
		private function dbLoadedHandler($e:LoadingEvent):void
		{
			this._dbLdr.removeEventListener(LoadingEvent.DATABASE_LOADED, this.dbLoadedHandler);
			this._pre.prompt = "loading skin UIs...";
			this._skinLdr.addEventListener(LoadingEvent.SKIN_LOADED, this.skinLoadedHandler);
			this._skinLdr.loadSkin();
		}
		
		
		/**
		 * Event handler for the SKIN_LOADED event dispatched by SkinLoader.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function skinLoadedHandler($e:LoadingEvent):void
		{
			this._skinLdr.removeEventListener(LoadingEvent.SKIN_LOADED, this.skinLoadedHandler);
			this._pre.prompt = "loading menu icons...";
			this.dispatchEvent($e);
			this._menuIconLdr.addEventListener(LoadingEvent.MENU_ICON_LOADED, this.menuIconLoadedHandler);
			this._menuIconLdr.loadMenu();
		}
		
		
		/**
		 * Event handler for the MENU_ICON_LOADED dispatched by MenuIconLoader.
		 *  Loading process finished, dispatch event of Init_Finished.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function menuIconLoadedHandler($e:LoadingEvent):void
		{
			this._menuIconLdr.removeEventListener(LoadingEvent.MENU_ICON_LOADED, this.menuIconLoadedHandler);
			this._pre.prompt = "loading album covers...";
			this.dispatchEvent($e);
			this._photoGalleryLdr.addEventListener(LoadingEvent.GALLERY_COVER_LOADED, this.albumCoverLoadedHandler);
			this._photoGalleryLdr.loadGallery();
		}
		
		
		/**
		 * Event handler for the GALLERY_COVER_LOADED dispatched by GalleryPhotoLoader.
		 *  Loading process finished, dispatch event of Init_Finished.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function albumCoverLoadedHandler($e:LoadingEvent):void
		{
			this._photoGalleryLdr.removeEventListener(LoadingEvent.GALLERY_COVER_LOADED, this.albumCoverLoadedHandler);
			this._pre.prompt = "loading movie gallery...";
			
			this._movGalleryLdr.addEventListener(LoadingEvent.MOVIEGALLERY_THUMB_LOADED, this.movieThumbLoadedHandler);
			this._movGalleryLdr.loadMovGallery();
		}
		
		
		/**
		 * Event handler for the MOVIEGALLERY_THUMB_LOADED dispatched by MovieGalleryPhotoLoader.
		 *  Loading process finished, dispatch event of Init_Finished.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function movieThumbLoadedHandler($e:LoadingEvent):void
		{
			var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.INIT_FINISHED);
			this.dispatchEvent($evt);
		}
		
		

	}
	
}
