/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageDisplayState;
	
	import com.idsquare.vince.ikeleido.model.InitializationManager;
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	
	import com.idsquare.vince.ikeleido.events.LoadingEvent; 
	import com.idsquare.vince.ikeleido.events.ModuleEvent; 
	
	import com.idsquare.vince.ikeleido.view.Preloader;
	
	import com.idsquare.vince.ikeleido.view.Keleido;
	
	
	/**
	 * The entry point of the whole App.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.main
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class main extends MovieClip
	{
	// init utility:		
		/**
		 * @private
		 */
		private var _initMgr:InitializationManager;
		
	// visual elements:	
		
		
		/**
		 * @private
		 */
		private var _keleido:Keleido;
		
		/**
		 * @private
		 */
		private var _preloader:Preloader = new Preloader();
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */	
		public function main() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		
	// HANDLERS:
	
		/**
		 * Event handler for the addedToStageHandler event, start init process.
		 * .
		 * 
		 * @param	$e	
		 * 
		 * @private
		 */		
		private function addedToStageHandler($e:Event):void
		{
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			this._preloader.x = stage.width / 2;
			this._preloader.y = stage.height / 2;
			
			this.addChild(this._preloader);
			
			this._initMgr = new InitializationManager(this._preloader);
			this._initMgr.addEventListener(LoadingEvent.INIT_FINISHED, this.initFinishedHandler);
			this._initMgr.initialize();
		}
		
		
		/**
		 * Event handler for the initFinished event of InitializationManager.
		 *  Time to create the visual elements.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function skinLoadedHandler($e:LoadingEvent):void
		{
			//trace("V");
			this._initMgr.removeEventListener(LoadingEvent.SKIN_LOADED, this.skinLoadedHandler);
			
			
			
		}

		
				
		/**
		 * Event handler for the initFinished event of InitializationManager.
		 *  Time to create the visual elements.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function initFinishedHandler($e:LoadingEvent):void
		{		
			this._keleido = new Keleido();
			this._keleido.build();
			this.addChildAt(this._keleido, 1);
			this._preloader.fadeAway();
			/*
			this._keleido.addEventListener(ModuleEvent.KELEIDO_BUILT, this.keleidoBuiltHandler);
			this._keleido.build();
			*/
			
		}
		
		
		private function keleidoBuiltHandler($e:ModuleEvent):void
		{	
			
		}
		
		
		
	}
	
}
