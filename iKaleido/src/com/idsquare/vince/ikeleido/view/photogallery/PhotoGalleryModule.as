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
	import com.idsquare.vince.ikeleido.events.ModuleEvent;
	import com.idsquare.vince.ikeleido.view.photogallery.Album;
	import com.idsquare.vince.ikeleido.view.photogallery.ThumbsGrid;
	import com.idsquare.vince.ikeleido.view.BackButton;
	
	import com.greensock.*;
	import com.greensock.easing.*
	/* for test only */
	//import com.hexagonstar.util.debug.Debug;
	/**
	 * The top container of the photo gallery.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.photogallery.PhotoGalleryModule
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class PhotoGalleryModule extends Sprite
	{
		/**
		 * @public
		 */
		public var options:Object;
		/**
		 * @private
		 */	
		private var _albumsContainer:Sprite = new Sprite();
		/**
		 * @private
		 */	
		private var _albums:Vector.<Album>;
		/**
		 * @private
		 */	
		//private var _photoCons:Array = new Array();
		
	// variables related to pages:
		/**
		 * @private
		 */	
		private var _pages:Vector.<Sprite> = new Vector.<Sprite>();
		/**
		 * @private
		 */
		private var _numOfPage:uint;
		/**
		 * @private
		 */
		private var _pageWidth:uint;
		/**
		 * @private
		 */
		private var _pageHeight:uint;
		/**
		 * @private
		 */
		private var _pageMovement:uint;
		/**
		 * @private
		 */
		private var _pagePosX:int;
		/**
		 * @private
		 */
		private var _pagePosY:int;
		/**
		 * page container
		 * @private
		 */	
		private var _pageContainer:Sprite;
		/**
		 * mask of page
		 * @private
		 */	
		private var _pageMask:Sprite;
	// interaction with users:	
		/**
		 * keep track of which page is present currently
		 * @private
		 */	
		private var _currentPage:uint;
		/**
		 * @private
		 */
		private var _isDragging:Boolean;
		/**
		 * the x position of mouse when it pressed
		 * @private
		 */
		private var _mouseDownPosX:Number = 0;
		/**
		 * the x position of page-container when MouseDown event occures
		 * @private
		 */
		private var _contStartX:Number = 0;
		/**
		 * the right most position of the page-container, means its x property must be larger than this
		 * @private
		 */
		private var _minBoundry:Number;
		
		/**
		 * keep track of which album is just clicked
		 * @private
		 */
		private var _clickAlbum:Boolean = false;
		/**
		 * keep track of current in-stage photos-board
		 * @private
		 */
		private var _currentThumbsGrid:ThumbsGrid;
		
		private var SENSITIVITY:int = GlobalModelManager.devOptions.deviceSensitivity;
		
		private var _backButton:BackButton;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */
		
		public function PhotoGalleryModule() 
		{
			//build();
		}
		
		
		public function build():void 
		{
			this.options = GlobalModelManager.photoGalleryUiOptions;
			
			this._backButton = new BackButton();
			this._backButton.x = GlobalModelManager.backButtonUiOptions.activeX;
			this._backButton.y = GlobalModelManager.backButtonUiOptions.activeY;
			
			this._pagePosX = GlobalModelManager.photoAlbumUiOptions.left;
			this._pagePosY = GlobalModelManager.photoAlbumUiOptions.top;
			
			var $numOfPie:uint = GlobalModelManager.photoGallerySkins.length;
			
			/****************************************
			 * form its visual body
			 ***************************************/
			if ($numOfPie > 0)
			{
				for (var $j:int=$numOfPie-1; $j>=0; $j--)	// add each predesign element to 
				{
					var $bm:Bitmap = new Bitmap(GlobalModelManager.photoGallerySkins[$j].ui);
					$bm.smoothing = GlobalModelManager.photoGallerySkins[$j].smooth;
						
					var $holder:Sprite = new Sprite();
					$holder.addChild($bm);
					$holder.x = GlobalModelManager.photoGallerySkins[$j].x;
					$holder.y = GlobalModelManager.photoGallerySkins[$j].y;
					$holder.alpha = GlobalModelManager.photoGallerySkins[$j].alpha;
					$holder.rotation = GlobalModelManager.photoGallerySkins[$j].rotation;
					$holder.blendMode = GlobalModelManager.photoGallerySkins[$j].blendmode;
						
					this._albumsContainer.addChild($holder);
				}
			}
			
			
			/* build albums */
			if (GlobalModelManager.albums.length > 0)
			{
				this._albums = new Vector.<Album>();
				
				/* form the visual elements */
				var $totalPerPage:uint = GlobalModelManager.photoAlbumUiOptions.numOfRow * GlobalModelManager.photoAlbumUiOptions.numOfCol;
				this._pageContainer = new Sprite();
				var $page:Sprite = new Sprite();
				
				for (var $i:uint=0; $i<GlobalModelManager.albums.length; $i++)
				{
					var $album:Album = new Album();
					$album.addChildAt(GlobalModelManager.albums[$i].options.image, GlobalModelManager.photoAlbumUiOptions.cusZindex);
					
					/* calculate its position within page, per page */
					var $pageIndx:uint = $i % $totalPerPage;

					$album.x = ($pageIndx % GlobalModelManager.photoAlbumUiOptions.numOfCol) * (GlobalModelManager.photoAlbumUiOptions.modWidth + GlobalModelManager.photoAlbumUiOptions.hSpace);
					$album.y = Math.floor($pageIndx / GlobalModelManager.photoAlbumUiOptions.numOfCol) * (GlobalModelManager.photoAlbumUiOptions.modHeight + GlobalModelManager.photoAlbumUiOptions.vSpace);
					$album.uid = $i;
					
					/* this approach is not more efficient finally */
					//$album.clickedHandler = this.albumMouseClickHandler;
					$album.addEventListener(MouseEvent.CLICK, this.albumMouseClickHandler);
					
					/* add album to array */
					this._albums.push($album);
					/* if the previous page is full, then create a new page */
					if ( ($i > 0) && ($pageIndx == 0) )
					{
						this._pageWidth = $page.width;
						this._pageHeight = $page.height;
						
						$page = new Sprite();
						$page.x = Math.floor($i/$totalPerPage) * (this._pageWidth + GlobalModelManager.photoAlbumUiOptions.hSpace);
						//$page.y = this._pagePosY;
					}
					
					$page.addChild($album);
					if ($pageIndx == 0)
					{
						this._pages.push($page);
					}
				}
				
				this._numOfPage = this._pages.length;
				this._pageContainer.x = this._pagePosX;
				this._pageContainer.y = this._pagePosY;
				this._pageMovement = this._pageWidth + GlobalModelManager.photoAlbumUiOptions.hSpace;
				/*
				Debug.trace("this._pageMovement: "+this._pageMovement);
				*/
				for each (var $p:Sprite in this._pages)
				{
					this._pageContainer.addChild($p);
				}
				
				/* cache it */
				this._pageContainer.cacheAsBitmap = true;
				
				/* apply mask if there are more than one page */
				this._albumsContainer.addChild(this._pageContainer);
				
				if (this._numOfPage > 1)
				{
					this._pageMask = new Sprite();
					this._pageMask.graphics.beginFill(0x33FFFF);
					this._pageMask.graphics.drawRect(0, 0, this._pageWidth, this._pageHeight);
					this._pageMask.graphics.endFill();
					this._pageMask.x = this._pagePosX; 
					this._pageMask.y = this._pagePosY;
					
					this._pageContainer.mask = this._pageMask;
					this._albumsContainer.addChild(this._pageMask);
				
					/* set up the interaction logics with user */
					this._currentPage = 0;	// this index indicate the rendered page currently, and it is used to calculate the position of page-container
				
					this._minBoundry = (- this._pageMovement * (this._numOfPage-1)) + this._pagePosX;
				}
					
				this.addChild(this._albumsContainer);
				
				/*
				Debug.trace("this.width: "+this.width);
				Debug.trace("this.height: "+this.height);
				Debug.trace("this._pageWidth: "+this._pageWidth);
				Debug.trace("this._pageHeight: "+this._pageHeight);
				Debug.trace("this._pagePosX: "+this._pagePosX);
				Debug.trace("this._pagePosY: "+this._pagePosY);
				*/
				
			}	// end if there are albums
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		
		/**
		 * tween the page container.
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function slidePages():void
		{
			if(this._pageContainer.x < this._pagePosX && this._pageContainer.x > this._minBoundry)
			{
				var $direction:Number = this._pageContainer.x - this._contStartX;
				var $target:Number;
				var $p:int;
				if($direction > 0)// right
				{
					$target = this._contStartX + this._pageMovement;
					$p = -1;
				}
				else if($direction < 0)// left
				{
					$target = this._contStartX - this._pageMovement;
					$p = 1;
				}
				
				this.lock();
				
				TweenLite.to(
							 	this._pageContainer, 
								0.55, 
								{
									x:$target, 
									ease:Circ.easeOut,
									onComplete: this.onPagesSlided,
									onCompleteParams: [$p]
								}
							 );
			}
		}
		
		
		/**
		 * Hide albums-container.
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function hideAlbumsShowThumbs($albId:uint):void
		{
			this.lock();
				
			TweenLite.to(
							this._albumsContainer, 
							0.35, 
							{
								alpha: 0, 
								ease:Circ.easeOut,
								onComplete: this.onAlbumsContHided,
								onCompleteParams: [$albId]
							}
						);
		}
		
		
		/**
		 * Hide current thumbs grid.
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function hideThumbsShowAlbums():void
		{
			this.lock();
				
			TweenLite.to(
							this._currentThumbsGrid, 
							0.25, 
							{
								alpha: 0, 
								ease:Circ.easeOut,
								onComplete: this.onThumbsGridHided
							}
						);
		}
		
		
		/**
		 * Hide albums-container.
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function buildPhotoGallery($albumId:uint):void
		{
			
			// create photo mc
			/**/
			if (this._albums[$albumId].thumbsGrid)
			{
				this._currentThumbsGrid = this._albums[$albumId].thumbsGrid;
			}
			else
			{
				this._albums[$albumId].thumbsGrid = new ThumbsGrid();
				this._albums[$albumId].thumbsGrid.build($albumId);
				this._currentThumbsGrid = this._albums[$albumId].thumbsGrid;
			}
			
			this.addChild(this._currentThumbsGrid);
			this._currentThumbsGrid.show();
			
			this.addChild(this._backButton);
			this._backButton.addEventListener(MouseEvent.CLICK, this.backBtnMouseClickHandler);
			
			this.unlock();
			// start to load the image
			
			// add it, tween it
						
		}
		
		
		/**
		 * disable mouse event.
		 * 
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function lock():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		
		/**
		 * enable mouse event.
		 * 
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function unlock():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		
	// CALLBACKS:
	
		/**
		 * called at the page container be slided.
		 * 
		 * @param	$p	augment of page index	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function onPagesSlided($p:int):void
		{
			this._contStartX = 0;
			this._clickAlbum = false;
			this._currentPage += $p;
			this.unlock();
		}
		
		
		/**
		 * called at the albums container be hided.
		 * 
		 * @param	$p	augment of page index	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function onAlbumsContHided($aId:uint):void
		{
			this.buildPhotoGallery($aId);
		}
		
		
		/**
		 * called at the current thumb grid be hided.
		 * 
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function onThumbsGridHided():void
		{
			this.removeChild(this._currentThumbsGrid);
			this._currentThumbsGrid = null;
			this.removeChild(this._backButton);
			
			TweenLite.to(
							this._albumsContainer, 
							0.25, 
							{
								alpha: 1, 
								ease:Circ.easeOut,
								onComplete: this.unlock
							}
						);
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
			if (this._numOfPage > 1)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			}
		}
		
		
		/**
		 * Event handler for the MOUSE_DOWN on page mask.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseDownHandler($e:MouseEvent):void
		{
			/* reset vars */
			this._isDragging = true;
			this._mouseDownPosX = this._pageMask.mouseX;
			this._contStartX = this._pageContainer.x;
			/* attach listeners */
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseUpHandler);
		}
		
		
		/**
		 * Event handler for the MOUSE_MOVE on page mask.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseMoveHandler($e:MouseEvent):void
		{
			var $movement:Number = this._pageMask.mouseX - this._mouseDownPosX;
			
			/* restrict the pageContainer's movement, only slide one page per one tap gesture */
			var $absMovement = Math.abs($movement);
			if ($absMovement > this._pageMovement)
			{
				$movement = this._pageMovement * ($absMovement/$movement);
			}
			
			/* if the movement distance is less than 4, then we consider user might intend to select album */
			if ( Math.abs($movement) < SENSITIVITY )
			{
				return;
			}
			
			var $x:Number = this._contStartX + $movement;
			/* restrict the pageContainer's position, within its range */
			$x = Math.min(this._pagePosX, $x);
			$x = Math.max(this._minBoundry, $x);
			
			this._pageContainer.x = $x;
		}
		
		
		/**
		 * Event handler for the MOUSE_UP on page mask.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseUpHandler($e:MouseEvent):void
		{
			this._isDragging = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseUpHandler);
			
			if ( Math.abs(this._pageMask.mouseX - this._mouseDownPosX) < SENSITIVITY )	// user intends to click album
			{
				/* if detect user intends to select album, then regisiter it globally, then laterly it can be processed */
				this._clickAlbum = true;
			}
			else	// user intends to drag pages
			{
				this._clickAlbum = false;
				
				if ((this._pageContainer.x-this._pagePosX) % this._pageMovement == 0)
				{
					//trace("no need to tween");
					// set current page
					if (this._pageContainer.x > this._contStartX)
					{
						this._currentPage++; 
					}
					else
					{
						this._currentPage--;
					}
				
					this._contStartX = 0;
				}
				else
				{
					slidePages();
				}
			
			}
			
			this._mouseDownPosX = 0;			
		}
		
		
		/**
		 * Event handler for the MOUSE_CLICK on album.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function albumMouseClickHandler($e:MouseEvent):void
		{
			$e.stopPropagation();
			
			if (this._numOfPage > 1)
			{
				if (this._clickAlbum)
				{
					//trace("album dis: " + $e.target.uid);
					this._clickAlbum = false;
					
					this.hideAlbumsShowThumbs($e.target.uid);
				}
				else
				{
					//$e.stopPropagation();
					return;
				}	
			}
			/*
			 * no matter that if the user intend to do what, 
			 * there is sole one page, it must be to select a album
			 */
			else
			{
				this.hideAlbumsShowThumbs($e.target.uid);
				//$e.stopPropagation();
			}
					
		}
		
		
		/**
		 * Event handler for the MOUSE_CLICK on back button.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function backBtnMouseClickHandler($e:MouseEvent):void
		{
			this._backButton.removeEventListener(MouseEvent.CLICK, this.backBtnMouseClickHandler);
			this.hideThumbsShowAlbums();
		}
		
		

	}
	
}
