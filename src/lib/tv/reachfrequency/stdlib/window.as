package tv.reachfrequency.stdlib {

  import flash.external.ExternalInterface;
  import flash.net.URLRequest;
  import flash.net.navigateToURL;
  import flash.system.Capabilities;
  import flash.utils.*;

  public class window {

    private static const JS_TEST_FN:String = 'Function("return true;")';
    private static var FOCUS_CHECK_INTERVAL:Number = 10; // ms
    private static var FOCUS_COUNT:Number = 10;

    public static function jsAvailable() : Boolean {
      var result:Boolean = false;
      try {
        result = ExternalInterface.available && ExternalInterface.call(JS_TEST_FN);
      } catch(error:Error) { /* do nothing. */ }
      return result;
    }


    public static function open(settings:Object, next:Function) : * {
      settings = settings || {};
      var version:String = Capabilities.version;
      var versionOS:String = version.slice(0, version.indexOf(" "));;
      var versionNum:Array = version.slice(version.indexOf(" ") + 1).split(",");
      var superVersion:Number = Number(versionNum[0]);
      var subVersion:Number = Number(versionNum[2]);
      var playerType:String = Capabilities.playerType;
      var userAgent:String = "";
      var openWithNavigate:Boolean = true;
      var url:String = settings.url || '#';
      var target:String = settings.target || '_blank';
      var req:URLRequest = new URLRequest(url);
      

      if (!ExternalInterface.available) {
        navigateToURL(req, target);
        return;
      }
      
      try {
        userAgent = String(ExternalInterface.call("window.navigator.userAgent.toString"));
      }
      catch (error:Error){ }; //TODO: log this
      
      openWithNavigate = true;
      if (versionOS == "WIN" && playerType == "PlugIn" && superVersion < 10 && subVersion < 124) {
        openWithNavigate = false;
      }
      else if (versionOS == "WIN" && playerType == "ActiveX") {
        openWithNavigate = false;
      }
      else if (userAgent.indexOf("Firefox") > -1 && superVersion < 10) {
        openWithNavigate = false;
      }
      
      
      if (openWithNavigate) {
        try {
          navigateToURL(req, target);
        }
        catch (e:Error){} //TODO: log this
      }
      else {
        try {
          ExternalInterface.call("window.open", url, "_blank");
        }
        catch (e:Error){ } //TODO: log this
      }

    }

  }
}