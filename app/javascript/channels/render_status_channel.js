import consumer from "./consumer"

consumer.subscriptions.create("RenderStatusChannel", {
  connected() {
    console.log('connected')
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log('terminate')
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    var progress = JSON.parse(data)
    var circleProgressContainer = $('.jsSaveProgress-'+progress.id)
    if(progress.status == "inprogress"){
      var progContainer = $('.progress-'+progress.id);
      if(!progContainer.hasClass('inprogress')){
        $('.progress-'+progress.id).removeClass('hidden')
        $('.progress-'+progress.id).addClass('inprogress')
      }
      if(!circleProgressContainer.hasClass('inprogress')){
        circleProgressContainer.removeClass('hidden')
        circleProgressContainer.addClass('inprogress')
      }
      var jsProgressText = $('.jsProgressText-'+progress.id)
      jsProgressText.html('<small>'+parseFloat((progress.progress).toFixed(1))+'%<\/small>')
    }
    $('.progress-'+progress.id + ' .progress-bar').css('width', progress.progress+'%').attr('aria-valuenow', progress.progress)
    updateCircleProgress(progress.progress, progress.id)
    if(progress.status == "success"){
      jsProgressText.html('<i class=\"ti-download\"><\/i>')
      $(".progress--circle-"+progress.id).attr('href', progress.url)
      var prog = $('.progress-'+progress.id);
      prog.removeClass('inprogress')
      circleProgressContainer.removeClass('inprogress')
      setInterval(function(){
        if(!prog.hasClass('inprogress')){
          prog.addClass('hidden')
        }
      }, 3000);
    }
  }
});

var updateCircleProgress = function(value, card_id) {
  console.log(card_id)
  $(".progress--circle-"+card_id).each(function() {
    var left = $(this).find('.progress-left .progress-bar');
    var right = $(this).find('.progress-right .progress-bar');
    if (value > 0) {
      if (value <= 50) {
        right.css('transform', 'rotate(' + percentageToDegrees(value) + 'deg)')
      } else {
        right.css('transform', 'rotate(180deg)')
        left.css('transform', 'rotate(' + percentageToDegrees(value - 50) + 'deg)')
      }
    }
  })
  function percentageToDegrees(percentage) {
    return percentage / 100 * 360
  }
}
