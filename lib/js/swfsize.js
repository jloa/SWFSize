/*
	@project:	SWFsize @ www.chargedweb.com/swfsize/
	@version:	1.4
	@author:	Julius Loa a.k.a. Jloa | jloa[at]chargedweb.com
	licence:	CC 3.0 @ http://creativecommons.org/licenses/by-sa/3.0/
	
	o---[changes]---------------------------------------------------------------
	
	[v.1.4]
		- event broadcast removed from setSWFWidth(), setSWFHeight() methods [thx 2 Umano Teodori]
	[v.1.3]
		- ie 6, 7 scroll bug fixed [thx to Reed Bertolette]
	[v.1.2]
		- engine switched singleton -> class; now you can manage more than 1 embedded swf at a time! [thx David Aguilar for the suggestion]
	[v.1.1]
		- improved performance
		- method setWidth() renamed to setSWFWidth()
		- method setHeight() renamed to setSWFHeight()
	[v.1.0]
		- added setWidth() method
		- added setHeight() method
		- added getWidth() method
		- added getHeight() method
		- added getWindowWidth() method
		- added getWindowHeight() method
		- added getLeftX() method
		- added getRightX() method
		- added getTopY() method
		- added getBottomY() method
		- added setScrollX() method
		- added getScrollX() method
		- added setScrollY() method
		- added getScrollY() method
		@FIXME:	[not for IE] have to deduct the scrollbars width/height @see desciption below
		
	o---------------------------------------------------------------------------
	
	o---[example]---------------------------------------------------------------
	
	html usage (with swfobject):
	
	<script type="text/javascript" language="javascript" src="include/js/swfobject.js"></script>
	<script type="text/javascript" language="javascript" src="include/js/swfsize.js"></script>
	<script type="text/javascript">
	var attributes = {};
	attributes.id = "swfID";
	attributes.name = "swfID";
	
	var flashvars = {};
	flashvars.swfsizeId = attributes.id;
	
	var params = {};
	params.menu = "false";
	params.bgcolor = "#ffffff";
	params.quality = "high";
	params.allowFullScreen = "true";
	params.allowScriptAccess = "always";
	swfobject.embedSWF("mysite.swf", "flashContent", "550", "400", "9.0.0","include/swf/expressInstall.swf", flashvars, params, attributes);
	
	// now all you need to do is create a new SWFSize instance and the swf's id;
	var swfsize = new SWFSize();
	swfsize.setId(attributes.id);
	</script>
	
	AS3 usage: @see the com.chargedweb.swfsize.SWFSize class	
	
	o---------------------------------------------------------------------------
*/
SWFSize = function SWFSize()
{
this.id = "";
this.version = "1.3.0";
this.valueAbs = "px"; this.valueRel = "%";
this.browser = navigator.appName;
this.isIE = (this.browser.indexOf("Microsoft") >= 0);
this.lX = 0; this.rX = 0; this.tY = 0; this.bY = 0; this.wH = 0; this.wW = 0; this.sW = 0; this.sH = 0; this.swfW = 0; this.swfH = 0;  this.scrX = 0; this.scrY = 0;
this.setId = function(id) { this.id = id; SWFSizePool.register(this); }
this.init = function()
{
	if(!this.available()){ this.errorID(); return 0; }
	this.targetSWF().focus();
	this.onWindowLoadHandler(); return 1;
}
this.updateMetrics = function()
{
	this.swfW = this.getSWFWidth();
	this.swfH = this.getSWFHeight();
	this.scrX = this.getScrollX();
	this.scrY = this.getScrollY();
	this.wW = (this.isIE) ? document.body.clientWidth : window.innerWidth;
	this.wH = (this.isIE) ? document.body.clientHeight : window.innerHeight;
	
	/**
	 * @FIXME [!IE] have to deduct the scrollbars width/height (horizontal/vertical bars) from the swfsize.wW, swfsize.wH so that the swfsize.rX, swfsize.bY be precise; window.pageXOffset; window.pageYOffset
	 * @UPD solved, part
	 */  
	if(!this.isIE)
	{
		this.sW = this.wW - document.body.offsetWidth;
		this.sH = this.wH - document.body.offsetHeight;
		this.wW -= this.sW;
	}
	
	this.lX = document.body.scrollLeft;
	this.rX = this.lX + this.wW;
	this.tY = document.body.scrollTop;
	this.bY = this.tY + this.wH;
}
this.onWindowLoadHandler = function(e)
{
	if(this.available())
	{
		this.updateMetrics();
		this.targetSWF().onWindowInit(this.tY+","+this.bY+","+this.lX+","+this.rX+","+this.wW+","+this.wH+","+this.swfW+","+this.swfH+","+this.scrX+","+this.scrY);
	}else{
		this.errorID();
	}
}

this.setSWFWidth = function(value, valueType)
{
	valueType = this.checkValueType(valueType);
	if(this.available())
	{
		this.targetSWF().width = (valueType == this.valueAbs) ? value : value + valueType;
		this.targetSWF().style.width = value + valueType;
	}else{
		this.errorID();
	}
}
this.setSWFHeight = function(value, valueType)
{
	valueType = this.checkValueType(valueType);
	if(this.available())
	{
		this.targetSWF().height = (valueType == this.valueAbs) ? value : value + valueType;
		this.targetSWF().style.height = value + valueType;
	}else{
		this.errorID();
	}
}
this.getSWFWidth = function() { if(this.id != "" && this.targetSWF()) { return this.targetSWF().width; }else{ this.errorID(); return 0; } }
this.getSWFHeight = function() { if(this.id != "" && this.targetSWF()) { return this.targetSWF().height; }else{ this.errorID(); return 0; } }
this.setScrollX = function(value){ var oY = (this.isIE) ? this.tY : window.pageYOffset; window.scrollTo(value, oY); this.updateMetrics(); }
this.setScrollY = function(value){ var oX = (this.isIE) ? this.lX : window.pageXOffset; window.scrollTo(oX, value); this.updateMetrics(); }
this.getScrollX = function(){ return (this.isIE) ? this.lX : window.pageXOffset; }
this.getScrollY = function(){ return (this.isIE) ? this.tY : window.pageYOffset; }
this.getWindowWidth = function(){ return this.wW; }
this.getWindowHeight = function(){ return this.wH; }
this.getLeftX = function(){ return this.lX; }
this.getRightX = function(){ return this.rX; }
this.getTopY = function(){ return this.tY; }
this.getBottomY = function(){ return this.bY; }
this.available = function() { return (this.id != "" && this.targetSWF()); }
this.checkValueType = function(value) { value = (!value || value != this.valueAbs && value != this.valueRel) ? this.valueAbs : value; return value; }
this.targetSWF = function() { return (this.isIE) ? window[this.id] : document[this.id]; }
this.errorID = function() { alert("Error: could not find the swf container using SWFsize.id = \""+this.id+"\"\nCheck wheter you've passed the swf's id to SWFSize via swfsize.setId(attributes.id);"); }
}

