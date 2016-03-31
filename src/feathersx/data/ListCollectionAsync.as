/**
 * Created by Max Rozdobudko on 4/24/15.
 */
package feathersx.data
{
import feathers.data.ListCollection;

import feathersx.errors.ItemPendingError;

import starling.events.Event;

public class ListCollectionAsync extends ListCollection
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    private static function defaultCreatePendingItemFunction(index:int):Object
    {
        return "Loading " + index;
    }

    private static function defaultCreateFailedItemFunction(index, reason:Object):Object
    {
        return "Error to load item " + index;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ListCollectionAsync()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Variables: Caches
    //-------------------------------------

    protected var failedItems:Array = [];

    protected var responders:Array = [];

    //-------------------------------------
    //  Variables: Flags
    //-------------------------------------

    protected var isLengthRequesting:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    override public function get length():int
    {
        var actualLength:int = super.length;

        if (!isLengthRequesting && actualLength <= 0)
        {
            loadLength();
        }

        return actualLength;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  pageSize
    //-------------------------------------

    private var _pageSize:uint;

    public function get pageSize():uint
    {
        return _pageSize;
    }

    public function set pageSize(value:uint):void
    {
        if (value == _pageSize) return;
        _pageSize = value;
        reset();
    }

    //-------------------------------------
    //  loadLengthFunction
    //-------------------------------------

    private var _loadLengthFunction:Function;

    public function get loadLengthFunction():Function
    {
        return _loadLengthFunction;
    }

    public function set loadLengthFunction(value:Function):void
    {
        if (value == _loadLengthFunction) return;
        _loadLengthFunction = value;
        reset();
    }

    //-------------------------------------
    //  requestItemsFunction
    //-------------------------------------

    private var _loadItemsFunction:Function;

    public function get loadItemsFunction():Function
    {
        return _loadItemsFunction;
    }

    public function set loadItemsFunction(value:Function):void
    {
        if (value == _loadItemsFunction) return;
        _loadItemsFunction = value;
        reset();
    }

    //-------------------------------------
    //  createPendingItemFunction
    //-------------------------------------

    private var _createPendingItemFunction:Function = defaultCreatePendingItemFunction;

    public function get createPendingItemFunction():Function
    {
        return _createPendingItemFunction;
    }

    public function set createPendingItemFunction(value:Function):void
    {
        if (value == _createPendingItemFunction) return;
        _createPendingItemFunction = value;
        reset();
    }

    //-------------------------------------
    //  createFailedItemFunction
    //-------------------------------------

    private var _createFailedItemFunction:Function = defaultCreateFailedItemFunction;

    public function get createFailedItemFunction():Function
    {
        return _createFailedItemFunction;
    }

    public function set createFailedItemFunction(value:Function):void
    {
        if (value == _createFailedItemFunction) return;
        _createFailedItemFunction = value;
        reset();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

//    override public function getItemAt(index:int):Object
//    {
//        var responder:ListCollectionAsyncResponder = responders[index];
//
//        if (responder != null)
//            return responder.item;
//
//        var item:* = failedItems[index];
//
//        if (item != null)
//            return item;
//
//        try
//        {
//            item = super.getItemAt(index);
//        }
//        catch (ipe:ItemPendingError)
//        {
//
//        }
//
//        item = _data[index];
//
//        if (item === undefined)
//        {
//            var start:int = Math.floor(index / _pageSize) * _pageSize;
//            var count:int = Math.min(_pageSize, _dataDescriptor.getLength(_data) - start);
//
//
//
//
//
//            if (_createPendingItemFunction != null)
//            {
//                item = _createPendingItemFunction(index);
//                _data[index] = item;
//            }
//
//            responder = new ListCollectionAsyncResponder(this, index, item);
//
//            for (var i:int = 0; i < count; i++)
//            {
//                if (_createPendingItemFunction != null)
//                {
//                    _data[i] = _createPendingItemFunction(index);;
//                }
//            }
//
//            requestItems(start, count);
//
//            return responder.item;
//        }
//        else
//        {
//            return item;
//        }
//    }


    override public function getItemAt(index:int):Object
    {
        var responder:ListCollectionAsyncResponder = responders[index];

        if (responder != null)
            return responder.item;

        var item:* = failedItems[index];

        if (item != null)
            return item;

        item = _data[index];

        if (item === undefined)
        {
            var start:int = Math.floor(index / _pageSize) * _pageSize;
            var count:int = Math.min(_pageSize, _dataDescriptor.getLength(_data) - start);

            responder = new ListCollectionAsyncResponder(this, index, item);

            for (var i:int = start; i < start + count; i++)
            {
                if (_createPendingItemFunction != null)
                {
                    _data[i] = _createPendingItemFunction(i);
                }
            }

            requestItems(start, count);

            return _data[index];
        }
        else
        {
            return item;
        }
    }

    override public function getItemIndex(item:Object):int
    {
        var index:int = failedItems.indexOf(item);

        if (index != -1)
            return index;

//        for (var i:int = 0, n:int = responders.length; i < n; i++)
//        {
//            var responder:ListCollectionAsyncResponder = responders[i];
//
//            if (responder.item === item)
//                return responder.index;
//        }

        return super.getItemIndex(item);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Methods: length
    //-------------------------------------

    protected function loadLength():void
    {
        if (!isLengthRequesting)
        {
            if (_loadLengthFunction != null)
            {
                _loadLengthFunction(loadLengthResult, loadLengthError);

                isLengthRequesting = true;
            }
        }
    }

    protected function loadLengthResult(value:int, items:Array = null):void
    {
        isLengthRequesting = false;

        items = items || [];

        for (var i:int = items.length; i < value; i++)
        {
            items[i] = undefined;
        }

        this.data = items;
    }

    protected function loadLengthError(error:*=undefined):void
    {
        isLengthRequesting = false;
    }

    //-------------------------------------
    //  Methods: items
    //-------------------------------------

    protected function requestItems(start:int, count:int):void
    {
        if (_loadItemsFunction != null)
            _loadItemsFunction(start, count, requestItemsResult, requestItemsError);
    }

    protected function requestItemsResult(index:int, items:Array):void
    {
        items = items || [];

        if (index < 0 || (index + items.length) > length)
        {
            return;
        }

        for (var i:int = 0, n:int = items.length; i < n; i++)
        {
//            var responder:ListCollectionAsyncResponder = responders[index + i];
//            responder.result();
//            responders[index + i] = null;
//            delete responders[index + i];

            _data[index + i] = items[i];

            updateItemAt(index + i);
        }

        dispatchEvent(new Event(Event.CHANGE));
    }

    protected function requestItemsError(index:int, count:int, error:*=undefined):void
    {
        if (index < 0 || (index + count) > length)
        {
            return;
        }

        for (var i:int = 0, n:int = count; i < n; i++)
        {
//            var responder:ListCollectionAsyncResponder = responders[index + i];
//            responder.error(error);
//            responders[index + i] = null;
//            delete responders[index + i];

            if (_createFailedItemFunction != null)
                failedItems[index + i] = _createFailedItemFunction(index + i, error);

            _data[index + i] = undefined;

            updateItemAt(index + i);
            dispatchEvent(new Event(Event.CHANGE));
        }
    }

    //-------------------------------------
    //  Methods: common
    //-------------------------------------

    protected function reset():void
    {
        removeAll();
    }
}
}

import feathersx.data.ListCollectionAsync;

class ListCollectionAsyncResponder
{
    function ListCollectionAsyncResponder(collection:ListCollectionAsync, index:int, item:Object)
    {
        super();

        _item = item;
    }

    private var _item:Object;

    public function get item():Object
    {
        return _item;
    }

    public function result(value:Object = null):void
    {

    }

    public function error(reason:* = undefined):void
    {

    }
}