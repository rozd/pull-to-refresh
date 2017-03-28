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

    override public function set dataProvider(value:HierarchicalCollection):void
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
            loadFunction = Provider(_dataProvider).load;
            refreshFunction = Provider(_dataProvider).refresh;
            proceedFunction = Provider(_dataProvider).proceed;

            insertDataFunction = Provider(_dataProvider).insertDataFunction;
            appendDataFunction = Provider(_dataProvider).appendDataFunction;
            prependDataFunction = Provider(_dataProvider).prependDataFunction;
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
