// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load', function(){
   var div = document.getElementById('drop');
   div.style.display = 'none';
   $("#shopBtn").on("click", function() {
     $("#drop").slideToggle();
   });
});