<%--
 Copyright (c) 2000, 2007 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
     2008/08/18 - updated by Xu Yumei(IBM Corp.) for Group Search
     2008/08/26 - updated by Xu Yumei(IBM Corp.) for Filter for Navigation View 
     2008/09/02 - updated by Hu Qiongkai(IBM Corp.) for Defect 587: stable toolbar menu display
--%>
<%@ include file="header.jsp"%>

<% 
	ToolbarData data = new ToolbarData(application,request, response);
	WebappPreferences prefs = data.getPrefs();
%>

<%@page import="org.eclipse.help.internal.base.HelpBasePlugin"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title><%=ServletResources.getString("Toolbar", request)%></title>
 
<style type="text/css">

/* need this one for Mozilla */
HTML { 
	margin:0px;
	padding:0px;
}
 
BODY {
	background:<%=prefs.getToolbarBackground()%>;
}

#titleText {
	font-weight:bold;
	color:WindowText;
}

/*for group search*/

#a {
display: block; width: 80px; text-align:center;
}

#a:link {
color:#666; text-decoration:none;
}
#a:visited {
color:#666;text-decoration:none;
}
#a:hover {
color:#FFF;text-decoration:none;font-weight:bold;
}

#li {
float: left; width: 80px; background:#CCC;
}
#li a:hover{
background:#999;
}
#li ul {
line-height: 27px; list-style-type: none;text-align:left;
left: -999em; width: 180px; position: absolute;
}
#li ul li{
float: left; width: 180px;
background: #F6F6F6;
}

#li ul a{
display: block; width: 156px;text-align:left;padding-left:24px;
}

#li ul a:link {
color:#666; text-decoration:none;
}
#li ul a:visited {
color:#666;text-decoration:none;
}
#li ul a:hover {
color:#F3F3F3;text-decoration:none;font-weight:normal;
background:#C00;
}

#li:hover ul {
left: auto;
}
#li.sfhover ul {
left: auto;
}
/*for group search ends*/
 
.buttonOn a { 
	display:block;
	margin-left:2px;
	margin-right:2px;
	width:<%=data.isMozilla()?18:20%>px;
	height:<%=data.isMozilla()?18:20%>px;
	border:1px solid Highlight;
<% 
if (data.isIE()){
%>
	writing-mode:lr-tb; <%-- needed to verticaly center icon image on IE--%>
<%
}
%>	
    vertical-align:middle;
	<%=prefs.getViewBackgroundStyle()%>
}

.button a, .buttonMenu a { 
	display:block;
	margin-left:2px;
	margin-right:2px;
	height:<%=data.isMozilla()?18:20%>px;
	border:1px solid <%=prefs.getToolbarBackground()%>;
<% 
if (data.isIE()){
%>
	writing-mode:lr-tb; <%-- needed to verticaly center icon image on IE--%>
<%
}
%>	
	vertical-align:middle;
}

.button a {
	width:<%=data.isMozilla()?18:20%>px;
}

.buttonMenu a {
	width:<%=data.isMozilla()?30:32%>px;
}

.buttonHidden a { 
	display:none;
}

.button a:hover, .buttonMenu a:hover { 
	border-top:1px solid ButtonHighlight; 
	border-<%=isRTL?"right":"left"%>:1px solid ButtonHighlight; 
	border-<%=isRTL?"left":"right"%>:1px solid ButtonShadow; 
	border-bottom:1px solid ButtonShadow;
}

<% if (data.isIE() || data.isMozilla() && "1.2.1".compareTo(data.getMozillaVersion()) <=0){
// maximize (last) button should not jump
%>
#b<%=data.getButtons().length-1%>:hover{
	border:1px solid <%=prefs.getToolbarBackground()%>;
}
<%}%>

.separator {
	background-color: ThreeDShadow;
	height:100%;
	width: 1px;
	border-top:2px solid <%=prefs.getToolbarBackground()%>;
	border-bottom:2px solid <%=prefs.getToolbarBackground()%>;
	border-left:3px solid <%=prefs.getToolbarBackground()%>;
	border-right:3px solid <%=prefs.getToolbarBackground()%>;
	
} 

#container {
	border-bottom:1px solid ThreeDShadow;
