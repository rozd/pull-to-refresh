/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 8/29/14
 * Time: 12:34 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
public interface Header
{
    /**
     * Indicates current state.
     *
     * @see HeaderState
     */
    function get state():String;
    function set state(value:String):void;

    /**
     * The height of Header that should be reached to transition to
     * HeaderState.RELEASE state.
     */
    function get headerHeight():Number;
}
}
