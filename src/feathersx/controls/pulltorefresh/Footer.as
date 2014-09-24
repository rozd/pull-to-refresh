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
    /**
     * The preferred height of a concrete Footer component.
     */
    function get footerHeight():Number;

    /**
     * Indicates current state.
     *
     * @see FooterState
     */
    function get state():String;
    function set state(value:String):void;
}
}
