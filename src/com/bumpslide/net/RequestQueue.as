﻿/**
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

package com.bumpslide.net {	import com.bumpslide.data.Action;	import com.bumpslide.data.ActionQueue;	import com.bumpslide.data.Callback;	import com.bumpslide.util.Delegate;	import com.bumpslide.util.StringUtil;		import flash.events.Event;	import flash.events.EventDispatcher;	import flash.utils.Dictionary;
	[Event(name="complete", type="flash.event.Event")]		/**	 * Prioritized and 'multi-threaded' loading queue for RPC requests	 * 	 * Built on top of the ActionQueue.	 *  	 * @author David Knape	 */	public class RequestQueue extends EventDispatcher 	{		// the queue		protected var _actionQueue:ActionQueue;				// actions indexed by request		protected var _actions:Dictionary;		// trace log?		public var debugEnabled:Boolean = false;				public function RequestQueue(threadCount:uint = 1) 		{			_actionQueue = new ActionQueue();			_actionQueue.threads = threadCount;			_actions = new Dictionary(true);						// Note to self:			// We can't just listen for queue complete, beacause actionqueue is			// not aware of asynchronous nature of our actions			// Thus, we can't do this...//			_actionQueue.addEventListener(Event.COMPLETE, function(event:Event):void {//				dispatchEvent( event );//			} );		}				public function clear():void 		{			var req:IRequest;			for( var o:Object in _actions) {				req = (o as IRequest);				req.cancel();				remove(req);			}			_actionQueue.clear();		}				public function load( req:IRequest, priority:Number = 1 ):void 		{						// remove existing			if(_actions[req]) remove(req);						debug('load() - enqueuing ' + req);			// create action			var a:Action = new Action(req.load, priority);			req.addResponder(new Callback(Delegate.create(handleResult, req), Delegate.create(handleError, req))); 						// save reference to action so it can be cancelled using the req as a key			_actions[req] = a; 			_actionQueue.enqueue(a);		}				protected function handleError( info:Object, req:IRequest ):void 		{			debug('handleError() ' + String(req) + String(info));			remove(req);		}				protected function handleResult(result:Object, req:IRequest):void 		{			debug('handleResult() ' + req + StringUtil.abbreviate(String(result), 20));			remove(req);		}				protected function remove( req:IRequest ):void 		{			if(req == null) return;			var a:Action = _actions[req];			_actionQueue.remove(a);			delete _actions[req];						if(actionQueue.currentActions.length==0 && actionQueue.size==0) {				// dispatch complete event if there are no more actions running				debug('Queue complete');				dispatchEvent( new Event(Event.COMPLETE) );			}		}				public function get threads():uint {			return _actionQueue.threads;		}				public function set threads(threads:uint):void {			_actionQueue.threads = threads;		}				public function get size():uint {			return _actionQueue.size;		}				protected function debug( s:* ):void 		{			if(debugEnabled) trace('[RequestQueue] ' + s);		}				public function get actionQueue():ActionQueue {			return _actionQueue;		}	}}