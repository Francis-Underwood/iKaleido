/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.view.Background;
	import com.idsquare.vince.ikeleido.view.menu.PavoMenu;
	import com.idsquare.vince.ikeleido.view.TextBoxModule;
	import com.idsquare.vince.ikeleido.view.photogallery.PhotoGalleryModule;
	import com.idsquare.vince.ikeleido.view.videogallery.MovieGalleryModule;
	import com.idsquare.vince.ikeleido.view.viewer.MediaViewer;
	import com.idsquare.vince.ikeleido.events.ModuleEvent; 
	import com.idsquare.vince.ikeleido.events.ViewEvent;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.BlurFilterPlugin; 
	import com.greensock.plugins.ColorTransformPlugin;
	
	/**
	 * The top container of Pavo Menu and all the modules.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.Keleido
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class Keleido extends Sprite
	{
		
	// visual elements:		
		/**
		 * @private
		 */
		private var _textBox:TextBoxModule;
		/**
		 *
		 * @private
		 */
		private var _menu:PavoMenu;
		
		/**
		 *  ____			
		 * |    |----|--->modId(Int)
		 * |    |	 |--->modType(String)
		 * |____|	 |--->module(Sprite)
		 * |    |		
		 * |    |	
		 * |____|			
		 *
		 * @private
		 */
		private var _modules:Object;
		/**
		 * @private
		 */
		private var _numOfModules:uint;
		/**
		 * @private
		 */
		private var _buildModulesCnter:uint;
		/**
		 * @private
		 */
		private var _background:Background;
		/**
		 * @private
		 */
		private var _mainContent:Sprite;
		/**
		 * @private
		 */
		private var _menuExpanded:Boolean;
		/**
		 * @private
		 */
		private var _prevOpenedModId:int = -1;
		/**
		 * @private
		 */
		private var _openedModId:int = -1;
		/**
		 * @private
		 */
		private var _mediaViewer:MediaViewer;
		/**
		 * @private
		 */
		private var _shouldTweenModule:Boolean;

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */
		public function Keleido() 
		{
			TweenPlugin.activate([ColorTransformPlugin]);
			TweenPlugin.activate([BlurFilterPlugin]);
		}
		
		/**
		 * 
		 * The main workhorse of this class, called by its parent.
		 *  Its main task is to build menu and all the modules corrospending to each item, 
		 *  MedieFile Viewer and its background.	
		 *
		 */
		public function build():void
		{
			this._mainContent = new Sprite();
			this._background = new Background();
			this._mainContent.addChild(this._background);
			this.addChild(this._mainContent);
			
			this._menu = new PavoMenu();
			this._menu.x = 80;
			this._menu.y = 1000;
			this._modules = this._menu.moduleDatas;
			this._numOfModules = this._menu.uidCounter;
			
			this.addChild(this._menu);
			this._menuExpanded = false;
			this._menu.addEventListener(MouseEvent.CLICK, this.menuClickedHandler);
			//this._buildModulesCnter = 0;
			
			this._mediaViewer = new MediaViewer(this.onMediaViewerHided);
			this._mediaViewer.init();
			
			//trace(this._numOfModules);	// 13
			
			for (this._buildModulesCnter = 0; this._buildModulesCnter<this._numOfModules; this._buildModulesCnter++)
			{
				//trace("type: "+this._modules[this._buildModulesCnter].modType);	// textbox
				
				switch (this._modules[this._buildModulesCnter].modType.toString())	// must apply toString() method
				{
					case "textbox":
						this._modules[this._buildModulesCnter].module = new TextBoxModule(GlobalModelManager.configOptions.txtModUrl.toString(), 2);
						this._modules[this._buildModulesCnter].module.build();
						break;
					case "photogallery":
						this._modules[this._buildModulesCnter].module = new PhotoGalleryModule();
						this._modules[this._buildModulesCnter].module.build();
						this._modules[this._buildModulesCnter].module.addEventListener(ViewEvent.MEDIA_VIEW, this.mediaViewHandler);
						break;
					case "moviegallery":
						this._modules[this._buildModulesCnter].module = new MovieGalleryModule();
						this._modules[this._buildModulesCnter].module.build();
						this._modules[this._buildModulesCnter].module.addEventListener(ViewEvent.MEDIA_VIEW, this.mediaViewHandler);
						break;
					default:
						// log to error: unknown mod type 
						break;
				}
			}
			
			/*
			this._textBox = new TextBoxModule("http://192.168.0.123/lab/richTxTedtotpt/tiny.html", 2);
			this._textBox.addEventListener(ModuleEvent.MOD_BUILT, this.txtBoxBuiltHandler);
			this._textBox.build();
			*/
			
		}
		
		/**
		 * 
		 * Set the main content darker, to lock it.	
		 *
		 * @private
		 *
		 */
		private function darkenContent():void
		{
			TweenLite.to(
						 	this._mainContent, 
							0.2, 
							{
								colorTransform:{brightness:0.5},
								ease: Cubic.easeOut, 
								onComplete: this.onContentBrightnessComplete,
								onCompleteParams: ["darkening"]
							}
						 );
		}
		
		/**
		 * 
		 * Set the main content brighter, to unlock it.	
		 *
		 * @private
		 *
		 */
		private function brightenContent():void
		{
			TweenLite.to(
						 	this._mainContent, 
							0.2, 
							{
								colorTransform:{brightness:1},
								ease: Cubic.easeOut, 
								onComplete: this.onContentBrightnessComplete,
								onCompleteParams: ["brightening"]
							}
						 );
		}
		
		/**
		 * 
		 * Lock the main content, forbidden its mouse event.	
		 *
		 * @private
		 *
		 */
		private function lockContent():void
		{
			this._mainContent.mouseChildren = false;
		}
		
		/**
		 * 
		 * Unlock the main content, recover its mouse event.	
		 *
		 * @private
		 *
		 */
		private function unlockContent():void
		{
			this._mainContent.mouseChildren = true;
		}
	
		
	// HANDLERs	
		
		/**
		 * Hendler of the click event from PavoMenu.
		 *  If the execution reach here, means that user open the PavoMenu, or close it,
		 *  or select one option.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function menuClickedHandler($e:MouseEvent):void
		{
//trace("menu clicked-----");


			if(!this._menuExpanded)
			{
				//trace("menu collpsed, so open menu, darken content.");
				this.darkenContent();
				this.lockContent();
			}
			else
			{
				//trace("menu expended, so close menu, brighten content.");
				this.brightenContent();
			}
			
			this._menuExpanded = !this._menuExpanded;
			
			if(undefined == $e.target.uid)
			{
				// change color of main content
				//trace("switcher");
				//this.unlockContent();
			}
			else
			{
				// nav content module
				/*
				trace("selected id: " + $e.target.uid);
				trace("previous Opened Module Id: " + this._prevOpenedModId);
				trace("opened Module Id: " + this._openedModId);
				*/
				if($e.target.uid != this._prevOpenedModId)	// only if the selected module is different from the current module
				{
					this._openedModId = $e.target.uid;
					this._shouldTweenModule = true;
				}
				else
				{
					this._shouldTweenModule = false;
				}
			}
			
		}
		
		
		private function txtBoxBuiltHandler($e:ModuleEvent):void
		{
			
			/*
			var $evt:ModuleEvent = new ModuleEvent(ModuleEvent.KELEIDO_BUILT);
			this.dispatchEvent($evt);
			*/
		}
		
		/**
		 * Hendler of the MEDIA_VIEW view event from Photo Gallery module.
		 *  Run the MediaViewer, to present the photos belong to the
		 *  selected album.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function mediaViewHandler($e:ViewEvent):void
		{
			this.lockContent();
			
			switch ($e.mediaType)
			{
				case "IMAGE":
					this.addChild(this._mediaViewer);
					this._mediaViewer.alpha = 0;
					this._mediaViewer.run(GlobalModelManager.albums[$e.aid].photos, $e.mediaType, $e.phid);
					this._mediaViewer.show();
					break;
				case "VIDEO":
					//trace($e);
					this.addChild(this._mediaViewer);
					this._mediaViewer.alpha = 0;
					this._mediaViewer.run(GlobalModelManager.movies, $e.mediaType, $e.phid);
					this._mediaViewer.show();
					break;
				default:
					break;
			}
			
			
		}
		
		
	// CALL-BACKs	
		
		private function onContentBrightnessComplete($action:String):void
		{
//trace("opened Module Id: " + this._openedModId);

			if (!this._shouldTweenModule)
			{
				this.unlockContent();
				return;
			}
			
			if("brightening" == $action && this._openedModId >= 0)
			{
				/* set up tweening animation to hide the module */
				if(this._prevOpenedModId >= 0)
				{
					TweenLite.to(
						 	this._modules[this._prevOpenedModId].module, 
							0.6, 
							{
								x: this._modules[this._prevOpenedModId].module.options.dismissedX,
								y: this._modules[this._prevOpenedModId].module.options.dismissedY,
								blurFilter: {
												blurX: this._modules[this._prevOpenedModId].module.options.dismissedBlrX,
												blurY: this._modules[this._prevOpenedModId].module.options.dismissedBlrY
											},
								ease: Cubic.easeOut, 
								onComplete: this.onContentMoveComplete,
								onCompleteParams: ["out", this._prevOpenedModId]
							}
					);
				}
				
				/* reset its init position and state */
				this._modules[this._openedModId].module.x = this._modules[this._openedModId].module.options.standbyX;
				this._modules[this._openedModId].module.y = this._modules[this._openedModId].module.options.standbyY;
