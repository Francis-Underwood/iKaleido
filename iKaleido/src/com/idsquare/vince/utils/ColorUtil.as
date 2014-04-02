/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.utils 
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;	
	
	public class ColorUtil extends Object 
	{
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 */
		public function ColorUtil() 
		{
			// do nothing
		}
		
		
		public static function setColor($do:DisplayObject, $color:uint, $alpha:Number=1):void
		{
			var $myColor:ColorTransform;
			
			try 
			{
				$myColor = $do.transform.colorTransform;
				
				if ($color > 0xFFFFFF) 
				{
					$color = 0xFFFFFF;
				}
				else if ($color < 0) 
				{
					$color = 0;
				}
				
				$myColor.color = $color;
				
				if ($alpha > 1) 
				{
					$alpha = 1;
				}
				else if ($alpha < 0) 
				{
					$alpha = 0;
				}
				
				$myColor.alphaMultiplier = $alpha;
				$do.transform.colorTransform = $myColor;
			}
			catch (err:Error)
			{
				trace("ERROR! " + err.toString());
			}
		}		
		
		
		

	}
	
}
