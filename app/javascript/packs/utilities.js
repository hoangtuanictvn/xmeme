import 'dropzone'
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
                                            <a class=\"insert jsResourceImageInsert\" title=\"挿入\" data-raw=\"'+response.container.url+'\" data-type=\"'+resource.type+'\"><i class=\"ti-anchor\"></i></a>\
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
                        break;
                    case "music":
                        $('.nav-tabs a#music-tab').tab('show')
                        initInserResource('.jsResourceImageInsert.rnew')
                        break;
                    default : break;
                }
            }
        }
    });
    initDeleteResource('.jsResourceDelete')
    initInserResource('.jsResourceImageInsert')
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
                    });
                }
            }
            $('#resourceModal').modal('hide')
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