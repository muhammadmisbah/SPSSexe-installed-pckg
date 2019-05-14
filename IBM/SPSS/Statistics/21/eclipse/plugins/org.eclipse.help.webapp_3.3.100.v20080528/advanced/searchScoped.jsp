<%--
 Copyright (c) 2000, 2007 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation    
     Pierre Candela  - fix for Bug 194911
     2008/08/18 - updated by Xu Yumei(IBM Corp.) for Group Result
--%>
<%@ include file="header.jsp"%>

<% 
	SearchData data = new SearchData(application, request, response);
	WebappPreferences prefs = data.getPrefs();
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title><%=ServletResources.getString("Search", request)%></title>
     
<style type="text/css">
/* need this one for Mozilla */
HTML { 
	width:100%;
	height:100%;
	margin:0px;
	padding:0px;
	border:0px;
 }

BODY {
	background:<%=prefs.getToolbarBackground()%>;
	border:0px;
	height:100%;
}

TABLE {
	font: <%=prefs.getToolbarFont()%>;
	background:<%=prefs.getToolbarBackground()%>;
	margin: 0px;
	padding: 0px;
	height:100%;
}

FORM {
	background:<%=prefs.getToolbarBackground()%>;
	height:100%;
	margin:0px;
}

INPUT {
	font: <%=prefs.getToolbarFont()%>;
	margin:0px;
	padding:0px;
}

INPUT {
    font-size: 1.0em;
}

A {
	color:WindowText;
	text-decoration:none;
}

#searchTD {
	padding-<%=isRTL?"right":"left"%>:7px;
	padding-<%=isRTL?"left":"right"%>:4px;
}

#searchWord {
	margin-left:5px;
	margin-right:5px;
	border:1px solid ThreeDShadow;
}

#searchLabel {
	color:WindowText;
}

#go {
	background:ThreeDShadow;
	color:Window;
	font-weight:bold;
	border:1px solid ThreeDShadow;
	margin-left:1px;
	font-size: 1.0em;
}

#scopeLabel {
	text-decoration:underline; 
	color:#0066FF; 
	cursor:pointer;
	padding-left:15px;   /* This should be the same for both RTL and LTR. */
}

#scope { 
	text-align:<%=isRTL?"left":"right"%>;
	margin-<%=isRTL?"right":"left"%>:5px;
	border:0px;
	color:WindowText;
	text-decoration:none;
}

<%
	if (data.isIE()) {
%>
#go {
	padding-<%=isRTL?"right":"left"%>:1px;
}
<%
	}
%>
</style>
<script language="JavaScript" src="utils.js"></script>
<script language="JavaScript">
var isIE = navigator.userAgent.indexOf('MSIE') != -1;
var isMozilla = navigator.userAgent.toLowerCase().indexOf('mozilla') != -1 && parseInt(navigator.appVersion.substring(0,1)) >= 5;

var advancedDialog;

function openAdvanced() 
{ 
    var scope = document.getElementById("scope").firstChild;
    var workingSet = ""; 
    if (scope != null) 
              workingSet = document.getElementById("scope").firstChild.nodeValue;                
    var minSize = 300; 
    var maxHeight= 500;  
    var maxWidth = 600;       
    var w = minSize; 
    var h = minSize; 
      
    // If we have large fonts make the dialog larger, up to 500 pixels high, 600 wide
    try {         
        var letterHeight = document.getElementById("searchWord").offsetHeight; 
        var requiredSize = 16 * letterHeight; 
        if (requiredSize > minSize) { 
            if (requiredSize < maxWidth) { 
                w = requiredSize; 
            } else { 
                w =  maxWidth; 
            }
            if (requiredSize < maxHeight) { 
                h = requiredSize; 
            } else {               
                h = maxHeight;
            }
        } 
             
    } catch (e) {} 
    
<%
if (data.isIE()){
%>
	var l = parent.screenLeft + (parent.document.body.clientWidth - w) / 2;
	var t = parent.screenTop + (parent.document.body.clientHeight - h) / 2;
<%
} else {
%>
	var l = parent.screenX + (parent.innerWidth - w) / 2;
	var t = parent.screenY + (parent.innerHeight - h) / 2;
<%
}
%>
	// move the dialog just a bit higher than the middle
	if (t-50 > 0) t = t-50;
	
	window.location="javascript://needModal";
	advancedDialog = window.open("workingSetManager.jsp?workingSet="+encodeURIComponent(workingSet), "advancedDialog", "resizable=yes,height="+h+",width="+w+",left="+l+",top="+t );
	advancedDialog.focus(); 
}

function closeAdvanced()
{
	try {
		if (advancedDialog)
			advancedDialog.close();
	}
	catch(e) {}
}

/**
 * This function can be called from this page or from
 * the advanced search page. When called from the advanced
 * search page, a query is passed.
 */
