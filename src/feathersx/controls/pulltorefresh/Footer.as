/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 8/29/14
 * Time: 3:04 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
public interface Footer
{
    function get originalHeight():Number;

    function get state():String;
    function set state(value:String):void;
}
}
