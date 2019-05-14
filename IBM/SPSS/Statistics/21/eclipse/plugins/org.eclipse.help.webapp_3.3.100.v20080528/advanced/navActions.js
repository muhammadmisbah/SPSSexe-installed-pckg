/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Pierre Candela  - fix for Bug 194911
 *	   2008/08/08 - updated by Hu Qiongkai(IBM Corp.) for Story345 Quick Search
 *     2008/08/18 - updated by Xu Yumei(IBM Corp.) for Group Search
 *	   2008/08/26 - updated by Xu Yumei(IBM Corp.) for Group Search
 *	   2008/08/29 - updated by Hu Qiongkai(IBM Corp.) for Defect593: resize search window
 *	   2008/09/03 - updated by Xu Yumei(IBM Corp.) for FilterDialog Resizable
 * 	   2008/11/03 - updated by Xu Yumei(IBM Corp.) for quick print for anchor doc
 *     2008/11/04 - updated by Xu Yumei(IBM Corp.) for quick search for anchor
 *******************************************************************************/

var isIE = navigator.userAgent.indexOf('MSIE') != -1;
 

function toggleAutosynch(button) {
    var tocFrame = window.parent.tocViewFrame;
    tocFrame.toggleAutosynch();
    if (tocFrame.isAutosynchEnabled()) {
        try {
		    parent.parent.parent.parent.ContentFrame.ContentToolbarFrame.autosynch();
	    } catch(e){
	    }
	    document.getElementById("synchnav").setAttribute("title", autoSyncButtonTooltipOff);
	    document.getElementById("synchnav").setAttribute("alt", autoSyncButtonTooltipOff);
    }else{
    	document.getElementById("synchnav").setAttribute("title", autoSyncButtonTooltipOn);
    	document.getElementById("synchnav").setAttribute("alt", autoSyncButtonTooltipOn);
    }
    
    if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}


function toggleShowAll(button){
	window.parent.parent.toggleShowAll();
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}

function toggleShowCategories(button){ 
	if(parent.searchViewFrame.isShowCategories())
		return;
		
 	parent.searchViewFrame.toggleShowCategories(); 
 	if(parent.searchViewFrame.isGroupBy() == "None" && !(parent.searchViewFrame.isShowCategories())){
		document.getElementById("show_categories").setAttribute("title", groupByButtonTooltipoOn);
	    document.getElementById("show_categories").setAttribute("alt", groupByButtonTooltipoOn);
    }else{
  		document.getElementById("show_categories").setAttribute("title", groupByButtonTooltipOff);
	    document.getElementById("show_categories").setAttribute("alt", groupByButtonTooltipOff);
	}
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
} 

// group search
function toggleGroupBy(button,arg) { 
	if(parent.searchViewFrame.isGroupBy() == arg && arg != "None") { // already grouped
		return;
	}
	parent.frames[1].toggleGroupBy(arg);
	if(parent.searchViewFrame.isGroupBy() == "None" && !(parent.searchViewFrame.isShowCategories())){
		document.getElementById("show_categories").setAttribute("title", groupByButtonTooltipoOn);
	    document.getElementById("show_categories").setAttribute("alt", groupByButtonTooltipoOn);
    }else{
  		document.getElementById("show_categories").setAttribute("title", groupByButtonTooltipOff);
	    document.getElementById("show_categories").setAttribute("alt", groupByButtonTooltipOff);
	}
	
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}
// group search ends

//filter
function openFilter(button){  
	if (isIE){ 
		var l = top.screenLeft + (top.document.body.clientWidth - 300) / 2;
		var t = top.screenTop + (top.document.body.clientHeight - 500) / 2;

	} else {
		var l = top.screenX + (top.innerWidth - 300) / 2;
		var t = top.screenY + (top.innerHeight - 500) / 2;

	}

	// move the dialog just a bit higher than the middle
	if (t-50 > 0) t = t-50;
	
	window.location="javascript://needModal";
	filterDialog = window.open("filterManager.jsp?", "filterDialog", "resizable=yes,height="+400+",width="+305+",left="+l+",top="+t );
	filterDialog.focus(); 
	
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}
//filter ends

