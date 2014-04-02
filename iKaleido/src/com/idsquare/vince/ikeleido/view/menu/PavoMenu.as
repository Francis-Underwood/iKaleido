/*
  Copyright (c) 2012, OnSystem Ltd.
  All rights reserved.
*/

package com.idsquare.vince.ikeleido.view.menu
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import com.idsquare.vince.ikeleido.model.GlobalModelManager;
	import com.idsquare.vince.utils.TextPrinter;
	
	import com.idsquare.vince.ikeleido.view.menu.PavoTweenMenuItem;
	import com.idsquare.vince.ikeleido.view.menu.PavoTweenSubMenuItem;
	
	import com.idsquare.vince.ikeleido.events.PavoMenuItemEvent;
	import com.idsquare.vince.ikeleido.events.MenuEvent;
	
	
	
	/**
	 * The top container of the fan menu.
	 * 
	 * @author		Vincent ZHANG
	 * 				that-individual@hotmail.com
	 * 				www.site.com
	 * @version		0.0.0
	 * @see			com.idsquare.vince.ikeleido.view.menu.PavoMenu
	 * 
	 * 
	 * edit 0
	 *
	 */
	
	public class PavoMenu extends Sprite
	{
		
	// CONSTANTS:	
		//const :Number = 1200;
		
	// creating items:	
		/**
		 * @private
		 */
		private var _txtPrinter:TextPrinter;

	// references to MenuItems & SubMenuItems:
		/**
		 * Store the ref to the top-level menu items, namely instances of PavoMenuItem.
		 *
		 * @private
		 */		
		private var _topMenuItems:Vector.<PavoTweenMenuItem> = new Vector.<PavoTweenMenuItem>();
		/**
		 * Number of top-level menu items.
		 *
		 * @private
		 */		
		private var _numOfTItems:uint;
		/**
		 * a 2-dinmension array, to store sub-menu items.
		 *
		 * @private
		 */		
		private var _subMenuItems:Vector.<Vector.<PavoTweenSubMenuItem>>;
		/**
		 * Normal top-level menu item positions.
		 *  When the top-level menu is open, and the sub-menu is closed, the positions of the top-level menu items.
		 * 
		 * @private
		 */
		private var _nml_TmItem_Positions:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * Top-level menu item positions, it's a two-dimension array.
		 *  When the menu is opened, and one of the sub-menu is opened too, the positions of the top-level menu items.
		 *
		 *  ____			 ____
		 * |    |			|    |		 
		 * |    |	<--->	|  0 |	--->[pos_0][pos_1][pos_2][][][] ... [pos_n-2][pos_n-1]
		 * |____|			|____|       
		 * |    |			|    |
		 * |    |	<--->	|  1 |	--->[     ][pos_1][pos_2][][][] ... [pos_n-2][pos_n-1]
		 * |____|			|____|
		 * |    |			|    |
		 * |    |	<--->	|  2 |	--->[     ][     ][pos_2][][][] ... [pos_n-2][pos_n-1]
		 * |____|			|____|
		 * |    |			|    |
		 * |    |	<--->	| .. |	--->[     ][     ][     ][][][] ... [pos_n-2][pos_n-1]
		 * |____|			|____|
		 * |    |			|    |
		 * |    |	<--->	| n-2|	--->[     ][     ][     ][][][] ... [pos_n-2][pos_n-1]
		 * |____|			|____|
		 * |    |			|    |
		 * |    |			| n-1|	--->[     ][     ][     ][][][] ... [       ][pos_n-1]
		 * 
		 *
		 * n = total number of top-level menu items
		 *
		 * @private
		 */
		private var _so_TmItem_Positions:Vector.<Vector.<Object>>;
		/**
		 * Positions of the sub-menu items when they are in the stage.
		 *	a 2-dinmension array.
		 *
		 * @private
		 */
		private var _smItem_Positions:Vector.<Vector.<Object>>;
		/**
		 * @private
		 */
		private var _topMenuExpanded:Boolean = false;
		/**
		 * @private
		 */
		private var _subMenuExpanded:Boolean = false;
		/**
		 * @private
		 */
		private var _openedTopItemId:int = -1;
		/**
		 * @private
		 */
		private var _menuSwitcher:MovieClip;
		/**
		 * @private
		 */
		private var _counter:int;
		/**
		 * @private
		 */
		private var _counter_TmItem_Sopen:uint;
		/**
		 * @private
		 */
		private var _ttl_Num_Item_Sweeping:uint;
		/**
		 * This associ-array is storing the info for the modules, according to each menu item.
		 *  ____			
		 * |    |----|--->modId(Int)
		 * |    |    |--->modType(String)
		 * |____|	 
		 * |    |		
		 * |    |	
		 * |____|			
		 *		 
		 * @private
		 */
		private var _moduleDatas:Object = {};
		/**
		 * @private
		 */
		private var _uidCounter:uint = 0;
		/**
		 * @private
		 */
		private var _clickedUid:int = -1;	// -1 means no clicked event
		
	// CONSTRUCTOR:
		
		/**
		 * Constructor.
		 *  Create MenuItem instances and SubMenuItem instances, by accessing data from GlobalModelManager.
		 */
		public function PavoMenu() 
		{
			var $mun:uint = GlobalModelManager.menu.length;
			var $gg:uint = GlobalModelManager.subMenu.skin.length;
			
			this._txtPrinter = TextPrinter.getInstance();
			
			/* a 2-dinmension array, to store sub items */
			this._subMenuItems = new Vector.<Vector.<PavoTweenSubMenuItem>>($mun, true);
			/* a 2-dinmension array, to store sub items positions */
			this._smItem_Positions = new Vector.<Vector.<Object>>($mun, true);
			/* a 2-dinmension array, to store top items positions when sub-menu is open */
			this._so_TmItem_Positions = new Vector.<Vector.<Object>>($mun, true);
			
			/* create the top menu items */
			for (var $i:int=0; $i<$mun; $i++)	// create one item for each element
			{
				/****************************************
				 * calculate the normal position info of top menu items
				 ***************************************/
				var $pos:Object = new Object();
					$pos.rotation = ($i+1) * GlobalModelManager.menuAnimation.degreeAugment;
				var	$xtempRad:Number = -($pos.rotation * Math.PI / 180);
					$pos.x = GlobalModelManager.menuAnimation.radius 
							- (  Math.cos($xtempRad) * GlobalModelManager.menuAnimation.radius  );
					$pos.y = Math.sin($xtempRad) * GlobalModelManager.menuAnimation.radius;
					$pos.alpha = 1;
					
					this._nml_TmItem_Positions.push($pos);
				
				
				/****************************************
				 * instantiate the MenuItem objects
				 ***************************************/
				var $item:PavoTweenMenuItem = new PavoTweenMenuItem();
					$item.id = $i;
					$item.moduleId = GlobalModelManager.menu[$i].options.moduleId;
					$item.hasSubMenu = GlobalModelManager.menu[$i].options.hasSubMenu;
				
				/* add the user costom icon image */
				$item.addChildAt(GlobalModelManager.menu[$i].options.image, GlobalModelManager.topMenu.options.cusZindex);
				$item.addLabel(GlobalModelManager.menu[$i].options.label);
				$item.mouseChildren = false;
				/* forming done */
				
				
				/**************************** 
				 * create the sub-menu items
				 ***************************/
				if ( $item.hasSubMenu && (GlobalModelManager.menu[$i].subMenu.length > 0) )
				{
					var $sublen:uint = GlobalModelManager.menu[$i].subMenu.length;
					
					/* to store the positions of these sub items */ 
					var $subPositions:Vector.<Object> = new Vector.<Object>();
					
					var $subItems:Vector.<PavoTweenSubMenuItem> = new Vector.<PavoTweenSubMenuItem>();
					
					for (var $n:uint=0; $n<$sublen; $n++)
					{
						/* calculate the position info of these sub items */
						var $sPos:Object = new Object();
						
						/* we should start from the previous top item preceding the current item */
						if ( $i == 0 )
						{
							$sPos.rotation = ($n+1) * GlobalModelManager.menuAnimation.subDegreeAugment;
						}
						else if ( $i > 0 )
						{
							$sPos.rotation =  ( ($n+1) * GlobalModelManager.menuAnimation.subDegreeAugment ) + this._nml_TmItem_Positions[$i-1].rotation;
						}
						
						var $ttmpRad:Number = -($sPos.rotation * Math.PI / 180);
						$sPos.x = GlobalModelManager.menuAnimation.radius 
									- (  Math.cos($ttmpRad) * GlobalModelManager.menuAnimation.radius  );
						$sPos.y = Math.sin($ttmpRad) * GlobalModelManager.menuAnimation.radius;
						$sPos.alpha = 1;
						$subPositions.push($sPos);
						
						/* create bus menu items */
						var $subItem:PavoTweenSubMenuItem = new PavoTweenSubMenuItem();
						$subItem.moduleId= GlobalModelManager.menu[$i].subMenu[$n].moduleId;
						
						/* add the user costom icon image */
						$subItem.addChildAt(GlobalModelManager.menu[$i].subMenu[$n].image, GlobalModelManager.subMenu.options.cusZindex);
						$subItem.addLabel(GlobalModelManager.menu[$i].subMenu[$n].label);
						$subItem.mouseChildren = false;
						
						$subItem.addEventListener(MouseEvent.CLICK, this.subMenuItemPressedHandler);
						$subItems.push($subItem);
						
						/* for create modules */
						$subItem.uid = this._uidCounter;
						this._moduleDatas[this._uidCounter] = {modType: GlobalModelManager.menu[$i].subMenu[$n].moduleType, modId: GlobalModelManager.menu[$i].subMenu[$n].moduleId};
						this._uidCounter++;
					}
					
					this._subMenuItems[$i] = $subItems;
					this._smItem_Positions[$i] = $subPositions;
					
					/********************************************************************************************     
					 * calculate the positions of the top-menu item, when the current item's sub-menu is open,
					 * we only need to calculate the positions for the item that afterward the current one
					 ********************************************************************************************/
					var $topPositions:Vector.<Object> = new Vector.<Object>();
					
					var $counterX:uint = 1;
					
					for (var $c:uint=$i; $c<$mun; $c++)	// start at $i
					{
						/* this position should not include alpha */
						var $tPos_o:Object = new Object();
						
						/*
						 * rotation accumulation should start at the last sub-menu item of current top-menu item,
						 * that is basing on $sPos.rotation
						 */
						$tPos_o.rotation = $sPos.rotation + $counterX * GlobalModelManager.menuAnimation.degreeAugment;
						
						var $tempRadian:Number = -($tPos_o.rotation * Math.PI / 180);
						
						$tPos_o.x = GlobalModelManager.menuAnimation.radius 
									- ( Math.cos($tempRadian) * GlobalModelManager.menuAnimation.radius );
						$tPos_o.y = Math.sin($tempRadian) * GlobalModelManager.menuAnimation.radius;
						
						$topPositions.push($tPos_o);
						$counterX++;
					}
					
					this._so_TmItem_Positions[$i] = $topPositions;
					
				}	// end of the if block that the top-menu item has sub-menu 
				
				else	// if block that the top-menu item do not has sub-menu 
				{
					/* for create modules */
					$item.uid = this._uidCounter;
					this._moduleDatas[this._uidCounter] = {modType: GlobalModelManager.menu[$i].options.moduleType, modId: GlobalModelManager.menu[$i].options.moduleId};
					this._uidCounter++;
				}
				
				// actually not necessary
				$item.x = 0;
				$item.y = 0;
				$item.rotation = 0;
				$item.alpha = 0;
				
				//this.addChild($item);	// not now
				this._topMenuItems.push($item);
			}	// end of the most outside for loop
			
			
			this._numOfTItems = this._topMenuItems.length;
		
			this._menuSwitcher = menuSwher;
			this._menuSwitcher.mouseChildren = false;
			this._menuSwitcher.addEventListener(MouseEvent.CLICK, switcherPressedHandler);
			
			
			/* test 
			this._subMenuItems[0][0].x = 500;
			this._subMenuItems[0][0].y = -400;
			this.addChild(this._subMenuItems[0][0]);
			this._subMenuItems[0][1].x = 500;
			this._subMenuItems[0][1].y = -380;
			this.addChild(this._subMenuItems[0][1]);
			this._subMenuItems[0][2].x = 500;
			this._subMenuItems[0][2].y = -360;
			this.addChild(this._subMenuItems[0][2]);
			
			this._subMenuItems[1][0].x = 500;
			this._subMenuItems[1][0].y = -340;
			this.addChild(this._subMenuItems[1][0]);
			this._subMenuItems[1][1].x = 500;
			this._subMenuItems[1][1].y = -320;
			this.addChild(this._subMenuItems[1][1]);
			
			this._subMenuItems[2][0].x = 500;
			this._subMenuItems[2][0].y = -300;
			this.addChild(this._subMenuItems[2][0]);
			this._subMenuItems[2][1].x = 500;
			this._subMenuItems[2][1].y = -280;
			this.addChild(this._subMenuItems[2][1]);
			this._subMenuItems[2][2].x = 500;
			this._subMenuItems[2][2].y = -260;
			this.addChild(this._subMenuItems[2][2]);
			
			Debug.traceObj(_nml_TmItem_Positions);
			Debug.traceObj(_so_TmItem_Positions);
			Debug.traceObj(_smItem_Positions);
			*/
			
			
			// test only
			/*
			for each(var $r in this._moduleDatas)
			{
				trace("___");
				trace($r.modType, $r.modId);
			}
			
			for (var $r in this._moduleDatas)
			{
				trace($r);
				//trace($r.modType, $r.modId);
			}
			*/
		}
		
		
		/**
		 * Show the menu items out.
		 *  This is done by calling MenuItem::flyIn() method, and attach a listener for menuItemShowed event.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function blow():void
		{
			this._counter = 0;
			
			for (var $i:int=0; $i<this._numOfTItems; $i++)
			{
				var $item:PavoTweenMenuItem = this._topMenuItems[$i] as PavoTweenMenuItem;
				this.addChild($item);
				$item.addEventListener(PavoMenuItemEvent.MENUITEM_SHOWED, this.itemShowedHandler);
				//$item.flyTo(this._nml_TmItem_Positions[$i]);
				$item.flyIn(this._nml_TmItem_Positions[$i]);
			}
		}
		
		
		/**
		 * Hide the menu items behind.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function fade():void
		{
			this._counter = 0;
			
			for (var $i:int=0; $i<this._numOfTItems; $i++)
			{
				var $item:PavoTweenMenuItem = this._topMenuItems[$i] as PavoTweenMenuItem;
				$item.addEventListener(PavoMenuItemEvent.MENUITEM_HIDED, this.itemHidedHandler);
				//$item.flyTo({x:0,y:0,rotation:0,alpha:0});
				$item.flyOut({x:0,y:0,rotation:0,alpha:0});
			}
		}
		
		
		/**
		 * Disable the mouse operation on the switcher button.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function lock():void
		{
			this.mouseChildren = false;
		}
		
		
		/**
		 * Enable the mouse operation on the switcher button.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function unlock():void
		{
			this.mouseChildren = true;
		}
		
		
	// HANDLERS:
		
		/**
		 * Hendler of the click event on switcher button.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function switcherPressedHandler($e:MouseEvent):void
		{
			if (this._topMenuExpanded)
			
			{
				this._topMenuExpanded = false;
				this._menuSwitcher.gotoAndPlay("close");
				this.lock();
				
				if (this._subMenuExpanded)
				{
					this._subMenuExpanded = false;
					var $nuumm:uint = this._subMenuItems[this._openedTopItemId].length;
					
					for (var $subItee:uint=0; $subItee<$nuumm; $subItee++)
					{
						var $childIt:PavoTweenSubMenuItem = this._subMenuItems[this._openedTopItemId][$subItee] as PavoTweenSubMenuItem;
						$childIt.disapper();
					}
					
					this._openedTopItemId = -1;
				}
				this.fade();
			}
			else
			{
				this._topMenuExpanded = true;
				this._clickedUid = -1;
				this._menuSwitcher.gotoAndPlay("open");
				this.lock();
				this.blow();
			}
		}
		
		
		/**
		 * Handler of menuItemShowed event on the MenuItem.
		 *  Unbind the listeners, and update the counter, if counter equals to the total
		 *  number of items, then means all the items are placed to their target position,
		 *  then, recover the switcher button mouse-enabled.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function itemShowedHandler($e:PavoMenuItemEvent):void
		{
			$e.target.removeEventListener(PavoMenuItemEvent.MENUITEM_SHOWED, this.itemShowedHandler);
			
			/* attach the event listener for click */
			$e.target.addEventListener(MouseEvent.CLICK, this.topMenuItemPressedHandler);
			
			this._counter++;
			if (this._counter == this._numOfTItems)
			{
				this.unlock();
			}
		}
		
		
		/**
		 * Handler of menuItemHided event on the MenuItem.
		 *  Unbind the listeners, remove it from display-list,
		 *  and update the counter, if counter equals to the total number of items,
		 *  then means all the items are placed to their target position,
		 *  then, recover the switcher button mouse-enabled.
		 *
		 * @see	
		 *
		 * @private
		 */
		private function itemHidedHandler($e:PavoMenuItemEvent):void
		{
			var $item:PavoTweenMenuItem = $e.target as PavoTweenMenuItem;
			//trace($item);	// [object MenuItem]
			$item.removeEventListener(PavoMenuItemEvent.MENUITEM_HIDED, this.itemHidedHandler);
			this.removeChild($item);
			
			this._counter++;
			
			if (this._counter == this._numOfTItems)
			{
				this.unlock();
				
				// dispatch nav event
			}
		}
		
		
		/**
		 * Hendler of the click event on top-level menu item.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function topMenuItemPressedHandler($e:MouseEvent):void
		{
			var $item:PavoTweenMenuItem = $e.target as PavoTweenMenuItem;
			
			/* _topMenuExpanded should alyays be open, no need to check */
			
			
			/***************************************** 
			 * process under different conditions
			 *****************************************/
			 
			/* when sub menu is closed */
			if (!this._subMenuExpanded)
			{
				if ($item.hasSubMenu)	// it has sub-menu, then open it
				{
					/* update global var to keep track of which top-level menu item is opened */
					this._openedTopItemId = $item.id
					/* disable the mouse event on the switcher button */
					this.lock();
					
					/**********************
					 * open its sub menu
					 **********************/
					
					/* reset the global vars */
					this._ttl_Num_Item_Sweeping = this._subMenuItems[this._openedTopItemId].length + (this._numOfTItems - this._openedTopItemId);
					this._counter_TmItem_Sopen = 0;
					
					/* set top-level menu items */
					var $cnterPosIdx:uint = 0;
					for (var $topI:uint=this._openedTopItemId; $topI<this._numOfTItems; $topI++)
					{
						var $aftItem:PavoTweenMenuItem = this._topMenuItems[$topI] as PavoTweenMenuItem;
						
						$aftItem.addEventListener(PavoMenuItemEvent.MENUITEM_SWEPT, this.itemSweptHandler);
						$aftItem.sweepTo(this._so_TmItem_Positions[this._openedTopItemId][$cnterPosIdx]);
						
						$cnterPosIdx++;
					}
					
					/* set sub-menu items' init positions, and animate it */
					var $num:uint = this._subMenuItems[_openedTopItemId].length;
					for (var $subI:uint=0; $subI<$num; $subI++)
					{
						var $child:PavoTweenSubMenuItem = this._subMenuItems[this._openedTopItemId][$subI] as PavoTweenSubMenuItem;
						$child.x = $item.x;
						$child.y = $item.y;
						$child.rotation = $item.rotation;
						$child.alpha = 0;
						this.addChild($child);
						$child.addEventListener(PavoMenuItemEvent.SUBMENU_ITEM_SWEPT, this.itemSweptHandler);
						$child.sweepTo(this._smItem_Positions[this._openedTopItemId][$subI]);
					}
					
					this._subMenuExpanded = true;
					
					// do not bubble it to parent
					$e.stopPropagation();
				}
				else	// it has no sub-menu, so should close the menu, and navigate the main content
				{
					/* close the top menu */
					this._topMenuExpanded = false;
					this._menuSwitcher.gotoAndPlay("close");
					this.lock();
					this.fade();
					
					// dispatch Nav event
					
					// bubble it to parent
				}
					
			}
			
			/* otherwise, when sub menu is opened */
			else if (this._subMenuExpanded)
			{
				if (this._openedTopItemId == $item.id)	// the clicked top menu item's sub menu is already opened
				{
					/* close its sub menu */
					this._subMenuExpanded = false;
					this._openedTopItemId = -1;
					/* disable the mouse event on the switcher button */
					this.lock();
					
					/* set sub-menu items' init positions, and animate it */
					var $numm:uint = this._subMenuItems[$item.id].length;
					for (var $subIt:uint=0; $subIt<$numm; $subIt++)
					{
						var $childi:PavoTweenSubMenuItem = this._subMenuItems[$item.id][$subIt] as PavoTweenSubMenuItem;
						$childi.disapper();
					}
					
					/******************************* 
					 * animate top-level menu items
					 ******************************/
					
					/* reset the global vars */
					this._ttl_Num_Item_Sweeping = this._numOfTItems - $item.id;
					this._counter_TmItem_Sopen = 0;
					
					for (var $topIt:uint=$item.id; $topIt<this._numOfTItems; $topIt++)
					{
						var $afterItem:PavoTweenMenuItem = this._topMenuItems[$topIt] as PavoTweenMenuItem;
						$afterItem.addEventListener(PavoMenuItemEvent.MENUITEM_SWEPT, this.itemSweptHandler);
						$afterItem.sweepTo(this._nml_TmItem_Positions[$topIt]);
					}
					
					// do not bubble it to parent
					$e.stopPropagation();
				}
				else if( (this._openedTopItemId != $item.id) && ($item.hasSubMenu) )	// the clicked top menu item is different from the currently opened one, and it has children
				{
					/* animate all revalant elements */
					var $minInd:uint = Math.min(this._openedTopItemId, $item.id);
					/* disable the mouse event on the switcher button */
					this.lock();
					
					/* 
					 * hide the previous opened sub-menu items
					 */
					var $nuumm:uint = this._subMenuItems[this._openedTopItemId].length;
					for (var $subItee:uint=0; $subItee<$nuumm; $subItee++)
					{
						var $childIt:PavoTweenSubMenuItem = this._subMenuItems[this._openedTopItemId][$subItee] as PavoTweenSubMenuItem;
						$childIt.disapper();
					}
										
					/* 
					 * show the sub-menu of the clicked top item
					 */
					this._openedTopItemId = $item.id;
					
					/* reset the global vars */
					this._counter_TmItem_Sopen = 0;
					this._ttl_Num_Item_Sweeping = this._subMenuItems[$item.id].length + (this._numOfTItems - $minInd);
					
					/* set top-level menu items */
					var $cnterPosIdxx:uint = 0;
					for (var $topIte:uint=$minInd; $topIte<this._numOfTItems; $topIte++)
					{
						var $afterrItem:PavoTweenMenuItem = this._topMenuItems[$topIte] as PavoTweenMenuItem;
						$afterrItem.addEventListener(PavoMenuItemEvent.MENUITEM_SWEPT, this.itemSweptHandler);
						
						/* the items before the clicked item */
						if ($topIte < $item.id)
						{
							$afterrItem.sweepTo(this._nml_TmItem_Positions[$topIte]);
						}
						
						/* the items after the clicked item */
						else
						{
							$afterrItem.sweepTo(this._so_TmItem_Positions[$item.id][$cnterPosIdxx]);	// ???
							$cnterPosIdxx++;
						}
					}
					
					
					/* set sub-menu items' init positions, and animate it */
					var $nnum:uint = this._subMenuItems[this._openedTopItemId].length;
					for (var $subItem:uint=0; $subItem<$nnum; $subItem++)
					{
						var $childx:PavoTweenSubMenuItem = this._subMenuItems[this._openedTopItemId][$subItem] as PavoTweenSubMenuItem;
						$childx.x = $item.x;
						$childx.y = $item.y;
						$childx.rotation = $item.rotation;
						$childx.alpha = 0;
						this.addChild($childx);
						$childx.addEventListener(PavoMenuItemEvent.SUBMENU_ITEM_SWEPT, this.itemSweptHandler);
						$childx.sweepTo(this._smItem_Positions[this._openedTopItemId][$subItem]);
					}
					
					// do not bubble it to parent
					$e.stopPropagation();
				}
				else	// the opened id is not current one, and current one do not have children
				{
					this._topMenuExpanded = false;
					this._menuSwitcher.gotoAndPlay("close");
					this.lock();
				
					if (this._subMenuExpanded)
					{
						this._subMenuExpanded = false;
						var $nnuumm:uint = this._subMenuItems[this._openedTopItemId].length;
					
						for (var $subIteem:uint=0; $subIteem<$nnuumm; $subIteem++)
						{
							var $childItem:PavoTweenSubMenuItem = this._subMenuItems[this._openedTopItemId][$subIteem] as PavoTweenSubMenuItem;
							$childItem.disapper();
						}
					
						this._openedTopItemId = -1;
					}
					
					this.fade();
					
					// bubble it to parent
				}
				
			}
				
		}
		
		
		/**
		 * Handler of menuItemSwept event on both top-Menu Item & sub menu item.
		 *  
		 *
		 * @see	
		 *
		 * @private
		 */
		private function itemSweptHandler($e:PavoMenuItemEvent):void
		{
			var $item:* = $e.target;
			
			//trace($item);	// [object MenuItem]
			if($item.hasEventListener(PavoMenuItemEvent.MENUITEM_SWEPT))
			{
				$item.removeEventListener(PavoMenuItemEvent.MENUITEM_SWEPT, this.itemSweptHandler);
			}
			if($item.hasEventListener(PavoMenuItemEvent.SUBMENU_ITEM_SWEPT))
			{
				$item.removeEventListener(PavoMenuItemEvent.SUBMENU_ITEM_SWEPT, this.itemSweptHandler);
				
				/* 
				 * This is one option, but we can not trace that the item is out of stage
				 */
				
				/*
				$item.addEventListener(MouseEvent.CLICK, this.subMenuItemPressedHandler);
				*/
			}
			
			this._counter_TmItem_Sopen++;
			
			if ( this._counter_TmItem_Sopen == this._ttl_Num_Item_Sweeping )
			{
				this.unlock();
			}
		}
		
		
		/**
		 * Hendler of the click event on sub-menu item.
		 *  .
		 *
		 * @see	
		 *
		 * @private
		 */
		private function subMenuItemPressedHandler($e:MouseEvent):void
		{
			var $item:PavoTweenSubMenuItem = $e.target as PavoTweenSubMenuItem;
			this._topMenuExpanded = false;
			this._menuSwitcher.gotoAndPlay("close");
			this.lock();
				
			if (this._subMenuExpanded)
			{
				this._subMenuExpanded = false;
				var $nuumm:uint = this._subMenuItems[this._openedTopItemId].length;
					
				for (var $subItee:uint=0; $subItee<$nuumm; $subItee++)
				{
					var $childIt:PavoTweenSubMenuItem = this._subMenuItems[this._openedTopItemId][$subItee] as PavoTweenSubMenuItem;
					$childIt.disapper();
				}
					
				this._openedTopItemId = -1;
			}
			
			this.fade();	
			
			// dispatch Nav event
		}
		
	// ACCESSORS:	
		
		public function get moduleDatas():Object
		{
			return this._moduleDatas;
		}
		
		
		public function get uidCounter():uint
		{
			return this._uidCounter;
		}
		
		

	}
	
}
