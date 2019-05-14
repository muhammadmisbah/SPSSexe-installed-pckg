<%@ include file="sheader.jsp"%>
<% 
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-store, no-cache");
response.setDateHeader("Expires", 0);
%> 
<%
	ErrorFeatureData data = new ErrorFeatureData(application, request, response);
%>
<html lang="<%=UrlUtil.getLocale(request,response)%>" xml:lang="<%=UrlUtil.getLocale(request,response)%>">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
<%@ include file="css/update.css"%>
</style>  
</head>
<script language="JavaScript" src="js/cancel.js"></script>

<body onload="" 
dir="<%=direction%>"
	 style="margin-top: 0; 
	 margin-left: 0; 
	 margin-right: 0;">
<br>
<table width="100%" cellspacing="0" cellpadding="10" border="0">
<tr>
	<td>
		<h4><%=ServletResources.getString("ErrorFeature", request)%></h4>
	</td>
</tr>
<tr>	
	<td>
			
		<div class='panel' >
			<div class='innerPanel'>
						
				<p> 
				<ul class="itemPanel">
					<%=data.generateScript()%>
				</ul>
				<br >
			</div>
		</div>	
	</td>
</tr>
<tr>
	<td>
		<div align = "right" style="padding-top: 150px;padding-right: 25px" >
			<button onclick="window.location='selectFeature.jsp';" >
				<%=ServletResources.getString("NextButton", request)%>
			</button>
			<button onclick=cancel("errorFeature")>
				<%=ServletResources.getString("CancelButton", request)%>
			</button>
		</div>
	</td>
</tr>
</table>
</body>
</html>
