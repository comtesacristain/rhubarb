// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function () {
  $('#vessel').tokenInput('/surveys/vessels.json', { 
  	crossDomain: false,
  	tokenLimit: 1,
  	resultsLimit: 20,
  	prePopulate: $('#vessel').data('pre'),
  	});
  	
  	 $('#name').tokenInput('/deposits/names.json', { 
  	crossDomain: false,
  	tokenLimit: 1,
  	resultsLimit: 20,
  	prePopulate: $('#name').data('pre'),
  //	minChars: 3
  	});
});