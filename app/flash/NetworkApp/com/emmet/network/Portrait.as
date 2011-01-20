package com.emmet.network {
  import com.emmet.model.Person;
  import flash.events.Event;
  import flash.display.Loader;
  import flash.net.URLRequest;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Sprite;

  public class Portrait extends Sprite implements Highlightable {

    private const IMAGE_WIDTH:Number = 75;
    private const IMAGE_HEIGHT:Number = 75;
    private const BORDER_WIDTH:Number = IMAGE_WIDTH + 8;
    private const BORDER_HEIGHT:Number = IMAGE_HEIGHT + 8;

    public const BORDER_COLOR:Number = 0x333333;
    public const BORDER_HIGHLIGHT_COLOR:Number = 0x0099CC;
    public const BORDER_EXTRA_HIGHLIGHT_COLOR:Number = World.EXTRA_HIGHLIGHT_COLOR;

    private var _person:Person;
    private var _imageLoader:Loader;
    private var _image:Bitmap;

    public function Portrait(person:Person) {
      _person = person;
      _imageLoader = new Loader();
      _imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteImageLoad);
      _imageLoader.load(new URLRequest(person.primaryPhotoUrl));
      draw();
    }

    private function draw(color:Number = BORDER_COLOR):void {
      graphics.beginFill(color);
      graphics.drawRoundRect(-BORDER_WIDTH / 2, -BORDER_HEIGHT / 2, BORDER_WIDTH, BORDER_HEIGHT, 8, 8);
    }

    private function onCompleteImageLoad(event:Event):void {
      _image = Bitmap(_imageLoader.content);
      _image.x = -(_image.width / 2);
      _image.y = -(_image.height / 2);
      addChild(_image);
    }

    public function highlight():void {
      graphics.clear();
      draw(BORDER_HIGHLIGHT_COLOR);
    }

    public function extraHighlight():void {
      graphics.clear();
      draw(BORDER_EXTRA_HIGHLIGHT_COLOR);
    }

    public function unhighlight():void {
      graphics.clear();
      draw();
    }
  }
}