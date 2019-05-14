<%@ include file="sheader.jsp"%>
<% 
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-store, no-cache");
response.setDateHeader("Expires", 0);
%>
<html lang="<%=UrlUtil.getLocale(request,response)%>" xml:lang="<%=UrlUtil.getLocale(request,response)%>">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=ServletResources.getString("updater", request)%></title>
<style type="text/css">
<%@ include file="css/update.css"%>
</style>
<script language="JavaScript" src="js/update.js" type="text/javascript"></script>
<script language="JavaScript" src="js/cancel.js" type="text/javascript"></script>
</head>
<%
	boolean isSafari = UrlUtil.isSafari(request);
	FindUpdatesData data = new FindUpdatesData(application, request, response);
	data.retrieveFeatures();
%>

<script language="JavaScript" type="text/javascript">
var isIE = <%=data.isIE()%>;
var req;
var percentOfProcess = -1;
var statusMessage = "";

function findUpdates() {
    var url = "UpdateServlet?action=getFindingStatus";
    initRequest(url);
    // set callback function
    req.onreadystatechange = processXMLResponse;
    req.send(null);
}

function initRequest(url) {
    if (window.XMLHttpRequest) {
        req = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }
    req.open("GET", url, true);
}

function processXMLResponse() {
    if (req.readyState == 4) {
        if (req.status == 200) {
            var item = req.responseXML.getElementsByTagName("progress")[0];
            if(item) {
	            percentOfProcess = item.firstChild.nodeValue;
	            showProgress(percentOfProcess);
            }
			
			var updateStatus = req.responseXML.getElementsByTagName("status")[0];
			try{
				statusMessage = updateStatus.firstChild.nodeValue;
				showStatus(statusMessage);
             } catch(e){
       			//some strange character lead to this exception
             }
			
	        if (percentOfProcess < 100) {
	            window.setTimeout("findUpdates()", 2000);
	        } else {
	       		var numOfErrorFeatures = req.responseXML.getElementsByTagName("numOfErrorFeatures")[0];
	       		var errorNum = numOfErrorFeatures.firstChild.nodeValue;
	            
	            if (errorNum > 0) {
	            	redirectToErrorFeatures();
	            } else {
	            	complete();
	            }
	        }
       }
    }
}

function showProgress(percentOfProcess) {
	var progressBar = window.document.getElementById("divProgress");
	progressBar.style.width = percentOfProcess + "%";
}

function showStatus(statusMessage) {
	var statusContainer = window.document.getElementById("statusContainer");
	clearAllChildren(statusContainer);
	
	var newStatusContainer = window.document.getElementById("statusContainer");
	newStatusContainer.appendChild(document.createTextNode(statusMessage));
}

function complete() {
	window.location.replace("selectFeature.jsp");
}

function redirectToErrorFeatures() {
	window.location.replace("errorFeature.jsp");
}
</script>

<body dir="<%=direction%>" onload=""
	style="margin-top: 0; margin-left: 0; margin-right: 0;">
<h3>
	<%=ServletResources.getString("WizardSearchingUpdates", request)%>
</h3>
<table align="center" width="300" cellspacing="0" cellpadding="0"
	border="0" style="margin-top:100">
	<tr>
		<td align="center">
			<%=ServletResources.getString("Searching", request)%>
		</td>
	</tr>
	<tr>
		<td>
		<div style='width:300px;height:16px;border:1px solid ThreeDShadow;'>
			<div id='divProgress'
				 style='width:0%;height:100%;
				 <%if(isSafari) {%>
				 	background-color:grey'
				<%}else { %> 
					background-color:Highlight'<%} %>>
			</div>
		</div>
		</td>
	</tr>
	<tr>
		<td>
			<div id="statusContainer" align="center"/>
		</td>
	</tr>
	<tr>
		<td>
			<div align="right">
				<button onclick="cancel('findFeature')">
					<%=ServletResources.getString("CancelButton", request)%>
				</button>
			</div>
		</td>
	</tr>
</table>
</body>
<script language="JavaScript" type="text/javascript">
	findUpdates();
</script>
</html>