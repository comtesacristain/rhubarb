// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function () {
 
  	
  	 $('#name').tokenInput('/occurrences/names.json', { 
  	crossDomain: false,
  	tokenLimit: 1,
  	resultsLimit: 20,
  	prePopulate: $('#name').data('pre')
  	});
  	
  	$('#commodity').tokenInput('/commodity_types.json', { 
  	crossDomain: false,
  	preventDuplicates: true,
  	resultsLimit: 20,
  	prePopulate: $('#commodity').data('pre')
  	});
  	
  	//TODO Change the token input to separate it from deposit_statuses 
  	$('#state').tokenInput('/deposit_statuses/states.json', { 
  	crossDomain: false,
  	preventDuplicates: true,
  	prePopulate: $('#state').data('pre')
  	});
  	
});