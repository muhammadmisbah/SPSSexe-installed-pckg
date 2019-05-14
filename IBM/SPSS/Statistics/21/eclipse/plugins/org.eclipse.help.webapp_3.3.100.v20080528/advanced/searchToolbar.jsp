<%--
 Copyright (c) 2000, 2007 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
     2008/08/18 - updated by Xu Yumei(IBM Corp.) for Group Search
     2008/08/29 - updated by Xu Yumei(IBM Corp.) for Group Search 
--%>
<%@ include file="header.jsp"%>

<%@ page import="java.util.*"%>

<%
	SearchData data = new SearchData(application, request, response);

	String groupByMenuData="";
	String categories = UrlUtil.JavaScriptEncode(ServletResources.getString("ShowResultsCategories", request));
	
	groupByMenuData="SearchMenu"+","+categories+"=toggleShowCategories,None=toggleGroupBy"; 
	if(data.isFilterEnabled()) {
		Iterator groupTypes = data.getGroupTypes();
		while(groupTypes.hasNext()) { 
			String groupType = (String)groupTypes.next();
			groupByMenuData = groupByMenuData+","+groupType+"=toggleGroupBy";
		}
	}
%>

<jsp:include page="toolbar.jsp">
	<jsp:param name="script" value="navActions.js"/>
	<jsp:param name="view" value="search"/>

	<jsp:param name="name"     value="show_all"/>
	<jsp:param name="tooltip"  value='show_all'/>
	<jsp:param name="image"    value="show_all.gif"/>
	<jsp:param name="action"   value="toggleShowAll"/>
	<jsp:param name="param"    value=""/>
	<jsp:param name="state"    value="<%=(new ActivitiesData(application, request, response)).getButtonState()%>"/>

	<jsp:param name="name"     value="show_categories"/>
	<jsp:param name="tooltip"  value='<%=data.getGroupButtonTip()%>'/>
	<jsp:param name="image"    value="show_categories.gif"/>
	<jsp:param name="action"   value="menu"/>
	<jsp:param name="param"    value="<%=groupByMenuData %>"/>
	<jsp:param name="state"    value="<%=(data.isShowCategoriesButtonOn() ? "on" : "off")%>"/>

	<jsp:param name="name"     value="show_descriptions"/>
	<jsp:param name="tooltip"  value='<%=data.getButtonToolTip()%>'/>
	<jsp:param name="image"    value="show_descriptions.gif"/>
	<jsp:param name="action"   value="toggleShowDescriptions"/>
	<jsp:param name="param"    value=""/>
	<jsp:param name="state"    value="<%=(data.isShowDescriptions() ? "on" : "off")%>"/>

</jsp:include>
