<%--
IBM Confidential
OCO Source Materials
IEHS-314
(c) Copyright IBM Corporation 2008.
All rights reserved.

The source code for this program is not published or otherwise
divested of its trade secrets, irrespective of what has been t
deposited with the U.S. Copyright Office.
2008/09/03 - updated by Xu Yumei(IBM Corp.) for FilterDialog Resizable
--%>
<%@ include file="header.jsp"%>
<%@ page import="java.util.*"%>
<%
	FilterData fdata = new FilterData(request,response,application);
	TocData data = new TocData(application,request, response);	
	WebappPreferences prefs = data.getPrefs();

%>
<html>
<head>
<title><%=ServletResources.getString("SetFilter", request)%></title>

<style type="text/css">

BODY {
	background-color: ButtonFace;
	font: <%=prefs.getViewFont()%>;
	margin:0;
	padding:0;
	border:0;
	
}

UL { 
	border-width:0; 
	margin-<%=isRTL?"right":"left"%>:20px; 
}

#listTable{
	background:Window;
	color:WindowText;
	border:	2px inset ThreeDHighlight;
	margin:5px;
	margin-top:2px;
	padding-<%=isRTL?"right":"left"%>:5px;
	overflow:auto;
	height:300px;
	<%if (data.isIE()) {%>
	width:98%;
	<%}%>
	
}
UL.expanded {
	display:block; 
}

UL.collapsed { 
	display: none;
}
#root {
	margin-top:5px;
	margin-<%=isRTL?"right":"left"%>:0px;
}
LI { 
	margin-<%=isRTL?"right":"left"%>:0px;
	margin-top:3px; 
	list-style-image:none;
	list-style-type:none;
	white-space: nowrap;
}
LI.all { 
	margin-<%=isRTL?"right":"left"%>:-10px;
	margin-top:3px; 
	list-style-image:none;
	list-style-type:none;
	white-space: nowrap;
}
IMG {
	border:0px;
	margin:0px;
	padding:0px;
	margin-<%=isRTL?"left":"right"%>:4px;
}

.grayed {
	background-color: <%=prefs.getToolbarBackground()%>;
}
A{
	font-size:12px;
}
LABEL{
	font-size:12px;
}
A.grouptype {
			text-decoration:none; 
			color:WindowText;
			padding-<%=isRTL?"left":"right"%>:2px;
			/* this works in ie5.5, but not in ie5.0  */
			white-space: nowrap;

}

A.grouptype:hover {
	text-decoration:none; 
	color:WindowText;
	padding-<%=isRTL?"left":"right"%>:2px;
	/* this works in ie5.5, but not in ie5.0  */
	white-space: nowrap;
}

}
<% 
if (data.isMozilla()){
%>
UL { 
	margin-<%=isRTL?"right":"left"%>:-20px;
} 
#root{ 
	margin-<%=isRTL?"right":"left"%>:-35px; 
	margin-top:5px;
}
<%
}
%>
 
</style>  


<script language="JavaScript">

// Preload images
minus = new Image();
minus.src = "<%=prefs.getImagesDirectory()%>"+"/minus.gif";
plus = new Image();
plus.src = "<%=prefs.getImagesDirectory()%>"+"/plus.gif";

altCriteriaClosed="<%=ServletResources.getString("criteriaClosed", request)%>";
altCriteriaOpen="<%=ServletResources.getString("criteriaOpen", request)%>";
</script>

<script type="text/javascript">
<!--
var isMozilla = navigator.userAgent.indexOf('Mozilla') != -1 && parseInt(navigator.appVersion.substring(0,1)) >= 5;
var isIE = navigator.userAgent.indexOf('MSIE') != -1;
if (isMozilla) {
  document.addEventListener('keydown', keyDownHandler, true);
}
else if (isIE){
  document.onkeydown = keyDownHandler;
  //window.onfocus = focusHandler;
}



/**
 * Handler for key down (arrows)
 */
function keyDownHandler(e)
{
	
	var key;

	if (isIE) {
		key = window.event.keyCode;
	} else if (isMozilla) {
		key = e.keyCode;
	}
	
	if (key <37 || key > 40) 
		return true;
	
	if (isMozilla)
  		e.cancelBubble = true;
  	else if (isIE)
  		window.event.cancelBubble = true;
  		
  	var target = getTarget(e);
  	if(target && target.tagName == "A") {
  		if (key == 39) {
  			expand(target.parentNode);
  		} else if(key == 37) {
  			collapse(target.parentNode);
  		}
  	}
  	return true;
}

/**
 * Returns the target node of an event
 */
