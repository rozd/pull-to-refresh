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

import feathers.data.HierarchicalCollection;

import feathers.data.ListCollection;
import feathers.examples.todos.TodoItem;

import feathersx.controls.pulltorefresh.Provider;
import feathersx.controls.pulltorefresh.event.ProviderEvent;

import flash.utils.clearTimeout;

import flash.utils.setTimeout;

public class GroupedTodoProvider extends HierarchicalCollection implements Provider
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function GroupedTodoProvider()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    public var numItemsInResponse:int = 10;
    
    public var numberOfSections:int = 3;
    public var rowsInSection:int = 3;

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

    public function get insertDataFunction():Function {return null;}

    public function get appendDataFunction():Function {return null;}

    public function get prependDataFunction():Function {return null;}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function load(resultHandler:Function, errorHandler:Function):void
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
            };

            var items:Array = [];

            for (var i:int = 0; i < numberOfSections; i++)
            {
                var children:Array = [];
                for (var j:int = 0; j < rowsInSection; j++)
                {
                    children[children.length] = new TodoItem("Item # " + oldItemIndex++);
                }
                
                items[items.length] = {header : "Section #" + i, children: children};
            }
            
            Promise.delay(items, 10).then(complete).otherwise(errorHandler);
        }
    }

    public function refresh(resultHandler:Function, errorHandler:Function):void
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

    public function proceed(resultHandler:Function, errorHandler:Function):void
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
