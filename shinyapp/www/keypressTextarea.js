
$(document).on("keyup input", ".reactiveTextarea", function(evt) {
	
	var el = $(evt.target)[0];
	var offset = el.offsetHeight - el.clientHeight;
	
	$(el).css('height', 'auto').css('height', el.scrollHeight + offset);
	
	// Set the button's text to its current value plus 1
  //$(el).val($(el).val());
	
  // Raise an event to signal that the value changed
  $(el).trigger("change");
	
});

var keypressBinding = new Shiny.InputBinding();
$.extend(keypressBinding, {
  find: function(scope) {
    return $(scope).find(".reactiveTextarea");
  },
  getValue: function(el) {
    return $(el).val();
  },
  setValue: function(el, value) {
    $(el).val(value);
  },
	receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      this.setValue(el, data.value);

    //if (data.hasOwnProperty('label'))
    //  $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(data.label);

    $(el).trigger('change');
  },
	getRatePolicy: function() {
		return {
			policy: 'throttle',
			delay: 10
		};
	},
  subscribe: function(el, callback) {
    $(el).on("change.keypressBinding", function(e) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".keypressBinding");
  }
	//getType: function() {
	//	return "keypressBinding";
	//}
});

Shiny.inputBindings.register(keypressBinding,"keypressBinding");



/*
function h(e) {
  $(e).css({'height':'auto','overflow-y':'hidden'}).height(e.scrollHeight);
}
$('textarea').each(function () {
  h(this);
}).on('input', function () {
  h(this);
});
*/

/*
$('textarea').each(
	function () {
		console.log("hello");
		this.setAttribute('style', 'height:' + (this.scrollHeight) + 'px;overflow-y:hidden;');
	}
).on('input', function () {
	console.log("hello2");
  this.style.height = 'auto';
  this.style.height = (this.scrollHeight) + 'px';
});
*/

//$('textarea').each(function (idx) {
	
	//alert("clicked");
	/*
		var offset = this.offsetHeight - this.clientHeight;
 
    var resizeTextarea = function(el) {
        jQuery(el).css('height', 'auto').css('height', el.scrollHeight + offset);
    };
    jQuery(this).on('keyup input', function() { resizeTextarea(this); });
		jQuery(this).on('click', function() {
			alert("ok");
		};
	*/
	
//});
