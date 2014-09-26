/**
 * Created by mobitile on 9/26/14.
 */
package pulltorefresh.examples
{
import com.codecatalyst.promise.Promise;

import feathers.controls.PanelScreen;
import feathers.data.ListCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.themes.MetalWorksMobileTheme;

import feathersx.controls.PullToRefresh;

public class Main extends PanelScreen
{
    public function Main()
    {
        super();

        headerProperties.title = "Example";
    }

    private var pullToRefresh:PullToRefresh;

    override protected function initialize():void
    {
        super.initialize();

        this.width = this.stage.stageWidth;
        this.height = this.stage.stageHeight;

        new MetalWorksMobileTheme();

        this.layout = new AnchorLayout();

        pullToRefresh = new PullToRefresh();
        pullToRefresh.loadImmediately = true;
        pullToRefresh.layoutData = new AnchorLayoutData(0, 0, 0, 0);
        pullToRefresh.dataProvider = new ListCollection();
        pullToRefresh.loadFunction = this.load;
        pullToRefresh.refreshFunction = this.refresh;
        pullToRefresh.proceedFunction = this.proceed;
        addChild(pullToRefresh);
    }

    /** Simulates loading initial data. */
    private function load(resultHandler:Function, errorHandler:Function):void
    {
        // we need this wrapper due to resultHandler here takes two params
        var result:Function = function(value:Array):*
        {
            resultHandler(value, true); // true indicates that there are more data to proceed

            return value;
        }

        Promise.delay([{label : "L"}, {label : "K"}, {label : "M"}, {label : "N"}, {label : "O"}, {label : "P"}, {label : "Q"}, {label : "R"}, {label : "S"}, {label : "T"}, {label : "U"}], 1000).then(result).otherwise(errorHandler);
    }

    /** Simulates loading new data. */
    private function refresh(resultHandler:Function, errorHandler:Function):void
    {
        Promise.delay([{label : "A"}, {label : "B"}, {label : "C"}], 1000).then(resultHandler).otherwise(errorHandler);
    }

    /** Simulates loading previous data. */
    private function proceed(resultHandler:Function, errorHandler:Function):void
    {
        // we need this wrapper due to resultHandler here takes two params
        var result:Function = function(value:Array):*
        {
            resultHandler(value, true); // true indicates that there are more data to proceed

            return value;
        }

        Promise.delay([{label : "X"}, {label : "Y"}, {label : "Z"}], 1000).then(result).otherwise(errorHandler);
    }
}
}
