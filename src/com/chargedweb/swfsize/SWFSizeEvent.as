////////////////////////////////////////////////////////////////////////////////
//
//	@author		Julius Loa a.k.a. Jloa | jloa[at]chargedweb.com
//	@link		www.chargedweb.com/swfsize/
//	@project	SWFSize
//
// 	Licence:	CC 3.0 { http://creativecommons.org/licenses/by-sa/3.0/ }
//	Note: 		the project is fully open source; just please keep the header;
//				if u r to make any changes please add your info
//				(author/email/version/changes) to the header
//
////////////////////////////////////////////////////////////////////////////////
/**
 * changes
 * 
 * v.1.4
 *  - n/a
 * 
 * v.1.3 
 * 	- n/a
 * 
 * v.1.2
 *  - n/a
 * 
 * v.1.1
 *  - property windowWidth added
 *  - property windowHeight added
 *  - property swfWidth added
 *  - property swfHeight added
 *  - property scrollX added
 *  - property scrollY added
 */
package com.chargedweb.swfsize
{
	// fp API
	import flash.events.Event;
	
	/**
	 * <p>The SWFSizeEvent class defines events that are associated with the SWFSize object.</p>
	 * <p>These include the following events:</p>
	 * <ul>
	 * <li><code>SWFSizeEvent.INIT</code>: dispatched when SWFSize js is loaded and ready;</li>
	 * <li><code>SWFSizeEvent.SCROLL</code>: dispatched when user scrolls browser's native scrollbars;</li>
	 * <li><code>SWFSizeEvent.RESIZE</code>: dispatched when browser's window is being resized.</li>
	 * </ul>
	 * @see SWFSize 
	 */
	public class SWFSizeEvent extends Event
	{
		/**
		 * <p>The SWFSizeEvent.INIT constant defines the value of the <code>type</code> property of the
		 * event object for a <code>onInit</code> event; dispatched when SWFSize js is loaded and ready.</p>
		 * @eventType onInit
		 */
		public static const INIT:String = "onInit";
		
		/**
		 * <p>The SWFSizeEvent.SCROLL constant defines the value of the <code>type</code> property of the
		 * event object for a <code>onScroll</code> event; dispatched when user scrolls the browser's native scrollbars.</p>
		 * @eventType onScroll
		 */
		public static const SCROLL:String = "onScroll";
		
		/**
		 * <p>The SWFSizeEvent.SCROLL constant defines the value of the <code>type</code> property of the
		 * event object for a <code>onResize</code> event; dispatched when the browser's window is being resized.</p>
		 * @eventType onResize
		 */
		public static const RESIZE:String = "onResize";
		
		/**
		 * Current browser's window leftX coordinate value
		 */ 
		public var leftX:Number;
		
		/**
		 * Current browser's window rightX coordinate value
		 */ 
		public var rightX:Number;
		
		/**
		 * Current browser's window topY coordinate value
		 */
		public var topY:Number;
		
		/**
		 * Current browser's window bottomY coordinate value
		 */
		public var bottomY:Number;
		
		/**
		 * Current browser's window width value
		 */
		public var windowWidth:Number;
		
		/**
		 * Current browser's height width value
		 */
		public var windowHeight:Number;
		
		/**
		 * Current swf container's width value
		 */
		public var swfWidth:Object;
		
		/**
		 * Current swf container's height value
		 */
		public var swfHeight:Object;
		
		/**
		 * Current scrollX value
		 */
		public var scrollX:Number;
		
		/**
		 * Current scrollY value
		 */
		public var scrollY:Number;
		
		/**
		 * Constructor; creates a new SWFSizeEvent object.
		 * @param	type:String				event type
		 * @param	leftX:Number			browser's leftX coordinate
		 * @param	rightX:Number			browser's rightX coordinate
		 * @param	topY:Number				browser's topY coordinate
		 * @param	bottomY:Number			the browser's bottomY coordinate
		 * @param	windowWidth:Number		the browser's window width value
		 * @param	windowHeight:Number		the browser's window height value
		 * @param	swfWidth:Object			swf container's width value object
		 * @param	swfHeight:Object		swf container's height value object
		 * @param	scrollX:Number			current scrollX value
		 * @param	scrollY:Number			current scrollY value
		 * @param	bubbles:Boolean			bubbles @see flash.events.Event @default false
		 * @param	cancelable:Boolean		cancelable @see flash.events.Event @default false
		 */
		public function SWFSizeEvent(type:String,
									 leftX:Number,
									 rightX:Number,
									 topY:Number,
									 bottomY:Number,
									 windowWidth:Number,
									 windowHeight:Number,
									 swfWidth:Object,
									 swfHeight:Object,
									 scrollX:Number,
									 scrollY:Number,
									 bubbles:Boolean = false,
									 cancelable:Boolean = false):void
		{
			this.topY = topY;
			this.bottomY = bottomY;
			this.leftX = leftX;
			this.rightX = rightX;
			this.windowWidth = windowWidth;
			this.windowHeight = windowHeight;
			this.swfWidth = swfWidth;
			this.swfHeight = swfHeight;
			this.scrollX = scrollX;
			this.scrollY = scrollY;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Formats the event as string
		 * @return	the string representation of the SWFSizeEvent class. 
		 */
		override public function toString():String
		{ 
			return formatToString("SWFSizeEvent",
								  "type",
								  "leftX",
								  "rightX",
								  "topY",
								  "bottomY",
								  "windowWidth",
								  "windowHeight",
								  "swfWidth",
								  "swfHeight",
								  "scrollX",
								  "scrollY",
								  "bubbles",
								  "cancelable"); 
		}
	}
}