$(document).on('turbolinks:load', function() {

    var cardEditor = $('.card--editor');
    // $("input.jsTextSlider").slider();
    var cardFormat = cardEditor.data('card-format');
    var cardId = cardEditor.data("card-id");

    if(!window.CANVAS && cardEditor){
        var canvas = new fabric.Canvas('edit__content--place',{});
        canvas.selectionColor = 'rgba(0,255,0,0.3)';
        canvas.backgroundColor = 'rgb(255,255,255)';
        canvas.selectionBorderColor = 'red';
        canvas.selectionLineWidth = 5;
        window.CANVAS = canvas;
    }else{
        canvas = window.CANVAS
    }
    
    if(cardFormat){
        canvas.loadFromJSON(JSON.parse(cardFormat), canvas.renderAll.bind(canvas), function(o, obj){
            obj.cornerStyle = 'circle'
            mapObjectAttribute(obj)
        });
    }

    var link = $('.jsActionSaveImage')
    
    var canvasModifiedCallback = function(payload) {
        link.attr("href", canvas.toDataURL());
        link.attr("download",link.data('cid')+Date.now());
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
        var source = $(this).data('resource');
        var story = $(this).data('story');
        FB.ui(
            {
                method: 'send',
                name: 'Xmeme Facebook share',
                href: source,
                link: story,
                picture: source,
                caption: 'Type your meme',
                description: 'Xmeme | Merry Chirstmas'
            },
            function (response) {
                if (response && response.post_id) {
                    
                } else {
                    
                }
            }
        );
    });

    $('.jsTweet').on('click', function(e) {
        e.preventDefault();
        var story = $(this).data('story');
        var twitterWindow = window.open('https://twitter.com/share?url=' + story, 'twitter-popup', 'height=350,width=600');
        if(twitterWindow.focus) { twitterWindow.focus(); }
    })

    canvas.on('object:added', canvasModifiedCallback);
    canvas.on('object:removed', objectRemovedCallback);
    canvas.on('object:modified', canvasModifiedCallback);
    canvas.on('object:selected', onObjectSelected);
    canvas.on('selection:updated', onObjectSelected);
    canvas.on('background:change', canvasModifiedCallback);
    canvas.on('selection:cleared', hidenEditControl);
    window.updateCardLayoutTrigger()
});

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