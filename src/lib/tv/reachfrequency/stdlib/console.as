package tv.reachfrequency.stdlib {

  import flash.external.ExternalInterface;

  public class console {

    public static function log(... args) : void {
      if (window.jsAvailable())
        ExternalInterface.call("console.log", args.join(' '));
      trace(args);
    }

  };
};