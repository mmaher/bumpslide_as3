﻿/** * This code is part of the Bumpslide Library by David Knape * http://bumpslide.com/ *  * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc. *  * Released under the open-source MIT license. * http://www.opensource.org/licenses/mit-license.php * see LICENSE.txt for full license terms */  package com.bumpslide.ui {	import com.bumpslide.ui.skin.defaults.Style;	import flash.text.TextFieldType;
	import com.bumpslide.data.type.Padding;	import com.bumpslide.util.ObjectUtil;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	/**	 * Label and/or TextBox	 * 	 * This class is a wrapper around TextField and can be used as a BaseClass for 	 * Flash MovieClips that contain a dynamic text field on the stage called	 * textField.	 * 	 * If used on it's own, this class will create the necessary TextField instance.	 * 	 * textField.autoSize is set to "left".	 * Set an explicit width and multiline/wordWrapping are enabled.	 * Use maxLines property to enforce number of lines of text.	 * If no width is set, textField autoSizes horizontally.	 * Use setStyle to quickly set textFormat properties on the textField.	 * 	 * Note: This class is wrapped by the TextPanel component which provides	 * scrolling behavior.	 * 	 * @see com.bumpslide.ui.TextPanel	 *   	 * @author David Knape	 */	public class Label extends Component 	{		// child text field, created if not found on stage		public var textField:TextField;				// text format to be applied to the TextField		protected var _textFormat:TextFormat;		// padding around text field		protected var _padding:Padding = new Padding(0);		// original position of content_txt 		protected var _textOffsetX:Number = 0;		protected var _textOffsetY:Number = 0;		// content tet		protected var _text:String = "";		// whether or not we're using HTML
		protected var _html:Boolean = false;		// max lines to display		protected var _maxLines:uint = 0;		// validation constants		protected static const VALID_TEXT:String = "validText";
				function Label( txt:String = "", txtFormat:TextFormat = null):void {				_textFormat = (txtFormat != null) ? txtFormat : Style.LABEL_TEXT_FORMAT;						// init, addChildren, and invalidate			super();						if(txt != "") text = txt;						//logEnabled = true;			//showBounds = true;			}				override protected function addChildren():void {						if(textField) {							// content_txt was placed on the stage of a MovieClip in Flash									// use existing text format and keep track of 				// original text field position				_textFormat = textField.getTextFormat();				_textOffsetX = textField.x;				_textOffsetY = textField.y;								// prevent off-pixel text				textField.scaleX = textField.scaleY = 1; 				textField.x = Math.round(textField.x);				textField.y = Math.round(textField.y);							} else {				// create content_txt				textField = add(TextField, { defaultTextFormat: textFormat, embedFonts: Style.LABEL_FONT_EMBEDDED, selectable: false });			} 									delayUpdate = false;		}					override protected function draw():void {						if(textField == null) return;						textField.y = Math.round(_textOffsetY + padding.top);			textField.x = Math.round(_textOffsetX + padding.left);									// If width was explictly set, figure out how we should wrap			if(explicitWidth) {								// Single line Text Input				if(editable && maxLines==1) {					textField.wordWrap =  textField.multiline = false;					textField.autoSize = TextFieldAutoSize.NONE;									// Multiline, wordWrap, autoSize height				} else {					textField.wordWrap =  textField.multiline = true;						textField.autoSize = TextFieldAutoSize.LEFT;				}								textField.width = explicitWidth - padding.width;								} else {								// no width specified, stay on one line and autoSize width				textField.autoSize = TextFieldAutoSize.LEFT;				textField.wordWrap =  textField.multiline = false;								}						if(_html) {				textField.htmlText = _text;			} else {				textField.visible = false;				textField.text = _text;								// check max lines (doesn't work with HTML yet)					if(maxLines > 0 && textField.numLines > maxLines) {											var txt:String = "";					for(var n:int = 0;n < maxLines;n++) {												txt += textField.getLineText(n);					}					if(_text.length > txt.length) {						txt = txt.substr(0, txt.length - 4) + "...";											}					textField.text = txt;				}				textField.visible = true;			}									_textHeight = 0;			for(var i:int = 0;i < textField.numLines;i++) {				_textHeight += textField.getLineMetrics(i).height;			}						log('draw');			super.draw();		}				protected var _textHeight:Number = 0;				public function get textFormat():TextFormat {			return textField ? textField.getTextFormat() : _textFormat;		}				public function set textFormat( tf:TextFormat ):void {			_textFormat = ObjectUtil.clone(tf) as TextFormat;			textField.defaultTextFormat = tf;			textField.setTextFormat(tf);			invalidate();		}				/**		 * TextFormat.bold		 */		public function set bold( val:Boolean ):void {			setStyle('bold', val);		}				public function get bold():Boolean {			return getStyle('bold');		}				/**		 * TextFormat.align		 */		public function set textAlign( val:String ):void {			setStyle('align', val);		}				public function get textAlign():String {			return getStyle('align');		}				/**		 * TextFormat.size		 */		public function set fontSize( val:Number ):void {			setStyle('size', val);		}				public function get fontSize():Number {			return getStyle('size');		}				/**		 * TextFormat.color as number or string		 */		public function set color(val:*):void {			if(isNaN(val)) val = parseInt(val, 16);			setStyle('color', val);		}				/**		 * TextFormat.color		 */		public function get color():* {			return getStyle('color');		}				/**		 * TextFormat.font		 */		public function set font( val:String ):void {			setStyle('font', val);		}				public function get font():String {			return getStyle('font');		}				/**		 * Shortcut for setting textFormat properties		 */		public function setStyle( name:String, value:* ):void {			var tf:TextFormat = textFormat;			tf[name] = value;			textFormat = tf;		}				public function getStyle( name:String ):* {			return textFormat[name];		}				public function set text( s:String ):void {			if(s == null) s = "";			_text = s;			_html = false;			invalidate(VALID_TEXT);		}				public function set htmlText( s:String ):void {			if(s == null) s = "";			_text = s;			_html = true;			invalidate(VALID_TEXT);		}				public function get text():String {			return _text;		}				public function get htmlText():String {			return _text;		}				override public function get actualHeight():Number {			return Math.ceil(textField.getBounds(this).height + padding.height);		}				/**		 * Always return actual height, not explicit height for scrolling purposes		 */		override public function get height():Number {			return actualHeight;		}				override public function get actualWidth():Number {			return Math.ceil(textField.getBounds(this).width + padding.width);		}				override public function get width():Number {			if(explicitWidth) return super.width;			else return actualWidth;		}		public function set padding ( p:* ) : void {			if(p is Padding) _padding = (p as Padding).clone();			else _padding = Padding.fromString( String(p) );			invalidate();		}						public function get padding () : Padding {			return _padding;		}				public function set wordWrap(val:Boolean):void {			textField.wordWrap = val;			textField.multiline = val;		}				public function get maxLines():uint {			return _maxLines;		}				public function set maxLines(maxLines:uint):void {			_maxLines = maxLines;			invalidate();		}				public function get selectable():Boolean {			return textField.selectable;		}				public function set selectable( val:Boolean ):void {			textField.selectable = val;		}				public function get editable():Boolean {			return textField.type == TextFieldType.INPUT;		}				public function set editable( val:Boolean ):void {			textField.type = val ? TextFieldType.INPUT : TextFieldType.DYNAMIC; 		}				public function get embedFonts():Boolean {			return textField.embedFonts;		}				public function set embedFonts( val:Boolean ):void {			textField.embedFonts = val;		}	}}