<%--
 Copyright (c) 2000, 2007 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
     2008/08/08 - updated by Hu Qiongkai(IBM Corp.) for Story345 Quick Search
     2008/08/25 - updated by Xu Yumei(IBM Corp.) for Filter for Navigation View
     2008/09/01 - updated by Hu Qiongkai(IBM Corp.) for Defect 587
--%>
<%@ include file="header.jsp"%>

<%
	String tocWord=UrlUtil.JavaScriptEncode(ServletResources.getString("TocMenu", request));

	String printTopicLabel = UrlUtil.JavaScriptEncode(ServletResources.getString("PrintTopic", request));
	String printTocLabel = UrlUtil.JavaScriptEncode(ServletResources.getString("PrintToc", request));
	//String printError = UrlUtil.JavaScriptEncode(ServletResources.getString("PrintError", request));
	String printError = "PrintError";
	String menuData = tocWord+","+printTopicLabel + "=printTopic=" + printError + "," + printTocLabel + "=printToc=" + printError;
	
	String searchTopicLabel = UrlUtil.JavaScriptEncode(ServletResources.getString("SearchTopic", request));
	String searchTocLabel = UrlUtil.JavaScriptEncode(ServletResources.getString("SearchToc", request));
	//String searchError = UrlUtil.JavaScriptEncode(ServletResources.getString("SearchError", request));
	String searchError = "SearchError";
	String quickSearchMenuData = tocWord+","+searchTopicLabel  + "=searchTopic=" + searchError + "," + searchTocLabel+ "=searchToc=" + searchError;
	 
	// for filter
	FilterData filterData = new FilterData(request, response, application); // filter bug
	boolean cookiesEnabled = false;
	Cookie[] cookies = request.getCookies();
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) {
			if ("cookiesEnabled".equals(cookies[i].getName())
					&& "yes".equals(cookies[i].getValue())) {
				cookiesEnabled = true;
				break;
			}
		}
	}
	filterData.setCookiEnabled(cookiesEnabled);
	// for filter ends
	
	boolean isSyncOn = UrlUtil.isSyncOn(request, response);
	String autoSyncTip = isSyncOn?"SynchNavOff":"SynchNavOn";
%>

<jsp:include page="toolbar.jsp">
	<jsp:param name="script" value="navActions.js"/>
	<jsp:param name="view" value="toc"/>
	
	<jsp:param name="name"     value="show_all"/>
	<jsp:param name="tooltip"  value='show_all'/>
	<jsp:param name="image"    value="show_all.gif"/>
	<jsp:param name="action"   value="toggleShowAll"/>
	<jsp:param name="param"    value=""/>
	<jsp:param name="state"    value="<%=(new ActivitiesData(application, request, response)).getButtonState()%>"/>

	<jsp:param name="name"     value="print_toc"/>
	<jsp:param name="tooltip"  value='PrintMulti'/>
	<jsp:param name="image"    value="print_toc.gif"/>
	<jsp:param name="action"   value="menu"/>
	<jsp:param name="param"    value="<%=menuData%>"/>
	<jsp:param name="state"    value='off'/>
	
	<jsp:param name="name"     value=""/>
	<jsp:param name="tooltip"  value=""/>
	<jsp:param name="image"    value=""/>
	<jsp:param name="action"   value=""/>
	<jsp:param name="param"    value=""/>
	<jsp:param name="state"    value='off'/>
	
	<jsp:param name="name"     value="search_toc"/>
	<jsp:param name="tooltip"  value='QuickSearch'/>
	<jsp:param name="image"    value="quick_search_view.gif"/>
	<jsp:param name="action"   value="menu"/>
	<jsp:param name="param"    value="<%=quickSearchMenuData%>"/>
	<jsp:param name="state"    value='off'/> 
	
	<jsp:param name="name"     value=""/>
	<jsp:param name="tooltip"  value=""/>
	<jsp:param name="image"    value=""/>
	<jsp:param name="action"   value=""/>
	<jsp:param name="param"    value=""/>
	<jsp:param name="state"    value='off'/>

	<jsp:param name="name"     value="collapseall"/>
	<jsp:param name="tooltip"  value='CollapseAll'/>
	<jsp:param name="image"    value="collapseall.gif"/>
	<jsp:param name="action"   value="collapseAll"/>
	<jsp:param name="param"    value=""/>
	<jsp:param name="state"    value='off'/>

	<jsp:param name="name"     value="synchnav"/>
	<jsp:param name="tooltip"  value='<%=autoSyncTip%>'/>
	<jsp:param name="image"    value="auto_synch_toc.gif"/>
	<jsp:param name="action"   value="toggleAutosynch"/>
	<jsp:param name="param"    value=""/>	
	<jsp:param name="state"    value="<%=((new CookiesData(application, request, response)).isSynchToc() ? "on" : "off")%>"/> 
	
	<jsp:param name="name" 	   value="filter" />
	<jsp:param name="tooltip"  value='<%=filterData.getButtonToolTip()%>' />
	<jsp:param name="image"    value="filter.gif" />
	<jsp:param name="action"   value="openFilter" />
	<jsp:param name="param"    value=""/>
	<jsp:param name="state"    value="<%=filterData.getButtonState()%>" />
	
</jsp:include>