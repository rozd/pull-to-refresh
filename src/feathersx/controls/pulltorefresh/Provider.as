/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 10:26 AM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
public interface Provider
{
    function load(result:Function, error:Function):void;

    function refresh(result:Function, error:Function):void;

    function proceed(result:Function, error:Function):void;
}
}
