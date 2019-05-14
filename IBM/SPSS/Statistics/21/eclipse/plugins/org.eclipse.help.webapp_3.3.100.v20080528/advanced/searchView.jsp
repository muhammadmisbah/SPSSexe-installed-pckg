<%--
 Copyright (c) 2000, 2007 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
     2008/08/18 - updated by Xu Yumei(IBM Corp.) for Group Result
     2008/08/20 - updated by Hu Qiongkai for search view display decoration
     2008/09/03 - updated by Hu Qiongkai(IBM Corp.) for Defect 638
     2008/09/26 - updated by Hu Qiongkai(IBM Corp.) for Defect 762
--%>
<%@ include file="header.jsp"%>

<!--
	Search group
 -->
<%@ page import="java.util.*"%>
<%@ page import="org.eclipse.help.internal.search.*"%> 
<!--
	Search group ends
 -->

<% 
	SearchData data = new SearchData(application, request, response);
	// After each search we preserve the scope (working set), if any
	// this need to be at the beginning, otherwise cookie is not written
	if (data.isSearchRequest())
		data.saveScope();

	WebappPreferences prefs = data.getPrefs();
	//if(prefs.isZOS()){
	//	response.setBufferSize(prefs.getResponseBufferSize());
	//}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<title><%=ServletResources.getString("SearchResults", request)%></title>

<style type="text/css">
<%@ include file="searchList.css"%>
</style>

