var AudioPlayer = {
    $control: null,
    $player: null,
    init: function(selector){
        if ($(selector).length > 0) {
            this.$player = $(selector).get(0)
            this.initControl('.jsActionPlay')
            AudioPlayer.$player.load()
            AudioPlayer.$control.removeClass('pause')
            AudioPlayer.$control.html('<i class="ti-control-pause"></i>')
        }
    },
    play: function(){
        console.log(this.$player)
        this.$player.trigger('play')
    },
    pause: function(){
        this.$player.trigger('pause')
    },
    updateProgress: function(callback) {
        if (AudioPlayer.$player) {
            AudioPlayer.$player.addEventListener("timeupdate", function(e) {
                var currentTime = AudioPlayer.$player.currentTime
                var duration = AudioPlayer.$player.duration
                var progress = ((currentTime)/duration)*100
                callback(progress.toFixed(1))
            });
        }
    },
    initControl: function(selector){
        this.$control = $(selector)
        this.$control.on('click', function(ev){
            ev.preventDefault()
            if(AudioPlayer.$control.hasClass('pause')){
                AudioPlayer.$player.play()
                AudioPlayer.$control.removeClass('pause')
                AudioPlayer.$control.html('<i class="ti-control-pause"></i>')
            }else{
                AudioPlayer.$player.pause()
                AudioPlayer.$control.addClass('pause')
                AudioPlayer.$control.html('<i class="ti-control-play"></i>')
            }
        });
    }
}

$(document).on('turbolinks:load', function() {
    AudioPlayer.init('.story-player')
    AudioPlayer.updateProgress(function(progress){
        $('.story-progress .progress-bar').css('width', progress+'%').attr('aria-valuenow', progress)
    })
});