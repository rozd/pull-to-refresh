/**
 * Created by Max Rozdobudko on 4/24/15.
 */
package pulltorefresh.examples
{
import com.codecatalyst.promise.Promise;

import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.themes.MetalWorksMobileTheme;

import feathersx.data.ListCollectionAsync;

public class PagedListScreen extends PanelScreen
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    public function PagedListScreen()
    {
        super();

        headerProperties.title = "Example";

        collection = new ListCollectionAsync();
        collection.loadLengthFunction = getLength;
        collection.loadItemsFunction = getItems;
        collection.pageSize = 10;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var pagedList:List;

    private var collection:ListCollectionAsync;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize():void
    {
        super.initialize();

        this.width = this.stage.stageWidth;
        this.height = this.stage.stageHeight;

        new MetalWorksMobileTheme();

        this.layout = new AnchorLayout();

        pagedList = new List();
        pagedList.layoutData = new AnchorLayoutData(0, 0, 0, 0);
        pagedList.dataProvider = collection;
        addChild(pagedList);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function getLength(resultHandler:Function, errorHandler:Function):void
    {
        var result:Function = function(value:Object):*
        {
            resultHandler(value.length, value.items);

            return value;
        };

        Promise.when({length : 100}).then(result).otherwise(errorHandler);
//        Promise.when({length : 100, items : [{"label" : "A"}, {"label" : "B"}, {"label" : "C"}, {"label" : "D"}, {"label" : "E"}]}).then(result).otherwise(errorHandler);
    }

    private function getItems(index:int, count:int, resultHandler:Function, errorHandler:Function):void
    {
        var result:Function = function(value:Object):*
        {
            resultHandler(index, value);
        };

        var error:Function = function(reason:Object):*
        {
            errorHandler(index, count, reason);
        };

        var items:Array = [];

        for (var i:int = 0; i < count; i++)
            items[i] = {"label" : "Load item " + (index + i)};

        Promise.when(items).then(result).otherwise(error);
    }
}
}
