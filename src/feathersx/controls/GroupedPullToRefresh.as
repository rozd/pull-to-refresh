/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 10:27 AM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls
{
import feathers.data.HierarchicalCollection;
import feathers.data.IHierarchicalCollection;
import feathers.data.ListCollection;

import feathersx.controls.pulltorefresh.GroupedPullToRefreshBase;
import feathersx.controls.pulltorefresh.Provider;
import feathersx.controls.pulltorefresh.event.ProviderEvent;

import starling.events.Event;
import starling.events.EventDispatcher;

public class GroupedPullToRefresh extends GroupedPullToRefreshBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function GroupedPullToRefresh()
    {
        super();

        loadImmediately = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    override public function set dataProvider(value: IHierarchicalCollection): void
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
