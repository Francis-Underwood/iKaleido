/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.model.loader 
{
	
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.events.LoadingEvent; 
	
	/**
	 * Loader responsive to load XMLs.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.model.loader.DatabaseLoaderXML
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class DatabaseLoaderXML extends EventDispatcher
	{
	// loading utilities:
		/**
		 * @private
		 */	
		private var _xmlLoader:URLLoader;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */	
		public function DatabaseLoaderXML() 
		{
			// constructor code
		}


		/**
		 * Start the process of the chained loading action, begin at menu XML.
		 *  menu->photogallery->.
		 *
		 * @see		
		 */
		public function load():void 
		{
			var $req:URLRequest = new URLRequest(GlobalModelManager.XML_PATH + GlobalModelManager.MENU_FILE);
			this._xmlLoader = new URLLoader();
			this._xmlLoader.addEventListener(Event.COMPLETE, this.menuXMLLoadedHandler);
			this._xmlLoader.load($req);
		}
		
		
		
	// HANDLERS:

		/**
		 * Event handler for the Complete event of loading menu XML.
		 *  Store the data to GlobalModelManager, and dispatch the configLoaded event. The XML loading flow is finished.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function menuXMLLoadedHandler($e:Event):void
		{
			try{
				var $menu:XML = new XML($e.target.data);
				
				//GlobalModelManager.menuIconPath = $menu.options.iconpath.text();
				/* top menu item label setting */
				GlobalModelManager.menuLabelFormat.font = $menu.options.font.text();
				GlobalModelManager.menuLabelFormat.fontsize = parseInt($menu.options.fontsize.text());
				GlobalModelManager.menuLabelFormat.fontcolor = parseInt($menu.options.fontcolor.text(), 16);
				GlobalModelManager.menuLabelFormat.fontbold = ($menu.options.fontbold.text().toLowerCase()=="yes")?true:false;
				GlobalModelManager.menuLabelFormat.devicefont = ($menu.options.devicefont.text().toLowerCase()=="yes")?true:false;
				/* sub menu item label setting */
				GlobalModelManager.menuLabelFormat.subFont = $menu.options.sub_font.text();
				GlobalModelManager.menuLabelFormat.subFontsize = parseInt($menu.options.sub_fontsize.text());
				GlobalModelManager.menuLabelFormat.subFontcolor = parseInt($menu.options.sub_fontcolor.text(), 16);
				GlobalModelManager.menuLabelFormat.subFontbold = ($menu.options.sub_fontbold.text().toLowerCase()=="yes")?true:false;
				
				var $menuItems = $menu.fanmenu.children();
				for each (var $item in $menuItems)
				{
					var $m:Object = new Object();
					$m.options =  new Object();
					$m.options.label = $item.options.label.text();
					$m.options.moduleType = $item.options.module_type.text();
					$m.options.moduleId = parseInt($item.options.module_id.text());
					$m.options.hasSubMenu = ($item.options.has_sub_menu.text().toLowerCase()=="yes")?true:false;
					$m.options.icon = $item.options.icon.text();
					
					var $subItems = $item.submenu.children();
					
					$m.subMenu = new Vector.<Object>();
					
					// need to check
					for each (var $subItem in $subItems)
					{
						var $si:Object = new Object();
						$si.label = $subItem.label.text();
						$si.moduleType = $subItem.module_type.text();
						$si.moduleId = parseInt($subItem.module_id.text());
						$si.icon = $subItem.icon.text();
						
						$m.subMenu.push($si);
					}
					
					GlobalModelManager.menu.push($m);
				}
			}
			catch($er:Error){}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.menuXMLLoadedHandler);
			this._xmlLoader.addEventListener(Event.COMPLETE, this.galleryXMLLoadedHandler);
			
			var $req:URLRequest = new URLRequest(GlobalModelManager.XML_PATH + GlobalModelManager.GALLERY_FILE);
			this._xmlLoader.load($req);
			
		}
		
		
		
		/**
		 * Event handler for the Complete event of loading menu XML.
		 *  Store the data to GlobalModelManager,
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function galleryXMLLoadedHandler($e:Event):void
		{
			try {
				var $gallery:XML = new XML($e.target.data);
					
				var $albums = $gallery.albums.children();
					
				for each (var $item in $albums)
				{
					var $m:Object = new Object();
						
						$m.options =  new Object();
						$m.options.title = $item.options.title.text();
						$m.options.desc = $item.options.desc.text();
						$m.options.cover = $item.options.cover.text();
						
						var $photos = $item.photos.children();
						
						$m.photos = new Vector.<Object>();
						
						for each (var $pitem in $photos)
						{
							var $p:Object = new Object();
							$p.title = $pitem.title.text();
							$p.thumb = $pitem.thumb.text();
							$p.big = $pitem.big.text();
							$p.desc = $pitem.desc.text();
							
							$m.photos.push($p);
					}
						
						GlobalModelManager.albums.push($m);
					
				}
			}
			catch($er:Error){}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.galleryXMLLoadedHandler);
			this._xmlLoader.addEventListener(Event.COMPLETE, this.movGalleryXMLLoadedHandler);
			
			var $req:URLRequest = new URLRequest(GlobalModelManager.XML_PATH + GlobalModelManager.MOVGALLERY_FILE);
			this._xmlLoader.load($req);
		}

		/**
		 * Event handler for the Complete event of loading movie gallery XML.
		 *  Store the data to GlobalModelManager,
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function movGalleryXMLLoadedHandler($e:Event):void
		{
			try {
				var $vidGallery:XML = new XML($e.target.data);
					
				var $movies = $vidGallery.movies.children();
				for each (var $mitem in $movies)
				{
					var $mov:Object = new Object();
					$mov.title = $mitem.title.text();
					$mov.desc = $mitem.desc.text();
					$mov.thumb = $mitem.thumb.text();
					$mov.videourl = $mitem.videourl.text();
					
					GlobalModelManager.movies.push($mov);
				}
			}
			catch($er:Error){}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.movGalleryXMLLoadedHandler);
			//trace(GlobalModelManager.movies.length);
			var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.DATABASE_LOADED);
			this.dispatchEvent($evt);
		}



	}	// end of class
	
	
}
