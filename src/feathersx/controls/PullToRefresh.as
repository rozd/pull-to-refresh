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

import feathersx.controls.pulltorefresh.Provider;

import feathersx.controls.pulltorefresh.PullToRefreshBase;
import feathersx.controls.pulltorefresh.event.ProviderEvent;

import starling.events.Event;
import starling.events.EventDispatcher;

public class PullToRefresh extends PullToRefreshBase
{
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

    override public function set dataProvider(value:ListCollection):void
    {
        if (_dataProvider == value) return;

        if (_dataProvider is EventDispatcher)
        {
            EventDispatcher(_dataProvider).removeEventListener(ProviderEvent.RELOAD, dataProvider_reloadHandler);
        }

        if (_dataProvider is Provider)
        {
            loadFunction = null;
            refreshFunction = null;
            proceedFunction = null;
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
        }

        load();
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function dataProvider_reloadHandler(event:Event):void
    {
        load();
    }
}
}
