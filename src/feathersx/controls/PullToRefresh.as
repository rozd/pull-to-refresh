/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 10:27 AM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls
{
import feathers.data.ListCollection;
import feathers.skins.IStyleProvider;

import feathersx.controls.pulltorefresh.Provider;

import feathersx.controls.pulltorefresh.PullToRefreshBase;
import feathersx.controls.pulltorefresh.event.ProviderEvent;

import starling.events.Event;
import starling.events.EventDispatcher;

public class PullToRefresh extends PullToRefreshBase
{
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     * The default <code>IStyleProvider</code> for all <code>ToggleButton</code>
     * components. If <code>null</code>, falls back to using
     * <code>Button.globalStyleProvider</code> instead.
     *
     * @default null
     * @see feathers.core.FeathersControl#styleProvider
     * @see feathers.controls.Button#globalStyleProvider
     */
    public static var globalStyleProvider:IStyleProvider;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function PullToRefresh()
    {
        super();

        loadImmediately = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function get defaultStyleProvider():IStyleProvider
    {
        if (PullToRefresh.globalStyleProvider != null)
        {
            return PullToRefresh.globalStyleProvider;
        }

        return super.defaultStyleProvider;
    }

    override public function set dataProvider(value:ListCollection):void
    {
        if (_dataProvider == value) return;

        if (_dataProvider is EventDispatcher)
        {
            EventDispatcher(_dataProvider).removeEventListener(ProviderEvent.RELOAD, dataProvider_reloadHandler);
        }

        if (_dataProvider is Provider)
        {
            loadFunction = refreshFunction = proceedFunction = null;

            insertDataFunction = appendDataFunction = prependDataFunction = null;
        }

        super.dataProvider = value;

        if (_dataProvider is EventDispatcher)
        {
            EventDispatcher(_dataProvider).addEventListener(ProviderEvent.RELOAD, dataProvider_reloadHandler);
        }

        if (_dataProvider is Provider)
        {
            var provider:Provider = _dataProvider as Provider;

            loadFunction = provider.initial;

            if (provider.supportsRecents)
            {
                refreshFunction = Provider(_dataProvider).recents;
            }

            if (provider.supportsEarlier)
            {
                proceedFunction = Provider(_dataProvider).earlier;
            }

            insertDataFunction = Provider(_dataProvider).insertInitialItemsFunction;
            appendDataFunction = Provider(_dataProvider).insertRecentItemsFunction;
            prependDataFunction = Provider(_dataProvider).insertEarlierItemsFunction;
        }

        invalidate(INVALIDATION_FLAG_ITEMS);
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    protected function dataProvider_reloadHandler(event:Event):void
    {
        invalidate(INVALIDATION_FLAG_ITEMS);
    }
}
}
