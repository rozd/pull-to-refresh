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
    function get insertInitialItemsFunction():Function;

    /**
     * Returns function that overrides default function for append new items.
     */
    function get insertRecentItemsFunction():Function;

    /**
     * Returns function that overrides default function for prepend earlier items.
     */
    function get insertEarlierItemsFunction():Function;

    /**
     * Indicates if Provider has function to load recent items.
     */
    function get supportsRecents():Boolean;

    /**
     * Indicates if Provider has function to load previous items.
     */
    function get supportsEarlier():Boolean;

    /**
     * Loads initial items
     */
    function initial(resultHandler:Function, errorHandler:Function):void;

    /**
     * Loads new items
     */
    function recents(resultHandler:Function, errorHandler:Function):void;

    /**
     * Loads old items
     */
    function earlier(resultHandler:Function, errorHandler:Function):void;
}
}
