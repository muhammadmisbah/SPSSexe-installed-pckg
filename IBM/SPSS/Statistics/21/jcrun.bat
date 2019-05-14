@REM ************************************************************************
@REM IBM Confidential
@REM
@REM OCO Source Materials
@REM
@REM IBM SPSS Products: Statistics Common
@REM
@REM (C) Copyright IBM Corp. 1989, 2012
@REM
@REM The source code for this program is not published or otherwise divested of its trade secrets, 
@REM irrespective of what has been deposited with the U.S. Copyright Office.
@REM ************************************************************************

@SETLOCAL & PUSHD & SET RET=

@ECHO OFF

@REM the installation directory
SET INSTALLDIR=%~sdp0

@REM set the PATH to include the common directory
SET COMMONDIR=%INSTALLDIR%common\
SET PATH=%COMMONDIR%ext\bin\spss.common\;%COMMONDIR%thirdparty\;%PATH%

@REM set the PATH to include the installation directory
SET PATH=%INSTALLDIR%;%PATH%

%INSTALLDIR%JRE\bin\java.exe -ea -Dsun.java2d.d3d=false -Xshareclasses:name=statistics_%u -Xshareclasses:nonfatal -Xscmx32M -Xdisableexplicitgc -Xms32M -Xmx768M -Dcom.sun.media.jai.disableMediaLib=true -Dswing.aatext=false -Djava.library.path=%INSTALLDIR%;%INSTALLDIR%JRE\bin -Dstatistics.home=%INSTALLDIR% -Dstd_deployment.home=%INSTALLDIR% -DsaveXml=true -classpath %INSTALLDIR%axis.jar;%INSTALLDIR%castor-1.2.jar;%INSTALLDIR%cf-tool.jar;%INSTALLDIR%ChartEditor.jar;%INSTALLDIR%ChartEditorRes.jar;%INSTALLDIR%cobalt.jar;%INSTALLDIR%commons-codec-1.3.jar;%INSTALLDIR%commons-discovery-0.2.jar;%INSTALLDIR%commons-lang-2.1.jar;%INSTALLDIR%commons-logging-1.0.4.jar;%INSTALLDIR%cop-client.jar;%INSTALLDIR%CoreTools.jar;%INSTALLDIR%exacc.jar;%INSTALLDIR%excelxlsx.jar;%INSTALLDIR%ExportTools.jar;%INSTALLDIR%FieldChooser.jar;%INSTALLDIR%itext-2.0.1.jar;%INSTALLDIR%iTextAsian.jar;%INSTALLDIR%jaguar_treemodel.jar;%INSTALLDIR%jai_codec.jar;%INSTALLDIR%jai_core.jar;%INSTALLDIR%jaxrpc.jar;%INSTALLDIR%JimiProClasses.zip;%INSTALLDIR%JSON4J.jar;%INSTALLDIR%log4j-1.2.8.jar;%INSTALLDIR%looks-1.3.1.jar;%INSTALLDIR%mail.jar;%COMMONDIR%ext\lib\spss.common\pasw-cf-common.jar;%COMMONDIR%ext\lib\spss.common\pasw-cf-swingui.jar;%INSTALLDIR%pesworker.jar;%INSTALLDIR%pev-client.jar;%INSTALLDIR%pev-driver.jar;%INSTALLDIR%PivotTableEditor.jar;%INSTALLDIR%PivotTableEditorRes.jar;%INSTALLDIR%poi-3.0.1.jar;%INSTALLDIR%RapidSpell.jar;%INSTALLDIR%repository-client.jar;%INSTALLDIR%repository-client-application.jar;%INSTALLDIR%repository-ui.jar;%INSTALLDIR%saaj.jar;%INSTALLDIR%search-client.jar;%INSTALLDIR%security-client.jar;%INSTALLDIR%security-subject.jar;%INSTALLDIR%ssoProviders.jar;%INSTALLDIR%SPSSClientCore.jar;%INSTALLDIR%SPSSClientCoreRes.jar;%INSTALLDIR%SPSSClientUI.jar;%INSTALLDIR%SPSSClientUIRes.jar;%INSTALLDIR%spssexcel.jar;%INSTALLDIR%spssjio.jar;%INSTALLDIR%SPSSSyntaxEditor.jar;%INSTALLDIR%SPSSSyntaxEditorRes.jar;%INSTALLDIR%TableLayout-bin-jdk1.5-2007-04-21.jar;%INSTALLDIR%transformations.jar;%INSTALLDIR%TreeEditor.jar;%INSTALLDIR%TreeEditorRes.jar;%INSTALLDIR%TreeModel.jar;%INSTALLDIR%TreeViewerPanel.jar;%INSTALLDIR%UITools.jar;%INSTALLDIR%UIToolsRes.jar;%INSTALLDIR%util.jar;%INSTALLDIR%ViewableTree.jar;%INSTALLDIR%visualization.jar;%INSTALLDIR%ModelViewer.jar;%INSTALLDIR%VizConverter.jar;%INSTALLDIR%VizImager.jar;%INSTALLDIR%wsdl4j-1.5.1.jar;%INSTALLDIR%xmlrpc-2.0.1.jar com.spss.java_client.core.common.Driver %*

:end

@POPD & ENDLOCAL & SET RET=%RET%
