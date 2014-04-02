/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.viewer 
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.view.viewer.Photo;
	import com.idsquare.vince.ikeleido.view.video.ITubeVideoPlayer;
	import com.idsquare.vince.ikeleido.view.viewer.ButtonPanel;
	import com.idsquare.vince.ikeleido.view.viewer.TextHolder;
	
	import com.greensock.*;
	import com.greensock.easing.*
	
	/**
	 * The container of the thumb-nails in Photo Gallery module.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.viewer.MediaViewer
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class MediaViewer extends Sprite 
	{
		/**
		 * array of images' data, or videos' 
		 * @private
		 */
		private var _mediaData:Vector.<Object>;
		/**
		 * image or video
		 * @private
		 */
		private var _mediaType:String;
		/**
		 * keep track of which media is previously present
		 * @private
		 */
		private var _prevMediaId:int;
		/**
		 * keep track of which media is currently present
		 * @private
		 */
		private var _currentMediaId:int;
		/**
		 * keep track of which media is next present
		 * @private
		 */
		private var _nextMediaId:int;
		/**
		 * photos array
		 * @private
		 */
		private var _photos:Vector.<Photo>;
		/**
		 * a container of the photo MC instances
		 * @private
		 */
		private var _photosBoard:Sprite;
		/**
		 * total amount of images within the current album
		 * @private
		 */
		private var _totImgs:uint;
		/**
		 * a function executed after the hiding animation is finished
		 * @private
		 */
		private var _hideCallback:Function;
		/**
		 * width of one Photo MC instance
		 * @private
		 */
		private var PHOTO_STAGE_WIDTH:uint = GlobalModelManager.photoOptions.width;
		private var PHOTO_STAGE_HEIGHT:uint = GlobalModelManager.photoOptions.height;
		/**
		 * less than how long will be ignored
		 * @private
		 */
		private var SENSITIVITY:int = GlobalModelManager.devOptions.deviceSensitivity;
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
		private var _boardStartX:Number = 0;
		/**
		 * the right most position of the page-container, means its x property must be larger than this
		 * @private
		 */
		private var _minBoundry:Number;
		/**
		 * the left most position of the page-container, means its x property must be less than this
		 * @private
		 */
		private var _maxBoundry:Number;
		
		/**
		 * @private
		 */
		private var _buttonPanel:ButtonPanel;
		/**
		 * @private
		 */
		private var _isPanelShowing:Boolean;
		/**
		 * @private
		 */
		private var _isDescShowing:Boolean;
		
	// for videos:
	
		/**
		 * video player
		 * @private
		 */
		private var _videoPlayer:ITubeVideoPlayer;
		
	// CONSTRUCTOR:
	
		/**
		 * Constructor.
		 */
		public function MediaViewer($hided:Function) 
		{
			this._photosBoard = new Sprite();
			this._buttonPanel = new ButtonPanel();
			this._buttonPanel.x = GlobalModelManager.mediaViewerUiOptions.panelPosX;
			this._buttonPanel.y = PHOTO_STAGE_HEIGHT;
			this._buttonPanel.closeButton.addEventListener(MouseEvent.MOUSE_DOWN, this.closeButtonHandler);
			this._buttonPanel.infoButton.addEventListener(MouseEvent.MOUSE_DOWN, this.stopPropagationHandler);
			this._hideCallback = $hided;
			/*
			this._description = new TextHolder();
			this._description.visible = false;
			*/
		}
		
		/**
		 * Initialize, to the video player.
		 */
		public function init():void
		{
			this._videoPlayer = new ITubeVideoPlayer();
		}
		
		/**
		 * Show itself, and button panel.
		 */
		public function show():void
		{
			TweenLite.to(
							 	this, 
								0.45, 
								{
									alpha: 1, 
									ease: Circ.easeOut,
									onComplete: this.onShowed
								}
							 );
							 
			TweenLite.to(
							 	this._buttonPanel, 
								0.25, 
								{
									y: this._buttonPanel.activeY, 
									ease: Circ.easeOut
								}
							 ); 
		}
		
		/**
		 * Hide itself, and button panel.
		 */
		public function hide():void
		{
			this.lock();
			
			TweenLite.to(
							 	this, 
								0.45, 
								{
									alpha: 0, 
									ease: Circ.easeOut,
									onComplete: this.onHided
								}
							 );
			TweenLite.to(
							 	this._buttonPanel, 
								0.25, 
								{
									y: PHOTO_STAGE_HEIGHT, 
									ease: Circ.easeOut
								}
							 );
		}
		
		/**
		 * Hide/Show the button panel.
		 *
		 * @private
		 */
		private function togglePanel():void
		{
			if (this._isPanelShowing)
			{
				TweenLite.to(
							 	this._buttonPanel, 
								0.25, 
								{
									y: PHOTO_STAGE_HEIGHT, 
									ease: Circ.easeOut,
									onComplete: this.onPanelHided
								}
							 );
			}
			else
			{
				TweenLite.to(
							 	this._buttonPanel, 
								0.25, 
								{
									y: this._buttonPanel.activeY, 
									ease: Circ.easeOut,
									onComplete: this.onPanelHided
								}
							 ); 
			}
		}
		
		/**
		 * Hide/Show the button panel.
		 */
		private function resetAll():void
		{			
			
			if ( this._mediaType == "IMAGE"  )
			{
				// clear array of photos, but will it only clear the references to Photos, or will the Photo instances be destoryed as well?
				if (this.contains(this._photosBoard))
				{
					this.removeChild(this._photosBoard);
				}
				this._photosBoard = null;
				if (this._photos)
				{
					this._photos.length = 0;
				}
				
				// deattach these listeners, because we may show video next time, and in case of video, we don't need these listeners
				this._buttonPanel.infoButton.removeEventListener(MouseEvent.CLICK, this.infoButtonHandler);
				this._buttonPanel.infoButton.removeEventListener(MouseEvent.MOUSE_OUT, this.stopPropagationHandler);
				this._buttonPanel.infoButton.removeEventListener(MouseEvent.MOUSE_UP, this.stopPropagationHandler);
				
				if ( this.hasEventListener(MouseEvent.MOUSE_DOWN) )
				{
					this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
				}
			}
			else
			{
				if (this.contains(this._videoPlayer))
				{
					this.removeChild(this._videoPlayer);
				}
				
				if ( this.hasEventListener(MouseEvent.MOUSE_DOWN) )
				{
					this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownVideoHandler);
				}
			}
		}
		
		/**
		 * Build up all the Photo instances.
		 * 
		 * @param	$medias	array of the data about the media items	
		 * @param	$type	String, "photo" or "image"
		 * @param	$mid	id of the media file
		 *
		 *
		 */
		public function run($medias:Vector.<Object>, $type:String, $mid:uint):void
		{
			this._photosBoard = new Sprite();
			this._mediaData = $medias;
			this._mediaType = $type;
			this._currentMediaId = $mid;
			
			this._totImgs = this._mediaData.length;
						
			if (this._mediaType == "IMAGE")
			{
				this._photos = new Vector.<Photo>(this._totImgs);
				
				if (this._totImgs <= 3 && this._totImgs > 0)
				{
					for (var $j:uint=0; $j<this._totImgs; $j++)
					{
						this._photos[$j] = new Photo(GlobalModelManager.PHOTO_BIG_PATH + this._mediaData[$j].big.toString(), this._mediaData[$j].desc.toString());
						this._photos[$j].x = PHOTO_STAGE_WIDTH * $j;
						this._photosBoard.addChild(this._photos[$j]);
					}
					
					this._photosBoard.x = -PHOTO_STAGE_WIDTH * this._currentMediaId;
					
					this._minBoundry = PHOTO_STAGE_WIDTH - this._photosBoard.width;
					this._maxBoundry = 0;
					
					this.addChild(this._photosBoard);
					this.addChild(this._buttonPanel);
					
				}
				else if (this._totImgs > 3)
				{
					this._prevMediaId = this._currentMediaId - 1;
					if (this._prevMediaId<0) 
					{
						this._prevMediaId = this._totImgs - 1;
					}
					
					this._nextMediaId = this._currentMediaId + 1;
					if (this._nextMediaId >= this._totImgs) 
					{
						this._nextMediaId = 0;
					}
					
					this._photos[this._prevMediaId] = new Photo(GlobalModelManager.PHOTO_BIG_PATH + this._mediaData[this._prevMediaId].big.toString(), this._mediaData[this._prevMediaId].desc.toString());
					this._photos[this._prevMediaId].x = -PHOTO_STAGE_WIDTH;
					this._photosBoard.addChild(this._photos[this._prevMediaId]);
					
					//
					this._photos[this._currentMediaId] = new Photo(GlobalModelManager.PHOTO_BIG_PATH + this._mediaData[this._currentMediaId].big.toString(), this._mediaData[this._currentMediaId].desc.toString());
					this._photos[this._currentMediaId].x = 0;
					this._photosBoard.addChild(this._photos[this._currentMediaId]);
					
					//
					this._photos[this._nextMediaId] = new Photo(GlobalModelManager.PHOTO_BIG_PATH + this._mediaData[this._nextMediaId].big.toString(), this._mediaData[this._nextMediaId].desc.toString());
					this._photos[this._nextMediaId].x = PHOTO_STAGE_WIDTH;
					this._photosBoard.addChild(this._photos[this._nextMediaId]);
					
					this._minBoundry = -PHOTO_STAGE_WIDTH;
					this._maxBoundry = PHOTO_STAGE_WIDTH;
					
					this.addChild(this._photosBoard);
					this.addChild(this._buttonPanel);
				}
				
				this._buttonPanel.infoButton.addEventListener(MouseEvent.CLICK, this.infoButtonHandler);
				this._buttonPanel.infoButton.addEventListener(MouseEvent.MOUSE_OUT, this.stopPropagationHandler);
				this._buttonPanel.infoButton.addEventListener(MouseEvent.MOUSE_UP, this.stopPropagationHandler);
			
				if (this._totImgs > 1)
				{
					this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
				}
				
			}
			else if (this._mediaType == "VIDEO")
			{
				this.addChild(this._videoPlayer);
				this._videoPlayer.videoURL = GlobalModelManager.MOVIE_VIDEO_PATH + this._mediaData[this._currentMediaId].videourl.toString();
				this.addChild(this._buttonPanel);
				
				this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownVideoHandler);
			}
			
		}
		
		
		/**
		 * tween the photos board.
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function slideBoard():void
		{
			if(this._photosBoard.x < this._maxBoundry && this._photosBoard.x > this._minBoundry)
			{
				var $direction:Number = this._photosBoard.x - this._boardStartX;
				var $target:Number;
				var $p:int;
				if($direction > 0)// right
				{
					$target = this._boardStartX + PHOTO_STAGE_WIDTH;
					$p = -1;
				}
				else if($direction < 0)// left
				{
					$target = this._boardStartX - PHOTO_STAGE_WIDTH;
					$p = 1;
				}
				
				this.lock();
				
				TweenLite.to(
							 	this._photosBoard, 
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
		 * Lock itself, forbidden mouse events.
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
		 * Unlock itself, recover mouse events.
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
		
		/**
		 * Toggle description element of Photo.
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function toggleDesc():void
		{
			/**/
			this._isDescShowing = !this._isDescShowing;
			
			this._photos[this._currentMediaId].toggleDesc();
			this._photos[this._nextMediaId].toggleDesc();
			this._photos[this._prevMediaId].toggleDesc();
						
		}
		
		
	// CALLBACKS:
	
		/**
		 * called at the photo board be slided.
		 * 
		 * @param	$p	augment of page index	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function onPagesSlided($p:int):void
		{
			//this._boardStartX = 0;
			
			if (this._totImgs > 3)
			{
			
				if ($p > 0)	// move to left hand side
				{
					this._photos[this._currentMediaId].x = -PHOTO_STAGE_WIDTH;
					this._photos[this._nextMediaId].x = 0;
					this._photosBoard.x = 0;
					
					this._photosBoard.removeChild(this._photos[this._prevMediaId]);
					
					this._currentMediaId++;
					if (this._currentMediaId == this._totImgs) 
					{
						this._currentMediaId = 0;
					}
					
					this._nextMediaId++;
					if (this._nextMediaId == this._totImgs) 
					{
						this._nextMediaId = 0;
					}
					
					this._prevMediaId++;
					if (this._prevMediaId == this._totImgs) 
					{
						this._prevMediaId = 0;
					}
					
					if (this._photos[this._nextMediaId] == null)
					{
						this._photos[this._nextMediaId] = new Photo(GlobalModelManager.PHOTO_BIG_PATH + this._mediaData[this._nextMediaId].big.toString(), this._mediaData[this._nextMediaId].desc.toString());
					}
					
					this._photos[this._nextMediaId].x = PHOTO_STAGE_WIDTH;
					this._photosBoard.addChild(this._photos[this._nextMediaId]);
					
					// added 25th
					if (this._isDescShowing)
					{
						this._photos[this._nextMediaId].showDesc();
					}
					else
					{
						this._photos[this._nextMediaId].hideDesc();
					}
					
				}
				else	// move to right hand side
				{
					this._photos[this._currentMediaId].x = PHOTO_STAGE_WIDTH;
					this._photos[this._prevMediaId].x = 0;
					this._photosBoard.x = 0;
					
					this._photosBoard.removeChild(this._photos[this._nextMediaId]);
					
					this._currentMediaId--;
					if (this._currentMediaId == -1) 
					{
						this._currentMediaId = this._totImgs - 1;
					}
					
					this._nextMediaId--;
					if (this._nextMediaId == -1) 
					{
						this._nextMediaId = this._totImgs - 1;
					}
					
					this._prevMediaId--;
					if (this._prevMediaId == -1) 
					{
						this._prevMediaId = this._totImgs - 1;
					}
					
					if (this._photos[this._prevMediaId] == null)
					{
						this._photos[this._prevMediaId] = new Photo(GlobalModelManager.PHOTO_BIG_PATH + this._mediaData[this._prevMediaId].big.toString(), this._mediaData[this._prevMediaId].desc.toString());
					}
					
					this._photos[this._prevMediaId].x = -PHOTO_STAGE_WIDTH;
					this._photosBoard.addChild(this._photos[this._prevMediaId]);
					
					// added 25th
					if (this._isDescShowing)
					{
						this._photos[this._prevMediaId].showDesc();
					}
					else
					{
						this._photos[this._prevMediaId].hideDesc();
					}
					
				}

			}
			
			this.unlock();
		}		
		
		
		/**
		 * called at the photo board be slided.
		 * 
		 * @param	$p	augment of page index	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function onShowed():void
		{
			this.unlock();
			this._isPanelShowing = true;
			
			if (this._mediaType == "VIDEO")
			{
				this._videoPlayer.playDown();
			}
		}
		
		
		/**
		 * called at the photo board be slided.
		 * 
		 * @param	$p	augment of page index	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function onHided():void
		{
			this.resetAll();
			this._hideCallback();
		}
		
		
		
		private function onPanelHided():void
		{
			this._isPanelShowing = !this._isPanelShowing;
			
			if (this._isPanelShowing)
			{
				this._buttonPanel.unlock();
			}
			else
			{
				this._buttonPanel.lock();
			}
		}
		
		
	// HANDLERS:
	
		/**
		 * Event handler for the MOUSE_DOWN on this.
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
			this._mouseDownPosX = this.mouseX;
			this._boardStartX = this._photosBoard.x;
			
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
			var $movement:Number = this.mouseX - this._mouseDownPosX;
			var $x:Number = this._boardStartX + $movement;
			
			/* restrict the pageContainer's position, within its range */
			$x = Math.min(this._maxBoundry, $x);
			$x = Math.max(this._minBoundry, $x);
			
			/* move the photos board towards mouse position */
			this._photosBoard.x = $x;
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
			
			//
			if ( Math.abs(this.mouseX - this._mouseDownPosX) < SENSITIVITY )	// user intends to toggle button panel
			{
				this.togglePanel();
			}
			else	// user intends to drag pages
			{
				if ( this._photosBoard.x % PHOTO_STAGE_WIDTH == 0 )	// should never happen here!, 
				/* 
				 * actually, this always happen, when image amount is less than 3, means, drag to the boundary 
				 * of where the board can never cuccess.
				 */
				{
					//trace("no need to tween");
					// set current page
					if (this._photosBoard.x > this._boardStartX)
					{
						//this._currentPage++; 
					}
					else
					{
						//this._currentPage--;
					}
				}
				else
				{
					slideBoard();
				}
			
			}
			
			this._boardStartX = 0;
			this._mouseDownPosX = 0;			
		}
		
		/**
		 * Event handler for the MOUSE_DOWN on this, in case of VIDEO.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseDownVideoHandler($e:MouseEvent):void
		{
			this.togglePanel();
		}
		
		
		/**
		 * Event handler for the MOUSE_CLICK on close button, hide this.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function closeButtonHandler($e:MouseEvent):void
		{
			$e.stopPropagation();
			this.hide();
		}
		
		/**
		 * Event handler for the MOUSE_CLICK on info button, hide/show description holder.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function infoButtonHandler($e:MouseEvent):void
		{
			$e.stopPropagation();
			this.toggleDesc();
		}
		
		
		private function stopPropagationHandler($e:MouseEvent):void
		{
			$e.stopPropagation();
		}
		

	}
	
}
