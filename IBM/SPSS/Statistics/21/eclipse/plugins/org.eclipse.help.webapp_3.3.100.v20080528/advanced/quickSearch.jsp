<%--
IBM Confidential
OCO Source Materials
IEHS-311
(c) Copyright IBM Corporation 2006.
All rights reserved.

The source code for this program is not published or otherwise
divested of its trade secrets, irrespective of what has been 
deposited with the U.S. Copyright Office.

 Contributors:
	  2008/08/08 - updated by Hu Qiongkai(IBM Corp.) for Story345 Quick Search
	  2008/08/26 - updated by Xu Yumei(IBM Corp.) for Group search 
	  2008/09/01 - updated by Hu Qiongkai(IBM Corp.) for Defect 593
--%>
<%@ include file="header.jsp"%>

<%
SearchData data=new SearchData(application,request,response);
WebappPreferences prefs = data.getPrefs();
%>


<html>
<head>
<title><%=ServletResources.getString(data.isSingleTopicSearch()?"SearchTopic":"SearchToc", request)%></title>


<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<style type="text/css">


/* need this one for Mozilla */
HTML, BODY{ 
	width:100%;
	height:100%;
	margin:0px;
	padding:0px;
	border:0px;
 }
 
BODY {
	font:<%=prefs.getViewFont()%>;
	background:ButtonFace;
	color: WindowText;
}

TABLE {
	font:<%=prefs.getViewFont()%>;
	background:<%=prefs.getToolbarBackground()%>;
}

TD, TR {
	margin:0px;
	padding:0px;
	border:0px;
}



IMG {
	border:0px;
	margin:0px;
	padding:0px;
	margin-<%=isRTL?"left":"right"%>:4px;
}



.h {
	visibility:hidden;
}



BUTTON {
	font:<%=prefs.getViewFont()%>;
}



INPUT {
	font: <%=prefs.getToolbarFont()%>;
	margin:0px;
	padding:0px;
}

#searchTable {
	font:<%=prefs.getViewFont()%>;
	background:ButtonFace;
	margin: 0px;
	padding-top: 5px;
	height:45px;
}

#searchTD {
	padding-<%=isRTL?"right":"left"%>:7px;
	padding-<%=isRTL?"left":"right"%>:4px;
}


#searchLabel {
	color:WindowText;
}


#searchWord {
	padding-left:2px;
	padding-right:2px;
	border:1px solid ThreeDShadow;
}


#go {
	background:ThreeDShadow;
	color:Window;
	font-weight:bold;
	border:1px solid ThreeDShadow;
	margin-left:1px;
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
var top=opener.top;
var above;

