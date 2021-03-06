/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */

package com.bumpslide.net.deprecated {    import flash.events.Event;        /**     * Events fired from URLLoaderQueue     *      * @author David Knape     */    public class URLEvent extends Event {    	    	static public const ERROR:String = "urlError";    	static public const PROGRESS:String = "urlProgress";    	static public const COMPLETE:String = "urlComplete";    	    	private var _result:String;    	private var _message:String;    	private var _url:String;    	private var _data:*;    	private var _percentLoaded:*;            	    	        public function URLEvent(type:String, url:String, result:String="", data:*=null, message:String="", percentLoaded:Number=1)        {            super(type, false, false);            _url = url;            _result = result;            _data = data;            _message = message;            _percentLoaded = percentLoaded;        }                // requested url        public function get url():String        {            return _url;        }                // http result        public function get result ():String        {            return _result;        }                // app-specific data        public function get data ():String        {            return _data;        }                // Error Message        public function get message ():String        {            return _message;        }                public function get percentLoaded() : Number {            return _percentLoaded;        }    }}