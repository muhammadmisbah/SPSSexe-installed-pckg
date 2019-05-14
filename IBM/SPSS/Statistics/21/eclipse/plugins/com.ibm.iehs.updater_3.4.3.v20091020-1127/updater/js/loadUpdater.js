function loadUpdater(button, param) {
	try {
		parent.ContentViewFrame.window.location= "../updater/updater.jsp";	
	} catch(e) {
	}
	if (isIE && button && document.getElementById(button)){
			document.getElementById(button).blur();
	}
}