function toggleShowDescriptions(button){
	parent.searchViewFrame.toggleShowDescriptions();
	if(parent.searchViewFrame.isShowDescriptions()) {
		document.getElementById("show_descriptions").setAttribute("title", showDescriptionButtonTooltipOff);
    	document.getElementById("show_descriptions").setAttribute("alt", showDescriptionButtonTooltipOff);
	}
	else{
		document.getElementById("show_descriptions").setAttribute("title", showDescriptionButtonTooltipOn);
    	document.getElementById("show_descriptions").setAttribute("alt", showDescriptionButtonTooltipOn);
	}
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}

function removeBookmark(button){
	try {
		parent.bookmarksViewFrame.removeBookmark();
	} catch(e){
	}
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}

function removeAllBookmarks(button){
	try {
		parent.bookmarksViewFrame.removeAllBookmarks();
	} catch(e){
	}
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}

function printTopic(errorMsg) {
	var topic = parent.tocViewFrame.getSelectedTopic();		// Defect 644
	if (topic && topic != ":blank") {
		var contentRect;
		if(topic.indexOf(".pdf")!=-1)
			contentRect = getWindowBounds(parent.parent.parent.parent.ContentFrame.window);
		else 
			contentRect = getWindowBounds(parent.parent.parent.parent.ContentFrame.ContentViewFrame.window);
		var topRect = getWindowBounds(parent.parent.parent.parent.parent);
		var w = contentRect.width;
		var h = topRect.height;
		var x = topRect.x + (topRect.width - w)/2;
		var y = topRect.y;
		
		// modify for quick print for anchor doc
		var anchorIndex = topic.indexOf("#");
		var anchorParam = "";
		if(anchorIndex!=-1) {
			anchorParam = topic.substring(anchorIndex+1,topic.length);
			topic = topic.substring(0,anchorIndex);
			anchorParam = "anchor="+anchorParam;
		}		
		//ends
	    var parameters;		 	
	    parameters = "?topic="+topic+"&isSinglePrint=true&"+anchorParam;
	    
		var printWindow = window.open("print.jsp" + parameters, "printWindow", "directories=yes,location=no,menubar=yes,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=yes,width=" + w + ",height=" + h + ",left=" + x + ",top=" + y);
		printWindow.focus();
	}
	else {
		alert(errorMsg);
	}
}

function printToc(errorMsg) {
	var topic = parent.tocViewFrame.getSelectedTopic();
	if (topic && topic != ":blank") {
		var contentRect;
		if(topic.indexOf(".pdf")!=-1)
			contentRect = getWindowBounds(parent.parent.parent.parent.ContentFrame.window);
		else 
			contentRect = getWindowBounds(parent.parent.parent.parent.ContentFrame.ContentViewFrame.window);
		var topRect = getWindowBounds(parent.parent.parent.parent.parent);
		var w = contentRect.width;
		var h = topRect.height;
		var x = topRect.x + (topRect.width - w)/2;
		var y = topRect.y;
		var indexAnchor=topic.indexOf('#');
	    var parameters;		 	
	    if (indexAnchor!=-1) {
		    var anchor=topic.substr(indexAnchor+1);
		    topic=topic.substr(0,indexAnchor);
		    parameters = "?topic="+topic+"&anchor="+anchor;	
	     } else {
		    parameters = "?topic="+topic;
	     }

		var printWindow = window.open("print.jsp" + parameters, "printWindow", "directories=yes,location=no,menubar=yes,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=yes,width=" + w + ",height=" + h + ",left=" + x + ",top=" + y);
		printWindow.focus();
	}
	else {
		alert(errorMsg);
	}
}

