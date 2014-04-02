/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.photogallery 
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.view.photogallery.ThumbsGrid;
	
	/**
	 * The container of sigle photo album cover.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.photogallery.Album
	 * 
	 * 
	 * edit 0
	 *
	 */
	public class Album extends Sprite
	{
		/**
		 * @public
		 */
		public var uid:uint;
		/**
		 * @public
		 */
		public var thumbsGrid:ThumbsGrid;
		/**
		 * @public
		 */
		public var clickedHandler:Function;
		
	// CONSTRUCTOR:
		/**
		 * Constructor.
		 */
		public function Album() 
		{
			var $numOfPiee:uint = GlobalModelManager.photoAlbumSkins.length;
			if ($numOfPiee > 0)
			{
				for (var $k:int=$numOfPiee-1; $k>=0; $k--)	// add each predesign element to 
				{
					var $paBm:Bitmap = new Bitmap(GlobalModelManager.photoAlbumSkins[$k].ui);
					$paBm.smoothing = GlobalModelManager.photoAlbumSkins[0].smooth;
														
					var $paHolder:Sprite = new Sprite();
					$paHolder.addChild($paBm);
					$paHolder.x = GlobalModelManager.photoAlbumSkins[$k].x;
					$paHolder.y = GlobalModelManager.photoAlbumSkins[$k].y;
					$paHolder.alpha = GlobalModelManager.photoAlbumSkins[$k].alpha;
					$paHolder.rotation = GlobalModelManager.photoAlbumSkins[$k].rotation;
					$paHolder.blendMode = GlobalModelManager.photoAlbumSkins[$k].blendmode;
							
					this.addChild($paHolder);
				}
			}
			
			this.mouseChildren = false;
			
			//this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
	// HANDLERS:
	
		/**
		 * Event handler for the ADD_TO_STAGE.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function addedToStageHandler($e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.addEventListener(MouseEvent.CLICK, this.clickedHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}	
		
		
		/**
		 * Event handler for the REMOVED_FROM_STAGE.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function removedFromStageHandler($e:Event):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			this.removeEventListener(MouseEvent.CLICK, this.clickedHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}	

	}
	
}
