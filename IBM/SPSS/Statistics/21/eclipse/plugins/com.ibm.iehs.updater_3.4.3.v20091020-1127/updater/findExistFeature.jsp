<%@ include file="sheader.jsp"%>
<% 
	response.setHeader("Pragma","no-cache"); 
	response.setHeader("Cache-Control","no-store, no-cache");
	response.setDateHeader("Expires", 0); 

	GetInstalledFeaturesData data = new GetInstalledFeaturesData(application,request,response);
%>
<html lang="<%=UrlUtil.getLocale(request,response)%>" xml:lang="<%=UrlUtil.getLocale(request,response)%>">

<head>
<script language="JavaScript" type="text/javascript">
var showDe = "<%=ServletResources.getString("showdescription", request)%>";
var hideDe = "<%=ServletResources.getString("hidedescription", request)%>";
</script>

<script language="JavaScript" src="js/update.js" type="text/javascript"></script>
<script language="JavaScript" src="js/cancel.js" type="text/javascript"></script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=ServletResources.getString("updater", request)%></title>
<style type="text/css">
<%@ include file="css/update.css"%>
</style> 

</head>
<body style="margin-top: 0; margin-left: 0; margin-right: 0;" dir="<%=direction%>">
<table width="100%" cellspacing="0" cellpadding="10" border="0">
	<tr>
		<td colspan="10">
				<h3><%=ServletResources.getString("ShowExistFeature", request)%></h3>
				<div class='panel'>
					<div class='innerPanel'>
						<ul class="itemPanel">
							<%=data.getExistingFeatures()%>
						</ul>
					</div>
				</div>
		</td>
	</tr>
</table>
<div align = "<%=isRTL?"left":"right"%>"
	 style="<%=direction%>">
	<button	onclick="window.location='findFeature.jsp';" >
		<%=ServletResources.getString("NextButton", request)%>
	</button>
	<button	onclick="cancel('findExist')">
		<%=ServletResources.getString("CancelButton", request)%>
	</button>
				
</div>
</body>
</html>
