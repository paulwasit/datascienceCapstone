
$(document).on("keyup input", ".reactiveTextarea", function(evt) {
	
	var el = $(evt.target)[0];
	var offset = el.offsetHeight - el.clientHeight;
	$(el).css('height', 'auto').css('height', el.scrollHeight + offset);
  $(el).trigger("change"); // triggers update
	
});
