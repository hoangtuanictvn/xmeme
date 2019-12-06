$(document).on('turbolinks:load', function() {

    var cardEditor = $('.card--editor');
    // $("input.jsTextSlider").slider();
    var cardFormat = cardEditor.data('card-format');
    var cardId = cardEditor.data("card-id");
    var layoutData = cardEditor.data('lyt');

    if(!window.CANVAS && cardEditor){
        var canvas = new fabric.Canvas('edit__content--place');
        canvas.selectionColor = 'rgba(0,255,0,0.3)';
        canvas.backgroundColor = 'rgb(255,255,255)';
        canvas.selectionBorderColor = 'red';
        canvas.selectionLineWidth = 5;
        window.CANVAS = canvas;
    } else {
        canvas = window.CANVAS
    }
    
    if(cardFormat){
        canvas.loadFromJSON(JSON.parse(cardFormat), canvas.renderAll.bind(canvas), function(o, obj){
            obj.cornerStyle = 'circle'
            mapObjectAttribute(obj)
        });
    }

    var link = $('.jsActionSaveImage')

    // link.on('click', function(e){
    //     e.preventDefault()
    //     // $.ajax({
    //     //     type: 'POST',
    //     //     dataType: 'json',
    //     //     url: 'http://localhost:4000/render',
    //     //     data: {
    //     //         "ratio": layoutData.ratio,
    //     //         "height": layoutData.height,
    //     //         "width": layoutData.width,
    //     //         "format": JSON.parse(cardFormat)
    //     //     }
    //     // })
    // })
    
    var canvasModifiedCallback = function(payload) {
        link.attr("href", canvas.toDataURL());
        link.attr("download","painting.png");
        if(cardId){
            $.ajax({
                type: "PATCH", 
                url: "/cards/"+cardId,
                data:{
                    "format": JSON.stringify(canvas.toJSON(['meta_tag'])),
                    "thumb": canvas.toDataURL()
                }
            });
        }
    };

    var objectRemovedCallback = function(payload){
        canvasModifiedCallback(payload)
        hidenEditControl()
    }

    var hidenEditControl = function(payload){
        var changeAction = $('.jsObjectDropAction')
        changeAction.removeClass('show')
        changeAction.unbind('click');
    }

    $('.jsFacebookShare').on('click', function(e){
        e.preventDefault()
        sharefbimage()
    });

    canvas.on('object:added', canvasModifiedCallback);
    canvas.on('object:removed', objectRemovedCallback);
    canvas.on('object:modified', canvasModifiedCallback);
    canvas.on('object:selected', onObjectSelected);
    canvas.on('selection:updated', onObjectSelected);
    canvas.on('background:change', canvasModifiedCallback);
    canvas.on('selection:cleared', hidenEditControl);
    window.updateCardLayoutTrigger()
});

function sharefbimage() {
    FB.ui(
        {
            method: 'feed',
            name: 'Facebook Dialogs',
            href: $('.jsActionSaveImage').attr('href'),
            link: 'https://xmeme.herokuapp.com',
            picture: $('.jsActionSaveImage').attr('href'),
            caption: 'Ishelf Book',
            description: 'your description'
        },
        function (response) {
            if (response && response.post_id) {
                
            } else {
                
            }
        }
    );
}

window.updateCardLayoutTrigger = function(){
    var cardEditor = $('.card--editor');
    var cardId = cardEditor.data("card-id");
    $('.jsChangeLayout').each(function(e){
        $(this).on('click', function(ev){
            ev.preventDefault()
            if(cardId){
                $.ajax({
                    type: "POST", 
                    url: "/layout/change?card_id="+cardId+"&layout_id="+$(this).data('layout-id'),
                });
            }
        })
    })
}

function onObjectSelected(obj) {
    switch(obj.target.get('meta_tag')){
        case "image": handleImageObject(obj); break;
        case "sticker": handleStickerObject(obj); break;
        case "text": handleTextObject(obj); break;
        default: break;
    }
}

function handleImageObject(obj){
    $.ajax({
        type: "POST", 
        url: "/add?add=image&modify=true"
    });
}

function handleStickerObject(obj){
    $.ajax({
        type: "POST", 
        url: "/add?add=sticker&modify=true"
    });
}

function handleTextObject(obj){
    $.ajax({
        type: "POST",
        url: "/add?add=text&modify=true"
    });
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