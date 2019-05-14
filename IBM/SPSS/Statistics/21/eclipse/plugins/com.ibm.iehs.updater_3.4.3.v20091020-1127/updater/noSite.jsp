<%@ include file="sheader.jsp"%>
<html lang="<%=UrlUtil.getLocale(request,response)%>" xml:lang="<%=UrlUtil.getLocale(request,response)%>">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=ServletResources.getString("updater", request)%></title>
<style type="text/css">
<%@ include file="css/update.css"%>
</style>  
</head>
<script language="JavaScript" src="js/cancel.js" type="text/javascript"></script>

<body dir="<%=direction%>"
	  style="margin-top: 0; 
	  margin-left: 0; 
	  margin-right: 0;">
<table width="100%" cellspacing="0" cellpadding="10" border="0">
	<tr>
		<td>
			<h4><%=ServletResources.getString("noConfiguredSite", request)%></h4>
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
