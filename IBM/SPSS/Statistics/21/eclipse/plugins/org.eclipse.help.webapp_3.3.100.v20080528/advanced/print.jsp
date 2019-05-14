<%--
 Copyright (c) 2007 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
--%>
<%@ include file="header.jsp"%>

<% 
	PrintData data = new PrintData(application, request, response);
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=data.getTitle()%></title>
<link rel="stylesheet" href="print.css" charset="utf-8" type="text/css">
</head>
<body dir="<%=direction%>" >
<%
	data.generateToc(out);
	boolean hasScript = data.generateContent(out);
	if(hasScript) {
%>
<script type="text/javascript">
if(confirm("The file contains JavaScript code and these code may be displayed in the print. Are you sure to continue?")) {
	print();
}
</script>
<%
	}
%>
</body>
</html>
