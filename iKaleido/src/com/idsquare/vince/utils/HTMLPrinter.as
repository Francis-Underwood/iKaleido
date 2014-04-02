/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.utils 
{
	import flash.events.EventDispatcher;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
    import flash.net.URLRequest;
	import flash.events.Event;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	
	/**
	 * The util class, to copy the pixels of a HTMLLoader into a BitmapData, and render the HTML markups from a providded url.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.utils.HTMLPrinter
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class HTMLPrinter extends EventDispatcher
	{
		public static const HTML_PRINTED:String = "HTMLPrinted";
		
		private var _pageWidth:int;
		private var _htmlLdr_IniHeight:int;
		private var _defURL:String;

		private var _page:HTMLLoader;
		private var _output:Bitmap;
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */			
		public function HTMLPrinter($width:int, $iniHeight:int, $url:String) 
		{
			this._pageWidth = $width;
			this._htmlLdr_IniHeight = $iniHeight;
			this._defURL = $url;
		}
		
		
		public function printHTML():void
		{
			// set up HTMLLoader
			this._page = new HTMLLoader();
			this._page.width = this._pageWidth;
			this._page.height = this._htmlLdr_IniHeight;
			this._page.paintsDefaultBackground = false;
			this._page.addEventListener(Event.COMPLETE, this.completedHandler);
			
			var $urlReq:URLRequest = new URLRequest(this._defURL);
			this._page.load($urlReq);
		}
		
		
		private function clone():void
		{
			var $bd:BitmapData = new BitmapData(this._page.width, this._page.height, true, 0x00FFFFFF);
			$bd.draw(this._page);
			this._output = new Bitmap($bd);
			this._page = null;
			// dispatch the event
			var $e:Event = new Event(HTML_PRINTED);
			this.dispatchEvent($e);
		}
		
		
	// HANDLERS:
			
		private function completedHandler($e:Event):void
		{			
			this._page.addEventListener(Event.HTML_RENDER, this.htmlRenderedHandler);
			this._page.height = this._page.contentHeight + GlobalModelManager.HTML_HEIGHT_MORE;
		}
		
		
		private function htmlRenderedHandler($e:Event):void
		{
			this._page.removeEventListener(Event.HTML_RENDER, this.htmlRenderedHandler);
			this.clone();
		}
		
	// ACCESSORS:				
		public function get output():Bitmap
		{
			return this._output;
		}
		

	}
	
}
