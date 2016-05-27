
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

	var beforeCursor = inputText.substring(0, cursorPos),
		afterCursor = inputText.substring(cursorPos, inputText.length)
		
	Shiny.onInputChange("cursorPos", [beforeCursor,afterCursor]);
}

/*
$(document).on("click", ".reactiveTextarea", function(evt) {
	var number = [Math.random(),Math.random()];
	Shiny.onInputChange("cursorPos", number);
	
});
*/