<%
if (data.isIE()) {
%> 	
<%
}else if (data.isMozilla()){
%>
	border-top:1px solid ThreeDShadow;
	height:24px;
<%
}
%>
}

<%
// workaround for adding right border on mozilla (ugly..)
if (data.isMozilla() && "content".equals(request.getParameter("toolbar"))) { 
%>

/* need this one for Mozilla */
HTML { 
	margin:0px;
	padding:0px;
}
<%
}
%>

</style>

<script language="JavaScript" src="utils.js"></script>
<script language="JavaScript">

var bRestore = false;
// Preload images
<%
ToolbarButton[] buttons = data.getButtons();//toolbar buttons
for (int i=0; i<buttons.length; i++) {
	if (!buttons[i].isSeparator()) {
%>
	var <%=buttons[i].getName()%> = new Image();
	<%=buttons[i].getName()%>.src = "<%=buttons[i].getOnImage()%>";
<%
	}
}
%>

function setTitle(label)
{
	if( label == null) label = "";
	var title = document.getElementById("titleText");
	if (title == null) return;
	var text = title.lastChild;
	if (text == null) return;
	text.nodeValue = label;
}

<% if (data.isIE()
	|| data.isMozilla() && "1.2.1".compareTo(data.getMozillaVersion()) <=0
	|| (data.isSafari() && "120".compareTo(data.getSafariVersion()) <= 0) ){
%>
function registerMaximizedChangedListener(){
	// get to the frameset
	var p = parent;
	while (p && !p.registerMaximizeListener)
		p = p.parent;
	
	if (p!= null){
		p.registerMaximizeListener('<%=UrlUtil.JavaScriptEncode(data.getName())%>Toolbar', maximizedChanged);
	}
}
registerMaximizedChangedListener();

/**
 * Handler for double click: maximize/restore this view
 * Note: Mozilla browsers prior to 1.2.1 do not support programmatic frame resizing well.
 */
function mouseDblClickHandler(e) {
	// ignore double click on buttons
	var target=<%=data.isIE()?"window.event.srcElement":"e.target"%>;
	if (target.tagName && (target.tagName == "A" || target.tagName == "IMG"))
		return;
	toggleFrame();
	return false;
}
		
function menuKeyDownHandler(e, button, param) {			// Defect 789: 'M'
	var theEvent = e? e : window.event;
	var key = keyCode(theEvent);
    if (theEvent.altKey && key == '77') {
        menu(button, param); 
        return false;
    }    
    return true; 
}
function isInternetExplorer() {
	return navigator.userAgent.indexOf('MSIE') != -1;
}
function keyCode(e) {
    if (isInternetExplorer()) {
		return window.event.keyCode;
	} else {
		return e.keyCode;
	}
}

function restore_maximize(button)
{
	toggleFrame();
	if (button && document.getElementById(button)){
		document.getElementById(button).blur();
	}
}
function toggleFrame(){
	// get to the frameset
	var p = parent;
	while (p && !p.toggleFrame)
		p = p.parent;
	
	if (p!= null){
		p.toggleFrame('<%=UrlUtil.JavaScriptEncode(data.getTitle())%>');
	}
	document.selection.clear;	
}

function maximizedChanged(maximizedNotRestored){
	if(maximizedNotRestored){
		document.getElementById("maximize_restore").src="<%=data.getRestoreImage()%>";
		document.getElementById("maximize_restore").setAttribute("title", 
		    "<%=UrlUtil.JavaScriptEncode(data.getRestoreTooltip())%>");
		document.getElementById("maximize_restore").setAttribute("alt", 
		    "<%=UrlUtil.JavaScriptEncode(data.getRestoreTooltip())%>");
		bRestore = true;
	}else{
		document.getElementById("maximize_restore").src="<%=data.getMaximizeImage()%>";
		document.getElementById("maximize_restore").setAttribute("title", 
		    "<%=UrlUtil.JavaScriptEncode(data.getMaximizeTooltip())%>");
		document.getElementById("maximize_restore").setAttribute("alt", 
		    "<%=UrlUtil.JavaScriptEncode(data.getMaximizeTooltip())%>");
		bRestore = false;
	}
}

<%=( data.isIE() || data.isSafari() )?
	"document.ondblclick = mouseDblClickHandler;"
:
	"document.addEventListener('dblclick', mouseDblClickHandler, true);"%>
<%}%>

