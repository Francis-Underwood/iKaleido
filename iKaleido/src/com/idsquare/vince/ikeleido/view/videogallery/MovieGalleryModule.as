/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.videogallery 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.view.videogallery.MovieThumbsGrid;
	
	/**
	 * The top container of the movie gallery.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.videogallery.MovieGalleryModule
	 * 
	 * 
	 * edit 0
	 *
	 */
		
	public class MovieGalleryModule extends Sprite
	{
		/**
		 * would be accessed laterly
		 * @public
		 */
		public var options:Object;
		/**
		 * keep track of current in-stage movie-board
		 * @private
		 */
		private var _movieThumbsGrid:MovieThumbsGrid;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */		
		public function MovieGalleryModule() 
		{
			// constructor code
		}
		
		
		public function build():void 
		{
			this.options = GlobalModelManager.movieGalleryUiOptions;
			
			var $numOfPie:uint = GlobalModelManager.movieGallerySkins.length;
			
			/****************************************
			 * form its visual body
			 ***************************************/
			if ($numOfPie > 0)
			{
				for (var $j:int=$numOfPie-1; $j>=0; $j--)	// add each predesign element to 
				{
					var $bm:Bitmap = new Bitmap(GlobalModelManager.movieGallerySkins[$j].ui);
					$bm.smoothing = GlobalModelManager.movieGallerySkins[$j].smooth;
						
					var $holder:Sprite = new Sprite();
					$holder.addChild($bm);
					$holder.x = GlobalModelManager.movieGallerySkins[$j].x;
					$holder.y = GlobalModelManager.movieGallerySkins[$j].y;
					$holder.alpha = GlobalModelManager.movieGallerySkins[$j].alpha;
					$holder.rotation = GlobalModelManager.movieGallerySkins[$j].rotation;
					$holder.blendMode = GlobalModelManager.movieGallerySkins[$j].blendmode;
						
					this.addChild($holder);
				}
			}
			
			this._movieThumbsGrid = new MovieThumbsGrid();
			this._movieThumbsGrid.build();
			this.addChild(this._movieThumbsGrid);
		}
		
		
		

	}
	
}
