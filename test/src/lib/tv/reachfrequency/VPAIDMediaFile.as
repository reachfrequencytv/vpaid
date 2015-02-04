package tv.reachfrequency {

  import flash.display.*;
  import flash.display.*;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.events.NetStatusEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.*;
  import flash.media.*;
  import flash.utils.*;
  import flash.system.*;

  import tv.reachfrequency.stdlib.*;

  import net.iab.IVPAID;
  import net.iab.VPAIDEvent;

  public class VPAIDMediaFile extends MovieClip implements IVPAID {

    private static const HANDSHAKE_VERSION:String = '2.0';

    private var ad:Object = {};

    public function get adLinear() : Boolean { return ad.linear };
    public function get adWidth() : Number { return ad.width };
    public function get adHeight() : Number { return ad.height };
    public function get adExpanded() : Boolean { return ad.expanded };
    public function get adSkippableState() : Boolean { return ad.skippableState };
    public function get adRemainingTime() : Number { return ad.remainingTime };
    public function get adDuration() : Number { return ad.duration };
    public function get adVolume() : Number { return ad.volume };
    public function set adVolume(value:Number)  : void { ad.volume = value };
    public function get adCompanions() : String { return ad.companions };
    public function get adIcons() : Boolean { return ad.icons };
    public function handshakeVersion(playerVPAIDVersion:String) : String {
      return HANDSHAKE_VERSION;
    }

    public function initAd(width:Number, height:Number, viewMode:String, 
                    desiredBitrate:Number, creativeData:String='', 
                    environmentVars:String='') : void {
      ad.width = width;
      ad.height = height;
      ad.viewMode = viewMode;
      ad.desiredBitrate = desiredBitrate;
      ad.creativeData = creativeData;
      ad.environmentVars = environmentVars;
      handleInit();
    }

    public function resizeAd(width:Number,
                             height:Number,
                             viewMode:String) : void {
      ad.width = width;
      ad.height = height;
      ad.viewMode = viewMode;
    }

    public function startAd() : void {

    }

    public function stopAd() : void {

    }

    public function pauseAd() : void {

    }

    public function resumeAd() : void {

    }

    public function expandAd() : void {

    }

    public function collapseAd() : void {

    }

    public function skipAd() : void {

    }

    private function handleInit() : void {
      var connection:NetConnection = new NetConnection();
      connection.client = this;
      connection.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
      connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, destroyStream);
      connection.connect(null);
    }

    private function handleNetStatus(event:NetStatusEvent) : void {
      console.log('VideoPlayer#handleNetStatus', event.info.code);
      switch(event.info.code) {
        case "NetConnection.Connect.Success":
          connectStream(event);
          break;
        case "NetStatus.Seek.Notify":
          dispatchEvent(new Event('video:seeked'));
          break;
        case "NetStream.Play.Stop":
          dispatchEvent(new Event('video:ended'));
          break;
        case "NetConnection.Connect.Rejected":
        case "NetConnection.Connect.Failed":
        case "NetStream.Play.StreamNotFound":
        case "NetStream.Play.Failed":
         destroyStream(event);
      }
    }

    private function connectStream(event:NetStatusEvent) : void {
      event.target.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
      event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, destroyStream);
      
      var netStream:NetStream = new NetStream(event.target as NetConnection);
      var video:Video = new Video();
      video.attachNetStream(netStream);
      video.width = ad.width;
      video.height = ad.height;
      video.x = 0;
      video.y = 0;
      addChild(video);

      addEventListener('video:loaded', function(event:Event) : void {
        dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLoaded));
      });

      netStream.client = { onMetaData: function(data:Object) : void {
          ad.metadata = data;
          dispatchEvent(new Event('video:metadata'));
          dispatchEvent(new Event('video:loaded'));
        } 
      };
      netStream.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
      var videoUrl:String = root.loaderInfo.parameters.videoUrl;
      if (videoUrl)
        netStream.play(videoUrl);
      else
        console.log('No `videoUrl` supplied.');
    }


    private function destroyStream(event:NetStatusEvent) : void {
      event.target.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
      event.target.close();
      dispatchEvent(new Event('video:error'));
    }

  }
}
