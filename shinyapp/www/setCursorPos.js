'use strict'

var freqJson;

$(document).ready(function() {

  $("#inputText").focus();
	$.getJSON("./en_US.10.freq.10.fast.json", function(json) {
    freqJson = json;
		console.log("json"); // this will show the info it in firebug console
	});	
	
	Shiny.addCustomMessageHandler("setCursorPos", function(list) {
		var textareaID = '#' + list.textareaID,
				el = $(textareaID);
		el.val(list.newValue);
		el[0].selectionStart = list.cursorPos;
		el[0].selectionEnd = list.cursorPos;
		$(el).trigger("change"); // triggers update
		var ngram = getNgram("inputText", list.cursorPos);
		var nWords = getWords(ngram);
		Shiny.onInputChange("cursorPos", nWords);
	});

});

$(document).on("click", "#word1", function(evt) {	$("#inputText").focus(); });
$(document).on("click", "#word2", function(evt) {	$("#inputText").focus(); });
$(document).on("click", "#word3", function(evt) { $("#inputText").focus(); });

$(document).on("keyup", ".reactiveTextarea", function(evt) {
	console.log("ok");
	var el = $(evt.target)[0];
	var offset = el.offsetHeight - el.clientHeight;
	$(el).css('height', 'auto').css('height', el.scrollHeight + offset);
	updateInput(evt);
});

$(document).click(".reactiveTextarea", function(evt) { updateInput(evt); });

function updateInput (evt) {
	var el = $(evt.target)[0];
	$(el).trigger("change"); // triggers update
	var ngram = getNgram("inputText", 0);
	var nWords = getWords(ngram);
	Shiny.onInputChange("cursorPos", nWords);
}
