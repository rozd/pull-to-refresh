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

import starling.events.Event;

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

        if (_dataProvider)
        {
            loadFunction = null;
            refreshFunction = null;
            proceedFunction = null;
        }

        super.dataProvider = value;

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
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------

    override protected function dataProvider_resetHandler(event:Event):void
    {
        super.dataProvider_resetHandler(event);
    }
}
}