function getTarget(e) {
	var target;
  	if (isMozilla)
  		target = e.target;
  	else if (isIE)
   		target = window.event.srcElement;

	return target;
}
var child = false;
var disableFilter = "&disableFilter="+encodeURIComponent("false");
function selectFilterSet(){
	var criterias = getSelectedCriteria(); 
	window.opener.location.replace("tocToolbar.jsp"+"?"+disableFilter+criterias);
	self.close();
	return false;
}

function getSelectedCriteria() {
	var hrefs = "";
	var inputs = document.getElementsByTagName("input");
	for (var i=0; i<inputs.length; i++)
	{
		if (inputs[i].type != "checkbox") continue;
		if (inputs[i].checked == false) continue;
		if(inputs[i].id == "disableFilter") {
			disableFilter = "&disableFilter="+encodeURIComponent("true");
		} else if(inputs[i].id.indexOf("all") == -1) {
			hrefs += "&criteria="+encodeURIComponent(inputs[i].name);
		}
	}
	if(hrefs == ""){
		hrefs = "&nocriteria="+encodeURIComponent("true");
	}
	return hrefs;
}
function clickHandler(arg) {
	if(child == false) {
		if(isExpanded(arg)){
			collapse(arg);
			
		} else {
			expand(arg);
		}
	} else {
		child = false;
	}
}
/**
 * Collapses a tree rooted at the specified element
 */
function collapse(node) {
  node.className = "collapsed";
  var image = getChildNode(node, "IMG");
  image.src = plus.src;
  image.alt = altCriteriaClosed;
  // uat4i00000454 1/3
  image.title = altCriteriaClosed;
  // end of uat4i00000454 1/3
  
  // set the UL as well
  var ul = getChildNode(node, "UL");
  if (ul != null) ul.className = "collapsed";
}

/**
 * Returns the child node with specified tag
 */
function getChildNode(parent, childTag)
{
	var list = parent.childNodes;
	if (list == null) return null;
	for (var i=0; i<list.length; i++){
		if (list.item(i).tagName == childTag)
			return list.item(i);
	}
	return null;
}

/**
 * Expands a tree rooted at the specified element
 */
function expand(node) {
  	node.className = "expanded";
  	var image = getChildNode(node, "IMG");
  	image.src = minus.src;
  	image.alt = altCriteriaOpen;
  	
  	// uat4i00000454 2/3
  	image.title = altCriteriaOpen;
  	// end of uat4i00000454 2/3
  	
  	// set the UL as well
  	var ul = getChildNode(node, "UL");
  	if (ul != null){
  		ul.className = "expanded";
  	}
}

/**
 * Returns true when this is an expanded tree node
 */
function isExpanded(node) {
  return node.className == "expanded";
}

/**
 * Returns true when this is a collapsed tree node
 */
function isCollapsed(node) {
  return  node.className == "collapsed";
}
function childClick() {
	child = true;
}
function clearForm() {
	var inputs = document.getElementsByTagName("input");
	for (var i=0; i<inputs.length; i++)
	{
		if (inputs[i].type != "checkbox") continue;
		inputs[i].checked = true;
		inputs[i].className='';
		
	}
}
function onloadHandler() {
	sizeButtons();
}

function sizeButtons() {
	var minWidth=60;

	if(document.getElementById("ok").offsetWidth < minWidth){
		document.getElementById("ok").style.width = minWidth+"px";
	}
	if(document.getElementById("reset").offsetWidth < minWidth){
		document.getElementById("reset").style.width = minWidth+"px";
	}
	if(document.getElementById("cancel").offsetWidth < minWidth){
		document.getElementById("cancel").style.width = minWidth+"px";
	}
}
function selectAll(arg) {
	var group = document.getElementById(arg);
	var checkbox = document.getElementById(arg+"_all");
	var graySpan = document.getElementById(arg+"_grayBlock");
	if(group) {
		var list = group.childNodes;
		if(checkbox.checked == false){
			for (var i=0; i<list.length; i++){
				if (list.item(i).tagName == "LI")
					if(list.item(i).firstChild)
						list.item(i).firstChild.checked = false;
			}
		} else {
			for (var i=0; i<list.length; i++){
				if (list.item(i).tagName == "LI")
					if(list.item(i).firstChild)
						list.item(i).firstChild.checked = true;
			}
		}
		
		checkbox.className='';	
		graySpan.className='';
	}
}
function selectChange(option, arg) {
	var group = document.getElementById(arg);
	var checkbox = document.getElementById(arg+"_all");
	var graySpan = document.getElementById(arg+"_grayBlock");
	if(option.checked) { 
		if(allChildrenSelected(group)) {
			checkbox.className='';
			graySpan.className='';
			checkbox.checked=true;
		} else {
			checkbox.checked=true;
			checkbox.className='grayed'; 
			graySpan.className='grayed';
		}
	} else {
		if(nonChildrenSelected(group)) {
			checkbox.className='';
			graySpan.className='';
			checkbox.checked=false;
		} else {
			checkbox.checked=true;
			checkbox.className='grayed';
			graySpan.className='grayed'; 
		} 
	}
}
function allChildrenSelected(arg){
	var list = arg.childNodes;
	for (var i=0; i<list.length; i++){
		if (list.item(i).tagName == "LI") {
			if(list.item(i).firstChild && list.item(i).className != "all" && list.item(i).firstChild.checked == false){
				return false;
			} 
		}
   }
   return true;
		
}
function nonChildrenSelected(arg) {
	var list = arg.childNodes;
	for (var i=0; i<list.length; i++){
		if (list.item(i).tagName == "LI") {
			if(list.item(i).firstChild && list.item(i).firstChild.checked == true){
				if(list.item(i).className != "all") {
					return false;
				}
			} 
		}
   }
   return true;
}
//-->
// resizable
function sizeList() {
    resizeVertical("listTable", null, "buttonArea", 100, 70);
}
// resizable ends
</script>
<script language="JavaScript" src="resize.js"></script>

