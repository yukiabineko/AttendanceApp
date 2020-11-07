// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load', function(){
 
  var yearSelect = document.getElementById('yearSelect');
  var yearText = document.getElementById('yearText');

  var monthSelect = document.getElementById('monthSelect');
  var monthText = document.getElementById('monthText');
 
  var form = document.getElementById('myform');
  var button = document.getElementById('resetLog');
  var tbody = document.getElementById('tbody');

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

  button.addEventListener('click', ()=>{
    $("#tbody").empty();
    var tr = document.createElement('tr');
    var td = document.createElement('td');
    td.textContent = 'データがありません。';
    td.colSpan = "7";
    td.classList.add('text-center');
    tr.appendChild(td);
    tbody.appendChild(tr);
  });

});