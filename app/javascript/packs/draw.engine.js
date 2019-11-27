import { ftruncateSync } from "fs";

$(document).on('turbolinks:load', function() {
    if(!window.CANVAS){
        this.__canvases = [ ]
        var canvas = new fabric.Canvas('edit__content--place',{
            backgroundColor: 'rgb(255,255,255)'
        });
        canvas.selectionColor = 'rgba(0,255,0,0.3)';
        canvas.selectionBorderColor = 'red';
        canvas.selectionLineWidth = 5;
        window.CANVAS = canvas;
        var link = $('.jsActionSaveImage')
        var canvasModifiedCallback = function() {
            link.attr("href", canvas.toDataURL());
            link.attr("download","painting.png");
        };
        canvas.on('object:added', canvasModifiedCallback);
        canvas.on('object:removed', canvasModifiedCallback);
        canvas.on('object:modified', canvasModifiedCallback);
        canvas.on('object:selected', onObjectSelected);
    }
});

function onObjectSelected(obj) {
    window.ACTIVE_OBJECT = obj
    console.log(obj)
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
        url: "/add?add=image"
    });
}

function handleStickerObject(obj){
    $.ajax({
        type: "POST", 
        url: "/add?add=sticker"
    });
}

function handleTextObject(obj){
    $.ajax({
        type: "POST", 
        url: "/add?add=text"
    });
}
