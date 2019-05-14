<%@ include file="sheader.jsp"%>
<% 
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-store, no-cache");
response.setDateHeader("Expires", 0);
%> 
<%
	SelectUpdatesData data= new SelectUpdatesData(application, request, response);
	
	//responsible for the back button 
	if (InstallUpdatesData.hasInstance()) {
		   InstallUpdatesData.getInstance().cancel();
	}
	
	if (data.hasNoUpdates()) {
		request.getRequestDispatcher("noUpdates.jsp").forward(request, response);
	}
%>
<html lang="<%=UrlUtil.getLocale(request,response)%>" xml:lang="<%=UrlUtil.getLocale(request,response)%>">

<head>
<meta http-equiv="expires" content="0"> 
<meta http-equiv="cache-control" content="no-cache,no-store,must-revalidate"> 
<meta http-equiv="pragma" content="no-cache">
<script>
var showDe = "<%=ServletResources.getString("showdescription", request)%>";
var hideDe = "<%=ServletResources.getString("hidedescription", request)%>";
</script>

<script language="JavaScript" src="js/update.js"></script>
<script language="JavaScript" src="js/cancel.js"></script>

<title><%=ServletResources.getString("updater", request)%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<style type="text/css">
<%@ include file="css/update.css"%>
</style> 
</head>

<body dir="<%=direction%>" style="margin-top: 0; margin-left: 0; margin-right: 0;" onload="isValid()">
<form name="selectForm" 
	  action="installFeature.jsp" 
	  method="post">
	<table width="100%" cellspacing="0" cellpadding="10" border="0">
		<tr>
			<td>
				<h3>
					<%=ServletResources.getString("SelectUpdates", request)%>
				</h3>
					<div class='panel' >
						<div class='innerPanel'>
						
							<p> 
								<h4><%=ServletResources.getString("selectExist", request)%></h4>
								<ul class="itemPanel">
									<%=data.generateExistFeaturesCb()%>
								</ul>
								<h4><%=ServletResources.getString("selectNew", request)%></h4>
								<ul class="itemPanel">
									<%=data.generateNewFeaturesCb()%>
								</ul>
								
						</div>
					</div>	
				</td>
			</tr>
			<tr>
				<td>
				<div  align="<%=isRTL?"left":"right"%>">			
					<div>
						<button id="installbutton" type="submit">
							<%=ServletResources.getString("InstallButton", request)%>
						</button>
						<button onClick="cancel('selectFeature')">
							<%=ServletResources.getString("CancelButton", request)%>
						</button>
					</div>
				</div>
				</td>
			</tr>
	</table>
</form>

</body>
</html>