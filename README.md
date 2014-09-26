pull-to-refresh
===============

"Pull to Refresh" and "Infinity List" implementation for Feathers

## Features
* Pull to Refresh for latest items
* Inifinity Scroll for earlier items
* Visual indicators for _loading_, _error_ and _empty_ states
* Responsibility of loading items could be delegated to Data Provider
* Have no restriction for Header's and Footer's animation

## Usage
PullToRefresh extends standard Feathers' List, it can be created as usual list:
```as3
this.pullToRefresh = new PullToRefresh();
this.pullToRefresh.loadImmediately = true; // indicates that loading of initial items will be started on list created
this.pullToRefresh.dataProvider = new ListCollection();
this.addChild(this.pullToRefresh);
```

Then define three methods for loading **initial**, **earlier** and **latest** items:
```as3

this.pullToRefresh.loadFunction = function(resultHandler:Function, errorHandler:Function):void
{
  var result:Function = function(value:Object):*
  {
    resultHandler(value.data, value.hasMoreRecords);
  }

  Promise.delay({data : [{label : "M"}, {label : "N"}, {label : "O"}], hasMoreRecords : true}, 1000).then(result).otherwise(errorHandler);
};

this.pullToRefresh.proceedFunction = function(resultHandler:Function, errorHandler:Function):void
{
  var result:Function = function(value:Object):*
  {
    resultHandler(value.data, value.hasMoreRecords);
  }

  Promise.delay({data : [{label : "X"}, {label : "Y"}, {label : "Z"}], hasMoreRecords : true}, 1000).then(result).otherwise(errorHandler);
};

this.pullToRefresh.refreshFunction = function(resultHandler:Function, errorHandler:Function):void
{
  var result:Function = function(value:Object):*
  {
    resultHandler(value.data);
  }

  Promise.delay({data : [{label : "A"}, {label : "B"}, {label : "C"}]}, 1000).then(result).otherwise(errorHandler);
};

```

In this example we uses [as3-promises] to simulate server response. Also take a look on `hasMoreRecords` param, this is flag that indicates if there are more earlier data to load, and note that it is used only for `load` and `proceed` fucntion, but not for `refresh`.

### Customizing Appearance


The next visual components could be specified: 
* _Header_ that **should** implements Header iterface,
* _Footer_ that **should** implements Footer interface,
* _ErrorIndicator_ (indicates error state) that **could** implements ErrorIndicator interface,
* _EmptyIndicator_ (indicates empty state) that **could** implements EmptyIndicator interface and
* _LoadingIndicator_ (indicates loading state) that have not special interface.

The reason to implement corresponed interfaces for error and empty indicators is they can receive error and empty strings. Each indicator is placed at the center of list.

Each of these components have default implementation, that could be overridden through factory method: 
```as3
this.pullToRefresh.headerFactory = function():DisplayObject
{
  return new CustomHeader();
};

this.pullToRefresh.footerFactory = function():DisplayObject
{
  return new CustomFooter();
};

this.pullToRefresh.emptyIndicatorFactory = function():DisplayObject
{
  return new DisplayObject();
};

this.pullToRefresh.errorIndicatorFactory = function():DisplayObject
{
  return new DisplayObject();
};

this.pullToRefresh.loadingIndicatorFactory = function():DisplayObject
{
  return new DisplayObject();
};
```

### Customizing Data Insert
The default implementations of inserting, appending and prepending items could be overrieden
```as3
this.pullToRefresh.insertDataFunction = function(items:Array):void
{
  this.pullToRefresh.data = items;
};

this.pullToRefresh.appendDataFunction = function(items:Array):void
{
  this.pullToRefresh.addAllAt(new ListCollection(items), 0);
};

this.pullToRefresh.prependDataFunction = function(items:Array):void
{
  this.pullToRefresh.addAll(new ListCollection(items));
};
```

## Using Provider



Then add three methods for loading items:



Just define three methods for loading items

For loading initial state

```as3
pullToRefresh
```

