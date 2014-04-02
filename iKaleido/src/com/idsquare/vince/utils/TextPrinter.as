/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.utils 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * The util class, to copy the pixels of a TextField into a BitmapData.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.utils.TextPrinter
	 * 
	 * 
	 * edit 0
	 *
	 */	
	public class TextPrinter 
	{
		
	// variables:	
		/**
		 * @private
		 */
		private var _txtField:TextField;
		/**
		 * @private
		 */
		private var _txtFormat:TextFormat;
		/**
		 * @private
		 */
		private var _canvas:Sprite;
		/**
		 * @private
		 */
		private static var _instance:TextPrinter;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */	
		public function TextPrinter() 
		{
			/* init the text field */
			this._txtField = new TextField();
			this._txtField.autoSize = TextFieldAutoSize.LEFT; 
			this._txtField.multiline = false;
			this._txtField.wordWrap = false;
			//this._txtField.selectable = false;	// no need, it will be printed
			
			/* init the text format */
			this._txtFormat = new TextFormat();
			this._txtFormat.font = "_serif";
			this._txtFormat.size = 30;
			//this._txtFormat.color = 0x000000;	// leave it as default
			//this._txtFormat.bold = false;	// leave it as default
			
			/* apply the text format */ 
			this._txtField.defaultTextFormat = this._txtFormat;
		}
		
		
		public static function getInstance():TextPrinter
		{
			if (TextPrinter._instance == null) 
			{
				TextPrinter._instance = new TextPrinter();
			}
			return TextPrinter._instance;
		}
		
		/**
		 * Set the textFormat properties, according to the vars in XML.
		 * .
		 * 
		 * @param	$style	the font style parameters: {font: ,size: ,color: ,bold: ,embedFonts: }
		 * 
		 */
		public function setStyle($style:Object):void
		{
			/* redefine the font porfolio */
			this._txtFormat.font = $style.font;
			this._txtFormat.size = $style.size;
			this._txtFormat.color = $style.color;
			this._txtFormat.bold = $style.bold; 
			/* apply the format */
			this._txtField.defaultTextFormat = this._txtFormat;
			//this._txtField.setTextFormat(this._txtFormat);
			
			this._txtField.embedFonts = $style.embedFonts;
		}
		
		
		/**
		 * Set the textFormat properties, according to the vars in XML.
		 * .
		 * 
		 * @param	$style	
		 * 
		 */
		public function printText($text:String):Bitmap
		{
			this._txtField.text = $text;
			/* draw the pixels of Text to a new Bitmap */
			var $bd:BitmapData = new BitmapData(this._txtField.width, this._txtField.height, true, 0x00FFFFFF);
            $bd.draw(this._txtField);
			
            return new Bitmap($bd);  
		}
		
		
		
		

	}
	
}
