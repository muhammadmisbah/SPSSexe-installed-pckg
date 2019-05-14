<%--
* IBM Confidential
*
* OCO Source Materials
*
* The source code for this program is not published or otherwise
* divested of its trade secrets, irrespective of what has been
* deposited with the U.S. Copyright Office.
*
* 5722-IDF
* (C) Copyright IBM Corp. 2006
--%>
<%@ include file="header.jsp"%>
<html lang="<%=UrlUtil.getDefaultLocale(request,response)%>" xml:lang="<%=UrlUtil.getDefaultLocale(request,response)%>">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=ServletResources.getString("updater", request)%></title>
<style type="text/css">
<%@ include file="update.css"%>
</style>  
</head>
<script language="JavaScript" src="cancel.js" type="text/javascript"></script>

<body dir="<%=direction%>"
	  style="margin-top: 0; 
	  margin-left: 0; 
	  margin-right: 0;">
<table width="100%" cellspacing="0" cellpadding="10" border="0">
	<tr>
		<td>
			<h4><%=ServletResources.getString("NoNewUpdates", request)%></h4>
		</td>
	</tr>
</table>

<div align = "right" style="padding-top: 250px;padding-right: 25px;"> 
	<button onclick="parent.parent.parent.window.location='../index.jsp';">
		<%=ServletResources.getString("FinishButton", request)%>
	</button>
</div>

</body>
</html>
