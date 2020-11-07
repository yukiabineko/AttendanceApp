// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load', function(){
  var yearSelect = document.getElementById('yearSelect');
  var yearText = document.getElementById('yearText');

  var monthSelect = document.getElementById('monthSelect');
  var monthText = document.getElementById('monthText');
  monthSelect.style.display = 'none';
  monthText.style.display = 'none';
  var form = document.getElementById('myform');

 /*年セレクト*/
  yearSelect.addEventListener('change',()=>{
    yearText.value = yearSelect.value;
    yearSelect.options[0].selected = true;
    monthSelect.style.display = 'block';
    monthText.style.display = 'block';
  });

  /*月セレクト*/
  
  function selectData(id){
    monthText.value = monthSelect.value;
    monthSelect.options[0].selected = true;
    alert(id);
  }

});