function setButtonState(buttonName, pressed) {
	if(!document.getElementById("tdb_"+buttonName))
		return;
	if (pressed == "hidden")
		document.getElementById("tdb_"+buttonName).className="buttonHidden";
	else if(pressed == true)
		document.getElementById("tdb_"+buttonName).className="buttonOn";
	else
		document.getElementById("tdb_"+buttonName).className="button";
}

function setWindowStatus(buttonName){
	<%
	for (int i=0; i<buttons.length; i++) {
		String name = buttons[i].getName();%>
		if (buttonName == "<%=name%>"){
			if (buttonName == "maximize_restore"){
				if (bRestore){
					window.status = "<%=UrlUtil.JavaScriptEncode(data.getRestoreTooltip())%>";
				}else{
					window.status = "<%=UrlUtil.JavaScriptEncode(data.getMaximizeTooltip())%>";
				}
			}else{
				window.status = "<%=UrlUtil.JavaScriptEncode(buttons[i].getTooltip())%>";
			}
		}
	<%	
	}
	%>
}

<%
if (data.hasMenu()) { 
	
%> 
 
// this function has been modify for group search
function menu(button, param) {
	var doc = parent.frames[1].document; 
	if (!doc.getElementById("subMenu")) {
		var menu = doc.createElement("div");
		menu.id = "subMenu";
		menu.srcButton = button;
	//	if (isInternetExplorer()) {
			menu.onmouseout = menuExit;
			menu.onkeydown = menuKey;
	//	}
	//	else {
	//		document.addEventListener('onmouseout', menuExit, true);	
	//		document.addEventListener('onkeydown', menuKey, true);
	//	}
		
		<%
		if (data.isIE()) {
		%>
			menu.style.position = "absolute";
			menu.style.<%=isRTL ? "left" : "right"%> = doc.body.scrollLeft;
			menu.style.top = doc.body.scrollTop;
		<%
		} else if (data.isMozilla()) {
		%>
			menu.style.position = "fixed";
			menu.style.<%=isRTL ? "left" : "right"%> = "0px";
			menu.style.top = "0px";
		<%
		}
		%>
		menu.style.padding = "2px 2px 2px 2px";
		menu.style.background = "<%=prefs.getToolbarBackground()%>";
		menu.style.font = "<%=prefs.getToolbarFont()%>";
		menu.style.border<%=isRTL ? "Right" : "Left"%> = "1px solid ThreeDShadow";
		menu.style.borderBottom = "1px solid ThreeDShadow"; 
		
		ulElement = doc.createElement("ul");
		ulElement.style.margin="0px"; 

		var entries = param.split(",");
		if(entries[0]=="TocMenu") {
			ulElement.style.padding="0px 0px 0px 0px";
		}
		else if(entries[0]=="SearchMenu") {
			ulElement.style.paddingTop = "0px";
			ulElement.style.padding<%=isRTL ? "Right" : "Left"%> = "20px";
			ulElement.style.padding<%=isRTL ? "Left" : "Right"%> = "0px";
			ulElement.style.paddingBottom = "0px";
		}
		
		for (var i=1;i<entries.length;++i) {  
				var properties = entries[i].split("=");  
				var liElement = doc.createElement("li"); 
				
				var text;
				var anchor = doc.createElement("a"); 
				if(entries[0] == "SearchMenu") {// just for search view  
					if(i==1) {
						text = doc.createTextNode(properties[0]);
						anchor.href = "javascript:parent.frames[0].closeMenu(),parent.frames[0]." + properties[1]+"(\'"+button+"\')";
						
						if(parent.frames[1].isShowCategories()) { 
							liElement.style.listStyleType = "disc";
						}
						else {
							liElement.style.listStyleType = "none";
						}
					}
					else {
						var groupByText = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("groupBy", request))%>";
						var criteriaText;
						if(properties[0] == "version") {
							criteriaText = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("version", request))%>";
						}
						else if(properties[0] == "prodname") {
							criteriaText = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("prodname", request))%>";
						}
						else if(properties[0] == "platform") {
							criteriaText = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("platform", request))%>";
						}
						else {
							criteriaText = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("none", request))%>";
						}
						text = doc.createTextNode(groupByText+ " " + criteriaText);
						anchor.href = "javascript:parent.frames[0].closeMenu(),parent.frames[0]." + properties[1]+"(\'"+button+"\',\'"+properties[0]+"\')";
						
						if(parent.frames[1].isShowCategories()) {
							liElement.style.listStyleType = "none";
						}
						else if(parent.searchViewFrame.isGroupBy() != properties[0]) {
							liElement.style.listStyleType = "none";
						}
						else {
							liElement.style.listStyleType = "disc";
						}
					}
				}
				else {
					text = doc.createTextNode(properties[0]);
					var errorMsg;
					if(properties[2] == "PrintError") {
						errorMsg = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("PrintError", request))%>";
					}
					else if(properties[2] == "SearchError") {
						errorMsg = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("SearchError", request))%>";
					}
					anchor.href = "javascript:parent.frames[0].closeMenu(),parent.frames[0]." + properties[1]+"(\'"+errorMsg+"\')";;
					liElement.style.listStyleType="none";
				}
				anchor.appendChild(text);
				anchor.target = "_self";
				anchor.onmouseover = itemEnter;
				anchor.onmouseout = itemExit;
				anchor.onfocus = itemEnter;
				anchor.onblur = itemExit;
						
				anchor.style.display = "block";
				anchor.style.cursor = "default";
				anchor.style.textDecoration = "none";
				anchor.style.padding = "4px 4px 4px 4px";
				anchor.style.color = "WindowText";  
			
				liElement.appendChild(anchor);
				ulElement.appendChild(liElement);
				
				if(i==1 && entries[0]=="SearchMenu") {
					var hrElement = doc.createElement("hr"); 
					hrElement.style.width = "155px";
					hrElement.style.noshade = "false"; 
					ulElement.appendChild(hrElement);
				}
		}

		menu.appendChild(ulElement); 
		doc.body.appendChild(menu);
		menu.focus();
	}

	if (button && document.getElementById(button)) {
		var buttonElem = document.getElementById(button);
		buttonElem.blur();
		buttonElem.firstChild.title = "";
	}
}

