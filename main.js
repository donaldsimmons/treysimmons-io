function setupSmoothScrolling() {
   $('a[href*="#"]:not([href="#"]):not([href$="modal"])').click(function() {
     var target = $(this.hash);
     if (target.length) {
       $("html, body").animate(
         {scrollTop: target.offset().top},
         800
       );
     }
   });
}

function setYearsCounter(startDate) {
  var today = new Date();
  var yearsDiff = (Math.floor((today-startDate)/31556952000));
  $('.years-counter').text(yearsDiff);
}

$(function() {
  setupSmoothScrolling();
  setYearsCounter(new Date('2013','09','15'));
});
