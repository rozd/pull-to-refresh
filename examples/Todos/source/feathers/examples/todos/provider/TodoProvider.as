/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 10:53 AM
 * To change this template use File | Settings | File Templates.
 */
package feathers.examples.todos.provider
{
import com.codecatalyst.promise.Promise;

import feathers.data.ListCollection;
import feathers.examples.todos.TodoItem;

import feathersx.controls.pulltorefresh.Provider;
import feathersx.controls.pulltorefresh.event.ProviderEvent;

public class TodoProvider extends ListCollection implements Provider
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function TodoProvider()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    public var numItemsInResponse:int = 10;

    public var hasOldRecords:Boolean = true;

    public var hasNewRecords:Boolean = true;

    private var oldItemIndex:int;

    private var newItemIndex:int;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public function get insertDataFunction():Function {return null;}

    public function get appendDataFunction():Function {return null;}

    public function get prependDataFunction():Function {return null;}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function load(result:Function, error:Function):void
    {
        var complete:Function = function(data:Array):void
        {
            result(data, hasOldRecords);
        }

        var items:Array = [];

        for (var i:uint = 0, n:uint = numItemsInResponse; i < n; i++)
        {
            var item:TodoItem = new TodoItem("Item # " + oldItemIndex++);

            items.push(item);
        }

        Promise.delay(items, 1000).then(complete).otherwise(error);
    }

    public function refresh(result:Function, error:Function):void
    {
        var items:Array = [];

        if (hasNewRecords)
        {
            for (var i:uint = 0, n:uint = numItemsInResponse; i < n; i++)
            {
                var item:TodoItem = new TodoItem("Item # " + --newItemIndex);

                items.unshift(item);
            }
        }

        Promise.delay(items, 1000).then(result).otherwise(error);
    }

    public function proceed(result:Function, error:Function):void
    {
        var complete:Function = function(data:Array):void
        {
            result(data, hasOldRecords);
        }

        var items:Array = [];

        if (hasOldRecords)
        {
            for (var i:uint = 0, n:uint = numItemsInResponse; i < n; i++)
            {
                var item:TodoItem = new TodoItem("Item # " + oldItemIndex++);

                items.push(item);
            }
        }

        Promise.delay(items, 1000).then(complete).otherwise(error);
    }

    public function reset():void
    {
        removeAll();

        oldItemIndex = newItemIndex = 0;

        dispatchEvent(new ProviderEvent(ProviderEvent.RELOAD));
    }
}
}
