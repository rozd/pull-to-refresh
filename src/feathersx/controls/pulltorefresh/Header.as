/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 8/29/14
 * Time: 12:34 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
import flash.geom.Rectangle;

public interface Header
{
    function get state():String;
    function set state(value:String):void;

    function get refreshHeight():Number;
}
}
