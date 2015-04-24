/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
jQuery.ajaxSetup({
    'beforeSend': function (xhr) {xhr.setRequestHeader('Accept', 'text/javascript')}
});  

$(function () {
  $('.pagination a').live("click", function () {
    $('.pagination').html('Page is loading...');
    $.get(this.href, null, null, 'script');
    return false;
  });
});  