function setLi(element) {
	element.style.listStyleType="disc";
}

function setAnchorStyle(anchor) {
	anchor.onmouseover = itemEnter;
	anchor.onmouseout = itemExit;
	anchor.onfocus = itemEnter;
	anchor.onblur = itemExit;
						
	anchor.style.display = "block";
	anchor.style.cursor = "default";
	anchor.style.textDecoration = "none";
	anchor.style.padding = "4px 4px 4px 4px";
	anchor.style.color = "WindowText"; 
}

function menuKey(e) {
	var key;
	if (!e) var e = parent.frames[parent.frames.length - 1].window.event;
	if (e.keyCode) key = e.keyCode;
	else if (e.which) key = e.which;
    var src = e.srcElement ? e.srcElement : e.target;

												// Defect 790 
  	if (key == 38) { 			// Up arrow
  		if (src.id != "subMenu" && src.parentNode.previousSibling) {
  			src.parentNode.previousSibling.firstChild.focus();
  		}
  	}
  	else if (key == 40) { 		// Down arrow
  		if (src.id == "subMenu") {
	  		if (src.firstChild.firstChild.tagName == "LI") {
	  			src.firstChild.firstChild.firstChild.focus();
	  		}
	  	}
	  	else if (src.tagName == "A") {
	  		if (! (src.parentNode.nextSibling)) {
	  			return true;
	  		}
	  		src.parentNode.nextSibling.firstChild.focus();
  		}	
  	}
  	else if (e.ctrlKey && key == 13) {			// Defect798
  		e.keyCode = 0;
        e.returnValue = false; 
  	}
  	else if (key == 27) { // Esc
  		closeMenu();
  	}
  	else {
  		return true;
  	}
  	return false;
}

function closeMenu() {
    parent.frames[parent.frames.length - 1].window.status = "";
	var menu = parent.frames[1].document.getElementById("subMenu");
	menu.parentNode.removeChild(menu);

	//var img = document.getElementById(menu.srcButton).firstChild;  // does not work in IE7
	var img = document.getElementById("b1").firstChild;
	img.title = img.alt;
	img = document.getElementById("b3").firstChild;
	img.title = img.alt;						// Defect 796 
}

