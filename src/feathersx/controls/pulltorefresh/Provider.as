/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 10:26 AM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
/**
 * Provider interface allows delegate responsibility of loading items directly
 * to PullToRefresh' data provider.
 */
public interface Provider
{
    /**
     * Returns function that overrides default function for insert initial items.
     */
    function get insertDataFunction():Function;

    /**
     * Returns function that overrides default function for append new items.
     */
    function get appendDataFunction():Function;

    /**
     * Returns function that overrides default function for prepend earlier items.
     */
    function get prependDataFunction():Function;

    /**
     * Loads initial items
     */
    function load(resultHandler:Function, errorHandler:Function):void;

    /**
     * Loads new items
     */
    function refresh(resultHandler:Function, errorHandler:Function):void;

    /**
     * Loads old items
     */
    function proceed(resultHandler:Function, errorHandler:Function):void;
}
}
