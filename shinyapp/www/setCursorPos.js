
$(document).ready(function() {
  
	Shiny.addCustomMessageHandler("setCursorPos", function(list) {
		textareaID = '#' + list.textareaID;
		el = $(textareaID);
		el.val(list.newValue);
		el[0].selectionStart = list.cursorPos;
		el[0].selectionEnd = list.cursorPos;
		Shiny.onInputChange(list.textareaID, el.val());
		Shiny.onInputChange("cursorPos", list.cursorPos);
	});

});