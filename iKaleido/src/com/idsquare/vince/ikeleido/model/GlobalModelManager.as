/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.model 
{
	import flash.display.Bitmap;
	
	/**
	 * The global storage of all data.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.model.GlobalModelManager
	 * 
	 * 
	 * edit 0
	 *
	 */
	 
	public class GlobalModelManager 
	{
		

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */	
		public function GlobalModelManager() 
		{
			// constructor code
		}
		
	// CONSTANTS:	
		public static const XML_PATH:String = "xml/";
		public static const CONFIG_FILE:String = "config.xml";
		public static const MENU_FILE:String = "menu.xml";
		public static const GALLERY_FILE:String = "photogallery.xml";
		public static const MOVGALLERY_FILE:String = "moviegallery.xml";
		public static const SKIN_PATH:String = "skins/";
		public static const SKIN_FILE:String = "/skin.xml";
		public static const MENU_ICON_PATH:String = "assets/imgs/menu/";
		public static const ALBUM_COVER_PATH:String = "assets/imgs/albumcover/";
		public static const PHOTO_THUMB_PATH:String = "assets/imgs/gallerythumb/";
		public static const PHOTO_BIG_PATH:String = "assets/imgs/galleryphoto/";
		public static const MOVIE_THUMB_PATH:String = "assets/imgs/gallerythumb/";
		public static const MOVIE_VIDEO_PATH:String = "assets/vids/galleryvideo/";
		public static const SUBMENU_ICON_PATH:String = "assets/imgs/submenu/";
		
		
	// pavo menu animation
		public static const FACTOR_DEG_TO_RAD:Number = - (Math.PI / 180);
		
		public static const PMENU_RADIUS:uint = 1200;
		public static const PMENU_DEGREE:Number = 6;	// angle
		public static const PMENU_RADIAN:Number = -(PMENU_DEGREE * Math.PI / 180);
	// inertia animation parameters
		public static const PMENU_VELOCITY:Number = 2;	// degree per frame
		public static const PMENU_INERTIA:Number = 0.4;	// 
	// decay animation parameters
		public static const PMENU_DEVISION:uint = 6;	// movement, by how much 
		
	// HTML Printer settings
		public static const HTML_HEIGHT_MORE:uint = 50;	// augment to the content height, by how much, apply to HTML page height

	// APP GLOBAL VARS:
		public static var configOptions:Object = {};
		public static var preloaderAnimation:Object = {};
		
		public static var devOptions:Object = {};
		
		/************************* SKIN *************************/
		
		/* menu predesign skins, there positions and etc.. */
		public static var topMenu:Object = {};
		public static var subMenu:Object = {};
		
		/* menu animation setting variables */
		public static var menuAnimation:Object = {};
		
		/* background */
		public static var background:Object = {};
		
		/* text box */
		public static var textBoxSkins:Vector.<Object> = new Vector.<Object>();
		public static var textBoxUiOptions:Object = {};
		
		/* photo gallery */
		public static var photoGallerySkins:Vector.<Object> = new Vector.<Object>();
		public static var photoGalleryUiOptions:Object = {};
		
		/* photo album */
		public static var photoAlbumSkins:Vector.<Object> = new Vector.<Object>();
		public static var photoAlbumUiOptions:Object = {};
		
		/* photo thumb frame */
		//public static var photoFrameSkins:Array = [];
		public static var photoThumbUiOptions:Object = {};
		
		/* movie gallery */
		public static var movieGallerySkins:Vector.<Object> = new Vector.<Object>();
		public static var movieGalleryUiOptions:Object = {};
		
		/* photo thumb frame */
		public static var movieThumbUiOptions:Object = {};
		
		/* photo viewer */
		public static var photoOptions:Object = {};
		public static var mediaViewerUiOptions:Object = {};
		
		/* back button */
		public static var backButtonSkins:Vector.<Object> = new Vector.<Object>();
		public static var backButtonUiOptions:Object = {};
		
		/* video player setting */		
		public static var VideoPlayer_Options = {
													lightColor: Color_Light,
													darkColor: Color_Dark,
													accentColor: Color_Accent,
													initPlaybuttonScale: 3.00,
													defInitVol: 0.35
												}
		
		
		
		/********************** END SKIN **********************/
		
		
		/************* user data *************/
		public static var customSubMenuIcon:Object = {};
								
		public static var menuLabelFormat:Object = {};
		
		/**
		 *  ____			
		 * |    |----|--->options(Object)
		 * | O  |	 |		|--->label(String)
		 * |____|	 |		|--->moduleType(String)	
		 * |    |	 |		|--->moduleId(int)	
		 * | O  |	 |		|--->hasSubMenu(Boolean)	
		 * |____|	 |		|--->icon(String)	
		 * 			 |
		 *	   		 |--->subMenu(Array)
		 * 			 |		|--->label(String)
		 * 			 |		|--->moduleType(String)
		 * 			 |		|--->moduleId(int)
		 * 			 |		|--->icon(String)
		 * @public
		 */		
		public static var menu:Vector.<Object> = new Vector.<Object>();
		//
			
		public static var temp:Bitmap;
		/**
		 *  ____			
		 * |    |----|--->options(Object)
		 * | O  |	 |		|--->title(String)
		 * |____|	 |		|--->desc(String)	
		 * |    |	 |		|--->cover(int)	
		 * | O  |	 |		|--->
		 * |____|	 |		|--->	
		 * 			 |
		 *	   		 |--->photos(Array)
		 * 			 |		|--->title(String)
		 * 			 |		|--->thumb(String)
		 * 			 |		|--->big(String)
		 * 			 |		|--->desc(String)
		 * @public
		 */				
		public static var albums:Vector.<Object> = new Vector.<Object>();
		//public static var photos:Array = [];
		
		
		/**
		 *  ____			
		 * |    |----|--->videourl(String)
		 * | O  |	 |--->title(String)
		 * |____|	 |--->desc(String)	
		 * |    |	 |--->thumb(String)
		 * | O  |	 |
		 * |____|	 |
		 * 			 |
		 *	   		 |
		 * 			 |
		 * 			 |		
		 * 			 |		
		 * 			 |	
		 * @public
		 */				
		public static var movies:Vector.<Object> = new Vector.<Object>();
		/************* end user data *************/
		
	}
	
}
