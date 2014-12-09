package tv.reachfrequency.stdlib {

  public class path {

    public static function basename(string:String) : String {
      return string.split('/').reverse()[0];
    }

    public static function extname(string:String) : String {
      return string.split('.').pop() || '';
    }

    public static function isHttp(string:String) : Boolean {
      return /^http/.test(string);
    }

  }

}