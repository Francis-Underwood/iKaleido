/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.photogallery 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.view.photogallery.PhotoThumbnail;
	import com.idsquare.vince.ikeleido.events.ViewEvent;
	
	import com.greensock.*;
	import com.greensock.easing.*
	
	/**
	 * The container of the thumb-nails in Photo Gallery module.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.photogallery.ThumbsGrid
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class ThumbsGrid extends Sprite
	{
		/**
		 * @private
		 */
		private var _photoItems:Vector.<Object>;
		/**
		 * @private
		 */
		private var _numOfPhotos:uint;
		/**
		 * @private
		 */
		private var _thumbs:Vector.<PhotoThumbnail> = new Vector.<PhotoThumbnail>();
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
		private var _tittleFormat:TextFormat;
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
		 * page container
		 * @private
		 */	
		private var _pageContainer:Sprite;
		/**
		 * mask of page
		 * @private
		 */	
		private var _pageMask:Sprite;
		
	// arrangement parameters:	
		private var ROW = GlobalModelManager.photoThumbUiOptions.numOfRow;
		private var COL = GlobalModelManager.photoThumbUiOptions.numOfCol;
		private var TOT = ROW * COL;
		private var HORSPACE = GlobalModelManager.photoThumbUiOptions.hSpace;
		private var VERSPACE = GlobalModelManager.photoThumbUiOptions.vSpace;
	
		/**
		 * @private
		 */
		private var _gridTimeline:TimelineLite;
	
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
		 * keep track of which PhotoThumbnail is just clicked
		 * @private
		 */
		private var _clickPhoto:Boolean = false;
		/**
		 * less than how long will be ignored
		 * @private
		 */
		private var SENSITIVITY:int = GlobalModelManager.devOptions.deviceSensitivity;
		/**
		 * album id
		 * @public
		 */
		public var albumID:uint;
		
	// CONSTRUCTOR:
		/**
		 * Constructor.
		 */
		public function ThumbsGrid() 
		{
			this._tittleFormat = new TextFormat();
			this._tittleFormat.align = TextFormatAlign.LEFT;
			this._tittleFormat.bold = GlobalModelManager.photoThumbUiOptions.labelBold;
			this._tittleFormat.color = GlobalModelManager.photoThumbUiOptions.labelColor;   
			this._tittleFormat.font = GlobalModelManager.photoThumbUiOptions.labelFont;
			this._tittleFormat.size = GlobalModelManager.photoThumbUiOptions.labelSize;
		}
		
		public function build($albumId:uint):void
		{
			this.albumID = $albumId;
			
			this._photoItems = GlobalModelManager.albums[this.albumID].photos;
			this._numOfPhotos = this._photoItems.length;
			//trace();
			
			/* shall we just do this simple check? */
			if (this._numOfPhotos == 0)
			{
				return;
			}
						
			var $page:Sprite = new Sprite();
			
			/* build up photo mc for each item, add them to page and arrange them */
			for (var $pi:uint=0; $pi<this._numOfPhotos; $pi++)
			{
				/* create the visual parts of each Photo MC */
				var $thumbnail:PhotoThumbnail = new PhotoThumbnail(this._photoItems[$pi], this._tittleFormat);
				$thumbnail.uid = $pi;
								
				this._thumbs.push($thumbnail);
				
				/* position */
				var $indexWithinPage:uint = $pi % TOT;
				
				$thumbnail.x = ($indexWithinPage % COL) * (HORSPACE + $thumbnail.width);
				$thumbnail.y = Math.floor($indexWithinPage / COL) * (VERSPACE + $thumbnail.height);
				$thumbnail.addEventListener(MouseEvent.CLICK, this.photoClickedHandler);
				
				if ( ($indexWithinPage==0) && ($pi>0) )
				{
					this._pageWidth = $page.width;
					this._pageHeight = $page.height;
						
					$page = new Sprite();
					$page.x = Math.floor($pi/TOT) * (this._pageWidth + HORSPACE);
				}
				
				$page.addChild($thumbnail);
				
				if ($indexWithinPage == 0)
				{
					this._pages.push($page);
				}
	
			}
			
			this._numOfPage = this._pages.length;
			this._pageMovement = this._pageWidth + HORSPACE;
			
			/* build up page container, and mask */
			this._pageContainer = new Sprite();
			
			for each (var $p in this._pages)
			{
				this._pageContainer.addChild($p);
			}
			
			this.addChild(this._pageContainer);
			this._pageContainer.cacheAsBitmap = true;
			
			if (this._numOfPage > 1)
			{
				this._pageMask = new Sprite();
				this._pageMask.graphics.beginFill(0x33FFFF);
				this._pageMask.graphics.drawRect(0, 0, this._pageWidth + GlobalModelManager.photoThumbUiOptions.maskExtraHor, this._pageHeight + GlobalModelManager.photoThumbUiOptions.maskExtraVer);
				this._pageMask.graphics.endFill();
				//this._pageMask.x = this._pagePosX; 
				//this._pageMask.y = this._pagePosY;
					
				this._pageContainer.mask = this._pageMask;
				this.addChild(this._pageMask);
				
				/* set up the interaction logics with user */
				this._currentPage = 0;	// this index indicate the rendered page currently, and it is used to calculate the position of page-container
				
				this._minBoundry = (- this._pageMovement * (this._numOfPage-1));
			}
			
			/* set up slinding in animation timeline */
			this._gridTimeline = new TimelineLite({onComplete:this.onGridTimelineCompleted});  
			this._gridTimeline.gotoAndStop(1);
			
			var $firPageAmt:uint = Math.min(TOT, this._numOfPhotos);
			
			for (var $c:uint=0; $c<$firPageAmt; $c++)
			{
				this._thumbs[$c].activeY = this._thumbs[$c].y;
				this._thumbs[$c].y += GlobalModelManager.photoThumbUiOptions.timelineOffsetY;
				this._thumbs[$c].alpha = 0;
				
				this._gridTimeline.insert(    
                                    new TweenLite(    
                                                    this._thumbs[$c],    
                                                    GlobalModelManager.photoThumbUiOptions.timelineDuration,    
                                                    {  
                                                        y: this._thumbs[$c].activeY,
														alpha: 1,   
                                                        ease: Quint.easeOut  
                                                    }    
                                                  ) ,  
                                    (GlobalModelManager.photoThumbUiOptions.timelineDelay * $c)  
                                ); 
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}
		
		
		public function show():void
		{
			this.reArrange();	
			this.lock();
			this._gridTimeline.restart();
		}
		
		
		private function reArrange():void
		{
			this._currentPage = 0;
			this._pageContainer.x = 0;
			this.alpha = 1;
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
			if(this._pageContainer.x < 0 && this._pageContainer.x > this._minBoundry)
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
			this._clickPhoto = false;
			this._currentPage += $p;
			this.unlock();
		}		
		
		
		/**
		 * called at the init sliding in animation be finished.
		 * 
		 * @param	$p	augment of page index	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function onGridTimelineCompleted():void
		{
			this.unlock();
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
		 * Event handler for the MOUSE_DOWN on this, the mouse position is calculated based on mask.
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
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpOutHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseUpOutHandler);
		}
		
		
		/**
		 * Event handler for the MOUSE_MOVE on this, the mouse position is calculated based on mask.
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
			$x = Math.min(0, $x);
			$x = Math.max(this._minBoundry, $x);
			this._pageContainer.x = $x;
		}
		
		
		/**
		 * Event handler for the MOUSE_UP on this, the mouse position is calculated based on mask.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseUpOutHandler($e:MouseEvent):void
		{
			this._isDragging = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseUpOutHandler);
			
			if ( Math.abs(this._pageMask.mouseX - this._mouseDownPosX) < SENSITIVITY )	// user intends to click album
			{
				/* if detect user intends to select album, then regisiter it globally, then laterly it can be processed */
				this._clickPhoto = true;
			}
			else	// user intends to drag pages
			{
				this._clickPhoto = false;
				
				if ( this._pageContainer.x % this._pageMovement == 0 )
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
		 * Event handler for the MOUSE_CLICK on photo.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function photoClickedHandler($e:MouseEvent):void
		{
			var $eve:ViewEvent;
			
			if (this._numOfPage < 2)	// in the case that only one page exists, no need to drag 
			{
				$e.stopPropagation();
				$eve = new ViewEvent(ViewEvent.MEDIA_VIEW, this.albumID, $e.target.uid, "IMAGE");
				this.dispatchEvent($eve);
				return;
			}
			
			if (this._clickPhoto)	// in the case that more than one page exist, dragging events work
			{
				this._clickPhoto = false;
				// this time maybe should dispatch custom event
				//trace("album: " + this.albumID + ", photo: " + $e.target.uid);
				$e.stopPropagation();
				$eve = new ViewEvent(ViewEvent.MEDIA_VIEW, this.albumID, $e.target.uid, "IMAGE");
				this.dispatchEvent($eve);
			}
			else
			{
				$e.stopPropagation();
				return;
			}
			
			
		}



		
	}
	
}
