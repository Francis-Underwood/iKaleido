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
	 * @see			com.idsquare.vince.ikeleido.model.loader.ConfigLoader
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class ConfigLoader extends EventDispatcher
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
		public function ConfigLoader() 
		{
			// do nothing
		}
		
		
		/**
		 * Start the process of the chained loading action, begin at config XML.
		 *  config->skin->menu.
		 *
		 * @see		
		 */
		public function load():void 
		{
			var $req:URLRequest = new URLRequest(GlobalModelManager.XML_PATH + GlobalModelManager.CONFIG_FILE);
			this._xmlLoader = new URLLoader();
			this._xmlLoader.addEventListener(Event.COMPLETE, this.confLoadedHandler);
			this._xmlLoader.load($req);
		}
		
		
		
	// HANDLERS:
	
		/**
		 * Event handler for the Complete event of loading config XML.
		 *  Store the data to GlobalModelManager, and start to load skin XML.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function confLoadedHandler($e:Event):void
		{
			try{
				var $conf:XML = new XML($e.target.data);
				GlobalModelManager.configOptions.skin = $conf.options.skin[0].text();
				GlobalModelManager.configOptions.applyCustomBackground = ($conf.options.apply_custom_background.text().toLowerCase()=="yes") ? true : false;
				GlobalModelManager.configOptions.applySubmenuIcon = ($conf.options.apply_submenu_icon.text().toLowerCase()=="yes") ? true : false;
				GlobalModelManager.configOptions.txtModUrl = $conf.options.textmod_url.text();
				
				//trace(GlobalModelManager.configOptions.txtModUrl);
				
				/* preloader animation parameters */
				//GlobalModelManager.preloaderAnimation.x = parseFloat( $conf.preloader.x.text() );
				//GlobalModelManager.preloaderAnimation.y = parseFloat( $conf.preloader.y.text() );
				
				GlobalModelManager.preloaderAnimation.colorWheel = {};
				
				GlobalModelManager.preloaderAnimation.colorWheel.tw1Duration = parseFloat( $conf.preloader.colorwheel.tw1_duration.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw1ScaleRatio = parseFloat( $conf.preloader.colorwheel.tw1_scaleRatio.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw1Hue = parseFloat( $conf.preloader.colorwheel.tw1_hue.text() );
				
				GlobalModelManager.preloaderAnimation.colorWheel.tw2Duration = parseFloat( $conf.preloader.colorwheel.tw2_duration.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw2Position = parseFloat( $conf.preloader.colorwheel.tw2_position.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw2ScaleRatio = parseFloat( $conf.preloader.colorwheel.tw2_scaleRatio.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw2Brightness = parseFloat( $conf.preloader.colorwheel.tw2_brightness.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw2Saturation = parseFloat( $conf.preloader.colorwheel.tw2_saturation.text() );
				
				GlobalModelManager.preloaderAnimation.colorWheel.tw3Duration = parseFloat( $conf.preloader.colorwheel.tw3_duration.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw3Position = parseFloat( $conf.preloader.colorwheel.tw3_position.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw3Contrast = parseFloat( $conf.preloader.colorwheel.tw3_contrast.text() );
				
				GlobalModelManager.preloaderAnimation.colorWheel.tw4Duration = parseFloat( $conf.preloader.colorwheel.tw4_duration.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw4Position = parseFloat( $conf.preloader.colorwheel.tw4_position.text() );
				GlobalModelManager.preloaderAnimation.colorWheel.tw4Alpha = parseFloat( $conf.preloader.colorwheel.tw4_alpha.text() );
				
				GlobalModelManager.devOptions.deviceSensitivity = parseInt( $conf.dev_options.device_dependent.@sensitivity.toString() );
	
			}
			catch($er:Error){}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.confLoadedHandler);
			this._xmlLoader.addEventListener(Event.COMPLETE, this.skinXMLLoadedHandler);
			
			var $req:URLRequest = new URLRequest("skins/" + GlobalModelManager.configOptions.skin + "/skin.xml");
			this._xmlLoader.load($req);
			
		}
		
		
		/**
		 * Event handler for the Complete event of loading skin XML.
		 *  Store the data to GlobalModelManager,  and dispatch the configLoaded event. The XML loading flow is finished.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function skinXMLLoadedHandler($e:Event):void
		{
			try{
				var $skin:XML = new XML($e.target.data);
			
				/* top-level menu */
				GlobalModelManager.topMenu.skin = [];
				
				/*************************************
				 * the data of predesigned menu item
				 ************************************/
				var $slices = $skin.topmenu.skin.children();
				for each (var $slice in $slices)
				{
					var $tms:Object = new Object();
					$tms.file = $slice.@file.toString();
					$tms.x = parseInt( $slice.@x.toString() );
					$tms.y = parseInt( $slice.@y.toString() );
					$tms.alpha = parseInt( $slice.@alpha.toString() );
					$tms.rotation = parseFloat( $slice.@rotation.toString() );
					$tms.blendmode = $slice.@blendmode.toString();
					$tms.smooth = ( $slice.@smooth.toString().toLowerCase() == "yes" );
					
					GlobalModelManager.topMenu.skin.push($tms);
				}				
				
				GlobalModelManager.topMenu.options = {};
				
				GlobalModelManager.topMenu.options.cusZindex = parseInt( $skin.topmenu.options.cus_icon.@zindex.toString() );
				GlobalModelManager.topMenu.options.cusX = parseInt( $skin.topmenu.options.cus_icon.@x.toString() );
				GlobalModelManager.topMenu.options.cusY = parseInt( $skin.topmenu.options.cus_icon.@y.toString() );
				GlobalModelManager.topMenu.options.cusAlpha = parseFloat( $skin.topmenu.options.cus_icon.@alpha.toString() );
				GlobalModelManager.topMenu.options.cusRotation = parseFloat( $skin.topmenu.options.cus_icon.@rotation.toString() );
				GlobalModelManager.topMenu.options.cusBlendMode = $skin.topmenu.options.cus_icon.@blendmode.toString();
				GlobalModelManager.topMenu.options.cusSmooth = ( $skin.topmenu.options.cus_icon.@smooth.toString().toLowerCase() == "yes" );
				
				GlobalModelManager.topMenu.options.cusLabelLeft = parseInt( $skin.topmenu.options.label.@left.toString() );
				GlobalModelManager.topMenu.options.cusLabelTop = parseInt( $skin.topmenu.options.label.@top.toString() );
				GlobalModelManager.topMenu.options.cusLabelZindex = parseInt( $skin.topmenu.options.label.@zindex.toString() );
				
				GlobalModelManager.topMenu.options.itemWidth = parseInt( $skin.topmenu.options.dimensions.@width.toString() );
				GlobalModelManager.topMenu.options.itemHeight = parseInt( $skin.topmenu.options.dimensions.@height.toString() );
				
				
				
				/* sub menu */
				
				/*****************************************
				 * the data of predesigned sub-menu item
				 ****************************************/
				GlobalModelManager.subMenu.skin = [];
				
				var $subpieces = $skin.submenu.skin.children();
				//trace(": "+$subpieces);	// strange, nothing
				//trace($subpieces.length);	// strange, nothing
				for each (var $sp in $subpieces)
				{
					var $subpec:Object = new Object();
					$subpec.file = $sp.@file.toString();
					$subpec.x = parseInt( $sp.@x.toString() );
					$subpec.y = parseInt( $sp.@y.toString() );
					$subpec.alpha = parseInt( $sp.@alpha.toString() );
					$subpec.rotation = parseFloat( $sp.@rotation.toString() );
					$subpec.blendmode = $sp.@blendmode.toString();
					$subpec.smooth = ( $sp.@smooth.toString().toLowerCase() == "yes" );
					
					GlobalModelManager.subMenu.skin.push($subpec);
				}	
				
				GlobalModelManager.subMenu.options = {};
				
				GlobalModelManager.subMenu.options.cusZindex = parseInt( $skin.submenu.options.cus_icon.@zindex.toString() );
				GlobalModelManager.subMenu.options.cusX = parseInt( $skin.submenu.options.cus_icon.@x.toString() );
				GlobalModelManager.subMenu.options.cusY = parseInt( $skin.submenu.options.cus_icon.@y.toString() );
				GlobalModelManager.subMenu.options.cusAlpha = parseFloat( $skin.submenu.options.cus_icon.@alpha.toString() );
				GlobalModelManager.subMenu.options.cusRotation = parseFloat( $skin.submenu.options.cus_icon.@rotation.toString() );
				GlobalModelManager.subMenu.options.cusBlendMode = $skin.submenu.options.cus_icon.@blendmode.toString();
				GlobalModelManager.subMenu.options.cusSmooth = ( $skin.submenu.options.cus_icon.@smooth.toString().toLowerCase() == "yes" );
				
				GlobalModelManager.subMenu.options.cusLabelLeft = parseInt( $skin.submenu.options.label.@left.toString() );
				GlobalModelManager.subMenu.options.cusLabelTop = parseInt( $skin.submenu.options.label.@top.toString() );
				GlobalModelManager.subMenu.options.cusLabelZindex = parseInt( $skin.submenu.options.label.@zindex.toString() );
				
				GlobalModelManager.subMenu.options.itemWidth = parseInt( $skin.submenu.options.dimensions.@width.toString() );
				GlobalModelManager.subMenu.options.itemHeight = parseInt( $skin.submenu.options.dimensions.@height.toString() );
				
				
				/* the other data not of use */
				/*
				// x[0] = x_start_value; x[n] = x[n-1] + (x_step_length + n * x_step_multipler)
				GlobalModelManager.menuAnimation.x_start_value = parseInt( $skin.menu.top.dimensions.animation.x_start_value.text() );
				GlobalModelManager.menuAnimation.x_step_length = parseInt( $skin.menu.top.dimensions.animation.x_step_length.text() );
				GlobalModelManager.menuAnimation.x_step_multipler = parseFloat( $skin.menu.top.dimensions.animation.x_step_multipler.text() );
				
				// y[0] = y_start_value; y[n] = y[n-1] + (y_step_length + n * y_step_multipler)
				GlobalModelManager.menuAnimation.y_start_value = parseInt( $skin.menu.top.dimensions.animation.y_start_value.text() );
				GlobalModelManager.menuAnimation.y_step_length = parseInt( $skin.menu.top.dimensions.animation.y_step_length.text() );
				GlobalModelManager.menuAnimation.y_step_multipler = parseFloat( $skin.menu.top.dimensions.animation.y_step_multipler.text() );
				
				// rotation[0] = r_start_value; rotation[n] = rotation[n-1] + (r_step_length + n * r_step_multipler)
				GlobalModelManager.menuAnimation.r_start_value = parseFloat( $skin.menu.top.dimensions.animation.r_start_value.text() );
				GlobalModelManager.menuAnimation.r_step_length = parseFloat( $skin.menu.top.dimensions.animation.r_step_length.text() );
				GlobalModelManager.menuAnimation.r_step_multipler = parseFloat( $skin.menu.top.dimensions.animation.r_step_multipler.text() );
				
				// alpha
				GlobalModelManager.menuAnimation.a_start_value = parseFloat( $skin.menu.top.dimensions.animation.a_start_value.text() );
				GlobalModelManager.menuAnimation.a_end_value = parseFloat( $skin.menu.top.dimensions.animation.a_end_value.text() );
				*/
				/* the pro for sub-menu item */
				/*
				GlobalModelManager.menuAnimation.sub_x_start_value = parseInt( $skin.menu.top.dimensions.animation.sub_x_start_value.text() );
				GlobalModelManager.menuAnimation.sub_x_step_length = parseInt( $skin.menu.top.dimensions.animation.sub_x_step_length.text() );
				GlobalModelManager.menuAnimation.sub_x_step_multipler = parseFloat( $skin.menu.top.dimensions.animation.sub_x_step_multipler.text() );
				GlobalModelManager.menuAnimation.sub_y_start_value = parseInt( $skin.menu.top.dimensions.animation.sub_y_start_value.text() );
				GlobalModelManager.menuAnimation.sub_y_step_length = parseInt( $skin.menu.top.dimensions.animation.sub_y_step_length.text() );
				GlobalModelManager.menuAnimation.sub_y_step_multipler = parseFloat( $skin.menu.top.dimensions.animation.sub_y_step_multipler.text() );
				GlobalModelManager.menuAnimation.sub_r_start_value = parseFloat( $skin.menu.top.dimensions.animation.sub_r_start_value.text() );
				GlobalModelManager.menuAnimation.sub_r_step_length = parseFloat( $skin.menu.top.dimensions.animation.sub_r_step_length.text() );
				GlobalModelManager.menuAnimation.sub_r_step_multipler = parseFloat( $skin.menu.top.dimensions.animation.sub_r_step_multipler.text() );
				GlobalModelManager.menuAnimation.sub_r_start_offset = parseFloat( $skin.menu.top.dimensions.animation.sub_r_start_offset.text() );
				*/
				
				/*********************************
				 * the data of Pavo menu fomular
				 ********************************/
				
				GlobalModelManager.menuAnimation.radius = parseInt( $skin.topmenu.options.animation_circle.@radius.toString() );
				/* top level menu */
				GlobalModelManager.menuAnimation.degreeAugment = parseFloat( $skin.topmenu.options.animation_circle.@degree_augment.toString() );
				GlobalModelManager.menuAnimation.radianAugment = -(GlobalModelManager.menuAnimation.degreeAugment * Math.PI / 180);
				GlobalModelManager.menuAnimation.tweenSpeedOC = parseFloat( $skin.topmenu.options.animation_circle.@tween_speed_oc.toString() );
				GlobalModelManager.menuAnimation.tweenSpeedTo = parseFloat( $skin.topmenu.options.animation_circle.@tween_speed_to.toString() );
				/*
				trace(GlobalModelManager.menuAnimation.radius);
				 */
				
				
				/* deprecated */
				GlobalModelManager.menuAnimation.decayDevider = parseInt( $skin.topmenu.options.animation_circle.@decay_devider.toString() );
				GlobalModelManager.menuAnimation.inertiaVelocity = parseFloat( $skin.topmenu.options.animation_circle.@inertia_velocity.toString() );
				GlobalModelManager.menuAnimation.inertiaAccelerator = parseFloat( $skin.topmenu.options.animation_circle.@inertia_accelerator.toString() );
				
				
				/* sub menu */
				GlobalModelManager.menuAnimation.subDegreeAugment = parseFloat( $skin.submenu.options.animation_circle.@degree_augment.toString() );
				GlobalModelManager.menuAnimation.subRadianAugment = -(GlobalModelManager.menuAnimation.subDegreeAugment * Math.PI / 180);
				GlobalModelManager.menuAnimation.subTweenSpeedTo = parseFloat( $skin.submenu.options.animation_circle.@tween_speed_to.toString() );
				
				/* deprecated */
				GlobalModelManager.menuAnimation.subDecayDevider = parseInt( $skin.submenu.options.animation_circle.@decay_devider.toString() );
				GlobalModelManager.menuAnimation.subInertiaVelocity = parseFloat( $skin.submenu.options.animation_circle.@inertia_velocity.toString() );
				GlobalModelManager.menuAnimation.subInertiaAccelerator = parseFloat( $skin.submenu.options.animation_circle.@inertia_accelerator.toString() );
				
				
				
				/* background */
				GlobalModelManager.background.options = {};
				
				GlobalModelManager.background.options.defaultFile = $skin.background.options.cus_bg.@defaultfile.toString();
				GlobalModelManager.background.options.zindex = parseInt( $skin.background.options.cus_bg.@zindex.toString() );
				GlobalModelManager.background.options.x = parseInt( $skin.background.options.cus_bg.@x.toString() );
				GlobalModelManager.background.options.y = parseInt( $skin.background.options.cus_bg.@y.toString() );
				GlobalModelManager.background.options.alpha = parseFloat( $skin.background.options.cus_bg.@alpha.toString() );
				GlobalModelManager.background.options.rotation = parseFloat( $skin.background.options.cus_bg.@rotation.toString() );
				GlobalModelManager.background.options.blendmode = $skin.background.options.cus_bg.@blendmode.toString();
				GlobalModelManager.background.options.smooth = ( $skin.background.options.cus_bg.@smooth.toString().toLowerCase() == "yes" );
				
				/*******************************************
				 * the data of predesigned background item
				 ******************************************/
				GlobalModelManager.background.skin = [];
				
				var $bgpieces = $skin.background.skin.children();
				
				for each (var $bgp in $bgpieces)
				{
					var $bgpec:Object = new Object();
					$bgpec.file = $bgp.@file.toString();
					$bgpec.x = parseInt( $bgp.@x.toString() );
					$bgpec.y = parseInt( $bgp.@y.toString() );
					$bgpec.alpha = parseInt( $bgp.@alpha.toString() );
					$bgpec.rotation = parseFloat( $bgp.@rotation.toString() );
					$bgpec.blendmode = $bgp.@blendmode.toString();
					$bgpec.smooth = ( $bgp.@smooth.toString().toLowerCase() == "yes" );
					
					GlobalModelManager.background.skin.push($bgpec);
				}	
				
				
				/* text box */
				
				GlobalModelManager.textBoxUiOptions.modWidth = parseFloat( $skin.textbox.options.module.@width.toString() );
				GlobalModelManager.textBoxUiOptions.modHeight = parseFloat( $skin.textbox.options.module.@height.toString() );
				GlobalModelManager.textBoxUiOptions.txtWidth = parseFloat( $skin.textbox.options.textmask.@width.toString() );
				GlobalModelManager.textBoxUiOptions.txtHeight = parseFloat( $skin.textbox.options.textmask.@height.toString() );
				GlobalModelManager.textBoxUiOptions.txtX = parseFloat( $skin.textbox.options.textmask.@x.toString() );
				GlobalModelManager.textBoxUiOptions.txtY = parseFloat( $skin.textbox.options.textmask.@y.toString() );
				
				GlobalModelManager.textBoxUiOptions.standbyX = parseFloat( $skin.textbox.options.tween_standby.@x.toString() );
				GlobalModelManager.textBoxUiOptions.standbyY = parseFloat( $skin.textbox.options.tween_standby.@y.toString() );
				GlobalModelManager.textBoxUiOptions.standbyAlp = parseFloat( $skin.textbox.options.tween_standby.@alpha.toString() );
				GlobalModelManager.textBoxUiOptions.standbyRot = parseFloat( $skin.textbox.options.tween_standby.@rotation.toString() );
				GlobalModelManager.textBoxUiOptions.standbyBlrX = parseFloat( $skin.textbox.options.tween_standby.@blur_x.toString() );
				GlobalModelManager.textBoxUiOptions.standbyBlrY = parseFloat( $skin.textbox.options.tween_standby.@blur_y.toString() );
				
				GlobalModelManager.textBoxUiOptions.activeX = parseFloat( $skin.textbox.options.tween_active.@x.toString() );
				GlobalModelManager.textBoxUiOptions.activeY = parseFloat( $skin.textbox.options.tween_active.@y.toString() );
				GlobalModelManager.textBoxUiOptions.activeAlp = parseFloat( $skin.textbox.options.tween_active.@alpha.toString() );
				GlobalModelManager.textBoxUiOptions.activeRot = parseFloat( $skin.textbox.options.tween_active.@rotation.toString() );
				GlobalModelManager.textBoxUiOptions.activeBlrX = parseFloat( $skin.textbox.options.tween_active.@blur_x.toString() );
				GlobalModelManager.textBoxUiOptions.activeBlrY = parseFloat( $skin.textbox.options.tween_active.@blur_y.toString() );
				
				GlobalModelManager.textBoxUiOptions.dismissedX = parseFloat( $skin.textbox.options.tween_dismissed.@x.toString() );
				GlobalModelManager.textBoxUiOptions.dismissedY = parseFloat( $skin.textbox.options.tween_dismissed.@y.toString() );
				GlobalModelManager.textBoxUiOptions.dismissedAlp = parseFloat( $skin.textbox.options.tween_dismissed.@alpha.toString() );
				GlobalModelManager.textBoxUiOptions.dismissedRot = parseFloat( $skin.textbox.options.tween_dismissed.@rotation.toString() );
				GlobalModelManager.textBoxUiOptions.dismissedBlrX = parseFloat( $skin.textbox.options.tween_dismissed.@blur_x.toString() );
				GlobalModelManager.textBoxUiOptions.dismissedBlrY = parseFloat( $skin.textbox.options.tween_dismissed.@blur_y.toString() );
				
				/*******************************************
				 * the data of predesigned text box item
				 ******************************************/
				var $txtBoxPieces = $skin.textbox.skin.children();
				
				for each (var $tbp in $txtBoxPieces)
				{
					var $tbpec:Object = new Object();
					$tbpec.file = $tbp.@file.toString();
					$tbpec.x = parseInt( $tbp.@x.toString() );
					$tbpec.y = parseInt( $tbp.@y.toString() );
					$tbpec.alpha = parseInt( $tbp.@alpha.toString() );
					$tbpec.rotation = parseFloat( $tbp.@rotation.toString() );
					$tbpec.blendmode = $tbp.@blendmode.toString();
					$tbpec.smooth = ( $tbp.@smooth.toString().toLowerCase() == "yes" );
					
					GlobalModelManager.textBoxSkins.push($tbpec);
				}
				
				
				/* photo gallery */
				
				GlobalModelManager.photoGalleryUiOptions.modWidth = parseFloat( $skin.photogallery.options.module.@width.toString() );
				GlobalModelManager.photoGalleryUiOptions.modHeight = parseFloat( $skin.photogallery.options.module.@height.toString() );
				
				GlobalModelManager.photoGalleryUiOptions.standbyX = parseFloat( $skin.photogallery.options.tween_standby.@x.toString() );
				GlobalModelManager.photoGalleryUiOptions.standbyY = parseFloat( $skin.photogallery.options.tween_standby.@y.toString() );
				GlobalModelManager.photoGalleryUiOptions.standbyAlp = parseFloat( $skin.photogallery.options.tween_standby.@alpha.toString() );
				GlobalModelManager.photoGalleryUiOptions.standbyRot = parseFloat( $skin.photogallery.options.tween_standby.@rotation.toString() );
				GlobalModelManager.photoGalleryUiOptions.standbyBlrX = parseFloat( $skin.photogallery.options.tween_standby.@blur_x.toString() );
				GlobalModelManager.photoGalleryUiOptions.standbyBlrY = parseFloat( $skin.photogallery.options.tween_standby.@blur_y.toString() );
				
				GlobalModelManager.photoGalleryUiOptions.activeX = parseFloat( $skin.photogallery.options.tween_active.@x.toString() );
				GlobalModelManager.photoGalleryUiOptions.activeY = parseFloat( $skin.photogallery.options.tween_active.@y.toString() );
				GlobalModelManager.photoGalleryUiOptions.activeAlp = parseFloat( $skin.photogallery.options.tween_active.@alpha.toString() );
				GlobalModelManager.photoGalleryUiOptions.activeRot = parseFloat( $skin.photogallery.options.tween_active.@rotation.toString() );
				GlobalModelManager.photoGalleryUiOptions.activeBlrX = parseFloat( $skin.photogallery.options.tween_active.@blur_x.toString() );
				GlobalModelManager.photoGalleryUiOptions.activeBlrY = parseFloat( $skin.photogallery.options.tween_active.@blur_y.toString() );
				
				GlobalModelManager.photoGalleryUiOptions.dismissedX = parseFloat( $skin.photogallery.options.tween_dismissed.@x.toString() );
				GlobalModelManager.photoGalleryUiOptions.dismissedY = parseFloat( $skin.photogallery.options.tween_dismissed.@y.toString() );
				GlobalModelManager.photoGalleryUiOptions.dismissedAlp = parseFloat( $skin.photogallery.options.tween_dismissed.@alpha.toString() );
				GlobalModelManager.photoGalleryUiOptions.dismissedRot = parseFloat( $skin.photogallery.options.tween_dismissed.@rotation.toString() );
				GlobalModelManager.photoGalleryUiOptions.dismissedBlrX = parseFloat( $skin.photogallery.options.tween_dismissed.@blur_x.toString() );
				GlobalModelManager.photoGalleryUiOptions.dismissedBlrY = parseFloat( $skin.photogallery.options.tween_dismissed.@blur_y.toString() );
				
				/************************************************
				 * the data of predesigned photo gallery item
				 ***********************************************/
				var $photoGalleryPieces = $skin.photogallery.skin.children();
				
				for each (var $pgp in $photoGalleryPieces)
				{
					var $pgpec:Object = new Object();
					$pgpec.file = $pgp.@file.toString();
					$pgpec.x = parseInt( $pgp.@x.toString() );
					$pgpec.y = parseInt( $pgp.@y.toString() );
					$pgpec.alpha = parseInt( $pgp.@alpha.toString() );
					$pgpec.rotation = parseFloat( $pgp.@rotation.toString() );
					$pgpec.blendmode = $pgp.@blendmode.toString();
					$pgpec.smooth = ( $pgp.@smooth.toString().toLowerCase() == "yes" );
					
					GlobalModelManager.photoGallerySkins.push($pgpec);
				}
				
				/* photo album */
				
				GlobalModelManager.photoAlbumUiOptions.cusZindex = parseFloat( $skin.album.options.cus_cover.@zindex.toString() );
				GlobalModelManager.photoAlbumUiOptions.cusPosX = parseFloat( $skin.album.options.cus_cover.@x.toString() );
				GlobalModelManager.photoAlbumUiOptions.cusPosY = parseFloat( $skin.album.options.cus_cover.@y.toString() );
				
				GlobalModelManager.photoAlbumUiOptions.modWidth = parseFloat( $skin.album.options.module.@width.toString() );
				GlobalModelManager.photoAlbumUiOptions.modHeight = parseFloat( $skin.album.options.module.@height.toString() );
				
				GlobalModelManager.photoAlbumUiOptions.top = parseFloat( $skin.album.options.module.@margin_top.toString() );
				GlobalModelManager.photoAlbumUiOptions.left = parseFloat( $skin.album.options.module.@margin_left.toString() );
				
				GlobalModelManager.photoAlbumUiOptions.vSpace = parseFloat( $skin.album.options.module.@space_ver.toString() );
				GlobalModelManager.photoAlbumUiOptions.hSpace = parseFloat( $skin.album.options.module.@space_hor.toString() );
				GlobalModelManager.photoAlbumUiOptions.numOfRow = parseInt( $skin.album.options.module.@num_of_row.toString() );
				GlobalModelManager.photoAlbumUiOptions.numOfCol = parseInt( $skin.album.options.module.@num_of_col.toString() );
				
				/*********************************************
				 * the data of predesigned photo album item
				 ********************************************/
				var $photoAlbumPieces = $skin.album.skin.children();
				
				for each (var $pap in $photoAlbumPieces)
				{
					var $papec:Object = new Object();
					$papec.file = $pap.@file.toString();
					$papec.x = parseInt( $pap.@x.toString() );
					$papec.y = parseInt( $pap.@y.toString() );
					$papec.alpha = parseInt( $pap.@alpha.toString() );
					$papec.rotation = parseFloat( $pap.@rotation.toString() );
					$papec.blendmode = $pap.@blendmode.toString();
					$papec.smooth = ( $pap.@smooth.toString().toLowerCase() == "yes" );
					
					GlobalModelManager.photoAlbumSkins.push($papec);
				}
				
				
				GlobalModelManager.photoThumbUiOptions.cusPosX = parseFloat( $skin.photothumb.options.cus_picture.@x.toString() );
				GlobalModelManager.photoThumbUiOptions.cusPosY = parseFloat( $skin.photothumb.options.cus_picture.@y.toString() );
				GlobalModelManager.photoThumbUiOptions.frameWidth = parseFloat( $skin.photothumb.options.frame.@width.toString() );
				GlobalModelManager.photoThumbUiOptions.frameHeight = parseFloat( $skin.photothumb.options.frame.@height.toString() );
				GlobalModelManager.photoThumbUiOptions.frameColor = parseInt( $skin.photothumb.options.frame.@color.toString(), 16 );
				
				GlobalModelManager.photoThumbUiOptions.labelLeft = parseFloat( $skin.photothumb.options.label.@left.toString() );
				GlobalModelManager.photoThumbUiOptions.labelTop = parseFloat( $skin.photothumb.options.label.@top.toString() );
				GlobalModelManager.photoThumbUiOptions.labelBold = ( $skin.photothumb.options.label.@bold.toString().toLowerCase() == "yes" );
				GlobalModelManager.photoThumbUiOptions.labelColor = parseInt( $skin.photothumb.options.label.@color.toString(), 16 );
				GlobalModelManager.photoThumbUiOptions.labelFont = $skin.photothumb.options.label.@font.toString();
				GlobalModelManager.photoThumbUiOptions.labelSize = parseInt( $skin.photothumb.options.label.@size.toString() );
				
				GlobalModelManager.photoThumbUiOptions.shadDistance = parseInt( $skin.photothumb.options.shadow.@distance.toString() );
				GlobalModelManager.photoThumbUiOptions.shadColor = parseInt( $skin.photothumb.options.shadow.@color.toString(), 16 );
				GlobalModelManager.photoThumbUiOptions.shadBlrX = parseInt( $skin.photothumb.options.shadow.@blurX.toString() );
				GlobalModelManager.photoThumbUiOptions.shadBlrY = parseInt( $skin.photothumb.options.shadow.@blurY.toString() );
				GlobalModelManager.photoThumbUiOptions.shadQuality = parseInt( $skin.photothumb.options.shadow.@quality.toString() );
				
				GlobalModelManager.photoThumbUiOptions.maskExtraVer = parseInt( $skin.photothumb.options.module.@mask_ext_ver.toString() );
				GlobalModelManager.photoThumbUiOptions.maskExtraHor = parseInt( $skin.photothumb.options.module.@mask_ext_hor.toString() );
				GlobalModelManager.photoThumbUiOptions.vSpace = parseFloat( $skin.photothumb.options.module.@space_ver.toString() );
				GlobalModelManager.photoThumbUiOptions.hSpace = parseFloat( $skin.photothumb.options.module.@space_hor.toString() );
				GlobalModelManager.photoThumbUiOptions.numOfRow = parseInt( $skin.photothumb.options.module.@num_of_row.toString() );
				GlobalModelManager.photoThumbUiOptions.numOfCol = parseInt( $skin.photothumb.options.module.@num_of_col.toString() );
				//
				GlobalModelManager.photoThumbUiOptions.timelineOffsetY = parseInt( $skin.photothumb.options.tween_timeline.@offsetY.toString() );
				GlobalModelManager.photoThumbUiOptions.timelineDuration = parseFloat( $skin.photothumb.options.tween_timeline.@duration.toString() );
				GlobalModelManager.photoThumbUiOptions.timelineDelay = parseFloat( $skin.photothumb.options.tween_timeline.@delay.toString() );
				
				
				GlobalModelManager.photoOptions.width = parseInt( $skin.photo.options.background.@width.toString() );
				GlobalModelManager.photoOptions.height = parseInt( $skin.photo.options.background.@height.toString() );
				GlobalModelManager.photoOptions.bgColor = parseInt( $skin.photo.options.background.@color.toString(), 16 );
				GlobalModelManager.photoOptions.bgAlpha = parseFloat( $skin.photo.options.background.@alpha.toString() );
				
				
				/*********************************************
				 * the data of predesigned back button 
				 ********************************************/
				var $backButtonPieces = $skin.backbutton.skin.children();
				
				for each (var $bbp in $backButtonPieces)
				{
					var $bbpec:Object = new Object();
					$bbpec.file = $bbp.@file.toString();
					$bbpec.x = parseInt( $bbp.@x.toString() );
					$bbpec.y = parseInt( $bbp.@y.toString() );
					$bbpec.alpha = parseInt( $bbp.@alpha.toString() );
					$bbpec.rotation = parseFloat( $bbp.@rotation.toString() );
					$bbpec.blendmode = $bbp.@blendmode.toString();
					$bbpec.smooth = ( $bbp.@smooth.toString().toLowerCase() == "yes" );
					
					GlobalModelManager.backButtonSkins.push($bbpec);
				}
				
				GlobalModelManager.backButtonUiOptions.labelLeft = parseFloat( $skin.backbutton.options.label.@left.toString() );
				GlobalModelManager.backButtonUiOptions.labelTop = parseFloat( $skin.backbutton.options.label.@top.toString() );
				GlobalModelManager.backButtonUiOptions.labelBold = ( $skin.backbutton.options.label.@bold.toString().toLowerCase() == "yes" );
				GlobalModelManager.backButtonUiOptions.labelColor = parseInt( $skin.backbutton.options.label.@color.toString(), 16 );
				GlobalModelManager.backButtonUiOptions.labelFont = $skin.backbutton.options.label.@font.toString();
				GlobalModelManager.backButtonUiOptions.labelSize = parseInt( $skin.backbutton.options.label.@size.toString() );
				
				GlobalModelManager.backButtonUiOptions.modWidth = parseFloat( $skin.backbutton.options.module.@width.toString() );
				GlobalModelManager.backButtonUiOptions.modHeight = parseFloat( $skin.backbutton.options.module.@height.toString() );
				
				GlobalModelManager.backButtonUiOptions.standbyX = parseFloat( $skin.backbutton.options.tween_standby.@x.toString() );
				GlobalModelManager.backButtonUiOptions.standbyY = parseFloat( $skin.backbutton.options.tween_standby.@y.toString() );
				GlobalModelManager.backButtonUiOptions.standbyAlp = parseFloat( $skin.backbutton.options.tween_standby.@alpha.toString() );
				GlobalModelManager.backButtonUiOptions.standbyRot = parseFloat( $skin.backbutton.options.tween_standby.@rotation.toString() );
				
				GlobalModelManager.backButtonUiOptions.activeX = parseFloat( $skin.backbutton.options.tween_active.@x.toString() );
				GlobalModelManager.backButtonUiOptions.activeY = parseFloat( $skin.backbutton.options.tween_active.@y.toString() );
				GlobalModelManager.backButtonUiOptions.activeAlp = parseFloat( $skin.backbutton.options.tween_active.@alpha.toString() );
				GlobalModelManager.backButtonUiOptions.activeRot = parseFloat( $skin.backbutton.options.tween_active.@rotation.toString() );
				
				GlobalModelManager.backButtonUiOptions.dismissedX = parseFloat( $skin.backbutton.options.tween_dismissed.@x.toString() );
				GlobalModelManager.backButtonUiOptions.dismissedY = parseFloat( $skin.backbutton.options.tween_dismissed.@y.toString() );
				GlobalModelManager.backButtonUiOptions.dismissedAlp = parseFloat( $skin.backbutton.options.tween_dismissed.@alpha.toString() );
				GlobalModelManager.backButtonUiOptions.dismissedRot = parseFloat( $skin.backbutton.options.tween_dismissed.@rotation.toString() );
				
				GlobalModelManager.mediaViewerUiOptions.panelFile = $skin.mediaviewer.buttonpanel.@file.toString();
				GlobalModelManager.mediaViewerUiOptions.panelPosX = parseInt( $skin.mediaviewer.buttonpanel.@x.toString() );
				GlobalModelManager.mediaViewerUiOptions.panelPosY = parseInt( $skin.mediaviewer.buttonpanel.@y.toString() );
				GlobalModelManager.mediaViewerUiOptions.closeButtonFile = $skin.mediaviewer.closebutton.@file.toString();
				GlobalModelManager.mediaViewerUiOptions.closeButtonPosX = parseInt( $skin.mediaviewer.closebutton.@x.toString() );
				GlobalModelManager.mediaViewerUiOptions.closeButtonPosY = parseInt( $skin.mediaviewer.closebutton.@y.toString() );
				GlobalModelManager.mediaViewerUiOptions.infoButtonFile = $skin.mediaviewer.infobutton.@file.toString();
				GlobalModelManager.mediaViewerUiOptions.infoButtonPosX = parseInt( $skin.mediaviewer.infobutton.@x.toString() );
				GlobalModelManager.mediaViewerUiOptions.infoButtonPosY = parseInt( $skin.mediaviewer.infobutton.@y.toString() );
				
				GlobalModelManager.VideoPlayer_Options.lightColor = parseInt( $skin.mediaviewer.videoplayer.@lightcolor.toString(), 16 );
				GlobalModelManager.VideoPlayer_Options.darkColor = parseInt( $skin.mediaviewer.videoplayer.@darkcolor.toString(), 16 );
				GlobalModelManager.VideoPlayer_Options.accentColor = parseInt( $skin.mediaviewer.videoplayer.@accentcolor.toString(), 16 );
				
				GlobalModelManager.VideoPlayer_Options.initPlaybuttonScale = parseFloat( $skin.mediaviewer.videoplayer.@init_playbutton_scale.toString() );
				GlobalModelManager.VideoPlayer_Options.defInitVol = parseFloat( $skin.mediaviewer.videoplayer.@def_init_vol.toString() );
				
				/* movie gallery */
				
				GlobalModelManager.movieGalleryUiOptions.modWidth = parseFloat( $skin.moviegallery.options.module.@width.toString() );
				GlobalModelManager.movieGalleryUiOptions.modHeight = parseFloat( $skin.moviegallery.options.module.@height.toString() );
				
				GlobalModelManager.movieGalleryUiOptions.standbyX = parseFloat( $skin.moviegallery.options.tween_standby.@x.toString() );
				GlobalModelManager.movieGalleryUiOptions.standbyY = parseFloat( $skin.moviegallery.options.tween_standby.@y.toString() );
				GlobalModelManager.movieGalleryUiOptions.standbyAlp = parseFloat( $skin.moviegallery.options.tween_standby.@alpha.toString() );
				GlobalModelManager.movieGalleryUiOptions.standbyRot = parseFloat( $skin.moviegallery.options.tween_standby.@rotation.toString() );
				GlobalModelManager.movieGalleryUiOptions.standbyBlrX = parseFloat( $skin.moviegallery.options.tween_standby.@blur_x.toString() );
				GlobalModelManager.movieGalleryUiOptions.standbyBlrY = parseFloat( $skin.moviegallery.options.tween_standby.@blur_y.toString() );
				
				GlobalModelManager.movieGalleryUiOptions.activeX = parseFloat( $skin.moviegallery.options.tween_active.@x.toString() );
				GlobalModelManager.movieGalleryUiOptions.activeY = parseFloat( $skin.moviegallery.options.tween_active.@y.toString() );
				GlobalModelManager.movieGalleryUiOptions.activeAlp = parseFloat( $skin.moviegallery.options.tween_active.@alpha.toString() );
				GlobalModelManager.movieGalleryUiOptions.activeRot = parseFloat( $skin.moviegallery.options.tween_active.@rotation.toString() );
				GlobalModelManager.movieGalleryUiOptions.activeBlrX = parseFloat( $skin.moviegallery.options.tween_active.@blur_x.toString() );
				GlobalModelManager.movieGalleryUiOptions.activeBlrY = parseFloat( $skin.moviegallery.options.tween_active.@blur_y.toString() );
				
				GlobalModelManager.movieGalleryUiOptions.dismissedX = parseFloat( $skin.moviegallery.options.tween_dismissed.@x.toString() );
				GlobalModelManager.movieGalleryUiOptions.dismissedY = parseFloat( $skin.moviegallery.options.tween_dismissed.@y.toString() );
				GlobalModelManager.movieGalleryUiOptions.dismissedAlp = parseFloat( $skin.moviegallery.options.tween_dismissed.@alpha.toString() );
				GlobalModelManager.movieGalleryUiOptions.dismissedRot = parseFloat( $skin.moviegallery.options.tween_dismissed.@rotation.toString() );
				GlobalModelManager.movieGalleryUiOptions.dismissedBlrX = parseFloat( $skin.moviegallery.options.tween_dismissed.@blur_x.toString() );
				GlobalModelManager.movieGalleryUiOptions.dismissedBlrY = parseFloat( $skin.moviegallery.options.tween_dismissed.@blur_y.toString() );
				
				/************************************************
				 * the data of predesigned photo gallery item
				 ***********************************************/
				var $movieGalleryPieces = $skin.moviegallery.skin.children();
				
				for each (var $mgp in $movieGalleryPieces)
				{
					var $mgpec:Object = new Object();
					$mgpec.file = $mgp.@file.toString();
					$mgpec.x = parseInt( $mgp.@x.toString() );
					$mgpec.y = parseInt( $mgp.@y.toString() );
					$mgpec.alpha = parseInt( $mgp.@alpha.toString() );
					$mgpec.rotation = parseFloat( $mgp.@rotation.toString() );
					$mgpec.blendmode = $mgp.@blendmode.toString();
					$mgpec.smooth = ( $mgp.@smooth.toString().toLowerCase() == "yes" );
					
					GlobalModelManager.movieGallerySkins.push($mgpec);
				}
				
				
				GlobalModelManager.movieThumbUiOptions.cusPosX = parseFloat( $skin.moviethumb.options.cus_picture.@x.toString() );
				GlobalModelManager.movieThumbUiOptions.cusPosY = parseFloat( $skin.moviethumb.options.cus_picture.@y.toString() );
				GlobalModelManager.movieThumbUiOptions.frameWidth = parseFloat( $skin.moviethumb.options.frame.@width.toString() );
				GlobalModelManager.movieThumbUiOptions.frameHeight = parseFloat( $skin.moviethumb.options.frame.@height.toString() );
				GlobalModelManager.movieThumbUiOptions.frameColor = parseInt( $skin.moviethumb.options.frame.@color.toString(), 16 );
				
				GlobalModelManager.movieThumbUiOptions.labelLeft = parseFloat( $skin.moviethumb.options.label.@left.toString() );
				GlobalModelManager.movieThumbUiOptions.labelTop = parseFloat( $skin.moviethumb.options.label.@top.toString() );
				GlobalModelManager.movieThumbUiOptions.labelBold = ( $skin.moviethumb.options.label.@bold.toString().toLowerCase() == "yes" );
				GlobalModelManager.movieThumbUiOptions.labelColor = parseInt( $skin.moviethumb.options.label.@color.toString(), 16 );
				GlobalModelManager.movieThumbUiOptions.labelFont = $skin.moviethumb.options.label.@font.toString();
				GlobalModelManager.movieThumbUiOptions.labelSize = parseInt( $skin.moviethumb.options.label.@size.toString() );
				
				GlobalModelManager.movieThumbUiOptions.shadDistance = parseInt( $skin.moviethumb.options.shadow.@distance.toString() );
				GlobalModelManager.movieThumbUiOptions.shadColor = parseInt( $skin.moviethumb.options.shadow.@color.toString(), 16 );
				GlobalModelManager.movieThumbUiOptions.shadBlrX = parseInt( $skin.moviethumb.options.shadow.@blurX.toString() );
				GlobalModelManager.movieThumbUiOptions.shadBlrY = parseInt( $skin.moviethumb.options.shadow.@blurY.toString() );
				GlobalModelManager.movieThumbUiOptions.shadQuality = parseInt( $skin.moviethumb.options.shadow.@quality.toString() );
				
				GlobalModelManager.movieThumbUiOptions.maskExtraVer = parseInt( $skin.moviethumb.options.module.@mask_ext_ver.toString() );
				GlobalModelManager.movieThumbUiOptions.maskExtraHor = parseInt( $skin.moviethumb.options.module.@mask_ext_hor.toString() );
				GlobalModelManager.movieThumbUiOptions.vSpace = parseFloat( $skin.moviethumb.options.module.@space_ver.toString() );
				GlobalModelManager.movieThumbUiOptions.hSpace = parseFloat( $skin.moviethumb.options.module.@space_hor.toString() );
				GlobalModelManager.movieThumbUiOptions.numOfRow = parseInt( $skin.moviethumb.options.module.@num_of_row.toString() );
				GlobalModelManager.movieThumbUiOptions.numOfCol = parseInt( $skin.moviethumb.options.module.@num_of_col.toString() );
				//
				GlobalModelManager.movieThumbUiOptions.timelineOffsetY = parseInt( $skin.moviethumb.options.tween_timeline.@offsetY.toString() );
				GlobalModelManager.movieThumbUiOptions.timelineDuration = parseFloat( $skin.moviethumb.options.tween_timeline.@duration.toString() );
				GlobalModelManager.movieThumbUiOptions.timelineDelay = parseFloat( $skin.moviethumb.options.tween_timeline.@delay.toString() );
				
			}
			catch($er:Error){}
			
			this._xmlLoader.removeEventListener(Event.COMPLETE, this.skinXMLLoadedHandler);
			
			var $evt:LoadingEvent = new LoadingEvent(LoadingEvent.CONFIG_LOADED);
			this.dispatchEvent($evt);
			
		}
		
		
		
		
		
	}
	
}
