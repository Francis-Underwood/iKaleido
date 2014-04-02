/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view 
{
	
	import flash.display.MovieClip;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.TweenPlugin; 
	import com.greensock.plugins.ColorMatrixFilterPlugin; 

	
	/**
	 * The MovieClip of preloading animation.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.Preloader
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class Preloader extends MovieClip 
	{
		
		/**
		 * @private
		 */
 		private var _prompt:String;

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  .
		 */		
		public function Preloader() 
		{
			TweenPlugin.activate([ColorMatrixFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.
		}
		
		
		/**
		 * Start the animation that hidding self.
		 * 
		 * 
		 * @see		
		 *
		 */		
		public function fadeAway() 
		{
			promptTxt.text = "";
			
			/* set up the animation of hiding the preloader */
			var $preldrTimeline:TimelineLite = new TimelineLite(
																{
																	useFrames: true, 
																	onComplete: this.onfadeAwayComplete
																}
																);
			
			
			$preldrTimeline.append(
								   	new TweenLite(
												  colorWheel, 
												  GlobalModelManager.preloaderAnimation.colorWheel.tw1Duration, 	// duration in frames
												  {
													  scaleX: GlobalModelManager.preloaderAnimation.colorWheel.tw1ScaleRatio, 
													  scaleY: GlobalModelManager.preloaderAnimation.colorWheel.tw1ScaleRatio, 
													  ease: Quad.easeIn, 
													  colorMatrixFilter: {
														 				 hue: GlobalModelManager.preloaderAnimation.colorWheel.tw1Hue
														 				 }
												  }
												  )
								   );
			
			$preldrTimeline.insert(
								   new TweenLite(
												 colorWheel, 
												 GlobalModelManager.preloaderAnimation.colorWheel.tw2Duration,	// duration in frames
												 {
													 scaleX: GlobalModelManager.preloaderAnimation.colorWheel.tw2ScaleRatio, 
													 scaleY: GlobalModelManager.preloaderAnimation.colorWheel.tw2ScaleRatio, 
													 colorMatrixFilter: {
																		 brightness: GlobalModelManager.preloaderAnimation.colorWheel.tw2Brightness, 
																		 saturation: GlobalModelManager.preloaderAnimation.colorWheel.tw2Saturation
																		 }, 
													 ease: Quad.easeOut
												 }
												 ),
								   GlobalModelManager.preloaderAnimation.colorWheel.tw2Position	// position in frames
								   ); 
			
			$preldrTimeline.insert(
								   new TweenLite(
												 colorWheel, 
												 GlobalModelManager.preloaderAnimation.colorWheel.tw3Duration,	// duration in frames
												 {
													 colorMatrixFilter: {
																		 contrast: GlobalModelManager.preloaderAnimation.colorWheel.tw3Contrast
														 				}, 
													 ease: Quad.easeInOut
												 }
												 ), 
								   GlobalModelManager.preloaderAnimation.colorWheel.tw3Position	// position in frames
								   ); 
			
			$preldrTimeline.insert(
								   new TweenLite(
												 colorWheel, 
												 GlobalModelManager.preloaderAnimation.colorWheel.tw4Duration,	// duration in frames
												 {
													 alpha: GlobalModelManager.preloaderAnimation.colorWheel.tw4Alpha, 
													 ease: Cubic.easeIn
												 }
												 ), 
								   GlobalModelManager.preloaderAnimation.colorWheel.tw4Position	// position in frames
								   ); 
		}
		
		
		
	// HANDLERS:
	
	
	
	// CALLBACKS:
	
		/**
		 * Call-back method excuted when the animation is finished.
		 * 
		 * @see		
		 *
		 * @private
		 */	
		private function onfadeAwayComplete():void
		{
			//trace(this.alpha);
			//trace(colorWheel.alpha);
			
			// remove self from display-list
			this.parent.removeChild(this);
		}
		
		
	// ACCESSORS:		
		public function set prompt($value:String):void 
		{
			this._prompt = $value;
			promptTxt.text = $value;
		}
		
		
		
	}
	
}
