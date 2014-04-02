/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.utils 
{
	
	public class TimeDisplayUtil extends Object
	{

		public function TimeDisplayUtil() 
		{
			// constructor code
		}
		
		
		public static function timeCodeToSeconds($timeStr:String, $delimiter:String="-"):uint
		{
			var $codeArr:Array = $timeStr.split($delimiter);
			
			var $seconds:uint = 0;
			var $index:uint = 0;
			
			while ($index < ($codeArr.length - 1)) 
			{
				$seconds = $codeArr[$index] * 60;
				$codeArr[$index + 1] = parseInt($codeArr[$index + 1]) + $seconds;
				++$index;
			}
			
			return $codeArr[($codeArr.length - 1)];
		}


		public static function secondsToTimeCode($seconds:Number, $delimiter:String=":"):String
		{
			if (isNaN($seconds) || $seconds < 0) 
			{
				$seconds = 0;
				return "--" + $delimiter + "--";
			}
			
			var $timeCode:String = "";
			
			var $minutes:uint = Math.floor($seconds / 60);
			
			$seconds = $seconds - $minutes * 60;
			
			var $hours:uint = Math.floor($minutes / 60);
			$minutes = $minutes - $hours * 60;
			
			var $secondsStr:String = $seconds < 10 ? "0" + Math.floor($seconds) : (Math.floor($seconds)).toString();
			var $minutesStr:String = $minutes < 10 ? "0" + Math.floor($minutes) + $delimiter : Math.floor($minutes) + $delimiter;
			
			var $hoursStr:String = "";
			
			if ($hours < 10)
			{
				$hoursStr = "0" + Math.floor($hours);
				
				if (Math.floor($hours) != 0)
				{
					$hoursStr = $hoursStr + $delimiter;
				}
				else
				{
					$hoursStr = "";
				}
			}
			else
			{
				$hoursStr = (Math.floor($hours)).toString() + $delimiter;
			}
			
			$timeCode = $hoursStr + $minutesStr + $secondsStr;
			
			return $timeCode;
		}
		

		public static function secondsToMinutes($seconds:uint):uint
		{
			
			if (isNaN($seconds) || $seconds < 0) 
			{
				return 0;
			}
			
			return Math.floor($seconds / 60);
		}


		public static function millisecondsToTimeCode($mseconds:uint, $delimiter:String=":"):String
		{
			return secondsToTimeCode($mseconds / 1000, $delimiter);
		}
		
		
	}
	
}
