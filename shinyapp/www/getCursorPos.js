
shinyjs.getCursorPos = function(textareaID) {
	
	textareaID = '#' + textareaID;
	var input = $(textareaID), // or $('#myinput')[0]
		cursorPos = input[0].selectionStart,
		inputText = input.val();
		
	// detect if selection
	if (input.selectionStart !== input.selectionEnd)
	{
		var selectionValue =
		input.value.substring(input.selectionStart, input.selectionEnd);
	}

	Shiny.onInputChange("cursorPos", cursorPos);
}