/*************quick search begins**********************/
function searchTopic(errorMsg) {	//search this topic
	var topic = parent.tocViewFrame.getSelectedTopic();
	 	
	if (topic) {
		var node = parent.tocViewFrame.getActiveAnchor();
		var quickSearchTopicID;
		if(node.name) {
			quickSearchTopicID = node.name;
		}
		else {
			quickSearchTopicID = node.id;
		}
		var topicIndex = topic.indexOf(".htm");			//topic's href ends with .htm or .html, valid href
		var xTopicIndex = topic.indexOf(".xhtm");		//some topic's href ends with .xhtm or .xhtml, also valid href
		if(topicIndex == -1 && xTopicIndex == -1) {		//the selectedTopic is not a topic
			alert(errorMsg);
			return;
		} 
		// modify for quick search for anchor doc
		var anchorIndex = topic.indexOf("#");
		if(anchorIndex!=-1) {
			topic = topic.substring(0,anchorIndex);
		}		
		//ends
		
		var parameters = "?singleTopicSearch=true" + "&topic="+topic+"&quickSearchTopicID="+quickSearchTopicID;		//"singleTopicSearch"
			
		// Defect 593: resize search window    1/2
	    var w = 315;
		var h = 70;	   
		if (isIE){		
			var l = top.screenLeft + (top.document.body.clientWidth - w) / 2;
			var t = top.screenTop + (top.document.body.clientHeight - h) / 2;		
		} else {		
			var l = top.screenX + (top.innerWidth - w) / 2;
			var t = top.screenY + (top.innerHeight - h) / 2;		
		}		
		// move the dialog just a bit higher than the middle
		if (t-50 > 0) t = t-50;
	  	window.location="javascript://needModal";  
	  	// Defect 593 ends
	  		
	  	var quickSearchWindow = window.open("quickSearch.jsp" + parameters, "QuickSearch", "location=no, status=no,resizable=yes,height="+h+",width="+w +",left="+l+",top="+t);		
	    quickSearchWindow.focus();
	}
	else {
		alert(errorMsg);
	}
}

function searchToc(errorMsg) {		//search this topic and all subTopics
	var topic = parent.tocViewFrame.getSelectedTopic();
	
	if (topic) {
		var node = parent.tocViewFrame.getActiveAnchor();
		var quickSearchTopicID;
		if(node.name) {
			quickSearchTopicID = node.name;
		}
		else {
			quickSearchTopicID = node.id;
		}
		var indexAnchor=topic.indexOf('#');
	    var parameters;			
	    if (indexAnchor!=-1) {
		    var anchor=topic.substr(indexAnchor+1);
		    topic=topic.substr(0,indexAnchor);
		    parameters = "?subTopicsSearch=true" + "&topic="+topic+"&quickSearchTopicID="+quickSearchTopicID+"&anchor="+anchor;	
	     } else {
		    parameters = "?subTopicsSearch=true" + "&topic="+topic+"&quickSearchTopicID="+quickSearchTopicID;		//"subTopicsSearch"
	     }
	     
	    // Defect 593: resize search window     2/2
	    var w = 315;
		var h = 70;	   
		if (isIE){		
			var l = top.screenLeft + (top.document.body.clientWidth - w) / 2;
			var t = top.screenTop + (top.document.body.clientHeight - h) / 2;		
		} else {		
			var l = top.screenX + (top.innerWidth - w) / 2;
			var t = top.screenY + (top.innerHeight - h) / 2;		
		}		
		// move the dialog just a bit higher than the middle
		if (t-50 > 0) t = t-50;
	  	window.location="javascript://needModal";  
	  	// Defect 593 ends

		var quickSearchWindow = window.open("quickSearch.jsp" + parameters, "QuickSearch", "location=no, status=no,resizable=yes,height="+h+",width="+w +",left="+l+",top="+t);		
	    quickSearchWindow.focus();
	}
	else {
		alert(errorMsg);
	}
		
}
/**************quick search ends*************************/

function collapseAll(button) {
    try {
		parent.tocViewFrame.collapseAll();
	} catch(e){
	}
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}

function getWindowBounds(window) {
	var rect = new Object();
	if (window.screenLeft) {
		rect.x = window.screenLeft;
		rect.y = window.screenTop;
	}
	else {
		rect.x = window.screenX;
		rect.y = window.screenY;
	}

	if (window.innerWidth) {
		rect.width = window.innerWidth;
		rect.height = window.innerHeight;
	}
	else {
		rect.width = window.document.body.clientWidth;
		rect.height = window.document.body.clientHeight;
	}
	return rect;
}