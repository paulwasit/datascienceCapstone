
$(document).ready(function() {

  $("#inputText").focus();
	
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