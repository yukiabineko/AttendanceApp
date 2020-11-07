// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load', function(){
 
  var yearSelect = document.getElementById('yearSelect');
  var yearText = document.getElementById('yearText');

  var monthSelect = document.getElementById('monthSelect');
  var monthText = document.getElementById('monthText');
 
  var form = document.getElementById('myform');

 /*年セレクト*/
  yearSelect.addEventListener('change',()=>{
    yearText.value = yearSelect.value;
    yearSelect.options[0].selected = true;
    
  });

  /*月セレクト*/
  
  monthSelect.addEventListener('change',()=>{
    monthText.value = monthSelect.value;
    monthSelect.options[0].selected = true;
    var url = location.pathname ;
    Rails.fire(form, 'submit');
    
  });

});