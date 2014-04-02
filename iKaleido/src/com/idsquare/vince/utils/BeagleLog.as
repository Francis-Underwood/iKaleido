/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.utils 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * To write info into an external plain text file.
	 *  It's Singlton Class.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.utils.BeagleLog
	 * 
	 * 
	 * edit 0
	 *
	 */
	public class BeagleLog 
	{
	// CONSTANTS:
		/**
		 * The file url of the log text.
		 *
		 * @private
		 */
		private const LOG_FILE_NAME:String = "error.log";
			
		/**
		 * @private
		 */	
		private var _logFile:File = 
						new File(File.applicationDirectory.resolvePath(LOG_FILE_NAME).nativePath);
		/**
		 * @private
		 */
		private var _stream:FileStream = new FileStream();
		/**
		 * @private
		 */
		private static var _instance;
		
		
	// CONSTRUCTOR:
	
		/**
		 * Constructor.
		 */	
		public function BeagleLog() 
		{
			this._stream.addEventListener(IOErrorEvent.IO_ERROR, writeIOErrorHandler);
		}
		
		/**
		 * Static method, to get the only instance of this class through over the application runtime.
		 *  .
		 *
		 * @see	
		 *
		 */
		public static function getLogger():BeagleLog 
		{			
			if (this._instance == null) 
			{
				this._instance = new BeagleLog();
			}
			
			return this._instance;
		}	

		
		/**
		 * To write custom error text.
		 *  .
		 *
		 * @param	$cusMsg		the info to write
		 * @param	$caller		the name of the method which calls
		 *
		 * @see	
		 *
		 */
		public function customError($cusMsg:String, $caller:String):void
		{
			var $date:Date = new Date();
			
			if (this._stream != null)	
			{
				this._stream.close();
			}
			
			this._stream = new FileStream();
			this._stream.openAsync(_logFile, FileMode.APPEND);
			
			var $toWrite:String = $date.toLocaleString() + ":\t" 
								+ $caller + ":\t\n"
								+ "\t" + $cusMsg + "\n";
				$toWrite = $toWrite.replace(/\r/g, "\n");
				$toWrite = $toWrite.replace(/\n/g, File.lineEnding);
				this._stream.writeUTFBytes($toWrite);
				this._stream.close();
				
		}
		
		
		/**
		 * To write custom fatal error text.
		 *  .
		 *
		 * @param	$cusMsg		the info to write
		 * @param	$caller		the name of the method which calls
		 *
		 * @see	
		 *
		 */
		public function customFatalError($cusMsg:String, $caller:String):void
		{
			var $date:Date = new Date();
			
			if (this._stream != null)	
			{
				this._stream.close();
			}
			
			this._stream = new FileStream();
			this._stream.openAsync(_logFile, FileMode.APPEND);
			
			var $toWrite:String = "***************\n"
										+ $date.toLocaleString() + ":\t" 
										+ $caller + ":\t\n"
										+ "\t" + $cusMsg + "\n";
				$toWrite = $toWrite.replace(/\r/g, "\n");
				$toWrite = $toWrite.replace(/\n/g, File.lineEnding);
				this._stream.writeUTFBytes($toWrite);
				this._stream.close();
				
		}
		
		
		/**
		 * To write build-in error text.
		 *  .
		 *
		 * @param	$cusMsg		the info to write
		 * @param	$errMsg		the error info to write, it's Error::message
		 * @param	$caller		the name of the method which calls
		 *
		 * @see	
		 *
		 */
		public function buildInError($cusMsg:String, $errMsg:String, $caller:String):void
		{
			var $date:Date = new Date();
			
			if (this._stream != null)	
			{
				this._stream.close();
			}
			
			this._stream = new FileStream();
			this._stream.openAsync(_logFile, FileMode.APPEND);
			
			
			var $toWrite:String = $date.toLocaleString() + ":\t" 
										+ $caller + ":\t\n"
										+ "\t" + $cusMsg + "\n"
										+ "\t" + $errMsg + "\n";
				$toWrite = $toWrite.replace(/\r/g, "\n");
				$toWrite = $toWrite.replace(/\n/g, File.lineEnding);
				this._stream.writeUTFBytes($toWrite);
				this._stream.close();
		}
		
		
		/**
		 * To write build-in error text.
		 *  .
		 *
		 * @param	$fatalMsg	the info to write
		 * @param	$errMsg		the error info to write, it's Error::message
		 * @param	$caller		the name of the method which calls
		 *
		 * @see	
		 *
		 */
		public function fatalError($fatalMsg:String, $errMsg:String, $caller:String):void
		{
			var $date:Date = new Date();
			
			if (this._stream != null)	
			{
				this._stream.close();
			}
			
			this._stream = new FileStream();
			this._stream.openAsync(_logFile, FileMode.APPEND);
			
			var $toWrite:String = "***************\n"
										+ $date.toLocaleString() + ":\t" 
										+ $caller + ":\t\n"
										+ "\t" + $fatalMsg + "\n"
										+ "\t" + $errMsg + "\n";
				$toWrite = $toWrite.replace(/\r/g, "\n");
				$toWrite = $toWrite.replace(/\n/g, File.lineEnding);
				this._stream.writeUTFBytes($toWrite);
				this._stream.close();
		}
		
	
	// HANDLERS
		/**
		* Handles I/O errors that may come about when writing the currentFile.
		*/
		private function writeIOErrorHandler($e:IOErrorEvent):void 
		{
			//trace($e);
			//trace("The specified currentFile cannot be saved.");
		}

	}
	
}
