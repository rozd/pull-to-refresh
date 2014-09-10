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
    function get insertDataFunction():Function;

    function get appendDataFunction():Function;

    function get prependDataFunction():Function;

    function load(resultHandler:Function, errorHandler:Function):void;

    function refresh(resultHandler:Function, errorHandler:Function):void;

    function proceed(resultHandler:Function, errorHandler:Function):void;
}
}