function doSearch(query)
{
	var workingSet = document.getElementById("scope").firstChild.nodeValue;

	var searchScopeWs;
	if (!query || query == "")
	{
		var form = document.forms["searchForm"];
		var searchWord = form.searchWord.value;
		var maxHits = form.maxHits.value;
		if (!searchWord || searchWord == "")
			return;
		query ="searchWord="+encodeURIComponent(searchWord)+"&maxHits="+maxHits;
		searchScopeWs = "searchWord="+encodeURIComponent(searchWord);
		//searchScopeWs = query;
		if (workingSet != '<%=UrlUtil.JavaScriptEncode(ServletResources.getString("All", request))%>'){
			query = query +"&scope="+encodeURIComponent(workingSet);
			//var searchScopeValue = document.getElementById("searchScope").value;
			//searchScopeWs = searchScopeWs +"&scope="+encodeURIComponent(workingSet)+"&searchScope="+searchScopeValue;
			//searchScopeWs = searchScopeWs + "&searchScope="+searchScopeValue;
		}
	}
	
	
	/******** HARD CODED VIEW NAME *********/
	// do some tests to ensure the results are available
	if (parent.HelpFrame && 
		parent.HelpFrame.NavFrame && 
		parent.HelpFrame.NavFrame.showView &&
		parent.HelpFrame.NavFrame.ViewsFrame && 
		parent.HelpFrame.NavFrame.ViewsFrame.search && 
		parent.HelpFrame.NavFrame.ViewsFrame.search.searchViewFrame) 
	{
		parent.HelpFrame.NavFrame.showView("search");
		var searchView = parent.HelpFrame.NavFrame.ViewsFrame.search.searchViewFrame;
		// group search
		var index = query.indexOf("group");  
		var selectedGroup = getCookie("groupBy");
		if(index==-1 && selectedGroup!=null)
			query = query + "&group=" + selectedGroup; 
		else if(index!=-1) {
			query = query + query.substr(0, index - 1) + "&group=" + selectedGroup; 
		}
		
		//var searchScopeUrl = "<font size='1px'><strong>";
		//searchScopeUrl += window.location.protocol +"//" +window.location.host + parent.location.pathname + "?tab=search&"+searchScopeWs;
		//searchScopeUrl += "</strong></font>";
		//document.getElementById("scopeUrl").innerHTML= searchScopeUrl;
		// group search ends
		searchView.location.replace("searchView.jsp?"+query);
	} 
}

function fixHeights()
{
	if (!isIE) return;
	
	var h = document.getElementById("searchWord").offsetHeight;
	document.getElementById("go").style.height = h;
}

function onloadHandler(e)
{
	var form = document.forms["searchForm"];
	form.searchWord.value = '<%=UrlUtil.JavaScriptEncode(data.getSearchWord())%>';
	fixHeights();
}

</script>

</head>

<body dir="<%=direction%>" onload="onloadHandler()"  onunload="closeAdvanced()">

	<form  name="searchForm"   onsubmit="doSearch()">
		<table id="searchTable" align="<%=isRTL?"right":"left"%>" valign="middle" cellspacing="0" cellpadding="0" border="0">
			<tr nowrap  valign="middle">
				<td <%=isRTL?"nowrap":""%> id="searchTD">
					<label id="searchLabel" for="searchWord" accesskey="<%=ServletResources.getAccessKey("Search", request)%>">
					&nbsp;<%=ServletResources.getLabel("Search", request)%>
					</label>
				</td>
				<td>
					<input type="text" id="searchWord" name="searchWord" value='' size="24" maxlength="256" alt='<%=ServletResources.getString("expression_label", request)%>' title='<%=ServletResources.getString("expression_label", request)%>'>
				</td>
				<td >
					<input type="button" onclick="this.blur();doSearch()" value='<%=ServletResources.getString("GO", request)%>' id="go" alt='<%=ServletResources.getString("GO", request)%>' title='<%=ServletResources.getString("GO", request)%>'>
					<input type="hidden" name="maxHits" value="500" >
				</td>
				<td nowrap>
					<a id="scopeLabel" href="javascript:openAdvanced();" title='<%=ServletResources.getString("ScopeTooltip", request)%>' alt='<%=ServletResources.getString("ScopeTooltip", request)%>' onmouseover="window.status='<%=UrlUtil.JavaScriptEncode(ServletResources.getString("ScopeTooltip", request))%>'; return true;" onmouseout="window.status='';"><%=ServletResources.getLabel("Scope", request)%></a>
				</td>
				<td nowrap>
					<input type="hidden" name="workingSet" value='<%=UrlUtil.htmlEncode(data.getScope())%>'>
					<div id="scope" ><%=UrlUtil.htmlEncode(data.getScope())%></div>
					<input type="hidden" id="searchScope" name="searchScope" value="<%=data.getSearchScope()%>"/>
				</td>
				<td nowrap>    
					<div id="scopeUrlDiv">&nbsp;&nbsp;<span id="scopeUrl"></span>&nbsp;</div>
				</td>
			</tr>
		</table>
	</form>		

</body>
</html>