function itemEnter(e) {
    this.style.background = "<%=data.isSafari() ? "DarkBlue" : "Highlight"%>";
    this.style.color = "HighlightText";
    parent.frames[parent.frames.length - 1].window.status = this.firstChild.nodeValue;
    return true;
}

function itemExit(e) {
    this.style.background = "transparent";
    this.style.color = "WindowText";
    parent.frames[parent.frames.length - 1].window.status = "";
    return true;
}

function menuExit(e) {
	if (!e) var e = parent.frames[parent.frames.length - 1].window.event;
    var target = e.relatedTarget ? e.relatedTarget : e.toElement;
    while (target && target != this)
         target = target.parentNode;
    if (target == this) return;
    closeMenu();
}

<%
}
%>

// filter
/**
 * Close filterManger window when its opener is closed.
 */
function onunloadHandler()
{
	try{
		setCookie("groupBy", "None");
		if (filterDialog){		
			filterDialog.close();
		}
	}catch(e){} 
	
}
function onloadHandler(){
	// get to the frameset
	var p = parent;
	while (p && !p.toggleFrame)
		p = p.parent;
	
	if (p!= null){
		var frameset = p.document.getElementById("helpFrameset"); 
		if(frameset != null) {
			var navFrameSize = frameset.getAttribute("cols");
			var comma = navFrameSize.indexOf(',');
			var left = navFrameSize.substring(0,comma);
			var right = navFrameSize.substring(comma+1);
	
			if (left == "*" || right == "*") {
				maximizedChanged(true);
			}
		}
	}
	if(this.name == "tocToolbarFrame" && window.parent.tocViewFrame){
			window.parent.tocViewFrame.window.location.reload();
	}
}

//filter ends

</script>

<%
if (data.getScript() != null) {
%>
<script language="JavaScript" src="<%=data.getScript()%>"></script>
<%
}
%>

<%
	Object[] jsPaths = ButtonUtil.getJavascripts();
%>
<%for(int i=0; i<jsPaths.length; i++){ %>
<script language="JavaScript" src="<%=(String)jsPaths[i]%>"></script>
<%} %>
<%-- 
<%String infocenterContext = HelpBasePlugin.getDefault().getPluginPreferences().getString("infocenterContext");
if(infocenterContext.equals("/")) {
	infocenterContext = "";
}%>
--%>

<script language="JavaScript">
<%String value = System.getProperty("org.eclipse.equinox.http.jetty.context.path").substring(1);%>
var infocenterContext = "<%=value%>";
</script>

</head>
 
<%
if(buttons.length > 0){
%>
	<body dir="<%=direction%>" onload="onloadHandler()" onunload="onunloadHandler()">
<%
}else{
%>
	<body dir="<%=direction%>" tabIndex="-1" onunload="onunloadHandler()">
<%
}
%>

<table id="container" width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" style='padding-<%=isRTL?"right":"left"%>:<%=data.isIE()?"5px":"8px"%>;'>

	<tr>
		<td nowrap style="font: <%=prefs.getToolbarFont()%>" valign="middle">
			<div id="titleTextTableDiv" style="overflow:hidden; height:22px;"><table><tr><td nowrap style="font:<%=prefs.getToolbarFont()%>"><div id="titleText" >&nbsp;<%=data.getTitle()%></div></td></tr></table>
			</div>
		
		
		<div style="position:absolute; top:0.8px; <%=isRTL?"left":"right"%>:0px;">
		<table width="100%" border="0" cellspacing="1" cellpadding="0" height="100%">
			<tr>
				<td align="<%=isRTL?"left":"right"%>">
					<table align="<%=isRTL?"left":"right"%>" border="0" cellspacing="0" cellpadding="0" height="100%" style="background:<%=prefs.getToolbarBackground()%>">
					<tr>
					
<% 


