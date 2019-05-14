<%--
 Copyright (c) 2000, 2004 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
--%>
<%@ include file="fheader.jsp"%>

<% 
	LayoutData data = new LayoutData(application,request, response);
	WebappPreferences prefs = data.getPrefs();
%>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=ServletResources.getString("Help", request)%></title>

<style type="text/css">
<% 
if (data.isMozilla()) {
%>
HTML {
	border-<%=isRTL?"left":"right"%>:1px solid ThreeDShadow;
}
<% 
} else {
%>
FRAMESET {
	border-top:1px solid ThreeDShadow;
	border-left:1px solid ThreeDShadow;
	border-right:1px solid ThreeDShadow;
	border-bottom:1px solid ThreeDShadow;
}
<%
}
%>
</style>

</head>

<%boolean hasDefaultBottom = FrameData.hasDefaultBottomApplication(); 

if(hasDefaultBottom) { %>
<frameset id="contentFrameset" rows="24,*, 200" frameborder="0" framespacing="0" border=0 spacing=0>
<%} else{%>
<frameset id="contentFrameset" rows="24,*" frameborder="0" framespacing="0" border=0 spacing=0>
<%} %>
	<%if(!FrameData.hasDefaultCenterApplication()){ %>
	<frame name="ContentToolbarFrame" title="<%=ServletResources.getString("topicViewToolbar", request)%>" src='<%="contentToolbar.jsp"+data.getQuery()%>'  marginwidth="0" marginheight="0" scrolling="no" frameborder="0" noresize=0>
	<frame ACCESSKEY="K" name="ContentViewFrame" title="<%=ServletResources.getString("topicView", request)%>" src='<%=UrlUtil.htmlEncode(data.getContentURL())%>'  marginwidth="10"<%=(data.isIE() && "6.0".compareTo(data.getIEVersion()) <=0)?"scrolling=\"yes\"":""%> marginheight="0" frameborder="0" >
	<%} %>
	<%-- 
	<%if(hasDefaultBottom){ 
		String src = FrameData.getInfocenterContext() + "/" + FrameData.getDefaultBottomApplication().getAttribute("contributor");
	%>
	--%>
	<%if(hasDefaultBottom){ 
		String value = System.getProperty("org.eclipse.equinox.http.jetty.context.path");
		String src = value.substring(1) + "/" + FrameData.getDefaultBottomApplication().getAttribute("contributor");
	%>
	<frame name="bottomFrame" src="<%=src %>" marginwidth="0" marginheight="0" frameborder="1" scrolling="no">
	<%} %>
</frameset>

</html>

