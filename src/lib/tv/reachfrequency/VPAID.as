package tv.reachfrequency {

  import flash.display.MovieClip;
  import flash.display.Loader;
  import flash.net.URLRequest;
  import flash.events.Event;
  import flash.system.LoaderContext;

  import tv.reachfrequency.stdlib.*;

  import net.iab.IVPAID;
  import net.iab.VPAIDEvent;

  public class VPAID extends MovieClip {
    
    function VPAID() {
      addEventListener(Event.ADDED_TO_STAGE, init);
    };

    private function init(event:Event) : void {
      var parameters:Object = root.loaderInfo.parameters;
      var loader:Loader = new Loader();
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleAdLoaded);
      loader.load(new URLRequest(parameters.url), new LoaderContext());
    }

    private function handleAdLoaded(event:Event) : void {
      var ad:* = event.target.content;
      var options:Array = [
        stage.stageWidth, // width:Number
        stage.stageHeight, // height:Number
        'normal', // viewMode:String
        300, // desiredBitrate:Number
        null, // creativeData:String
        null // environmentVars:String
      ];
      ad.initAd.apply(ad, options);
      ad.addEventListener(VPAIDEvent.AdError, console.error);
      ad.addEventListener(VPAIDEvent.AdLoaded, function(event:*) : void {
        ad.startAd();
        addChild(ad);
      });
    }

  }

}
