// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function () {
 
  	
  	 $('#name').tokenInput('/deposits/names.json', { 
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
  	
  	
  	$('#state').tokenInput('/deposit_statuses/states.json', { 
  	crossDomain: false,
  	preventDuplicates: true,
  	prePopulate: $('#state').data('pre')
  	});
  	
  	//TODO Change to operating_status?
  	$('#status').tokenInput('/lookups/operating_statuses.json', { 
  	crossDomain: false,
  	preventDuplicates: true,
  	resultsLimit: 20,
  	prePopulate: $('#status').data('pre')
  	});
  	
  	$('#deposit_province_tokens').tokenInput('/provinces/deposits.json', { 
  	crossDomain: false,
  	preventDuplicates: true,
  	resultsLimit: 20,
  	deleteText: "",
  	prePopulate: $('#deposit_province_tokens').data('pre')
  	});
  	
  	$('#province_id').tokenInput('/provinces/deposits.json', { 
  	crossDomain: false,
  	preventDuplicates: true,
  	resultsLimit: 20,
  	tokenLimit: $('#province_id').data('tokenlimit'),
  	prePopulate: $('#province_id').data('pre')
  	});
  	
  	$('#company_id').tokenInput('/websites/companies.json', { 
  	crossDomain: false,
  	preventDuplicates: true,
  	resultsLimit: 20,
  	tokenLimit: 1,
  	prePopulate: $('#company_id').data('pre')
  	});
});