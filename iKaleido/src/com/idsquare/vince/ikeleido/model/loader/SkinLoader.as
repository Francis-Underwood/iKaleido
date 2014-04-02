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
	 * Loader responsive to load designer-defined skin images.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.model.loader.SkinLoader
	 * 
	 * 
	 * edit 0
	 *
	 */
			
	public class SkinLoader extends EventDispatcher
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
		public function SkinLoader() 
		{
			// do nothing
		}

		
		/**
		 * Start the process of the chained loading action of skin image files.
		 *  Call loadCustomBackground()->startLoadBackgroundUI->startLoadMenuItemUI().
		 *
		 * @see		
		 */
		public function loadSkin():void 
		{
			// start from background
			this.loadDefaultBackground();
		}
		
		
		/**
		 * Start the loop for loading top-level menu item design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadDefaultBackground():void 
		{
			if (GlobalModelManager.background.options.defaultFile)
			{
				this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
										   GlobalModelManager.configOptions.skin +
										   "/" +
										   GlobalModelManager.background.options.defaultFile.toString());
																	   
				this._ldr = new Loader();
				this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.defaultBackgroundLoadedHandler);
				this._ldr.load(this._req);
			}
			else
			{
				this.startLoadBackgroundUI();
			}
		}	
		
		/**
		 * Start the loop for loading background design UIs.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function startLoadBackgroundUI():void 
		{
			if (GlobalModelManager.background.skin.length > 0)
			{
				this._total = GlobalModelManager.background.skin.length;
				this._cnter = 0;
				// start the procedure
				this.loadBackgroundUI();
			}
			else
			{
			 	this.startLoadMenuItemUI();
			}
		}
		
		
		/**
		 * Load the current background design UI image.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadBackgroundUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.background.skin[this._cnter].file.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.backgroundUILoadedHandler);
			this._ldr.load(this._req);
		}
		
		
		/**
		 * Start the loop for loading top-level menu item design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function startLoadMenuItemUI():void 
		{
			if (GlobalModelManager.topMenu.skin.length > 0)
			{
				this._total = GlobalModelManager.topMenu.skin.length;
				this._cnter = 0;
				// start the procedure 
				this.loadMenuItemUI();
			}
			else
			{
				this.startLoadSubMenuItemUI();
			}
		}
		
		
		/**
		 * Load the current top-level menu item design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadMenuItemUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.topMenu.skin[this._cnter].file.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.menuItemUILoadedHandler);
			this._ldr.load(this._req);
		}
		

		/**
		 * Start the loop for loading sub-menu item design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function startLoadSubMenuItemUI():void 
		{
			if (GlobalModelManager.subMenu.skin.length > 0)
			{
				this._total = GlobalModelManager.subMenu.skin.length;
				this._cnter = 0;
				// start the procedure 
				this.loadSubMenuItemUI();
			}
			else
			{
				this.startLoadTextBoxUI();
			}
		}
		
		
		/**
		 * Load current sub-menu item design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadSubMenuItemUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.subMenu.skin[this._cnter].file.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.subMenuItemUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
		/**
		 * Start the loop for loading text box designs.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function startLoadTextBoxUI():void 
		{
			if (GlobalModelManager.textBoxSkins.length > 0)
			{
				this._total = GlobalModelManager.textBoxSkins.length;
				this._cnter = 0;
				// start the procedure 
				this.loadTextBoxUI();
			}
			else
			{
				this.startLoadPhotoGalleryUI();
			}
		}
		
		
		/**
		 * Load current text box design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadTextBoxUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.textBoxSkins[this._cnter].file.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.textBoxUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
		/**
		 * Start the loop for loading photo gallery designs.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function startLoadPhotoGalleryUI():void 
		{
			if (GlobalModelManager.photoGallerySkins.length > 0)
			{
				this._total = GlobalModelManager.photoGallerySkins.length;
				this._cnter = 0;
				// start the procedure 
				this.loadPhotoGalleryUI();
			}
			else
			{
				this.startLoadPhotoAlbumUI();
			}
		}
		
		
		/**
		 * Load current photo gallery design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadPhotoGalleryUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.photoGallerySkins[this._cnter].file.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.photoGalleryUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
		/**
		 * Start the loop for loading photo album designs.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function startLoadPhotoAlbumUI():void 
		{
			if (GlobalModelManager.photoAlbumSkins.length > 0)
			{
				this._total = GlobalModelManager.photoAlbumSkins.length;
				this._cnter = 0;
				// start the procedure 
				this.loadPhotoAlbumUI();
			}
			else
			{
				this.startLoadMovieGalleryUI();
			}
		}
		
		
		/**
		 * Load current photo album design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadPhotoAlbumUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.photoAlbumSkins[this._cnter].file.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.photoAlbumUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
		/**
		 * Start the loop for loading movie gallery designs.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function startLoadMovieGalleryUI():void 
		{
			if (GlobalModelManager.movieGallerySkins.length > 0)
			{
				this._total = GlobalModelManager.movieGallerySkins.length;
				this._cnter = 0;
				// start the procedure 
				this.loadMovieGalleryUI();
			}
			else
			{
				this.startLoadBackButtonUI();
			}
		}
		
		
		/**
		 * Load current photo gallery design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadMovieGalleryUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.movieGallerySkins[this._cnter].file.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.movieGalleryUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
		/**
		 * Start the loop for loading photo album designs.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function startLoadBackButtonUI():void 
		{
			if (GlobalModelManager.backButtonSkins.length > 0)
			{
				this._total = GlobalModelManager.backButtonSkins.length;
				this._cnter = 0;
				// start the procedure 
				this.loadBackButtonUI();
			}
			else
			{
				// loading finished
				var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.SKIN_LOADED);
				this.dispatchEvent($evt);
			}
		}
		
		
		/**
		 * Load current photo album design.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadBackButtonUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.backButtonSkins[this._cnter].file.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.photoBackButtonUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
		/**
		 * Load button panel's design in media viewer.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadMediaViewerButtonPanelUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.mediaViewerUiOptions.panelFile.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.mediaViewerButtonPanelUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
		/**
		 * Load close button 's design in media viewer.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadMediaViewerCloseButtonUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.mediaViewerUiOptions.closeButtonFile.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.mediaViewerCloseButtonUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
		/**
		 * Load info button 's design in media viewer.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadMediaViewerInfoButtonUI():void 
		{
			this._req = new URLRequest(GlobalModelManager.SKIN_PATH +
									   GlobalModelManager.configOptions.skin +
									   "/" +
									   GlobalModelManager.mediaViewerUiOptions.infoButtonFile.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.mediaViewerInfoButtonUILoadedHandler);
			this._ldr.load(this._req);
		}		
		
		
	// HANDLERS:
	
	
		/**
		 * Event handler for the Complete event of loading default custom background file.
		 *  Save the bitmap data to GlobalModelManager, and start the process of loading background pieces.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function defaultBackgroundLoadedHandler($e:Event):void 
		{
			GlobalModelManager.background.options.ui = $e.target.content.bitmapData;
						
			this.startLoadBackgroundUI();
		}
		
		
		/**
		 * Event handler for the Complete event of loading background piece image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the pieces are loaded, if yes, start the process of loading top menu icons.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function backgroundUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.background.skin[this._cnter].ui = $e.target.content.bitmapData;
						
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				this.startLoadMenuItemUI();
			}
			else
			{
				// continue to load background ui pieces
				this.loadBackgroundUI();
			}
		}
		
		
		/**
		 * Event handler for the Complete event of loading top-level menu image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the icons are loaded, if yes, start the process of loading sub menu icons.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function menuItemUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.topMenu.skin[this._cnter].ui = $e.target.content.bitmapData;
						
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				this.startLoadSubMenuItemUI();
			}
			else
			{
				// continue to load menu item pieces
				this.loadMenuItemUI();
			}
		}
		
		
		/**
		 * Event handler for the Complete event of loading sub-menu item icon image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the icons are loaded, if yes, start the process of loading text box icons.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function subMenuItemUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.subMenu.skin[this._cnter].ui = $e.target.content.bitmapData;
						
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				this.startLoadTextBoxUI();
			}
			else
			{
				// continue to load sub-menu item pieces
				this.loadSubMenuItemUI();
			}
		}
		
		
		/**
		 * Event handler for the Complete event of loading text box design image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the images are loaded, if yes, dispatch the event of skionLoaded.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function textBoxUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.textBoxSkins[this._cnter].ui = $e.target.content.bitmapData;
						
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				this.startLoadPhotoGalleryUI();
			}
			else
			{
				// continue to load text box design image files
				this.loadTextBoxUI();
			}
		}
		

		/**
		 * Event handler for the Complete event of loading photo gallery design image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the images are loaded, if yes, dispatch the event of skionLoaded.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function photoGalleryUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.photoGallerySkins[this._cnter].ui = $e.target.content.bitmapData;
						
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				this.startLoadPhotoAlbumUI();
			}
			else
			{
				// continue to load photo gallery design image files
				this.loadPhotoGalleryUI();
			}
		}
		
		
		/**
		 * Event handler for the Complete event of loading photo album design image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the images are loaded, if yes, dispatch the event of skionLoaded.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function photoAlbumUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.photoAlbumSkins[this._cnter].ui = $e.target.content.bitmapData;
						
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				this.startLoadMovieGalleryUI();
			}
			else
			{
				// continue to load sub-menu item pieces
				this.loadPhotoAlbumUI();
			}
		}
		
		
		/**
		 * Event handler for the Complete event of loading movie gallery design image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the images are loaded, if yes, dispatch the event of skionLoaded.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function movieGalleryUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.movieGallerySkins[this._cnter].ui = $e.target.content.bitmapData;
						
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				this.startLoadBackButtonUI();
			}
			else
			{
				// continue to load photo gallery design image files
				this.loadMovieGalleryUI();
			}
		}
		
		
		/**
		 * Event handler for the Complete event of loading back button design image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the images are loaded, if yes, dispatch the event of skionLoaded.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function photoBackButtonUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.backButtonSkins[this._cnter].ui = $e.target.content.bitmapData;
						
			this._cnter++;
			
			if (this._cnter == this._total)
			{
				this.loadMediaViewerButtonPanelUI();
			}
			else
			{
				// continue to load sub-menu item pieces
				this.loadBackButtonUI();
			}
		}
		
		
		/**
		 * Event handler for the Complete event of loading ButtonPanel(in MediaViewer) design image files.
		 *  For each image file, store its BitmapData to GlobalModelManager, 
		 *  and check if all the images are loaded, if yes, dispatch the event of skionLoaded.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */			
		private function mediaViewerButtonPanelUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.mediaViewerUiOptions.panelui = $e.target.content.bitmapData;
						
			this.loadMediaViewerCloseButtonUI();
		}
		
		
		private function mediaViewerCloseButtonUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.mediaViewerUiOptions.closeButtonui = $e.target.content.bitmapData;
						
			this.loadMediaViewerInfoButtonUI();
		}
		
		
		private function mediaViewerInfoButtonUILoadedHandler($e:Event):void 
		{
			GlobalModelManager.mediaViewerUiOptions.infoButtonui = $e.target.content.bitmapData;
						
			// loading finished
			var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.SKIN_LOADED);
			this.dispatchEvent($evt);
		}
		
		
		
		
	}
	
}
