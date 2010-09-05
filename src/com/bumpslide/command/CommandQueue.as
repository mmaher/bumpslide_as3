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

package com.bumpslide.command {	import com.bumpslide.net.IResponder;		import com.bumpslide.data.Action;	import com.bumpslide.data.ActionQueue;	import com.bumpslide.util.Delegate;		import flash.events.Event;	import flash.events.EventDispatcher;	import flash.utils.Dictionary;			/**	 * Macro/Sequence Command	 * 	 * - manages a queue of commands	 * - implements ICommand interface to facilitate nesting of sequences	 * 	 * This is useful for things like application startup where you really 	 * just want to run a bunch of commands in sequence, but you want to 	 * make sure each one finishes before the next is run.	 *  	 * @author David Knape	 */	public class CommandQueue extends EventDispatcher implements ICommand {		public var debugEnabled:Boolean = false;				protected var _queue:ActionQueue;		protected var _actions:Dictionary;		protected var _callback:IResponder;				public function CommandQueue() {			_queue = new ActionQueue();			//_queue.addEventListener( Event.COMPLETE, handleQueueComplete );			_queue.paused = true;			//_queue.debugEnabled = true;			_actions = new Dictionary();		}//		//		private function handleQueueComplete(event:Event):void {//			trace('[CommandQueue] Sequence Complete '+this);//			dispatchEvent( new Event( Event.COMPLETE ) );//		}		public function add( commandClass:Class, dataOrEvent:*=null, priority:int=1):ICommand {						var e:CommandEvent = dataOrEvent is CommandEvent ? dataOrEvent as CommandEvent : new CommandEvent( "enqueuedEvent", dataOrEvent );			var command:ICommand = new commandClass();			command.addEventListener( Event.COMPLETE, handleCommandComplete );									// create action			var f:Function = Delegate.create( doExecute, command, e );			var a:Action=new Action(f, priority);						// save reference to action so it can be cancelled using the command as a key			_actions[command] = a; 			debug('Enqueueing Action ' + a );			_queue.enqueue(a);						return command;		}				protected function doExecute( command:ICommand, event:CommandEvent=null ):void {			command.execute( event );		}		/**		 * Cancel any pending calls to a specific command class		 */		public function remove( command:ICommand ):void {						command.cancel();					finish( command );		}				/**		 * Start the queue		 */		public function execute(event:CommandEvent):void {			debug('Running Sequence' ); 			if(_queue.paused) _queue.paused = false;			_callback = event;		}				/**		 * remove all pending commands, and cancel active ones		 */		public function cancel() : void {						for( var c:Object in _actions) remove(c as ICommand);			_queue.clear();		}				private function handleCommandComplete(event:Event):void {			finish( event.target as ICommand );		}				private function finish( command:ICommand ):void {			debug('Finishing ' + command + ' ');			if(command == null) return;			var a:Action=_actions[command];			if(a != null) {				delete _actions[command];				_queue.remove(a);			}			command.removeEventListener( Event.COMPLETE, handleCommandComplete );						if(size==0) {				debug('Sequence Complete ');				dispatchEvent( new Event( Event.COMPLETE ) );								// call callback result				if(callback) callback.result(null);			}		}		public function get size():int {			return _queue.size;		}				public function get callback():IResponder {			return _callback;		}				public function set callback(callback:IResponder):void {			_callback = callback;		}				protected function debug(s:*) : void {			if(debugEnabled) trace( this + ' ' + s );		}				override public function toString():String {			return "[CommandQueue]";		}	}}