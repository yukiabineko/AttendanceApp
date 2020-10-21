// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load',function(){
  document.querySelectorAll(".accordion").forEach(function(btn){
    $(btn).on("click", function() {
        $(this).next().slideToggle();
    });
  })   
});