<%
// group search
if("none".equalsIgnoreCase(data.getGroup()) || data.getGroup() == null){
// group search ends
%>
<%
// group search
} else {
// group search ends
%> 
<!--
	For grouped search result  
 -->
<style type="text/css">
.searchresult {
	border-left-width: 15px;
	border-left-style: hidden;
	border-left-color: <%=prefs.getViewBackground()%>;
	display:none;
}
</style> 
<script language="JavaScript">

// Preload images
minus = new Image();
minus.src = "<%=prefs.getImagesDirectory()%>"+"/minus.gif";
plus = new Image();
plus.src = "<%=prefs.getImagesDirectory()%>"+"/plus.gif";
altGroupClosed="<%=ServletResources.getString("groupClosed", request)%>";
altGroupOpen="<%=ServletResources.getString("groupOpen", request)%>";
</script>
<script type="text/javascript">
<!--
/**
 * display topic label in the status line on mouse over topic
 */
var isMozilla = navigator.userAgent.indexOf('Mozilla') != -1 && parseInt(navigator.appVersion.substring(0,1)) >= 5;
var isIE = navigator.userAgent.indexOf('MSIE') != -1; 

function clickHandler(arg) {
		if(isExpanded(arg)){
			collapse(arg);
		} else {
			expand(arg);
		}
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
 * Collapses a tree rooted at the specified element
 */
function collapse(node) {
  node.className = "collapsed";
  var image = getChildNode(node, "IMG");
  image.src = plus.src;
  image.alt=altGroupClosed;
  image.title=altGroupClosed;
  // set the UL as well
  var tds = document.getElementById("c" + node.id);
  tds.style.display="none";
}



/**
 * Expands a tree rooted at the specified element
 */
function expand(node) {
  	node.className = "expanded";
  	var image = getChildNode(node, "IMG");
  	image.src = minus.src;
  	image.alt = altGroupOpen;
  	image.title = altGroupOpen;
  	// set the UL as well
  	var tds = document.getElementById("c" + node.id);
  	tds.style.display="block";
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

var preA;
function hightlight(arg) {
	if(preA){
		var preLink =  document.getElementById(preA);
		preLink.className="";
	}
	arg.className="highlight";
	preA = arg.id;
}
//-->
</script> 
<%} 
%>

<base target="ContentViewFrame">
<script language="JavaScript" src="utils.js"></script>
<script language="JavaScript" src="list.js"></script>
<script language="JavaScript">	

var cookiesRequired = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("cookiesRequired", request))%>";

function refresh() { 
	window.location.replace("searchView.jsp?<%=UrlUtil.JavaScriptEncode(request.getQueryString())%>");
}

function isShowCategories() {
	var value = getCookie("showCategories");
	return value ? value == "true" : false;
}

function isShowDescriptions() {
	var value = getCookie("showDescriptions");
	return value ? value == "true" : true;
}

function setShowCategories(value) {
	setCookie("showCategories", value);
	setCookie("groupBy", "None");
	var newValue = isShowCategories();   	    
	parent.searchToolbarFrame.setButtonState("show_categories", newValue);
	if (value != newValue) {
	    alert(cookiesRequired);
	} else { 	    
	var query = "<%=request.getQueryString()%>"; 
	var index = query.indexOf("group"); 
	var url;
	if(index==-1){
		url = "searchView.jsp?" + query + "&group=None";
	}else {
		url = "searchView.jsp?" + query.substr(0, index - 1) + "&group=None"; 
	}   
		window.location.replace(url);
	  //  window.location.reload();
	}
}

function setShowDescriptions(value) {
	setCookie("showDescriptions", value);
	var newValue = isShowDescriptions();   	
	parent.searchToolbarFrame.setButtonState("show_descriptions", newValue);
	if (value != newValue) {
	    alert(cookiesRequired);
	} else { 
	    setCSSRule(".description", "display", value ? "block" : "none");
	    window.location.reload();
	}
}

function toggleShowCategories() {
	setShowCategories(!isShowCategories());
}

function toggleShowDescriptions() {
	setShowDescriptions(!isShowDescriptions());
}

//group search
function showWindowStatus(arg) {
  	try {
		var statusText = "";
		if (isIE)
			statusText = arg.innerText;
		else if (isMozilla)
			statusText = arg.lastChild.nodeValue;
		if (statusText != arg.title) {
			statusText += " - " + arg.title;
		}
		window.status = statusText;
	} catch (e) {
	}
}

function isSearchRequest() {
	return <%=data.isSearchRequest() ? "true" : "false" %>
} 

function changeGroup(arg)
{
	var selectedGroup = arg;
	var query = "<%=request.getQueryString()%>"; 
	
	var index = query.indexOf("group"); 
	var url;
	if(index==-1){
		url = "searchView.jsp?" + query + "&group=" + selectedGroup;
	}else {
		url = "searchView.jsp?" + query.substr(0, index - 1) + "&group=" + selectedGroup; 
	}   
	window.location.replace(url);
}
 

function clearWindowStatus() {
	window.status="";
}

function isGroupBy() {
	var value = getCookie("groupBy"); 
	if(value == null)
		value="None";
	return value;
}

function setGroupBy(arg) {
	setCookie("groupBy", arg);
	setCookie("showCategories", false);
	var newValue = isGroupBy();   
	var pressed = false;
	
	if(newValue != "None")  
		pressed = true;	    
	parent.searchToolbarFrame.setButtonState("show_categories", pressed); 
	if (arg != newValue) {
	    alert(cookiesRequired);
	} else {
		if(isSearchRequest())
	    	changeGroup(arg);  
	} 
}

function toggleGroupBy(arg) { 
	setGroupBy(arg); 
}
//group search ends

/**
 * Defect 762 - right click for tree expanding in search results view
 * @author huqiongk
 */
function mouseUpHandler(e, node) {
	var theEvent = window.event||e;
	if (theEvent.button != 2) {
		return true;
	} 
	cancelEventBubble(theEvent);
	
	document.oncontextmenu=function(event) {   	// context menu forbidden
	    if (document.all) 
	    	window.event.returnValue = false;
	    else
	    	event.preventDefault();
	};
			
	expand(node);
	return false;
}

/**
 * Defect 762 - Alt+o and left/right arrows support  for tree navigating in search results view
 * @author huqiongk
 */
function pKeyDownHandler(e, node) {
	var theEvent = window.event||e; 
	var keycode = getKeycode(e);
	
	// Always cancel the event bubble for navigation keys
  	cancelEventBubble(theEvent);
	
  	if (keycode == 79 || keycode == 39) {	  	
		expand(node); 
		return false; 	
  	} 
  	else if (keycode == 66 || keycode == 37) {	  	
		collapse(node); 
		return false; 	
  	} 
  	
  	return true;
} 
</script>


</head>

<body dir="<%=direction%>">

<%
if (!data.isSearchRequest()) {
	out.write(ServletResources.getString("doSearch", request));
} else if (data.getQueryExceptionMessage()!=null) {
	out.write(data.getQueryExceptionMessage());
} else if (data.isProgressRequest()) {
%> 
<CENTER>
<TABLE BORDER='0'>
	<TR><TD><%=ServletResources.getString("Indexing", request)%></TD></TR>
	<TR><TD ALIGN='<%=isRTL?"RIGHT":"LEFT"%>'>
		<DIV STYLE='width:100px;height:16px;border:1px solid ThreeDShadow;'>
			<DIV ID='divProgress' STYLE='width:<%=data.getIndexedPercentage()%>px;height:100%;background-color:Highlight'></DIV>
		</DIV>
	</TD></TR>
	<TR><TD><%=data.getIndexedPercentage()%>% <%=ServletResources.getString("complete", request)%></TD></TR>
	<TR><TD><br><%=ServletResources.getString("IndexingPleaseWait", request)%></TD></TR>
</TABLE>
</CENTER> 
<script language='JavaScript'>
setTimeout('refresh()', 2000);
</script> 
<%
	return;
} else if (data.getResultsCount() == 0){
	out.write(ServletResources.getString("Nothing_found", request));
} else {
%>

<table class="results" cellspacing='0'>
<%--
   added by Sheila for search
--%>
<tr><td width="23px">&nbsp;</td></tr>
<tr>
	<%	// search results display decoration
		String []arg =  new String[]{String.valueOf(data.getResultsCount()),data.getSearchWord()};
		String resultAmount = ServletResources.getString("resultAmount", arg, request);
		String partialDisplay = ServletResources.getString("morethan500", data.getSearchWord(), request);
	%>
	<%if (data.getResultsCount() < 500) {%>
	<td colspan="2">
		<font size="-1"><%=resultAmount%></font>
	</td>
	<%} else { %>
	<td colspan="2">
		<font size="-1"><%=partialDisplay%></font>
	</td>
	<%} %>
</tr>  
<tr>
	<td colspan="2" class="" style="border-bottom-width: 2px;border-bottom-style: solid;border-bottom-color: #0000FF" nowrap>
	&nbsp;<%--group types --%>
	</td>
</tr>
 
<tr>
	<td colspan="2">
		&nbsp;
	</td>
</tr>
<%
 if("none".equalsIgnoreCase(data.getGroup()) || data.getGroup() == null) { 
	 
	String oldCat = null;
	for (int topic = 0; topic < data.getResultsCount(); topic++)
	{
		if(data.isActivityFiltering() && !data.isEnabled(topic)){
			continue;
		}
		//if(data.isFiltered(topic)) {
		//	continue;
		//}

		String cat = data.getCategoryLabel(topic);
		if (data.isShowCategories() && cat != null
				&& (oldCat == null || !oldCat.equals(cat))) {
%>

</table>
<table class="category" cellspacing='0'>
	<tr class='list' id='r<%=topic%>c'>
		<td>
			<a href="<%=data.getCategoryHref(topic)%>"
					id="a<%=topic%>c"'
					class="link"
					onmouseover="showStatus(event);return true;"
					onmouseout="clearStatus();blur();return true;">
				<%=cat%>
			</a>
		</td>
	</tr>
</table>
<table class="results" cellspacing='0'>

<%
			oldCat = cat;
		}
%>

<tr class='list' id='r<%=topic%>'>
<%-- group search --%>
<%
  if(data.isPercentageDisplay()) {
%>
<td class='score' align='<%=isRTL?"left":"right"%>'><%=data.getTopicScore(topic)%></td>
<%}%>  
<%-- ends group search --%>
	<td class='icon' >

<%
		boolean isPotentialHit = data.isPotentialHit(topic);
		if (isPotentialHit) {
%>
 

	<img src="<%=prefs.getImagesDirectory()%>/d_topic.gif" alt=""/> 
<%
		}
		else {
%> 
	<img src="<%=prefs.getImagesDirectory()%>/topic.gif" alt=""/> 
<%
		}
%>

	</td>
	<td align='<%=isRTL?"right":"left"%>'>
		<a class='link' id='a<%=topic%>' 
		   href="<%=data.getTopicHref(topic)%>" 
		   onmouseover="showStatus(event);return true;"
		   onmouseout="clearStatus();blur();return true;"
		   title="<%=data.getTopicTocLabel(topic)%>">

<%
		String label = null;
		if (isPotentialHit) {
            label = ServletResources.getString("PotentialHit", data.getTopicLabel(topic), request);
        }
        else {
            label = data.getTopicLabel(topic);
        }
%>

        <%=label%></a>
	</td>
</tr>

<%
		String desc = data.getTopicDescription(topic);
		if (desc!=null) {
%>
<tr id='d<%=topic%>'>
	<td class='icon'>
	</td>
	<td align='<%=isRTL?"right":"left"%>'>
		<div class="description">
			<%=desc%>
		</div>
	</td>
</tr>
<%
		}
	}//end for loop
 }
 else {
%>
</table>
<%
	int ids = 0;
	HashMap groups = data.getResults();
	Set keysSet = groups.keySet();
	List keysList = new ArrayList(keysSet);
    Collections.sort(keysList);
    String unCategory = ServletResources.getString("Uncategorized",
			request);
    if(keysList.remove(unCategory)){
    	keysList.add(unCategory);
    }
	for(Iterator keys = keysList.iterator(); keys.hasNext(); ) {
			String key = (String)keys.next();
%>	
		<table>
			<tr>
				<td class='collapsed' id="<%=key%>" colspan="2" nowrap>
				<img src='images/plus.gif' class='collapsed' alt="<%=ServletResources.getString("groupClosed", request)%>" title="<%=ServletResources.getString("groupClosed", request)%>" onClick='clickHandler(this.parentNode);'>
				<strong><a id="a<%=key%>" class="grouptype" href="javascript://needModal" title='<%=key%>' onclick='clickHandler(this.parentNode.parentNode);' onmouseup='mouseUpHandler(event,this.parentNode.parentNode);' onkeydown='pKeyDownHandler(event,this.parentNode.parentNode);'><%=key%></a></strong>
				</td>
			</tr>
		</table>
		<table class="searchresult" id="c<%=key%>" cellspacing="0px">
					<%
						for(Iterator values = ((List)groups.get(key)).iterator(); values.hasNext(); ) {
							SearchHit hit = (SearchHit)values.next();
							String tocLable = "";
							if(hit.getToc() != null) {
								tocLable = UrlUtil.htmlEncode(hit.getToc().getLabel());
							}
					%>
						<tr id='r<%=ids%>' class='list'>
						<%if(data.isPercentageDisplay()){%>
							<td width="35px" class='score' align='<%=isRTL?"left":"right"%>'>
								<div style="width:35px;">	
									<%=data.getTopicScore(hit)%>
								</div>
							</td>
						<%}%>
							
							<td class='icon' >  							 
	<%
		boolean isPotentialHit = (data.getMode() != data.MODE_INFOCENTER) && hit.isPotentialHit();
		if (isPotentialHit) {
	%>
 

								<img src="<%=prefs.getImagesDirectory()%>/d_topic.gif" alt=""/> 
	<%
		}
		else {
	%> 
								<img src="<%=prefs.getImagesDirectory()%>/topic.gif" alt=""/> 
	<%
		}
	%>						
							</td>
							
							<td class='label' align='<%=isRTL?"right":"left"%>' colspan="2" nowrap>
								<a id='a<%=ids++%>'
								   href="<%=UrlUtil.getHelpURL(hit.getHref())%>" 
								   onmouseover="showWindowStatus(this);return true;"
								   onmouseout="clearWindowStatus();blur();return true;"
								   onclick='parent.parent.parent.setContentToolbarTitle(this.title);hightlight(this);' 
								   title="<%=tocLable%>">
								  <%=hit.getLabel()%>
								 </a>
							 </td>
							 </tr>
							 <%if(data.isShowDescriptions()) { %>
			
							 <tr>
							 <%if(data.isPercentageDisplay()){%>
							 	    <td>&nbsp;</td>
							 <%}%>
							 		<td ></td>
									<td align='<%=isRTL?"right":"left"%>' colspan="2"> 
										<div class="description">
											<%=hit.getSummary() %>
										</div>
									</td>
							</tr>
							
							 <%} %>
						
					<%
						}
					%>
				
		</table>
		
	<%
		}
	}
	%>


<!--
	end of For grouped search result 
	uat4i00000025 2/2
 -->
<%
	}


%>

 
</body>
</html>
