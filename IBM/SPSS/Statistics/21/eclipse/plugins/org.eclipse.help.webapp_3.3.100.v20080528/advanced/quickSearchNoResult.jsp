<%--
IBM Confidential
OCO Source Materials
IEHS-311
(c) Copyright IBM Corporation 2006.
All rights reserved.

The source code for this program is not published or otherwise
divested of its trade secrets, irrespective of what has been 
deposited with the U.S. Copyright Office.
--%>
<%@ include file="header.jsp"%>
<%
RequestData data = new RequestData(application,request, response);
WebappPreferences prefs = data.getPrefs();
%>

<html>
<head>
<title><%=ServletResources.getString("quickSearchResult", request)%></title>
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
	font: icon;
	background:ButtonFace;
	color: WindowText;
}

TABLE {
	font:<%=prefs.getViewFont()%>;
	background:<%=prefs.getToolbarBackground()%>;
	margin: 0px;
	padding-top: 5px;
	height:45px;
}

TD, TR {
	margin:0px;
	padding:0px;
	border:0px;
}


BUTTON {
	font:<%=prefs.getViewFont()%>;
	width:75px;
}

</style>

<script language="JavaScript">
function sizeButtons() {
	var minWidth=60;

	// if(document.getElementById("ok").offsetWidth < minWidth){
		document.getElementById("ok").style.width = minWidth+"px";
	// }
}

function onloadHandler(e)
{
<%if(!data.isMozilla() || "1.3".compareTo(data.getMozillaVersion()) <=0){
// buttons are not resized immediately on mozilla before 1.3
%>
	// sizeButtons();
<%}%>

}

</script>

</head>

<body dir="<%=direction%>">

<table id="searchTable" width='100%' valign="middle" cellspacing=20 cellpading=0 border=0>
	
	<tr nowrap align="center">		
		<td nowrap><%=ServletResources.getString("Nothing_found", request)%>
		</td>		
	</tr>
	
	<tr nowrap align="center">
	<td>
		<button type="submit" onclick="window.close();" id="ok"><%=ServletResources.getString("OK", request)%></button>
	</td>
	</tr>
</table>


</body>
</html>