SWFSizePool = new function SWFSizePooler(){
this.pool = [];
this.numItems = 0;
this.initialized = false;
this.register = function(instance)
{
	this.pool.push(instance);
	this.numItems = this.pool.length;
	if(!this.initialized)
	{
		if(window.addEventListener)
		{
			window.addEventListener("resize", this.onWindowResizeHandler, false);
			window.addEventListener("scroll", this.onWindowScrollHandler, false);
		}else{
			window.attachEvent("onresize", this.onWindowResizeHandler);
			window.attachEvent("onscroll", this.onWindowScrollHandler);
		}
		initialized = true;
	}
}
this.getItemById = function(id){
	for(var i = 0; i < this.numItems; i++)
		if(this.pool[i].id == id) return this.pool[i];
}
this.onWindowResizeHandler = function(e)
{
	for(var i = 0; i < SWFSizePool.numItems; i++)
	{
		inst = SWFSizePool.pool[i];
		inst.updateMetrics(); inst.targetSWF().onWindowResize(inst.tY+","+inst.bY+","+inst.lX+","+inst.rX+","+inst.wW+","+inst.wH+","+inst.swfW+","+inst.swfH+","+inst.scrX+","+inst.scrY);
	}
}
this.onWindowScrollHandler = function(e)
{
	for(var i = 0; i < SWFSizePool.numItems; i++)
	{
		inst = SWFSizePool.pool[i];
		inst.updateMetrics(); inst.targetSWF().onWindowScroll(inst.tY+","+inst.bY+","+inst.lX+","+inst.rX+","+inst.wW+","+inst.wH+","+inst.swfW+","+inst.swfH+","+inst.scrX+","+inst.scrY);
	}
}
}