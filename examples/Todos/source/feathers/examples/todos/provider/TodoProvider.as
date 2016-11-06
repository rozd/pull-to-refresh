/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 10:53 AM
 * To change this template use File | Settings | File Templates.
 */
package feathers.examples.todos.provider
{
import com.codecatalyst.promise.Deferred;
import com.codecatalyst.promise.Promise;

import feathers.data.ListCollection;
import feathers.examples.todos.TodoItem;

import feathersx.controls.pulltorefresh.Provider;
import feathersx.controls.pulltorefresh.event.ProviderEvent;

import flash.utils.clearTimeout;

import flash.utils.setTimeout;

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

    public var simulateError:Boolean = false;

    private var oldItemIndex:int;

    private var newItemIndex:int;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    public function get insertInitialItemsFunction():Function {return null;}

    public function get insertRecentItemsFunction():Function {return null;}

    public function get insertEarlierItemsFunction():Function {return null;}

    public function get supportsRecents():Boolean
    {
        return true;
    }

    public function get supportsEarlier():Boolean
    {
        return true;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function initial(resultHandler:Function, errorHandler:Function):void
    {
        if (simulateError)
        {
            var timeoutId:uint =
                setTimeout(function():void
                   {
                       clearTimeout(timeoutId);

                       errorHandler(new Error("An error occurs during load collection."));
                   }, 1000);
        }
        else
        {
            var complete:Function = function(data:Array):void
            {
                resultHandler(data, hasOldRecords);
            }

            var items:Array = [];

            for (var i:uint = 0, n:uint = numItemsInResponse; i < n; i++)
            {
                var item:TodoItem = new TodoItem("Item # " + oldItemIndex++);

                items.push(item);
            }

            Promise.delay(items, 10).then(complete).otherwise(errorHandler);
        }
    }

    public function recents(resultHandler:Function, errorHandler:Function):void
    {
        if (simulateError)
        {
            var timeoutId:uint =
                setTimeout(function():void
                {
                    clearTimeout(timeoutId);

                    errorHandler(new Error("An error occurs during refresh collection."));
                }, 1000);
        }
        else
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

            Promise.delay(items, 10).then(resultHandler).otherwise(errorHandler);
        }
    }

    public function earlier(resultHandler:Function, errorHandler:Function):void
    {
        if (simulateError)
        {
            var timeoutId:uint =
                setTimeout(function():void
                   {
                       clearTimeout(timeoutId);

                       errorHandler(new Error("An error occurs during loading earlier items."));
                   }, 1000);
        }
        else
        {
            var complete:Function = function(data:Array):void
            {
                resultHandler(data, hasOldRecords);
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

            Promise.delay(items, 1000).then(complete).otherwise(errorHandler);
        }
    }

    public function reset():void
    {
        removeAll();

        oldItemIndex = newItemIndex = 0;

        dispatchEvent(new ProviderEvent(ProviderEvent.RELOAD));
    }
}
}
