/**
 * Created by Max Rozdobudko on 4/24/15.
 */
package feathersx.data
{
import feathers.data.ArrayListCollectionDataDescriptor;

import feathersx.errors.ItemPendingError;

import starling.events.Event;

public class ArrayListCollectionDataDescriptorAsync extends ArrayListCollectionDataDescriptor
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ArrayListCollectionDataDescriptorAsync()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var pageSize:int;

    private var length:int;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  loadItemsFunction
    //----------------------------------

    private var _loadItemsFunction:Function = null;

    public function get loadItemsFunction():Function
    {
        return _loadItemsFunction;
    }

    public function set loadItemsFunction(value:Function):void
    {
        _loadItemsFunction = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override public function getItemAt(data:Object, index:int):Object
    {
        var item:* = super.getItemAt(data, index);

        if (item is ItemPendingError)
        {
            throw item as ItemPendingError;
        }
        if (item === undefined)
        {
            var ipe:ItemPendingError = new ItemPendingError();
            var start:int = Math.floor(index / pageSize) * pageSize;
            var count:int = Math.min(pageSize, getLength(data) - pageSize);

            for (var i:int = 0; i < count; i++)
            {
                super.setItemAt(data, ipe, start + i);
            }

            throw ipe;
        }
        else
        {
            return item;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
}
}
