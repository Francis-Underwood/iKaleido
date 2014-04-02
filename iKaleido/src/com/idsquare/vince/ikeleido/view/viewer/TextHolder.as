/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.viewer 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * The text container of Photo description.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.viewer.TextHolder
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class TextHolder extends Sprite
	{
		/**
		 * @private
		 */
		private var _desc:TextField;
		/**
		 * @private
		 */
		private var _format:TextFormat;
		/**
		 * @private
		 */
		private var _html:String;
		/**
		 * @private
		 */
		private var _text:String;
		/**
		 * @private
		 */
		private var _background:Sprite;
		/**
		 * @private
		 */
		private var _bgWidth:uint;
		/**
		 * @private
		 */
		private var _bgHeight:uint;

	// CONSTRUCTOR:
	
		/**
		 * Constructor.
		 */
		public function TextHolder() 
		{
			/* set up text format */
			this._format = new TextFormat();
			this._format.font = "_sans";
            this._format.color = 0xFFFFFF;
            this._format.size = 20;
			
			/* set up text field */
			this._desc = new TextField();
			this._desc.selectable = false;
			this._desc.autoSize = TextFieldAutoSize.LEFT;
			this._desc.multiline = true;
			this._desc.wordWrap = true;
			this._desc.defaultTextFormat = this._format;
			
			/* set up background */
			this._background = new Sprite();
			this._background.graphics.beginFill(0x33333333);
			this._background.graphics.drawRect(0, 0, 100, 100);
			this._background.graphics.endFill();
			this._background.alpha = 0.8;
			this.addChild(this._background);
			
			/* add description at upper layer */
			this._desc.x = 10;
			this._desc.y = 10;
			this.addChild(this._desc);
			
			this.mouseChildren = false;
		}
		
		/**
		 * Accessor to _html.
		 * 
		 * @param	$markups	HTML mark-ups	
		 * 
		 */
		public function set html($markups:String):void
		{
			this._html = $markups;
		}
		
		/**
		 * Accessor to _text.
		 * 
		 * @param	$txt	string of photo description	
		 * 
		 */
		public function set text($txt:String):void
		{
			this._text = $txt;
			
			if (this._text.length != 0)
			{
				this._desc.text = this._text;
				this._bgHeight = this._desc.height + 20;
				this._background.height = this._bgHeight;
			}
		}
		
		/**
		 * Accessor to _bgWidth.
		 * 
		 * @param	$value	width of background	
		 * 
		 */
		public function set bgWidth($value:uint):void
		{
			if ($value)
			{
				this._bgWidth = $value;
				
				if (this._bgWidth > 40)
				{
					this._desc.width = this._bgWidth - 20;
				}
				else
				{
					this._desc.width = this._bgWidth;
				}
				
				this._background.width = this._bgWidth;
			}
		}
		
		public function get bgHeight():uint
		{
			return this._bgHeight;
		}
		
		
		

	}
	
}