/*				
trace("now inside onContentBrightnessComplete.....");
trace("opened Module Id: " + this._openedModId);				
trace("this._modules[this._openedModId]: " + this._modules[this._openedModId]);				
	*/			
				var $bulrFilter:BitmapFilter = new BlurFilter(this._modules[this._openedModId].module.options.standbyBlrX, this._modules[this._openedModId].module.options.standbyBlrY, BitmapFilterQuality.HIGH);
				var $filters:Array = new Array();
				$filters.push($bulrFilter);
				this._modules[this._openedModId].module.filters = $filters;
				
				/* add it to display list, and animate it */
				this._mainContent.addChild(this._modules[this._openedModId].module);
				TweenLite.to(
						 	this._modules[this._openedModId].module, 
							0.8, 
							{
								x: this._modules[this._openedModId].module.options.activeX,
								y: this._modules[this._openedModId].module.options.activeY,
								blurFilter: {
												blurX: this._modules[this._openedModId].module.options.activeBlrX,
												blurY: this._modules[this._openedModId].module.options.activeBlrY
											},
								ease: Cubic.easeInOut, 
								delay: 0.05,
								onComplete: this.onContentMoveComplete,
								onCompleteParams: ["in", -1]
							}
				);
								
			}
			else	// darkening 
			{
				
			}
			
		}
		
				
		private function onContentMoveComplete($action:String, $id:int):void
		{
/*
trace("now exet reach onContentMoveComplete");			
trace("$action is: " + $action);
trace("$id is: " + $id);

*/
			if("in" == $action)
			{
				this._prevOpenedModId = this._openedModId;
				this._openedModId = -1;
				this.unlockContent();
			}
			else if("out" == $action)
			{
				if($id >= 0)
				{
					this._mainContent.removeChild(this._modules[$id].module);
				}
			}
			
			//this.unlockContent();
			
		}
		
		
		private function onMediaViewerHided():void
		{
			this.removeChild(this._mediaViewer);
			this.unlockContent();
		}
		
		
		

	}
	
}