if("content".equals(request.getParameter("toolbar"))) {
	Object[] extraButtons = ButtonUtil.getContentToolbarButtons();
	ToolbarButton button;
	for(int i=0; i<extraButtons.length; i++) {
		button = (ToolbarButton) extraButtons[i];
%>
	<td align="middle" id="tdb_<%=button.getName()%>" class="<%=button.getStyleClass()%>" height=18>
	<a href="javascript:<%=button.getAction()%>('b<%=i%>', '<%=button.getParam()%>');" 
	   onmouseover="javascript:setWindowStatus('<%=button.getName()%>');return true;" 
	   onmouseout="window.status='';" 
	   id="b<%=i%>">
	   <img src="<%=button.getOnImage()%>" 
			alt='<%=button.getTooltip() %>' 
			title='<%=button.getTooltip()%>'
			border="0"
			id="<%=button.getName()%>">
	</a>
</td>
<%}
}

	for (int i=0; i<buttons.length; i++) {
		
		
		
		if (buttons[i].isSeparator()) {
			
%>
						<td align="middle" class="separator" valign="middle">
						</td>
<%
		} else {
		 	if ("menu".equals(buttons[i].getAction())) { %>
		 				<td align="middle" id="tdb_<%=buttons[i].getName()%>" class="<%=buttons[i].getStyleClass()%>" height=18>
							<a href="javascript:<%=buttons[i].getAction()%>('b<%=i%>', '<%=buttons[i].getParam()%>');" 
							   onmouseover="javascript:setWindowStatus('<%=buttons[i].getName()%>');return true;" 
							   onmouseout="window.status='';"  onkeydown="menuKeyDownHandler(event, '<%=buttons[i]%>', '<%=buttons[i].getParam()%>');"
							   id="b<%=i%>">
							   <img src="<%=buttons[i].getOnImage()%>" 
									alt='<%=buttons[i].getTooltip() %>' 
									title='<%=buttons[i].getTooltip()%>'
									border="0"
									id="<%=buttons[i].getName()%>">
							</a>
						</td>
<%			}
			else {
%> 
						<td align="middle" id="tdb_<%=buttons[i].getName()%>" class="<%=buttons[i].getStyleClass()%>" height=18>
							<a href="javascript:<%=buttons[i].getAction()%>('b<%=i%>', '<%=buttons[i].getParam()%>');" 
							   onmouseover="javascript:setWindowStatus('<%=buttons[i].getName()%>');return true;" 
							   onmouseout="window.status='';" 
							   id="b<%=i%>">
							   <img src="<%=buttons[i].getOnImage()%>" 
									alt='<%=buttons[i].getTooltip() %>' 
									title='<%=buttons[i].getTooltip()%>'
									border="0"
									id="<%=buttons[i].getName()%>">
							</a>
						</td>
<%			
			}
%>
<%
		}
	}
%>				
					</tr>
					</table>
				</td>
			</tr>
		</table> 
		</div>
		</td>
	</tr>
</table>

<%// special case for content toolbar - internally used live help frame
if ("content".equals(request.getParameter("toolbar"))) {
%>
    <iframe name="liveHelpFrame" title="<%=ServletResources.getString("ignore", "liveHelpFrame", request)%>" src="blank.html" style="visibility:hidden" tabindex="-1" frameborder="no" width="0" height="0" scrolling="no">
    </iframe>
<%
}
%>
<script language="JavaScript">
var highlightButtonTooltipOn="<%=ServletResources.getString("highlighton", request)%>";
var highlightButtonTooltipOff="<%=ServletResources.getString("highlightoff", request)%>";
var autoSyncButtonTooltipOn="<%=ServletResources.getString("SynchNavOn", request)%>";
var autoSyncButtonTooltipOff="<%=ServletResources.getString("SynchNavOff", request)%>";
var showDescriptionButtonTooltipOn="<%=ServletResources.getString("show_descriptions_on", request)%>";
var showDescriptionButtonTooltipOff="<%=ServletResources.getString("show_descriptions_off", request)%>";
var groupByButtonTooltipoOn="<%=ServletResources.getString("group_search_result_on", request)%>";
var groupByButtonTooltipOff="<%=ServletResources.getString("group_search_result_off", request)%>";
var filterButtonTooltipOn="<%=ServletResources.getString("filteropen", request)%>";
var filterButtonTooltipOff="<%=ServletResources.getString("filterclose", request)%>";
</script>
</body>     
</html>

