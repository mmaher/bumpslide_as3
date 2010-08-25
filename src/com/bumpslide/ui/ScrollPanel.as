﻿/** * This code is part of the Bumpslide Library by David Knape * http://bumpslide.com/ *  * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc. *  * Released under the open-source MIT license. * http://www.opensource.org/licenses/mit-license.php * see LICENSE.txt for full license terms */  package com.bumpslide.ui {	import com.bumpslide.tween.FTween;	import flash.display.DisplayObject;	import flash.geom.Rectangle;	/**	 * Scrollpanel contains a scrollbar and some content	 * 	 * Most of the core logic for this class is in the AbstractScrollPanel class.	 * This class contains tweening code and implements the IScrollable interface	 * for a content display object by scrolling it using a scrollRect.	 * 	 * This component can be instantiated via code, or it can be created 	 * inside a FLA.  Missing pieces will be dynamically added to the 	 * display list. 	 * 	 * To create a custom panel, your component class must use as a base 	 * class com.bumpslide.ui.ScrollPanel.  It should contain 3 children:	 *  - content (the content clip)	 *  - background (the component background)	 *  - scrollbar (a custom VSlider)	 *    	 * @author David Knape	 */	public class ScrollPanel extends AbstractScrollPanel implements IScrollable {
				static public const EVENT_TWEENED:String = "scrollPanelTweened";		
		override protected function initScrollTarget():void {			scrollbar.scrollTarget = this;		}		public function cancelTweens():void {			FTween.stopTweening(this, '_holderScrollRectPosition');		}		/**		 * update size, position, and visibility of child components		 */		override protected function draw():void {				cancelTweens();			super.draw();		}		/**		 * Positions and sizes the content		 */		override protected function setContentSize(w:Number, h:Number):void {			super.setContentSize(w, h);									_holderScrollRectPosition = scrollPosition;		}		/**		 * Reset scroll to 0 and refresh (after content change)		 */		override public function reset():void {				cancelTweens();			_holderScrollRectPosition = 0;			super.reset();		}		//-------------------		// GETTERS/SETTERS		//-------------------		/**		 * Used by the scrollPosition setter to tween the scroll rect x or y value		 * 		 * Use the scrollPosition setter for adjusting scrollPosition, not this.  		 * Otherwise, scrollbar will not be updated.		 */		public function set _holderScrollRectPosition( n:Number ):void {			var rect:Rectangle=_holder.scrollRect;			rect[ isVertical ? 'y' : 'x'] = Math.round(n);			_holder.scrollRect = rect;		}				/**		 * content.scrollRect.[x or y] - used for tweening		 */		public function get _holderScrollRectPosition():Number {			if(_holder && _holder.scrollRect) {				return _holder.scrollRect[ isVertical ? 'y' : 'x'];			} else {				return 0;			}		}				//----------------------------------------		// IScrollable Interface		// 		// Adjusts scrollRect of content holder		// whenever the scrollbar changes			//----------------------------------------		public function get totalSize():Number {						if(_content) {				return isVertical ? _content.height : _content.width;			} else {				return 1;			}		}		public function get visibleSize():Number {			if(isVertical) { 				return height - _padding.height;			} else {				return width - _padding.width;			}		}		public function get scrollPosition():Number {			return _scrollPosition;		}		public function set scrollPosition( pos:Number ):void {					_scrollPosition = pos;			if(scrollbar.value!=pos) scrollbar.value = pos;			constrainScrollPosition();							if(tweenEnabled) { 				FTween.ease(this, '_holderScrollRectPosition', _scrollPosition, tweenEasingFactor, { minDelta: .1, onUpdate:onTweenUpdate});							} else {				_holderScrollRectPosition = _scrollPosition;			}		}				public function onTweenUpdate( tween:FTween ) : void {			sendEvent( EVENT_TWEENED, tween );		}				override public function set children(a:Array) : void {			var firstElement:DisplayObject = a.shift();			if(firstElement!=null) content = firstElement;		} 					}}