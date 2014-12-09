package tv.reachfrequency.stdlib {
  
  import com.adobe.serialization.json.*;

  public class JSON {

    public static function parse(string:String) : Object {
      return com.adobe.serialization.json.JSON.decode(string);
    }

    public static function stringify(object:Object) : String {
      return com.adobe.serialization.json.JSON.encode(object);
    }

  }

}