////////////////////////////////////////////////////////////////////////////////
//
//	@author		Julius Loa a.k.a. Jloa | jloa[at]chargedweb.com
//	@link		www.chargedweb.com/swfsize/
//	@version	1.3
//	@project	SWFSize
//
// 	Licence:	CC 3.0 { http://creativecommons.org/licenses/by-sa/3.0/ }
//	Note: 		the project is fully open source; just please keep the header;
//				if u r to make any changes please add your info
//				(author/email/version/changes) to the header
//
////////////////////////////////////////////////////////////////////////////////
/**
 * v.1.2 changes
 * 
 * 	- switched the js engine singleton -> class (for more changes info read the js file) 
 * 	- SWF_ID property added
 * 	- js methods rewritten
 * 
 * v.1.1 changes
 * 
 *  - increase in performance for setters using multithreading (setTimeout hack)
 *  - method setWidth() renamed to setSWFWidth
 *  - method getWidth() renamed to getSWFWidth
 *  - method setHeight() renamed to setSWFHeight
 *  - method getHeight() renamed to getSWFHeight
 *  - SWFSizeEvent now passes six more properties
 */
package com.chargedweb.swfsize
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	/**
	 * SWFSize class gives you the ability to:
	 * <ul>
	 * <li>control the swf's container metrics;</li>
	 * <li>gather browser's window metrics &amp; position;</li>
	 * <li>control the browser's native scrollbars.</li>
	 * </ul>
	 * @example The following code initializes the SWFSize and when the <code>SWFSizeEvent.INIT</code> is dispatched
	 * retrieves browser's window coordinates and metrics:
	 * <listing version="3.0">
	 * // import the SWFSize api
	 * import com.chargedweb.swfsize.SWFSize;
	 * import com.chargedweb.swfsize.SWFSizeEvent;
	 * 
	 * // initialize SWFSize
	 * SWFSize.SWF_ID = stage.loaderInfo.parameters.swfsizeId;
	 * var swfSizer:SWFSize = SWFSize.getInstance();
	 * swfSizer.addEventListener(SWFSizeEvent.INIT, onSWFSizeInit);
	 * 
	 * function onSWFSizeInit(event:SWFSizeEvent):void<br>
	 * {
	 * 	// your code logic goes here
	 * 	// eg: retrieve window coordinates and metrics on init
	 * 	trace(event.topY, event.bottomY, event.leftX, event.rightX);
	 * 	trace(swfSizer.windowWidth, swfSizer.windowHeight);
	 * }      
	 * </listing>
	 * 
	 * @see SWFSizeEvent
	 */
	public class SWFSize extends EventDispatcher
	{	
		/**
		 * The swf attributes.id defined in the html code; you have to define this before calling other methods;
		 */
		public static var SWF_ID:String;
		
		// SWFSize JS methods declaration
		private static var METHOD_INIT:String = "SWFSizePool.getItemById('%id%').init";
		private static var METHOD_SET_SCROLL_X:String = "SWFSizePool.getItemById('%id%').setScrollX";
		private static var METHOD_SET_SCROLL_Y:String = "SWFSizePool.getItemById('%id%').setScrollY";
		private static var METHOD_GET_SCROLL_X:String = "SWFSizePool.getItemById('%id%').getScrollX";
		private static var METHOD_GET_SCROLL_Y:String = "SWFSizePool.getItemById('%id%').getScrollY";
		private static var METHOD_SET_SWF_WIDTH:String = "SWFSizePool.getItemById('%id%').setSWFWidth";
		private static var METHOD_SET_SWF_HEIGHT:String = "SWFSizePool.getItemById('%id%').setSWFHeight";
		private static var METHOD_GET_SWF_WIDTH:String = "SWFSizePool.getItemById('%id%').getSWFWidth";
		private static var METHOD_GET_SWF_HEIGHT:String = "SWFSizePool.getItemById('%id%').geSWFtHeight";
		private static var METHOD_GET_WINDOW_WIDTH:String = "SWFSizePool.getItemById('%id%').getWindowWidth";
		private static var METHOD_GET_WINDOW_HEIGHT:String = "SWFSizePool.getItemById('%id%').getWindowHeight";
		private static var METHOD_GET_LEFT_X:String = "SWFSizePool.getItemById('%id%').getLeftX";
		private static var METHOD_GET_RIGHT_X:String = "SWFSizePool.getItemById('%id%').getRightX";
		private static var METHOD_GET_TOP_Y:String = "SWFSizePool.getItemById('%id%').getTopY";
		private static var METHOD_GET_BOTTOM_Y:String = "SWFSizePool.getItemById('%id%').getBottomY";
		
		// SWFSize value types declaration
		private static const TYPE_ABSOLUTE:String = "px";
		private static const TYPE_RELATIVE:String = "%";
		
		// Singleton instance
		private static var INSTANCE:SWFSize = null;
		
		// The browser's coordinate values
		private var _topY:Number = 0;
		private var _botY:Number = 0;
		private var _leftX:Number = 0;
		private var _rightX:Number = 0;
		
		// The browser's scroll values
		private var _scrollX:Number = 0;
		private var _scrollY:Number = 0;
		
		// Swf metrics
		private var _swfWidth:Object = {value: 0, absolute: true};
		private var _swfHeight:Object = {value: 0, absolute: true};
		
		// Browser window metrics
		private var _windowWidth:Number = 0;
		private var _windowHeight:Number = 0;
		
		// Holds the value type
		private var valueType:String;
		
		// EI availability flag
		private var available:Boolean = ExternalInterface.available;
	
		// Init hack timer (addCallBack needs time to register callbacks)
		private var initTimer:Timer = new Timer(50);
		
		// Init result holder
		private var initResult:int = 0;
		
		// JS raw result
		private var JSRawResult:String;
		
		/**
         * @throws IllegalOperationError The class cannot be instantiated.
         */
        public function SWFSize(key:SWFSizeKey = null)
		{
			super();
			if(!key || !(key is SWFSizeKey)) throw new IllegalOperationError('SWFSize cannot be instantiated.');
        }
		
		////////////////////////////////
		//
		//	PUBLIC
		//
		////////////////////////////////
		
		/**
		 * Singleton construction
		 * @return	SWFSize
		 */
		public static function getInstance():SWFSize
		{
			if (!INSTANCE) INSTANCE = new SWFSize(new SWFSizeKey()); INSTANCE.init();
			return INSTANCE;
		}
		
		/**
		 * Fits the swf's width value to browser's available width
		 * @param	always:Boolean	if set to true makes the swf's width property elastic @default false
		 * @return	nothing
		 */
		public function autoSizeWidth(always:Boolean = false):void
		{
			if(always)
				setSWFWidth(100, false);
			else
				setSWFWidth(windowWidth, true);
		}
		
		/**
		 * Fits the swf's height value to browser's available height
		 * @param	always:Boolean	if set to true makes the swf's height property elastic @default false
		 * @return	nothing
		 */
		public function autoSizeHeight(always:Boolean = false):void
		{
			if(always)
				setSWFHeight(100, false);
			else
				setSWFHeight(windowHeight, true);
		}
		
		/**
		 * Fits the swf's width and height values to browser available width and height
		 * @param	always:Boolean	if set to true makes the swf's width and height properties elastic @default false
		 * @return	nothing
		 */
		public function autoSize(always:Boolean = false):void
		{
			if (available)
			{
				if (always)
				{
					setSWFWidth(100, false);
					setSWFHeight(100, false);
				}else {
					setSWFWidth(windowWidth, true);
					setSWFHeight(windowHeight, true);
				}
			}
		}
		
		/**
		 * Sets the width property of the swf container
		 * @param	value:Number		new width value
		 * @param	absolute:Boolean	whether the value is absolute or relative (%) @default true
		 * @return	nothing
		 */
		public function setSWFWidth(value:Number, absolute:Boolean = true):void
		{
			valueType = (absolute) ? TYPE_ABSOLUTE : TYPE_RELATIVE;
			if (available) callJSMethod(METHOD_SET_SWF_WIDTH, value, valueType);
			//ExternalInterface.call(METHOD_SET_WIDTH, value, valueType);
		}
		
		/**
		 * Returns the current width value of the swf container
		 * @return	Object	{ value:Number, absolute:Boolean };
		 */
		public function getSWFWidth():Object
		{
			return _swfWidth;
		}
		
		/**
		 * Sets the height property of the swf container
		 * @param	value:Number		new height value
		 * @param	absolute:Boolean	whether the value is absolute or relative (%) @default true
		 * @return	nothing
		 */
		public function setSWFHeight(value:Number, absolute:Boolean = true):void
		{
			valueType = (absolute) ? TYPE_ABSOLUTE : TYPE_RELATIVE;
			if (available) callJSMethod(METHOD_SET_SWF_HEIGHT, value, valueType);
			//ExternalInterface.call(METHOD_SET_HEIGHT, value, valueType);
		}
		
		/**
		 * Returns the current height value of the swf container
		 * @return	Object	{ value:Number, absolute:Boolean };
		 */
		public function getSWFHeight():Object
		{
			return _swfHeight;
		}
		
		/**
		 * Returns the current available browser window width
		 * @return	Number
		 */
		public function get windowWidth():Number
		{
			return _windowWidth;
		}
		
		/**
		 * Returns the current available browser window height
		 * @return	Number
		 */
		public function get windowHeight():Number
		{
			return _windowHeight;
		}
		
		/**
		 * Returns the current leftX coordinate i.e. the relative x '0' coordinate of the browser
		 * @return	Number	current leftX coordinate
		 */
		public function get leftX():Number
		{
			return _leftX;
		}
		
		/**
		 * Returns the current rightX coordinate i.e. equals to leftX + windowWidth
		 * @return	Number	current rightX coordinate
		 */
		public function get rightX():Number
		{
			return _rightX;
		}
		
		/**
		 * Returns the current topY coordinate i.e. the relative y '0' coordinate of the browser
		 * @return	Number	current topY coordinate
		 */
		public function get topY():Number
		{
			return _topY;
		}
		
		/**
		 * Returns the current bottomY coordinate i.e. equals to topY + windowHeight
		 * @return	Number	current bottomY coordinate
		 */
		public function get bottomY():Number
		{
			return _botY;
		}
		
		/**
		 * {set/get} Scrolls the window to the X-axis to a specified value of pixels
		 * @param	value:Number	amount of pixels to scroll horizontally
		 * @return	Number			the current horizontal scroll amount
		 */
		public function set scrollX(value:Number):void
		{
			if (available) callJSMethod(METHOD_SET_SCROLL_X, value);
			//ExternalInterface.call(METHOD_SET_SCROLL_X, (value));
		}
		
		public function get scrollX():Number
		{
			return _scrollX;
		}
		
		/**
		 * {set/get} Scrolls the window to the Y-axis to a specified value of pixels
		 * @param	value:Number	amount of pixels to scroll vertically
		 * @return	Number			the current vertical scroll amount
		 */
		public function set scrollY(value:Number):void
		{
			if (available) callJSMethod(METHOD_SET_SCROLL_Y, value);
			//ExternalInterface.call(METHOD_SET_SCROLL_Y, (value));
		}
		
		public function get scrollY():Number
		{
			return _scrollY;
		}
		
		////////////////////////////////
		//
		//	PRIVATE
		//
		////////////////////////////////
		
		/**
		 * @private Initializes the callbacks
		 * @return	nothing
		 */
		private function init():void
		{
			if (!SWF_ID) throw new Error("SWF_ID not defined !");
					
			if (available)
			{
				METHOD_INIT = METHOD_INIT.replace("%id%", SWF_ID);
				METHOD_SET_SCROLL_X = METHOD_SET_SCROLL_X.replace("%id%", SWF_ID);
				METHOD_SET_SCROLL_Y = METHOD_SET_SCROLL_Y.replace("%id%", SWF_ID);
				METHOD_GET_SCROLL_X = METHOD_GET_SCROLL_X.replace("%id%", SWF_ID);
				METHOD_GET_SCROLL_Y = METHOD_GET_SCROLL_Y.replace("%id%", SWF_ID);
				METHOD_SET_SWF_WIDTH = METHOD_SET_SWF_WIDTH.replace("%id%", SWF_ID);
				METHOD_SET_SWF_HEIGHT = METHOD_SET_SWF_HEIGHT.replace("%id%", SWF_ID);
				METHOD_GET_SWF_WIDTH = METHOD_GET_SWF_WIDTH.replace("%id%", SWF_ID);
				METHOD_GET_SWF_HEIGHT = METHOD_GET_SWF_HEIGHT.replace("%id%", SWF_ID);
				METHOD_GET_WINDOW_WIDTH = METHOD_GET_WINDOW_WIDTH.replace("%id%", SWF_ID);
				METHOD_GET_WINDOW_HEIGHT = METHOD_GET_WINDOW_HEIGHT.replace("%id%", SWF_ID);
				METHOD_GET_LEFT_X = METHOD_GET_LEFT_X.replace("%id%", SWF_ID);
				METHOD_GET_RIGHT_X = METHOD_GET_RIGHT_X.replace("%id%", SWF_ID);
				METHOD_GET_TOP_Y = METHOD_GET_TOP_Y.replace("%id%", SWF_ID);
				METHOD_GET_BOTTOM_Y  = METHOD_GET_BOTTOM_Y.replace("%id%", SWF_ID);
				
				ExternalInterface.addCallback("onWindowInit", onWindowInitHandler);
				ExternalInterface.addCallback("onWindowScroll", onWindowScrollHandler);
				ExternalInterface.addCallback("onWindowResize", onWindowResizeHandler);
				
				// don't need this line any more | just use the hack
				//initResult = int(String(ExternalInterface.call(METHOD_INIT)));
				// if not initialized force the initTimer to init the SWFSize js lib {opera hack}
				if (initResult == 0)
				{
					initTimer.addEventListener(TimerEvent.TIMER, onInitTimerHandler);
					initTimer.start();
				}
			}
		}
		
		/**
		 * @private Forces the initialization of the SWFSize js lib {opera hack}; i HATE opera;
		 * @param	event:TimerEvent
		 */
		private function onInitTimerHandler(event:TimerEvent):void
		{
			initResult = int(String(ExternalInterface.call(METHOD_INIT)));
			
			if (initResult == 1)
			{
				initTimer.stop();
				initTimer.removeEventListener(TimerEvent.TIMER, onInitTimerHandler);
				initTimer = null;
			}
		}
		
		/**
		 * @private On window init handler
		 * @param	event:String	passed params
		 */
		private function onWindowInitHandler(event:String):void
		{
			parseEventData(event);
			dispatchEvent(new SWFSizeEvent(SWFSizeEvent.INIT,
										   _leftX,
										   _rightX,
										   _topY,
										   _botY,
										   _windowWidth,
										   _windowHeight,
										   _swfWidth,
										   _swfHeight,
										   _scrollX,
										   _scrollY));
		}
		
		/**
		 * @private On window scroll handler
		 * @param	event:String	passed params
		 */
		private function onWindowScrollHandler(event:String):void
		{
			parseEventData(event);
			dispatchEvent(new SWFSizeEvent(SWFSizeEvent.SCROLL,
										   _leftX,
										   _rightX,
										   _topY,
										   _botY,
										   _windowWidth,
										   _windowHeight,
										   _swfWidth,
										   _swfHeight,
										   _scrollX,
										   _scrollY));
		}
		
		/**
		 * @private On window resize handler
		 * @param	event:String	passed params
		 */
		private function onWindowResizeHandler(event:String):void
		{
			parseEventData(event);
			dispatchEvent(new SWFSizeEvent(SWFSizeEvent.RESIZE,
										   _leftX,
										   _rightX,
										   _topY,
										   _botY,
										   _windowWidth,
										   _windowHeight,
										   _swfWidth,
										   _swfHeight,
										   _scrollX,
										   _scrollY));
		}
		
		/**
		 * @private Parses the event data
		 * @param	event:String	js event data
		 * @return	nothing
		 */ 
		private function parseEventData(event:String):void
		{
			var eventData:Array = event.split(",");
			_topY = Number(eventData[0]);
			_botY = Number(eventData[1]);
			_leftX = Number(eventData[2]);
			_rightX = Number(eventData[3]);
			_windowWidth = Number(eventData[4]);
			_windowHeight = Number(eventData[5]);
			_swfWidth = toSWFMetrics(eventData[6]);
			_swfHeight = toSWFMetrics(eventData[7]);
			_scrollX = Number(eventData[8]);
			_scrollY = Number(eventData[9]);
		}
		
		/**
		 * @private Converts a value to a swf metrics object
		 * @param	value:String	value to convert
		 * @return	Object			swf metrics object 
		 */ 
		private function toSWFMetrics(value:String):Object
		{
			var result:Object = {};
			result.value = Number(value.split(TYPE_RELATIVE).join(""));
			result.absolute = (value.indexOf(TYPE_RELATIVE) < 0);
			return result;	
		}
		
		/**
		 * @private Call js method using multithreading
		 * @param	jsMethod:String		js method name to be called
		 * @param	...params:*			params to apply to the called js method
		 */
		private function callJSMethod(jsMethod:String, ...params):void
		{
			var n:int = params.length;
			var jsCall:String = "%method%(%params%)";
			var jsParams:String = "";
			for(var i:int = 0; i < n; i++) jsParams += (i == n-1) ? "'"+params[i]+"'" : "'"+params[i]+"',";
			jsCall = jsCall.replace("%method%", jsMethod);
			jsCall = jsCall.replace("%params%", jsParams);
			if(available) ExternalInterface.call("setTimeout", jsCall, 0);
		}
	}
}
// top secret key ^_^
internal class SWFSizeKey { };