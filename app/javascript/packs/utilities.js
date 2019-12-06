import 'dropzone'
import green from 'green-audio-player'
import 'green-audio-player/src/scss/main'


$(document).on('turbolinks:load', function() {
    $(".jsDropzone").dropzone({
        url: "/resources/upload",
        paramName: 'resource[container]',
        maxFilesize: 10,
        addRemoveLinks: true,
        method: 'post',
        addedfile: function(file) {
            $('.text-noti').css({display:"none"});
            $('.upload-progress').css({display:"block"});
        },
        thumbnail: function(file, dataUrl) {
            
        },
        uploadprogress: function(file, progress, bytesSent) {
            $('.upload-progress').css({width: progress+"%"})
        },
        success: function(file, response){
            $('.upload-progress').css({display:"none"});
            $('.text-noti').css({display:"block"});
            if(response && response.success == true){
                switch(response.type){
                    case "image":
                        $('.resources-image').prepend('\
                            <div class=\"card jsResourceCard new resource-'+ response.id +'\">\
                                <div class=\"card-top\">\
                                    <div class=\"user-image-thumb\" style=\"background: url(\''+response.container.standard.url+'\');\" data-type=\"'+response.type+'\">\
                                        <div class=\"d-flex flex-row resource--top__menu justify-content-end\">\
                                            <a class=\"delete jsResourceDelete rnew\" data-id=\"'+response.id+'\" title=\"削除\"><i class=\"ti-close\"></i></a>\
                                            <a class=\"insert jsResourceImageInsert rnew\" title=\"挿入\" data-raw=\"'+response.container.url+'\" data-type=\"'+response.type+'\"><i class=\"ti-anchor\"></i></a>\
                                        </div>\
                                    </div>\
                                </div>\
                            </div>'
                        )
                        $('.nav-tabs a#picture-tab').tab('show')
                        initDeleteResource('.jsResourceDelete.rnew')
                        setInterval(function(){
                            $('.jsResourceCard').removeClass('new')
                        }, 1000)
                        initInserResource('.jsResourceImageInsert.rnew')
                        break;
                    case "music":
                        $('.resource-music').prepend('\
                            <li class="d-flex flex-row audio-detail resource-'+ response.id +'">\
                            <a class="name"><i class="ti-music"></i>'+ response.file_name +'</a>\
                            <div class="ml-auto resource--top__menu">\
                                <a class="delete jsResourceDelete" data-id="'+ response.id +'" title="削除"><i class="ti-close"></i></a>\
                                <a class="insert jsResourceAudioChange rnew" title="挿入" data-res-id="'+ response.id +'"><i class="ti-anchor"></i></a>\
                            </div>\
                            </li>\
                        ')
                        initChangeAudioResource('.jsResourceAudioChange.rnew')
                        $('.nav-tabs a#music-tab').tab('show')
                        break;
                    default : break;
                }
            }
        }
    });
    initDeleteResource('.jsResourceDelete')
    initInserResource('.jsResourceImageInsert')
    initChangeAudioResource('.jsResourceAudioChange')
    var player = window.PLAYER;
    if(!player){
        var playerContainer = document.querySelector('.audio-player');
        if(playerContainer){
            player = new green(playerContainer)
            window.PLAYER = player;
        }
    }

    $.ajaxSetup({ cache: true });
    $.getScript('https://connect.facebook.net/en_US/sdk.js', function(){
      FB.init({
        appId: '716252648881594',
        xfbml: true,
        version: 'v3.0'
      });
    });
});

var initDeleteResource = function(select){
    $(select).each(function(obj){
        $(this).on('click', function(e){
            e.preventDefault()
            var id = $(this).data('id')
            $.ajax({
                method: 'DELETE',
                url: '/resources/'+id
            })
        });
    })
}

var initInserResource = function(select){
    $(select).each(function(obj){
        $(this).on('click', function(e){
            e.preventDefault()
            if(window.CANVAS){
                var canvas = window.CANVAS;
                var type = $(this).data('type');
                switch(type){
                    case "image": 
                    var imageUrl = $(this).data('raw');
                    fabric.Image.fromURL(imageUrl, function(img){
                        mapObjectAttribute(img);
                        img.cornerStyle = 'circle'
                        img.set('meta_tag', type)
                        img.scaleToHeight(canvas.height/2);
                        img.scaleToWidth(canvas.width/2);
                        canvas.add(img)
                    }, { crossOrigin: 'Anonymous' });
                }
            }
            $('#resourceModal').modal('hide')
        });
    })
}

var initChangeAudioResource = function(select){
    $(select).each(function(obj){
        $(this).on('click', function(e){
            e.preventDefault()
            var cardId = $('#resourceModal').data('card-id');
            var resId = $(this).data('res-id');
            if(cardId){
                $.ajax({
                    method: 'POST',
                    url: '/resources/insert',
                    data:{
                        card_id: cardId,
                        resource_id: resId
                    }
                });
            }
        });
    })
}

function mapObjectAttribute(object){
    object.toObject = (function(toObject) {
    return function() {
        return fabric.util.object.extend(toObject.call(this), {
            meta_tag: this.meta_tag
        });
    };
    })(object.toObject);
}