/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.utils 
{
	
	public class NumberUtil extends Object
	{

		public function NumberUtil() 
		{
			// constructor code
		}
		
		public static function map($arg1:Number, $arg2:Number, $arg3:Number, $arg4:Number, $arg5:Number):Number
		{
			return NumberUtil.interpolate(NumberUtil.normalize($arg1, $arg2, $arg3), $arg4, $arg5);
		}

		public static function normalize($norPoint:Number, $min:Number, $max:Number):Number
		{
			return ($norPoint - $min) / ($max - $min);
		}
		
		public static function interpolate($factor:Number, $min:Number, $max:Number):Number
		{
			return $min + ($max - $min) * $factor;
		}		
				
		

	}
	
}
