/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.video 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.view.video.ControlPanel;
	import com.idsquare.vince.ikeleido.view.video.OverlayPlayButton;
	import com.idsquare.vince.utils.NumberUtil;
	import com.idsquare.vince.utils.TimeDisplayUtil;
	
	
	/**
	 * A video player be used in MediaViewer, as cloning YouTube on Android.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.video.ITubeVideoPlayer
	 * 
	 * 
	 * edit 0
	 *
	 */
		
	public class ITubeVideoPlayer extends Sprite
	{
		private var _stageHeight:uint = 1080;
		private var _stageWidth:uint = 1920;
		private var _initVideoHeight:uint = 360;
		private var _initVideoWidth:uint = 640;
		
		private var _initOverlayScale:Number = GlobalModelManager.VideoPlayer_Options.initPlaybuttonScale;
		
		private var _playerBackground:Sprite;
		private var _videoContainer:Sprite;
		private var _videofg:Sprite;
		private var _video:Video;
		
		/* video stream */
		private var _nc:NetConnection;
		private var _ns:NetStream;
		
		/* volume */
		private var _st:SoundTransform;
		private var _defaultInitialVol:Number = GlobalModelManager.VideoPlayer_Options.defInitVol;
		private var _goalVol:Number;
		/**
		 * url string of flv file
		 * @private
		 */
		private var _videoURL:String;
		
		/**
		 * keep track of the video playing state
		 * @private
		 */
		private var _currentStatus:String = "ready";
		
		/* video meta data */
		//private var _isDurationGot:Boolean = false;
		private var _duration:Number = -1;
		//private var _isDimensionGot:Boolean = false;
		private var _videoMetaWidth:Number = -1;
		private var _videoMetaHeight:Number = -1;
		private var _isArranged:Boolean = false;

		private var _ctrpanel:ControlPanel;
		private var _overlayPlay:OverlayPlayButton;
		
		/* timers */
		private var _videoTimer:Timer;
		private var _scrubTimer:Timer;
		private var _mouseStillTimer:Timer;
		private var _flvDimenLsnTimer:Timer;
		
		private var _timeDisplayPadding:uint = 10;
		private var _volCtrlFloatPadding:uint = 20;
		
		/* mouse still */
		private var _mouseStill:Number = 0;
		private var _mouseStillMax:Number = 3;

	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */
		public function ITubeVideoPlayer() 
		{
			this._playerBackground = new Sprite();
			this._playerBackground.graphics.beginFill(0x333333);
			this._playerBackground.graphics.drawRect(0, 0, this._stageWidth, this._stageHeight);
			this._playerBackground.graphics.endFill();
			this.addChild(this._playerBackground);
			
			this._video = new Video(this._initVideoWidth, this._initVideoHeight);
			this._video.smoothing = true;
			
			this._videofg = new Sprite();
			this._videofg.graphics.beginFill(0x444444, 0);
			this._videofg.graphics.drawRect(0, 0, this._initVideoWidth, this._initVideoHeight);
			this._videofg.graphics.endFill();
			
			this._nc = new NetConnection();
			this._nc.connect(null);
			this._ns = new NetStream(this._nc);
			
			this._videoContainer = new Sprite();
			this._videoContainer.addChild(this._video);
			this._videoContainer.addChild(this._videofg);
			
			this._st = new SoundTransform();
			this._st.volume = 1;
			this._ns.soundTransform = this._st;
			this._ns.client = this;
			this._ns.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusEvent);
			this._video.attachNetStream(this._ns);
			
			this.addChild(this._videoContainer);
			
			this._ctrpanel = new ControlPanel();
			this.addChild(this._ctrpanel);
			
			this.setVol(this._defaultInitialVol);
			
			this._overlayPlay = new OverlayPlayButton();
			this.addChild(this._overlayPlay);
			
			this._videoTimer = new Timer(100);
			this._scrubTimer = new Timer(100);
			this._mouseStillTimer = new Timer(1000);
			this._flvDimenLsnTimer = new Timer(33, 1);
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			
			this._video.visible = false;
			this._ctrpanel.visible = false;
			this._overlayPlay.visible = false;
		}
		
		
		/**
		 * 
		 * Set the volume of video, and reset the volume control apperance.	
		 *
		 * @public		 
		 */
		public function setVol($value:Number):void
		{
			if ($value < 0 || $value > 1) 
			{
				$value = 0;
				trace("volume input Error");
			}
			
			this._st.volume = $value;
			this._ns.soundTransform = this._st;
		
			this._ctrpanel.volumeCtrl.slider.fill.scaleY = $value;
			this._ctrpanel.volumeCtrl.slider.handle.y = $value * (-(this._ctrpanel.volumeCtrl.slider.bg.height - (this._ctrpanel.volumeCtrl.slider.handle.height/2)));
			
			if ($value != 0) 
			{
				if ($value <= 0.33) 
				{
					this._ctrpanel.volumeCtrl.speaker.gotoAndStop("low");
				}
				else if ($value <= 0.66) 
				{
					this._ctrpanel.volumeCtrl.speaker.gotoAndStop("medium");
				}
				else if ($value <= 1) 
				{
					this._ctrpanel.volumeCtrl.speaker.gotoAndStop("high");
				}
			}
			else 
			{
				this._ctrpanel.volumeCtrl.speaker.gotoAndStop("mute");
			}
			
		}
		
		
		/**
		 * Play the video, and reset the volume control apperance.	
		 *
		 * @public
		 */
		public function playDown($e:MouseEvent=null):void
		{
			//trace("begin playDown - currentStatus: " + this._currentStatus);
			
			/* because we don't want this disturbe the MediaViewer's Hide/Show ButtonPanel */
			if ($e)	// added by Vincent
			{
				$e.stopPropagation();	
			}
			
			
			var $cs:String = this._currentStatus;
			
			switch ($cs) 
			{
				case "ready":
				{
					this._videoTimer.start();
					this._ns.play(this._videoURL);
					this._currentStatus = "playing";
					this._overlayPlay.icon.gotoAndStop("paused");	
					this._mouseStill = 0;
					this._mouseStillTimer.start();
					break;
				}
				case "playing":
				{
					this._currentStatus = "paused";
					this._ns.pause();
					this._overlayPlay.icon.gotoAndStop("playing");	
					this._mouseStill = 0;
					this._mouseStillTimer.stop();
					break;
				}
				case "paused":
				{
					this._currentStatus = "playing";
					this._ns.resume();
					this._overlayPlay.icon.gotoAndStop("paused");
					this._mouseStill = 0;
					this._mouseStillTimer.start();
					break;
				}
				case "complete":
				{
					/* to refresh the total time display */
					//this._ctrpanel.timeTotal.timeDisplay.text = TimeDisplayUtil.secondsToTimeCode(this._duration);	// added by Vincent
					
					this._ns.seek(0);
					this._ns.resume();
					this._videoTimer.start();
					this._currentStatus = "playing";
					this._overlayPlay.icon.gotoAndStop("paused");
					this._mouseStill = 0;
					this._mouseStillTimer.start();
					break;
				}
				default:
				{
					trace("ERROR: " + this._currentStatus);
				}
			}
		}
		
		
		/**
		 * Clean up the vars values about playing loaded video, to set the current instance to its init status.	
		 *
		 * @public
		 */
		public function cleanUp():void
		{
			/* do some cleaning */
			this._ns.close();
			this._video.visible = false;
			
			this._videoTimer.stop();
			this._scrubTimer.stop();
			this._mouseStillTimer.stop();
			
			this._ctrpanel.bar.playbar.width = 0;
			this._ctrpanel.bar.scrub.x = 0;
			this._ctrpanel.timeCurrent.timeDisplay.text = TimeDisplayUtil.secondsToTimeCode(NaN);
			this._ctrpanel.timeTotal.timeDisplay.text = TimeDisplayUtil.secondsToTimeCode(NaN);
			
			this._overlayPlay.icon.gotoAndStop("playing");
			this._mouseStill = 0;
			
			/* not done */
			this._currentStatus = "ready";
			
			//this._isDurationGot = false;
			this._duration = -1;
			
			//this._isDimensionGot = false;
			this._videoMetaWidth = -1;
			this._videoMetaHeight = -1;
			
			this._isArranged = false;
		}
		
		
		/**
		 * Show/Hide VolumeControl on ControlPanel.	
		 *
		 * @private
		 */
		private function toggleVolumeSlider():void
		{
			this._ctrpanel.volumeCtrl.slider.visible = !this._ctrpanel.volumeCtrl.slider.visible;
		}
		
		
		/**
		 * To arrange the visuel elements on the stage: video, ControlPanel and OverlayPlayButton.	
		 *
		 * @private
		 */
		private function arrangeLayout():void
		{
			this.arrangeVideo();
			this.arrangeControlPanel();
			this.arrangeOverlayPlayButton();
		}

		
		/**
		 * Setup the tween animation to hide OverlayPlayButton.	
		 *
		 * @private
		 */
		private function hideOverlayPlay():void
		{
			this._overlayPlay.mouseEnabled = false;
			
			TweenLite.to(
						   	this._overlayPlay, 
							0.2, 
							{	
								"alpha": 0, 
								"scaleX": this._initOverlayScale * 0.8, 
								"scaleY": this._initOverlayScale * 0.8, 
								"ease": Back.easeOut
							}
					   );
		}
		
		
		/**
		 * Setup the tween animation to show OverlayPlayButton.	
		 *
		 * @private
		 */
		private function showOverlayPlay():void
		{
			TweenLite.to(
							this._overlayPlay, 
							0.2, 
							{
								"alpha": 1, 
								"scaleX": this._initOverlayScale, 
								"scaleY": this._initOverlayScale, 
								"ease": Back.easeOut, 
								"onComplete": this.onOverlayPlayShowed,
								"overwrite": false
							}
					   );
		}
		
		
		/**
		 * As invoked after OverlayPlayButton showed, enable its dispatching mouse event.	
		 *
		 * @private
		 */
		private function onOverlayPlayShowed():void
		{
			this._overlayPlay.mouseEnabled = true;
		}
		
		
		/**
		 * Show/Hide ControlPanel, it uses time display's property: visible -- to keep track of the status of ControlPanel's visiblity.
		 * OverlayPlayButton would be showed/hided together with ControlPanel.
		 *
		 * @private
		 */
		private function toggleControlPanel($e:MouseEvent=null):void
		{
			/* because we don't want this disturbe the MediaViewer's Hide/Show ButtonPanel */
			if ($e)	// added by Vincent
			{
				$e.stopPropagation();	
			}
			
			if (this._ctrpanel.timeCurrent.visible)
			{
				this.hideControlPanel();
				this.hideOverlayPlay();
			}
			else
			{
				this.showControlPanel();
				this.showOverlayPlay();
				this._mouseStill = 0;
			}
		}
		
		
		/**
		 * Setup the tween animation to hide ControlPanel, frobid its mouse event, and invisiblize time diaplay.	
		 *
		 * @private
		 */
		private function hideControlPanel($e:MouseEvent=null):void
		{
			this._ctrpanel.mouseChildren = false;
			
			TweenLite.to(
							this._ctrpanel, 
							2, 
							{
								"alpha": 0, 
								"ease": Quad.easeOut
							}
					   );
			
			this._ctrpanel.timeCurrent.visible = false;
			this._ctrpanel.timeTotal.visible = false;
		}

		
		/**
		 * Setup the tween animation to show ControlPanel, and visiblize time diaplay.	
		 *
		 * @private
		 */
		private function showControlPanel($e:MouseEvent=null):void
		{
			if (!this._ctrpanel.timeCurrent.visible) 
			{
				TweenLite.to(
							   	this._ctrpanel, 
								0.4, 
								{
									"alpha": 1, 
									"ease": Quad.easeOut,
									"onComplete": this.onControlPanelShowed
								}
						   );
										   
				this._ctrpanel.timeCurrent.visible = true;
				this._ctrpanel.timeTotal.visible = true;
			}
		}		
		
		
		/**
		 * As invoked after ControlPanel be showed, recover its mouse event, .	
		 *
		 * @private
		 */
		private function onControlPanelShowed():void
		{
			this._ctrpanel.mouseChildren = true;
		}
		
		
	// video events:
		/**
		 * As invoked when receive flv's meta data, store them.	
		 *
		 * @private
		 */
		public function onMetaData($obj:Object):void
		{
			// condition 1: that the data is standby, and elements are arranged
			if (this._isArranged)
			{	//trace("metadata: cond - 1");
				return;
			}
			
			//trace("metadata: cond - 2");
			// condition 2: that the data is not ready, and elements are not yet arranged
			if ( this._duration == -1 || this._duration == 0 || isNaN(this._duration) )	// must be as this, the boolean may be true, whereas the value is still invalid number 
			{
				// if duration is still invalid, then try to get it
				this._duration = Number($obj["duration"]);	// why do we suppose that the invalid value must be -1? can't it be NaN?			
			}
			
			if ( this._videoMetaWidth == -1 || this._videoMetaWidth == 0 || isNaN(this._videoMetaWidth) )
			{
				// if dimension is still invalid, then try to get it
				this._videoMetaWidth = Number($obj["width"]);
				this._videoMetaHeight = Number($obj["height"]);
			}
			
			// condition 2.A: that all the meta data is available, then arrange the elements, and mark the _isArranged 
			if ( this._videoMetaWidth > 0 && this._duration > 0 )
			{//trace("metadata: cond - 2.A");
				this._isArranged = true;
				this.arrangeLayout();
			}
			// condition 2.B: that some meta data is still invalid
			else
			{//trace("metadata: cond - 2.B");
				// condition 2.B.1: that some meta data is still invalid
				this._flvDimenLsnTimer.addEventListener(TimerEvent.TIMER, this.listenForFlvDimension);
				this._flvDimenLsnTimer.start();
			}
			
		}


		/**
		 * As invoked when receive flv's meta data, store them.	
		 *
		 * @private
		 */
		public function onXMPData($obj:Object):void
		{
			// condition 1: that the data is standby, and elements are arranged
			if (this._isArranged)
			{
				return;
			}
			
			// condition 2: that the data is not ready, and elements are not yet arranged
			if ( this._duration == -1 || this._duration == 0 || isNaN(this._duration) )	// must be as this, the boolean may be true, whereas the value is still invalid number 
			{
				// if duration is still invalid, then try to get it
				this._duration = Number($obj["duration"]);	// why do we suppose that the invalid value must be -1? can't it be NaN?			
			}
			
			if ( this._videoMetaWidth == -1 || this._videoMetaWidth == 0 || isNaN(this._videoMetaWidth) )
			{
				// if dimension is still invalid, then try to get it
				this._videoMetaWidth = Number($obj["width"]);
				this._videoMetaHeight = Number($obj["height"]);
			}
			
			// condition 2.A: that all the meta data is available, then arrange the elements, and mark the _isArranged 
			if ( this._videoMetaWidth > 0 && this._duration > 0 )
			{
				this._isArranged = true;
				this.arrangeLayout();
			}
			// condition 2.B: that some meta data is still invalid
			else
			{
				// do nothing, since the listener is already set up and is working
			}
		}
		
		
		/**
		 * Handler of NetStream or NetConnection status event. So far, only process one event that the video playing is completed.	
		 *
		 * @private
		 */
		private function onStatusEvent($e:Object):void
		{
			if ($e.info.code == "NetStream.Play.Stop") 
			{
				//trace("video stop fired");
				this.videoComplete();
			}
		}
		
		/**
		 * Arrange the layout of ControlPanel, resize its children and reposition them.	
		 *
		 * @private
		 */
		private function arrangeControlPanel():void
		{
			//trace("vcr is layouting...");
			
			var $tempCtrlWidth:Number = 0;
			
			if ( ((this._stageWidth - this._videoMetaWidth) / 2) < (this._ctrpanel.volumeCtrl.width + this._volCtrlFloatPadding) )	// how to asure this 20?
			{
				$tempCtrlWidth = this._stageWidth - (this._ctrpanel.volumeCtrl.width + this._volCtrlFloatPadding);
				
				this._ctrpanel.x = 0;
			}
			else
			{
				$tempCtrlWidth = this._videoMetaWidth;
				this._ctrpanel.x = this._videoContainer.x;
			}
			
			this._ctrpanel.bar.background.width = $tempCtrlWidth;
			this._ctrpanel.bar.bar.width = $tempCtrlWidth;
			
			var $tempCtrlPanelY:int = this._videoContainer.y + this._videoContainer.height + 60;	// how to asure this 60?
			
			if ( $tempCtrlPanelY >= (this._stageHeight-this._ctrpanel.height) )
			{
				this._ctrpanel.y = this._stageHeight-this._ctrpanel.height;
			}
			else
			{
				this._ctrpanel.y = $tempCtrlPanelY;
			}
			
			this._ctrpanel.timeTotal.timeDisplay.text = TimeDisplayUtil.secondsToTimeCode(this._duration);
			this._ctrpanel.timeTotal.x = $tempCtrlWidth - this._ctrpanel.timeTotal.width;
			this._ctrpanel.volumeCtrl.x = $tempCtrlWidth + this._volCtrlFloatPadding;
			
			this._ctrpanel.volumeCtrl.slider.visible = false;
			this._ctrpanel.visible = true;
		}
		
		
		/**
		 * Arrange the layout of ControlPanel, resize its children and reposition them.	
		 *
		 * @private
		 */
		private function arrangeVideo():void
		{
			/* original size */
			
			this._video.width = this._videoMetaWidth;
			this._video.height = this._videoMetaHeight;
			
			/* full screen */
			/*
			
			this._video.width = this._stageWidth;
            this._video.height = this._stageHeight;
			
			if ( this._video.scaleX <  this._video.scaleY) 
			{
				this._video.scaleY =  this._video.scaleX;
			}
			else 
			{
				this._video.scaleX =  this._video.scaleY;
			}
			
			this._videofg.width = this._video.width;
			this._videofg.height = this._video.height;
			*/
			
			this._videofg.width = this._video.width;
			this._videofg.height = this._video.height;
			
			// reposition the video container in the center
			this._videoContainer.x = (this._stageWidth - this._videoContainer.width) / 2;
			this._videoContainer.y = (this._stageHeight - this._videoContainer.height) / 2;
			
			this._video.visible = true;
		}
		
		
		/**
		 * Arrange the layout of OverlayPlayButton, resize it and reposition it.	
		 *
		 * @private
		 */
		private function arrangeOverlayPlayButton():void
		{
			this._overlayPlay.scaleY = this._initOverlayScale;
			this._overlayPlay.scaleX = this._initOverlayScale;
			this._overlayPlay.x = this._stageWidth / 2;
			this._overlayPlay.y = this._stageHeight / 2;
			this._overlayPlay.visible = true;
		}
		
		
		/**
		 * Be invoked when playing is completed, to clear something.	
		 *
		 * @private
		 */
		private function videoComplete():void
		{
			this._ns.pause();
			this._currentStatus = "complete";
			this.showOverlayPlay();
			this.showControlPanel();
			this.clearVideoStatus();
		}		
		
		
		/**
		 * Be invoked by videoComplete().	
		 *
		 * @private
		 */
		private function clearVideoStatus($e:TimerEvent=null):void
		{
			this._videoTimer.stop();
			this._overlayPlay.icon.gotoAndStop("playing");
			this._ctrpanel.bar.playbar.width = 0;
			this._ctrpanel.bar.scrub.x = 0;
			this._ctrpanel.timeCurrent.timeDisplay.text = TimeDisplayUtil.secondsToTimeCode(NaN);
			//this._ctrpanel.timeTotal.timeDisplay.text = TimeDisplayUtil.secondsToTimeCode(NaN);
			
			this._mouseStill = 0;  
            this._mouseStillTimer.stop();
			
		}
		
		
	// HANDLERS:
		
		/**
		 * Event handler for the ADDED_TO_STAGE on this, set up the listeners.
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
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			
			this._videoTimer.addEventListener(TimerEvent.TIMER, this.videoTimerHandler);
			this._scrubTimer.addEventListener(TimerEvent.TIMER, this.scrubTimerHandler);
			
			this._videofg.addEventListener(MouseEvent.MOUSE_DOWN, this.toggleControlPanel);
			this._overlayPlay.addEventListener(MouseEvent.MOUSE_DOWN, this.playDown);
			
			this._ctrpanel.bar.loadbar.addEventListener(MouseEvent.MOUSE_DOWN, this.jumpPressHandler);
			this._ctrpanel.bar.background.addEventListener(MouseEvent.MOUSE_DOWN, this.jumpPressHandler);
			this._ctrpanel.bar.playbar.addEventListener(MouseEvent.MOUSE_DOWN, this.jumpPressHandler);
			this._ctrpanel.bar.scrub.addEventListener(MouseEvent.MOUSE_DOWN, this.scrubPressHandler);
			
			this._mouseStillTimer.addEventListener(TimerEvent.TIMER, this.mouseStatusTimerHandler);
			
			this._ctrpanel.volumeCtrl.hitArea.addEventListener(MouseEvent.MOUSE_DOWN, this.volControlDownHandler);
			this._ctrpanel.volumeCtrl.slider.handle.addEventListener(MouseEvent.MOUSE_DOWN, this.handlePressHandler);
			this._ctrpanel.volumeCtrl.slider.fill.addEventListener(MouseEvent.MOUSE_DOWN, this.volPressHandler);
			this._ctrpanel.volumeCtrl.slider.bg.addEventListener(MouseEvent.MOUSE_DOWN, this.volPressHandler);		
		}
		
		
		/**
		 * Event handler for the REMOVED_FROM_STAGE on this, clean up the listeners.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function removedFromStageHandler($e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			
			this._videoTimer.removeEventListener(TimerEvent.TIMER, this.videoTimerHandler);
			this._scrubTimer.removeEventListener(TimerEvent.TIMER, this.scrubTimerHandler);
			
			this._videofg.removeEventListener(MouseEvent.MOUSE_DOWN, this.toggleControlPanel);
			this._overlayPlay.removeEventListener(MouseEvent.MOUSE_DOWN, this.playDown);
			
			this._ctrpanel.bar.loadbar.removeEventListener(MouseEvent.MOUSE_DOWN, this.jumpPressHandler);
			this._ctrpanel.bar.background.removeEventListener(MouseEvent.MOUSE_DOWN, this.jumpPressHandler);
			this._ctrpanel.bar.playbar.removeEventListener(MouseEvent.MOUSE_DOWN, this.jumpPressHandler);
			this._ctrpanel.bar.scrub.removeEventListener(MouseEvent.MOUSE_DOWN, this.scrubPressHandler);
			
			this._mouseStillTimer.removeEventListener(TimerEvent.TIMER, this.mouseStatusTimerHandler);
			
			this._ctrpanel.volumeCtrl.hitArea.removeEventListener(MouseEvent.MOUSE_DOWN, this.volControlDownHandler);
			this._ctrpanel.volumeCtrl.slider.handle.removeEventListener(MouseEvent.MOUSE_DOWN, this.handlePressHandler);
			this._ctrpanel.volumeCtrl.slider.fill.removeEventListener(MouseEvent.MOUSE_DOWN, this.volPressHandler);
			this._ctrpanel.volumeCtrl.slider.bg.removeEventListener(MouseEvent.MOUSE_DOWN, this.volPressHandler);		
			
			this.cleanUp();
		}
		
		
		/**
		 * Event handler for the TimerEvent on VideoTimer, to update the playing bar and scrub position on ControlPanel.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function videoTimerHandler($e:TimerEvent=null):void
		{
			var $length:int = NumberUtil.map(this._ns.time, 0, this._duration, 0, this._videoMetaWidth);
			
			this._ctrpanel.bar.loadbar.width = NumberUtil.map(this._ns.bytesLoaded, 0, this._ns.bytesTotal, 0, this._videoMetaWidth);
			this._ctrpanel.bar.scrub.x = $length;
			this._ctrpanel.bar.playbar.width = $length;
			
			
			this._ctrpanel.timeCurrent.timeDisplay.text = TimeDisplayUtil.secondsToTimeCode(this._ns.time);
		}	
		
		
		/**
		 * Event handler for the MOUSE_DOWN event on ControlPanel's bars, to seek some point of playback.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function jumpPressHandler($e:MouseEvent):void
		{
			/* because we don't want this disturbe the MediaViewer's Hide/Show ButtonPanel */
			$e.stopPropagation();	// added by Vincent
			
			var $pos:Number = this._ctrpanel.bar.mouseX / this._ctrpanel.bar.bar.width * this._duration;
			this._ns.seek($pos);
		}
		
		
		/**
		 * Event handler for the MOUSE_MOVE event on ControlPanel's Scrub when it is being dragged, to seek some point of playback.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function scrubDragHandler($e:MouseEvent):void
		{
			$e.updateAfterEvent();
		}
		
		
		/**
		 * Event handler for the MOUSE_DOWN event on ControlPanel's Scrub, to set up drag.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function scrubPressHandler($e:MouseEvent):void
		{
			/* because we don't want this disturbe the MediaViewer's Hide/Show ButtonPanel */
			$e.stopPropagation();	// added by Vincent
			
			this._ctrpanel.bar.scrub.removeEventListener(MouseEvent.MOUSE_DOWN, scrubPressHandler);
			
			var $rect:Rectangle = new Rectangle(
													this._ctrpanel.bar.loadbar.x, 
													this._ctrpanel.bar.scrub.y, 
													this._ctrpanel.bar.loadbar.x + this._ctrpanel.bar.loadbar.width, 
													0
												);
												
			this._ctrpanel.bar.scrub.startDrag(true, $rect);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, scrubReleaseHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, scrubDragHandler);
			
			this._videoTimer.stop();
			this._scrubTimer.start();
		}
		
		
		/**
		 * Event handler for the MOUSE_UP event on ControlPanel's Scrub, to clean up drag.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function scrubReleaseHandler($e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, scrubReleaseHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrubDragHandler);
			
			this._scrubTimer.stop();
			this._videoTimer.start();
			
			this._ctrpanel.bar.scrub.stopDrag();
			this._ctrpanel.bar.scrub.addEventListener(MouseEvent.MOUSE_DOWN, scrubPressHandler);
		}		
		
		
		/**
		 * Event handler for the TimerEvent event on ScrubTimer, to update playback and playbar.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function scrubTimerHandler($e:TimerEvent):void
		{
			this._ns.seek(Math.floor(this._ctrpanel.bar.scrub.x / this._ctrpanel.bar.bar.width * this._duration));
			
			this._ctrpanel.bar.playbar.width = this._ctrpanel.bar.scrub.x;
		}
		
		
		/**
		 * Event handler for the MOUSE_DOWN event on Volume Control Button, show/hide volume slider.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function volControlDownHandler($e:MouseEvent):void
		{
			/* because we don't want this disturbe the MediaViewer's Hide/Show ButtonPanel */
			$e.stopPropagation();	// added by Vincent
			
			this.toggleVolumeSlider();
		}
		
		
		/**
		 * Event handler for the MOUSE_DOWN event on Volume Control Slider, to set volume by jumping to one point.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function volPressHandler($e:MouseEvent=null):void
		{
			/* because we don't want this disturbe the MediaViewer's Hide/Show ButtonPanel */
			$e.stopPropagation();	// added by Vincent
			
			this._goalVol = this._ctrpanel.volumeCtrl.slider.mouseY / (-this._ctrpanel.volumeCtrl.slider.bg.height);
			this.setVol(this._goalVol);
		}
		
		
		/**
		 * Event handler for the MOUSE_DOWN event on Volume Control-Slider-Handle, to set up drag on it.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function handlePressHandler($e:MouseEvent):void
		{
			/* because we don't want this disturbe the MediaViewer's Hide/Show ButtonPanel */
			$e.stopPropagation();	// added by Vincent
			
			this._ctrpanel.volumeCtrl.slider.handle.removeEventListener(MouseEvent.MOUSE_DOWN, handlePressHandler);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, handleReleaseHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleDragHandler);
			
			var $rect:Rectangle = new Rectangle(
													this._ctrpanel.volumeCtrl.slider.handle.x, 
													0, 
													0, 
													-this._ctrpanel.volumeCtrl.slider.bg.height + (this._ctrpanel.volumeCtrl.slider.handle.height/2)
													//-this._ctrpanel.volumeCtrl.slider.bg.height
												);
			
			this._ctrpanel.volumeCtrl.slider.handle.startDrag(true, $rect);
		}
		
		
		/**
		 * Event handler for the MOUSE_UP event on Volume Control-Slider-Handle, to clear up drag on it.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function handleReleaseHandler($e:MouseEvent):void
		{
			this._ctrpanel.volumeCtrl.slider.handle.addEventListener(MouseEvent.MOUSE_DOWN, handlePressHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleReleaseHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDragHandler);
			this._ctrpanel.volumeCtrl.slider.handle.stopDrag();
		}

		
		/**
		 * Event handler for the MOUSE_MOVE event on Volume Control-Slider-Handle, to update volume.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function handleDragHandler($e:MouseEvent):void
		{
			this.setVol(
				 	 	 this._ctrpanel.volumeCtrl.slider.handle.y / 
					 		( -(this._ctrpanel.volumeCtrl.slider.bg.height - (this._ctrpanel.volumeCtrl.slider.handle.height/2)) )
					   );
			$e.updateAfterEvent();
		}
		
		
		/**
		 * Event handler for the TimerEvent on MouseStillTimer, to calculate if it is time to hide ControlPanel.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function mouseStatusTimerHandler($e:TimerEvent):void
		{
			if (mouseY < this._ctrpanel.y || mouseY > this._ctrpanel.height + this._ctrpanel.y) 
			{
				this._mouseStill++;
			}
			if (this._mouseStill > this._mouseStillMax) 
			{
				this._mouseStill = 0;
				this.hideControlPanel();
				this.hideOverlayPlay();
			}
		}	
		
		
		/**
		 * Event handler for the TimerEvent on flvDimenLsnTimer, to grab the video's meta data.
		 * 
		 * @param	$e	
		 * 
		 * @see		
		 *
		 * @private
		 */
		private function listenForFlvDimension($e:TimerEvent = null):void
		{
			if (this._isArranged)
			{	
				this._flvDimenLsnTimer.removeEventListener(TimerEvent.TIMER, this.listenForFlvDimension);
				return;
			}
			
			if( this._video.videoWidth > 0 && this._video.videoHeight > 0 )
			{
				this._flvDimenLsnTimer.removeEventListener(TimerEvent.TIMER, this.listenForFlvDimension);
				
				this._videoMetaWidth = this._video.videoWidth;
				this._videoMetaHeight = this._video.videoHeight;
				this._isArranged = true;
				this.arrangeLayout();
			}
			else
			{
				this._flvDimenLsnTimer.reset();
				this._flvDimenLsnTimer.start();
			}			
		}
		
	// ACCESSORS:	
		
		public function set videoURL($value:String):void
		{
			this._videoURL = $value;
		}
		
	}
	
}
