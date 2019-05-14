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
	boolean isSafari = UrlUtil.isSafari(request);
	String msg = (String)request.getAttribute("msg");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<style type="text/css">

/* need this one for Mozilla */
HTML { 
	margin:0px;
	padding:0px;
}
 
#titleText {
	font-weight:bold;
	color:WindowText;
}
 
<%if(isSafari) {%> 
	.caption {
		background:ActiveCaption;
		color:HighLight;
	}
<%} else {%>
	.caption {
		background:ActiveCaption;
		color:CaptionText;
	}
<%}%>

.dialog {
	border:1px solid ButtonFace;
	border:2px outset ButtonShadow;
}

.button {
	background:ButtonFace;
	color:ButtonText;
}

.buttonOn a { 
	display:block;
	margin-left:2px;
	margin-right:2px;
	width:18px;
	height:18px;
	border:1px solid Highlight;
	writing-mode:tb-rl;
	vertical-align:middle;
	background: Window;
}

.button a { 
	display:block;
	margin-left:2px;
	margin-right:2px;
	width:18px;
	height:18px;
	border:1px solid ButtonFace;
	writing-mode:tb-rl;
	vertical-align:middle;
}

.button a:hover { 
	border-top:1px solid ButtonHighlight; 
	border-left:1px solid ButtonHighlight; 
	border-right:1px solid ButtonShadow; 
	border-bottom:1px solid ButtonShadow;
}
</style>

<script language="JavaScript">

function onloadHandler() {
	sizeButtons();
}

function sizeButtons() {
	var minWidth=60;

	if(document.getElementById("ok").offsetWidth < minWidth){
		document.getElementById("ok").style.width = minWidth+"px";
	}
}

</script>

</head>

<body dir='<%=direction%>' onload="onloadHandler()">
<p>&nbsp;</p>
<div align="center">
<DIV STYLE="width:400px;border:1px solid ThreeDShadow;background-color:button;">
	<table align="center" width="400" cellpadding="10" cellspacing="0">
		<tr>
			<td height="30" class="caption"><strong><%=ServletResources.getString("error", request)%></strong></td>
		</tr>
		<tr>
			<td height="50" class="button">
			<p><%=ServletResources.getString(msg, request)%>
			</p>
			</td>
		</tr>
		<tr>
			<td class="button">
			<div align="center">
				<button id="ok" onClick="top.close()"><%=ServletResources.getString("OK", request)%></button>
            </div>
			</td>
		</tr>
	</table>
</DIV>
</div>
</body>
</html>