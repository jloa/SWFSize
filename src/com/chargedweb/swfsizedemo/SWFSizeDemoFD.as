////////////////////////////////////////////////////////////////////////////////
//
//	@author		Julius Loa a.k.a. Jloa | jloa[at]chargedweb.com
//	@link		www.chargedweb.com/labs/
//	@version	1.0
//	@project	SWFSize demo
//
// 	Licence:	CC 3.0 { http://creativecommons.org/licenses/by-sa/3.0/ }
//	Note: 		the project is fully open source; just please keep the header;
//				if u r to make any changes please add your info
//				(author/email/version/changes) to the header
//
////////////////////////////////////////////////////////////////////////////////

package com.chargedweb.swfsizedemo
{
	// SWFSize api
	import com.chargedweb.swfsize.SWFSize;
	import com.chargedweb.swfsize.SWFSizeEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	// TweenLite api
	import gs.TweenLite;
	import gs.easing.*;

	// fp api
	import fl.controls.TextInput;
	import fl.controls.CheckBox;
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.Event
	
	/**
	 * SWFSizeDemoFD class :: just a demo class of SWFSize usage
	 */
	public class SWFSizeDemoFD extends MovieClip
	{
		// SWFSize ref
		private var swfSizer:SWFSize;
		
		// stage UI objects (i were lazy to create them here ^_^)
		private var widthTF:TextInput;
		private var wwidthTF:TextInput;
		private var heightTF:TextInput;
		private var wheightTF:TextInput;
		private var wleftXTF:TextInput;
		private var wrightXTF:TextInput;
		private var wtopYTF:TextInput;
		private var wbotYTF:TextInput;
		private var wabsChb:CheckBox;
		private var habsChb:CheckBox;
		private var awChb:CheckBox;
		private var ahChb:CheckBox;
		private var aChb:CheckBox;
		private var aboutBtn:Button;
		private var backBtn:Button;
		private var magicBtn:Button;
		private var mMagicBtn:Button;
		private var setwBtn:Button;
		private var sethBtn:Button;
		private var awBtn:Button;
		private var ahBtn:Button;
		private var aBtn:Button;
		private var windowInfoPanel:Sprite;
		private var infoSWFSize:Sprite;
		private var dude:Sprite;
		private var bg:Sprite;
		private var bgT:Sprite;
		private var bgR:Sprite;
		private var bgB:Sprite;
		private var bgL:Sprite;
		
		
		// just a num
		private var value:Number;
		
		/**
		 * Constructor
		 */ 
		public function SWFSizeDemoFD()
		{
			super();
			init();
		}
		
		////////////////////////////////
		//
		//	PUBLIC
		//
		////////////////////////////////
		
		/**
		 * Inits the demo UI
		 */
		public function init():void
		{
			// create SWFSize ref & add some listeners
			SWFSize.SWF_ID = stage.loaderInfo.parameters.swfsizeId;
			swfSizer = SWFSize.getInstance();
			swfSizer.addEventListener(SWFSizeEvent.INIT, onWindowInit);
			swfSizer.addEventListener(SWFSizeEvent.SCROLL, onWindowScroll);
			swfSizer.addEventListener(SWFSizeEvent.RESIZE, onWindowResize);
			
			// define stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			// Get the demo UI parts
			windowInfoPanel = getChildByName("_windowInfoPanel") as Sprite;
			infoSWFSize = getChildByName("_infoSWFSize") as Sprite;
			
			dude = getChildByName("_dude") as Sprite;
			dude.visible = false;
			dude.alpha = 0;
			dude.y = 1600;
			
			wleftXTF = windowInfoPanel.getChildByName("_wleftXTF") as TextInput;
			wleftXTF.restrict = "0-9";
			wleftXTF.text = "0";
			
			wrightXTF = windowInfoPanel.getChildByName("_wrightXTF") as TextInput;
			wrightXTF.restrict = "0-9";
			wrightXTF.text = "0";
			
			wtopYTF = windowInfoPanel.getChildByName("_wtopYTF") as TextInput;
			wtopYTF.restrict = "0-9";
			wtopYTF.text = "0";
			
			wbotYTF = windowInfoPanel.getChildByName("_wbotYTF") as TextInput;
			wbotYTF.restrict = "0-9";
			wbotYTF.text = "0";
			
			widthTF = getChildByName("_widthTF") as TextInput;
			widthTF.restrict = "0-9";
			widthTF.text = "0";
			
			wwidthTF = getChildByName("_wwidthTF") as TextInput;
			wwidthTF.text = "0";
			wwidthTF.restrict = "";
			
			heightTF = getChildByName("_heightTF") as TextInput;
			heightTF.restrict = "0-9";
			heightTF.text = "0";
			
			wheightTF = getChildByName("_wheightTF") as TextInput;
			wheightTF.text = "0";
			wheightTF.restrict = "";
			
			wabsChb = getChildByName("_wabsChb") as CheckBox;
			habsChb = getChildByName("_habsChb") as CheckBox;
			awChb = getChildByName("_awChb") as CheckBox;
			ahChb = getChildByName("_ahChb") as CheckBox;
			aChb = getChildByName("_aChb") as CheckBox;
			
			aboutBtn = getChildByName("_aboutBtn") as Button;
			aboutBtn.addEventListener(MouseEvent.CLICK, onAboutClick);
			
			backBtn = infoSWFSize.getChildByName("_backBtn") as Button;
			backBtn.addEventListener(MouseEvent.CLICK, onBackClick);
			
			magicBtn = getChildByName("_magicBtn") as Button;
			magicBtn.addEventListener(MouseEvent.CLICK, onMagicClick);
			
			mMagicBtn = dude.getChildByName("_magicBtn") as Button;
			mMagicBtn.addEventListener(MouseEvent.CLICK, onMoreMagicClick);
			
			setwBtn = getChildByName("_setwBtn") as Button;
			setwBtn.addEventListener(MouseEvent.CLICK, onSetWClick);
			
			sethBtn = getChildByName("_sethBtn") as Button;
			sethBtn.addEventListener(MouseEvent.CLICK, onSetHClick);
			
			awBtn = getChildByName("_awBtn") as Button;
			awBtn.addEventListener(MouseEvent.CLICK, onAutoSizeWClick);
			
			ahBtn = getChildByName("_ahBtn") as Button;
			ahBtn.addEventListener(MouseEvent.CLICK, onAutoSizeHClick);
			
			aBtn = getChildByName("_aBtn") as Button;
			aBtn.addEventListener(MouseEvent.CLICK, onAutoSizeClick);
			
			bg = getChildByName("_bg") as Sprite;
			bgT = getChildByName("_t") as Sprite;
			bgL = getChildByName("_l") as Sprite;
			bgB = getChildByName("_b") as Sprite;
			bgR = getChildByName("_r") as Sprite;
			
			onStageResize();
		}
		
		////////////////////////////////
		//
		//	PRIVATE
		//
		////////////////////////////////
		
		/**
		 * On window init handler i.e. body.onload
		 * @param	event:SWFSizeEvent
		 */
		private function onWindowInit(event:SWFSizeEvent):void
		{
			getAllMetrics();
			updateStickyItemsPos();
		}
		
		/**
		 * On window scroll handler
		 * @param	event:SWFSizeEvent
		 */
		private function onWindowScroll(event:SWFSizeEvent):void
		{
			getAllMetrics();
			updateStickyItemsPos();
		}
		
		/**
		 * On window resize handler
		 * @param	event:SWFSizeEvent
		 */
		private function onWindowResize(event:SWFSizeEvent):void
		{
			getAllMetrics();
			updateStickyItemsPos();
			onStageResize();
		}
		
		/**
		 * Update the positions of the sticky items
		 * @return	nothing
		 */
		private function updateStickyItemsPos():void
		{
			// make dude's x pos at center
			_dude.x = swfSizer.leftX + int(swfSizer.windowWidth / 2);
			
			// make it always stick to the top-left corner
			windowInfoPanel.x = swfSizer.leftX;
			windowInfoPanel.y = swfSizer.topY;
			
			// make it always stick to the top (center)
			bgT.x = swfSizer.leftX + int((swfSizer.windowWidth - bgT.width) / 2);
			bgT.y = swfSizer.topY;
			
			// make it always stick to the left (center)
			bgL.x = swfSizer.leftX;
			bgL.y = swfSizer.topY + int((swfSizer.windowHeight - bgL.height) / 2);
			
			// make it always stick to the right (center)
			bgR.x = swfSizer.rightX - bgR.width;
			bgR.y = swfSizer.topY + int((swfSizer.windowHeight - bgR.height) / 2);
			
			// make it always stick to the bottom (center)
			bgB.x = swfSizer.leftX + int((swfSizer.windowWidth - bgB.width) / 2);
			bgB.y = swfSizer.bottomY - bgB.height;
		}
		
		/**
		 * Get and show all metrics of the SWFSize
		 * @return	nothing
		 */
		private function getAllMetrics():void
		{
			// retrieve the current leftX value
			wleftXTF.text = String(swfSizer.leftX);
			
			// retrieve the current rightX value
			wrightXTF.text = String(swfSizer.rightX);
			
			// retrieve the current topY value
			wtopYTF.text = String(swfSizer.topY);
			
			// retrieve the current bottomY value
			wbotYTF.text = String(swfSizer.bottomY);
			
			// retrieve the current width value of the swf container
			var result:Object = swfSizer.getSWFWidth();
			widthTF.text = String(result.value);
			wabsChb.selected = result.absolute;
			
			// retrieve the current height value of the swf container
			result = swfSizer.getSWFHeight();
			heightTF.text = String(result.value);
			habsChb.selected = result.absolute;
			
			// get the browser window width
			wwidthTF.text = String(swfSizer.windowWidth);
			
			// get the browser window height 
			wheightTF.text = String(swfSizer.windowHeight);
		}
		
		/**
		 * Stage resize handler | just resizing the background
		 * @param	event:Event	@default null
		 */
		private function onStageResize(event:Event = null):void
		{
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			
			infoSWFSize.x = int((stage.stageWidth - infoSWFSize.width)/2);
			infoSWFSize.y = int(stage.stageHeight - infoSWFSize.height - 15);
		}
		
		/**
		 * Show the about panel
		 * @param	event:MouseEvent
		 */
		private function onAboutClick(event:MouseEvent):void
		{
			TweenLite.to(swfSizer, 3, {scrollY: stage.stageHeight - swfSizer.windowHeight + 20 , ease:Bounce.easeOut});
		}
		
		/**
		 * Move to top
		 * @param	event:MouseEvent
		 */
		private function onBackClick(event:MouseEvent):void
		{
			TweenLite.to(swfSizer, 1, {scrollY: 0});
		}
		
		/**
		 * The magic handler :)
		 * @param	event:MouseEvent
		 */
		private function onMagicClick(event:MouseEvent):void
		{	
			dude.visible = true;
			dude.alpha = 0;
			TweenLite.to(dude, 1, {alpha: 1});
			TweenLite.to(swfSizer, 3, {scrollY: dude.y - 200, ease:Back.easeOut});
		}
		
		/**
		 * The 'more' magic handler :)
		 * @param	event:MouseEvent
		 */
		private function onMoreMagicClick(event:MouseEvent):void
		{
			dude.visible = true;
			dude.alpha = 1;
			TweenLite.to(dude, 1, {alpha: 0, onComplete: onDudeFadeOut});
			TweenLite.to(swfSizer, 2, {scrollY: 0, ease:Back.easeOut});
		}
		
		/**
		 * Just to hide the dude
		 * @return nothing
		 */
		private function onDudeFadeOut():void
		{
			dude.visible = false;
		}
		
		/**
		 * On set width click handler
		 * @param	event:MouseEvent
		 */
		private function onSetWClick(event:MouseEvent):void
		{
			value = Number(widthTF.text);
			
			// set the width of the swf container according to the values
			// of the textfield and the checkbox
			swfSizer.setSWFWidth(value, wabsChb.selected);
		}
		
		/**
		 * On set height click handler
		 * @param	event:MouseEvent
		 */
		private function onSetHClick(event:MouseEvent):void
		{
			value = Number(heightTF.text);
			
			// set the height of the swf container according to the values
			// of the textfield and the checkbox
			swfSizer.setSWFHeight(value, habsChb.selected);
		}
		
		/**
		 * On autoSize width click handler
		 * @param	event:MouseEvent	@default null
		 */
		private function onAutoSizeWClick(event:MouseEvent = null):void
		{
			// if the 'always' checkbox selected, set the autoSizeWidth with 'always' param
			// i.e. make the width elastic
			swfSizer.autoSizeWidth(awChb.selected);
			getAllMetrics();
		}
		
		/**
		 * On autoSize height click handler
		 * @param	event:MouseEvent	@default null
		 */
		private function onAutoSizeHClick(event:MouseEvent = null):void
		{
			// if the 'always' checkbox selected, set the autoSizeHeight with 'always' param
			// i.e. make the height elastic
			swfSizer.autoSizeHeight(ahChb.selected);
			getAllMetrics();
		}
		
		/**
		 * On autoSize click handler
		 * @param	event:MouseEvent	@default null
		 */
		private function onAutoSizeClick(event:MouseEvent = null):void
		{
			// if the 'always' checkbox selected, set the autoSize with 'always' param
			// i.e. make the width and height elastic
			swfSizer.autoSize(aChb.selected);
			getAllMetrics();
		}
	}	
}