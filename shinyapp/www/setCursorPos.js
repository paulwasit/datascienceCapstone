
$(document).ready(function() {

  $("#inputText").focus();
	
	$.getJSON("./en_US.10.freq.10.fast.json", function(json) {
    console.log("json"); // this will show the info it in firebug console
	});	
	
	Shiny.addCustomMessageHandler("setCursorPos", function(list) {
		textareaID = '#' + list.textareaID;
		el = $(textareaID);
		el.val(list.newValue);
		el[0].selectionStart = list.cursorPos;
		el[0].selectionEnd = list.cursorPos;
		$(el).trigger("change"); // triggers update
		Shiny.onInputChange("cursorPos", list.cursorPos);
	});

});