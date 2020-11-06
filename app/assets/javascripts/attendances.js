// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load', function(){
  var yearSelect = document.getElementById('yearSelect');
  var yearText = document.getElementById('yearText');

  var monthSelect = document.getElementById('monthSelect');
  var monthText = document.getElementById('monthText');
  monthSelect.style.display = 'none';
  monthText.style.display = 'none';
  monthText.style.display = 'none';

  yearSelect.addEventListener('change',()=>{
    yearText.value = yearSelect.value;
    yearSelect.value="年"
    monthSelect.style.display = 'block';
    monthText.style.display = 'block';
  });
});