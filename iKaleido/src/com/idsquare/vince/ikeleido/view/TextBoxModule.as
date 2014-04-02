/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view 
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.ikeleido.events.ModuleEvent;
	
	import com.idsquare.vince.utils.HTMLPrinter;
	
	/**
	 * The top container of the text box.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.TextBoxModule
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class TextBoxModule extends Sprite 
	{
		/**
		 * @private
		 */
		private var _htmlPrinter:HTMLPrinter;
		/**
		 * @private
		 */
		private var _url:String;
		/**
		 * @private
		 */
		private var _modId:uint;
		/**
		 * @private
		 */
		private var _textHolder:Sprite;
		/**
		 * @private
		 */
		private var _textMask:Sprite;
		/**
		 * indicates the top most value of the Text's y position 
		 * @private
		 */
		private var _verticalBoundary:Number;
		/**
		 * keep track of the y position of the cursor, when mouse pressed down 
		 * @private
		 */
		private var _mouseDownPos:Number;
		/**
		 * keep track of the y position of the Text, when mouse pressed down 
		 * @private
		 */
		private var _txtPos_Pressed:Number;
		/**
		 * @public
		 */
		public var options:Object;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */		
		public function TextBoxModule($url:String, $modId:uint) 
		{
			this._url = $url;
			this._modId = $modId;
		}
		
		
		public function build():void 
		{
			this.options = GlobalModelManager.textBoxUiOptions;
			
			var $numOfPie:uint = GlobalModelManager.textBoxSkins.length;
			
			/****************************************
			 * form its visual body
			 ***************************************/
			if ($numOfPie > 0)
			{
				for (var $j:int=$numOfPie-1; $j>=0; $j--)	// add each predesign element to 
				{
					var $bm:Bitmap = new Bitmap(GlobalModelManager.textBoxSkins[$j].ui);
					$bm.smoothing = GlobalModelManager.textBoxSkins[$j].smooth;
						
					var $holder:Sprite = new Sprite();
					$holder.addChild($bm);
					$holder.x = GlobalModelManager.textBoxSkins[$j].x;
					$holder.y = GlobalModelManager.textBoxSkins[$j].y;
					$holder.alpha = GlobalModelManager.textBoxSkins[$j].alpha;
					$holder.rotation = GlobalModelManager.textBoxSkins[$j].rotation;
					$holder.blendMode = GlobalModelManager.textBoxSkins[$j].blendmode;
						
					this.addChild($holder);
				}
			}
			
			// get the HTML content
			this._htmlPrinter = new HTMLPrinter(GlobalModelManager.textBoxUiOptions.txtWidth, 10, this._url);
			this._htmlPrinter.addEventListener(HTMLPrinter.HTML_PRINTED, this.htmlPrintedHandler);
			this._htmlPrinter.printHTML();
		}
	
	
		public function lockMouse():void 
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
		}
	
	// HANDLERS:
		private function htmlPrintedHandler($e:Event):void
		{
			// clear listener
			this._htmlPrinter.removeEventListener(HTMLPrinter.HTML_PRINTED, this.htmlPrintedHandler);
			
			// add the text 
			this._textHolder = new Sprite();
			this._textHolder.addChild(this._htmlPrinter.output);
			this._textHolder.x = GlobalModelManager.textBoxUiOptions.txtX;
			this._textHolder.y = GlobalModelManager.textBoxUiOptions.txtY;
			this.addChild(this._textHolder);
			
			// add mask
			this._textMask = new Sprite();
			this._textMask.graphics.beginFill(0xff00ff);
			this._textMask.graphics.drawRect(0, 0, this._textHolder.width, GlobalModelManager.textBoxUiOptions.txtHeight);
			this._textMask.graphics.endFill();
			this._textMask.x = GlobalModelManager.textBoxUiOptions.txtX;
			this._textMask.y = GlobalModelManager.textBoxUiOptions.txtY;
			this.addChild(this._textMask);
			this._textHolder.mask = this._textMask;
			
			// clear memory
			this._htmlPrinter = null;
			
			// set up the drag listeners
			this._verticalBoundary = GlobalModelManager.textBoxUiOptions.txtY - (this._textHolder.height - GlobalModelManager.textBoxUiOptions.txtHeight);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			
			// dispatch event to tell
			/*
			var $ee:ModuleEvent = new ModuleEvent(ModuleEvent.MOD_BUILT);
			this.dispatchEvent($ee);
			*/
		}
		
		
		
		
		private function mouseDownHandler($e:MouseEvent):void
		{
			this._mouseDownPos = this.mouseY;
			this._txtPos_Pressed = this._textHolder.y;
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
		}
		
		
		private function mouseMoveHandler($e:MouseEvent):void
		{
			var $curPos:Number = this.mouseY;
			this._textHolder.y = Math.min(Math.max(this._txtPos_Pressed + ($curPos - this._mouseDownPos), this._verticalBoundary), GlobalModelManager.textBoxUiOptions.txtY);
		}
		
		
		
		private function mouseUpHandler($e:MouseEvent):void
		{
			this._mouseDownPos = 0;
			this._txtPos_Pressed = 0;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
		}
		
		
		
		
		
		

	}
	
}