function doQuickSearch(){
		
		document.getElementById("ok").blur();
    
		var quickSearchType='singleTopicSearch';
		
		if(document.getElementById("singleTopicSearch")==null){
			quickSearchType='subTopicsSearch';
		}		
		
		var searchWord = document.getElementById("searchWord").value;
		var quickSearchTopicID=document.getElementById("quickSearchTopicID").value;
		var maxHits = document.getElementById("maxHits").value;
		if (!searchWord || searchWord == "" || !quickSearchTopicID || quickSearchTopicID== ""){
				return;
		}
		
		var query ="searchWord="+encodeURIComponent(searchWord)+"&maxHits="+maxHits+"&"+quickSearchType+"=true&quickSearchTopicID="+quickSearchTopicID;
		  
	  if (top.HelpFrame && 
		top.HelpFrame.NavFrame && 
		top.HelpFrame.NavFrame.showView &&
		top.HelpFrame.NavFrame.ViewsFrame && 
		top.HelpFrame.NavFrame.ViewsFrame.search && 
		top.HelpFrame.NavFrame.ViewsFrame.search.searchViewFrame) 
		{
			//if(quickSearchType=='subTopicsSearch'){
				top.HelpFrame.NavFrame.showView('search');
			//}
			// group search
			var index = query.indexOf("group");  
			var selectedGroup = getCookie("groupBy");
			if(index==-1 && selectedGroup!=null)
				query = query + "&group=" + selectedGroup; 
			else if(index!=-1) {
				query = query + query.substr(0, index - 1) + "&group=" + selectedGroup; 
			}
			// group search ends
			var searchView = top.HelpFrame.NavFrame.ViewsFrame.search.searchViewFrame;
			searchView.location.replace("searchView.jsp?"+query);
		}
		
		
		
	<%=data.isSingleTopicSearch()?"window.close()":""%>
  
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

function enterKeyDownHandler(event) {
	var key = getKeycode(event);
	if (key == 13) {
		document.getElementById("ok").click();	
		return false;	
	}
	return true;
}

function sizeButtons() {
	var minWidth=60;

	if(document.getElementById("ok").offsetWidth < minWidth){
		document.getElementById("ok").style.width = minWidth+"px";
	}
	if(document.getElementById("cancel").offsetWidth < minWidth){
		document.getElementById("cancel").style.width = minWidth+"px";
	}
}

function onloadHandler(e)
{
<%if(!data.isMozilla() || "1.3".compareTo(data.getMozillaVersion()) <=0){
// buttons are not resized immediately on mozilla before 1.3
%>
	sizeButtons();
<%}%>
	if (isIE) {
		document.onkeydown = enterKeyDownHandler;
	}
	else {
		document.addEventListener('keydown', enterKeyDownHandler, true);
	}
	
	document.getElementById("searchWord").value = '<%=UrlUtil.JavaScriptEncode(data.getSearchWord())%>';
	
	if (document.getElementById("searchWord").value==""){
	document.getElementById("searchWord").value='<%=UrlUtil.JavaScriptEncode(data.getQuickSearchWord())%>';
	}
	
	if (document.getElementById("quickSearchTopicID").value==''){
	document.getElementById("quickSearchTopicID").value='<%=data.getQuickSearchTopicID()%>';
	}
	document.getElementById("searchWord").focus();
}



</script>



</head>

<body dir="<%=direction%>" onload="onloadHandler()" >

<div name="searchForm">
<div align="center">
<table width='265' align="center">
<tr>
<td width="23">
</td>
<td align="<%=isRTL?"right":"left"%>">
<table id="searchTable"  align="center" valign="middle" cellspacing=1 cellpading=1 border=0>
	<tr nowrap>
		<td height='<%=data.isIE()?"7":"1"%>'/>
	</tr>
	<tr nowrap valign="top">
		
		<td colspan="2"  align="center"><%=ServletResources.getLabel(data.isSingleTopicSearch()?"SearchTopic":"SearchToc", request)%>
		</td>
	</tr>
	<tr nowrap>
		<td height='<%=data.isIE()?"7":"1"%>'/>
	</tr>
	<tr nowrap valign="middle">
	<td nowrap colspan="2" id="searchTD" align="<%=isRTL?"left":"right"%>">
	
		<label id="searchLabel"
			for="searchWord"
			accesskey="<%=ServletResources.getAccessKey("Search", request)%>">
		 <%=ServletResources.getLabel("Search", request)%> </label>
    
		 
		<input type="text" id="searchWord" name="searchWord"
			value='' size='<%=data.isIE()?"32":"24"%>' maxlength="256"
			alt='<%=ServletResources.getString("SearchExpression", request)%>'
			title='<%=ServletResources.getString("SearchExpression", request)%>'/>
	
		</td>
	</tr>
	<tr nowrap>
		<td height='3'/>
	</tr>
	<tr valign="bottom">
		<td <%=isRTL?"nowrap":""%>></td>
		<td align="<%=isRTL?"left":"right"%>">
			<button type="button" onClick="doQuickSearch();" id="ok"><%=ServletResources.getString("OK", request)%></button>&nbsp;&nbsp;&nbsp;&nbsp;<button type="reset" onclick="window.close()" id="cancel"><%=ServletResources.getString("Cancel", request)%></button>
		</td>
		<td width='10'></td>
	</tr>
</table>
</td>
</tr>
</table>

<%--input type="hidden" id="anchor" name="anchor" value='<%=request.getParameter("anchor")%>'--%>
<input type="hidden" id="maxHits" name="maxHits" value="500">
<input type="hidden" id="quickSearchTopicID" name="quickSearchTopicID" value='<%=data.getQuickSearchTopicID()%>'>
<input type="hidden" id="<%=data.isSingleTopicSearch()?"singleTopicSearch":"subTopicsSearch"%>" name="<%=data.isSingleTopicSearch()?"singleTopicSearch":"subTopicsSearch"%>" value="true">
</div>
</div>
</body>
</html>
