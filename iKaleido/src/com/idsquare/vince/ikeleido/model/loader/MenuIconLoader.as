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
	 * Loader responsive to load user-defined menu icons.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.model.loader.MenuIconLoader
	 * 
	 * 
	 * edit 0
	 *
	 */
		
	public class MenuIconLoader extends EventDispatcher
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
		private var _cnterOfSub:int;
		/**
		 * @private
		 */	
		private var _totalOfSub:int;
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
		public function MenuIconLoader() 
		{
			// do nothing
		}
		
		
		/**
		 * Start the process of the chained loading action of image files.
		 *  Call loadMenuItemIcon().
		 *
		 * @see		
		 */
		public function loadMenu():void 
		{
			this._total = GlobalModelManager.menu.length;
			this._cnter = 0;
			
			if (this._total == 0)
			{
				// log
				return;
			}
			// start the procedure 
			this.loadMenuItemIcon();
		}
		
		
		/**
		 * Start the loop for loading top-level menu icon.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadMenuItemIcon():void 
		{
			this._req = new URLRequest(GlobalModelManager.MENU_ICON_PATH +
									   GlobalModelManager.menu[this._cnter].options.icon.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.menuItemIconLoadedHandler);
			this._ldr.load(this._req);
		}
		
		
		/**
		 * Start the loop for loading sub-menu icon.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function loadSubMenuItemIcon():void 
		{
			this._req = new URLRequest(GlobalModelManager.SUBMENU_ICON_PATH +
									   GlobalModelManager.menu[this._cnter].subMenu[this._cnterOfSub].icon.toString());
			
			this._ldr = new Loader();
			this._ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.subMenuItemIconLoadedHandler);
			this._ldr.load(this._req);
		}
		
		
	// HANDLERS:
	
		/**
		 * Event handler for the Complete event of loading icon files.
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
		private function menuItemIconLoadedHandler($e:Event):void 
		{
			var $bm:Bitmap = new Bitmap($e.target.content.bitmapData);
			$bm.smoothing = GlobalModelManager.topMenu.options.cusSmooth;
			var $holder:Sprite = new Sprite();
			$holder.addChild($bm);
			$holder.x = GlobalModelManager.topMenu.options.cusX;
			$holder.y = GlobalModelManager.topMenu.options.cusY;
			$holder.alpha = GlobalModelManager.topMenu.options.cusAlpha;
			$holder.rotation = GlobalModelManager.topMenu.options.cusRotation;
			$holder.blendMode = GlobalModelManager.topMenu.options.cusBlendMode;
			
			GlobalModelManager.menu[this._cnter].options.image = $holder;
			
			if (GlobalModelManager.configOptions.applySubmenuIcon)
			{
				// sub
				this._totalOfSub = GlobalModelManager.menu[this._cnter].subMenu.length;
				this._cnterOfSub = 0;
				// start process of loading sub-menu item icon
				this.loadSubMenuItemIcon();
			}
			else
			{
				this._cnter++;
				
				if (this._cnter == this._total)
				{
					// loading finished
					var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.MENU_ICON_LOADED);
					this.dispatchEvent($evt);
				}
				else
				{
					// continue to load
					this.loadMenuItemIcon();
				}
				
			}
			
		}
		
		
		/**
		 * .
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
		private function subMenuItemIconLoadedHandler($e:Event):void 
		{
			var $bm:Bitmap = new Bitmap($e.target.content.bitmapData);
			$bm.smoothing = GlobalModelManager.subMenu.options.cusSmooth;
			var $holder:Sprite = new Sprite();
			$holder.addChild($bm);
			$holder.x = GlobalModelManager.subMenu.options.cusX;
			$holder.y = GlobalModelManager.subMenu.options.cusY;
			$holder.alpha = GlobalModelManager.subMenu.options.cusAlpha;
			$holder.rotation = GlobalModelManager.subMenu.options.cusRotation;
			$holder.blendMode = GlobalModelManager.subMenu.options.cusBlendMode;
			
			
			GlobalModelManager.menu[this._cnter].subMenu[this._cnterOfSub].image = $holder;
			
			this._cnterOfSub++;
			
			if (this._cnterOfSub==this._totalOfSub)
			{
				this._cnter++;
				
				if (this._cnter == this._total)
				{
					// loading finished
					var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.MENU_ICON_LOADED);
					this.dispatchEvent($evt);
				}
				else
				{
					// continue to load
					this.loadMenuItemIcon();
				}
			}
			else
			{
				this.loadSubMenuItemIcon();
			}
			
		}
		
		
		

	}
	
}
