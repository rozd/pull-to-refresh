/**
 * Created by Max Rozdobudko on 4/29/15.
 */
package feathersx.data
{
import feathers.data.ListCollection;

import starling.events.Event;

public class ListCollectionAsync2 extends ListCollection
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
//        var item:* = failedItems[index];
//
//        if (item) return item;
//
//        return failedItems[index] || responders[index] || createResponderForIndex(index);
//    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function createResponderForIndex(index:int):void
    {
        var start:int = Math.floor(index / _pageSize) * _pageSize;
        var count:int = Math.min(_pageSize, _dataDescriptor.getLength(_data) - start);

        for (var i:int = start; i < start + count; i++)
        {
            if (_createPendingItemFunction != null)
            {
                _data[i] = _createPendingItemFunction(i);
            }
        }
    }

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
