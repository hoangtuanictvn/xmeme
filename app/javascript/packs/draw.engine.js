$(document).ready(function() {
    this.__canvases = [ ]
    var canvas = new fabric.Canvas('edit__content--place',{
        backgroundColor: 'rgb(255,255,255)'
    });
    canvas.add(new fabric.Circle({ radius: 30, fill: '#f55', top: 100, left: 100 }));

    canvas.selectionColor = 'rgba(0,255,0,0.3)';
    canvas.selectionBorderColor = 'red';
    canvas.selectionLineWidth = 5;
    this.__canvases.push(canvas);
    console.log(this.__canvases.length)
    var link = $('.jsActionSaveImage')
    var canvasModifiedCallback = function() {
        link.attr("href", canvas.toDataURL());
        link.attr("download","painting.png");
    };
    canvas.on('object:added', canvasModifiedCallback);
    canvas.on('object:removed', canvasModifiedCallback);
    canvas.on('object:modified', canvasModifiedCallback);
});