</head>
<body dir="<%=direction%>" onload="onloadHandler()" onresize = "sizeList()">
<% if(fdata.isFilterAvailable()){%> 
<form onsubmit="selectFilterSet();return false;" >
<%}else { %>
<form onsubmit="window.close();" >
<%} %>

<table align="center" style="font-size:14px;"><tr><td><strong>
<%=ServletResources.getString("InfoCenterFilter", request)%></strong>
</td></tr></table>






<div id="listTable">
			<ul class='expanded' id='root'>
			<%
			int ids = 0;
			if(fdata.isFilterAvailable()){
				for(Iterator it = fdata.getCriteria().keySet().iterator();it.hasNext();){
					String key = (String)it.next();
			%>
				
					<!-- uat4i00000454 3/3-->
					<li class="title" ><img src='images/plus.gif' class='collapsed' alt="<%=ServletResources.getString("criteriaClosed", request)%>"  title="<%=ServletResources.getString("criteriaClosed", request)%>" onClick="clickHandler(this.parentNode)"><a class='grouptype' href="javascript://needmodel" onClick="clickHandler(this.parentNode)"> <%=ServletResources.getString(key, request)%></a>
					<!--end of  uat4i00000454 3/3-->
						<ul id='<%=key%>' class='collapsed'>
							<li class='all' onClick="selectAll('<%=key%>')"><span id="<%=key+"_"+"grayBlock"%>" <%if(fdata.isPartSelected(key)) {%>class='grayed'<%} %> <%if(fdata.isSelected(key)) {%>checked<%} %>>
								<input type="checkbox" id="<%=key+"_"+"all"%>" name="<%=key+"_"+"all"%>" alt="<%=key+"_"+"all"%>"  <%if(fdata.isPartSelected(key)) {%>checked class='grayed'<%} %> <%if(fdata.isSelected(key)) {%>checked<%} %>>
																			</span>
								<label for="<%=key+"_"+"all"%>"><%=ServletResources.getString("ALL_" + (key.equals("prodname") ? "product" : key).toUpperCase(), request)%></label></li>
						<%
						for(Iterator options = ((List)fdata.getCriteria().get(key)).iterator();options.hasNext();){
							String option = (String)options.next();
						%>
							<li onClick="childClick()"><input type="checkbox" onclick="selectChange(this,'<%=key%>')" id="<%=key+"_"+option+ids%>" name="<%=key+"_"+option%>" alt="<%=option%>" <%if(fdata.isSelected(key, option)) {%>checked<%} %>><label for="<%=key+"_"+option+ids++%>"><%= option%></label></li>
						<%
						}
						%>
						</ul>
					</li>
				
			<%
				}
			} else {
			%>
			<li><%=ServletResources.getString("nofilterinfo", request)%></li>
			<%} %>
			</ul>
</div>

<div id="buttonArea">
<table align="center">
	<tr>	
		<td>
	  		&nbsp;<button id="ok" type="submit"><%=ServletResources.getString("OK", request)%></button>&nbsp;
	  	</td>
	  	<td>
	  		&nbsp;<button id="reset" type="button" onClick="clearForm()"><%=ServletResources.getString("SelectAll", request)%></button>&nbsp;
	  	</td>
	  	<td>
	  		&nbsp;<button id="cancel" type="button" onClick="window.close()"><%=ServletResources.getString("Cancel", request)%></button>&nbsp;
	  	</td>
	</tr>
	

</table>
</div>
</form>
</body>
</html>
