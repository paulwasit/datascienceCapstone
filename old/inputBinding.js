
/*
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
    $(el).trigger('change');
  },
	getRatePolicy: function() {
		return {
			policy: 'throttle',
			delay: 3000
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
*/