/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 8/28/14
 * Time: 5:43 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
import feathers.controls.List;
import feathers.data.ListCollection;
import feathers.skins.IStyleProvider;

import feathersx.controls.pulltorefresh.impl.DefaultEmptyIndicator;
import feathersx.controls.pulltorefresh.impl.DefaultErrorIndicator;
import feathersx.controls.pulltorefresh.impl.DefaultFooter;
import feathersx.controls.pulltorefresh.impl.DefaultHeader;
import feathersx.controls.pulltorefresh.impl.DefaultLoadingIndicator;

import starling.display.DisplayObject;
import starling.events.Event;

public class PullToRefreshBase extends List
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /** Invalidation flag that indicates that Header appearance has changed.*/
    public static const INVALIDATION_FLAG_HEADER:String = "header";

    /** Invalidation flag that indicates that Footer appearance has changed.*/
    public static const INVALIDATION_FLAG_FOOTER:String = "footer";

    /** Invalidation flag that indicates that data should be reload.*/
    public static const INVALIDATION_FLAG_ITEMS:String = "items";

    /** Indicates normal state. */
    public static const STATE_NORMAL:String = "normal";

    /** Indicates loading state, when LoadingIndicator could be shown. */
    public static const STATE_LOADING:String = "loading";

    /** Indicates error state, when ErrorIndicator could be shown. */
    public static const STATE_ERROR:String = "error";

    /** Indicates empty state, when EmptyIndicator could be shown. */
    public static const STATE_EMPTY:String = "empty";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     * The default <code>IStyleProvider</code> for all <code>ToggleButton</code>
     * components. If <code>null</code>, falls back to using
     * <code>Button.globalStyleProvider</code> instead.
     *
     * @default null
     * @see feathers.core.FeathersControl#styleProvider
     * @see feathers.controls.Button#globalStyleProvider
     */
    public static var globalStyleProvider:IStyleProvider;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    private static function defaultHeaderFactory():Header
    {
        return new DefaultHeader();
    }

    private static function defaultFooterFactory():Footer
    {
        return new DefaultFooter();
    }

    private static function defaultErrorIndicatorFactory():DisplayObject
    {
        return new DefaultErrorIndicator();
    }

    private static function defaultEmptyIndicatorFactory():DisplayObject
    {
        return new DefaultEmptyIndicator();
    }

    private static function defaultLoadingIndicatorFactory():DisplayObject
    {
        return new DefaultLoadingIndicator();
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function PullToRefreshBase()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Variables: Components
    //-------------------------------------

    protected var header:Header;

    protected var footer:Footer;

    protected var currentIndicator:DisplayObject;

    //-------------------------------------
    //  Variables: Internal
    //-------------------------------------

    private var originalMinScrollPosition:Number = NaN;
    private var originalMaxScrollPosition:Number = NaN;

    private var previousMaxScrollPosition:Number = NaN;
    private var previousScrollPosition:Number = NaN;

    private var resetHeaderStateOnNextDraw:Boolean = true;

    //-------------------------------------
    //  Variables: Flags
    //-------------------------------------

    /** Indicates if there are records for continue loading. */
    protected var hasOldRecords:Boolean = true;

    /** Indicates if there are new records. */
    protected var hasNewRecords:Boolean = true;

    /** Indicates if loading initial data in progress */
    protected var isLoading:Boolean;

    /** Indicates if loading new data in progress */
    protected var isRefreshing:Boolean;

    /** Indicates if loading previous data in progress */
    protected var isProceeding:Boolean;

    /** Indicates if Footer is visible if there is no earlier data on the Server */
    public var showFooterWhenDone:Boolean;

    /** Indicates if loading should be started immediately on List created. */
    public var loadImmediately:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function get defaultStyleProvider():IStyleProvider
    {
        if (PullToRefreshBase.globalStyleProvider)
        {
            return PullToRefreshBase.globalStyleProvider;
        }

        return List.globalStyleProvider;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  bounceBackMode
    //-------------------------------------

    /** @private */
    private var _bounceBackMode:String = BounceBackMode.JUMP_TO_EDGE;

    /**
     * Specifies bounce back mode.
     * When refresh is complete and there are new data, scrolling could
     * jump to the first item in the List (BounceBackMode.JUMP_TO_EDGE) or
     * stay at same place (BounceBackMode.STAY_IN_PLACE).
     */
    public function get bounceBackMode():String
    {
        return _bounceBackMode;
    }

    /** @private */
    public function set bounceBackMode(value:String):void
    {
        _bounceBackMode = value;
    }

    //-------------------------------------
    //  currentState
    //-------------------------------------

    /** @private */
    private var _currentState:String = STATE_NORMAL;

    /**
     * Indicates current state.
     */
    public function get currentState():String
    {
        return _currentState;
    }

    /** @private */
    protected function setCurrentState(value:String):void
    {
        if (value == _currentState) return;
        _currentState = value;
        invalidate(INVALIDATION_FLAG_STATE);
    }

    protected var previousState:String = null;

    //-------------------------------------
    //  headerFactory
    //-------------------------------------

    /** @private */
    private var _headerFactory:Function = defaultHeaderFactory;

    /**
     * A function that used to create Header instance.
     *
     * <listing version="3.0">
     * pullToRefresh.headerFactory = function():DisplayObject
     * {
     *     return new DefaultHeader();
     * }
     * </listing>
     *
     * @see Header
     */
    public function get headerFactory():Function
    {
        return _headerFactory;
    }

    /** @private */
    public function set headerFactory(value:Function):void
    {
        if (_headerFactory == value) return;
        _headerFactory = value;
        invalidate(INVALIDATION_FLAG_HEADER);
    }

    //-------------------------------------
    //  footerFactory
    //-------------------------------------

    /** @private */
    private var _footerFactory:Function = defaultFooterFactory;

    /**
     * A function that used to create Footer instance.
     *
     * <listing version="3.0">
     * pullToRefresh.footerFactory = function():DisplayObject
     * {
     *     return new DefaultFooter();
     * }
     * </listing>
     *
     * @see Footer
     */
    public function get footerFactory():Function
    {
        return _footerFactory;
    }

    /** @private */
    public function set footerFactory(value:Function):void
    {
        if (_footerFactory == value) return;
        _footerFactory = value;
        invalidate(INVALIDATION_FLAG_FOOTER);
    }

    //-------------------------------------
    //  loadingIndicatorFactory
    //-------------------------------------

    /** @private */
    private var _loadingIndicatorFactory:Function = defaultLoadingIndicatorFactory;

    /**
     * A function that used to create LoadingIndicator instance.
     *
     * <listing version="3.0">
     * pullToRefresh.loadingIndicatorFactory = function():DisplayObject
     * {
     *     return new DefaultLoadingIndicator();
     * }
     * </listing>
     *
     * @see LoadingIndicator
     * @see DefaultLoadingIndicator
     */
    public function get loadingIndicatorFactory():Function
    {
        return _loadingIndicatorFactory;
    }

    /** @private */
    public function set loadingIndicatorFactory(value:Function):void
    {
        if (value == _loadingIndicatorFactory) return;
        _loadingIndicatorFactory = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //-------------------------------------
    //  emptyIndicatorFactory
    //-------------------------------------

    /** @private */
    private var _emptyIndicatorFactory:Function = defaultEmptyIndicatorFactory;

    /**
     * A function that used to create EmptyIndicator instance.
     *
     * <listing version="3.0">
     * pullToRefresh.emptyIndicatorFactory = function():DisplayObject
     * {
     *     return new DefaultEmptyIndicator();
     * }
     * </listing>
     *
     * @see EmptyIndicator
     * @see DefaultEmptyIndicator
     */
    public function get emptyIndicatorFactory():Function
    {
        return _emptyIndicatorFactory;
    }

    /** @private */
    public function set emptyIndicatorFactory(value:Function):void
    {
        if (value == _emptyIndicatorFactory) return;
        _emptyIndicatorFactory = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //-------------------------------------
    //  errorIndicatorFactory
    //-------------------------------------

    /** @private */
    private var _errorIndicatorFactory:Function = defaultErrorIndicatorFactory;

    /**
     * A function that used to create ErrorIndicator instance, that used to show
     * an error message.
     *
     * <listing version="3.0">
     * pullToRefresh.errorIndicatorFactory = function():DisplayObject
     * {
     *     return new DefaultErrorIndicator();
     * }
     * </listing>
     *
     * @see ErrorIndicator
     * @see DefaultErrorIndicator
     */
    public function get errorIndicatorFactory():Function
    {
        return _errorIndicatorFactory;
    }

    /** @private */
    public function set errorIndicatorFactory(value:Function):void
    {
        if (value == _errorIndicatorFactory) return;
        _errorIndicatorFactory = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //-------------------------------------
    //  errorString
    //-------------------------------------

    /** @private */
    private var _errorString:String;

    /** An error message that is displayed when something wrong. */
    public function get errorString():String
    {
        return _errorString;
    }

    //-------------------------------------
    //  emptyString
    //-------------------------------------

    /** @private */
    private var _emptyString:String;

    /** The message that will be displayed if there are no data on the Server. */
    public function get emptyString():String
    {
        return _emptyString;
    }

    /** @private */
    public function set emptyString(value:String):void
    {
        _emptyString = value;
    }

    //-------------------------------------
    //  loadFunction
    //-------------------------------------

    /** @private */
    private var _loadFunction:Function;

    /**
     * A function that used to load initial data. It takes two arguments:
     *
     * <ul>
     *  <li>
     *   First is result handler function with signature
     *   <code>function(items:Array, hasMoreRecords:Boolean = false):void;</code>,
     *   where <code>items:Array</code> are items to be inserted, and
     *   <code>hasMoreRecords</code> is flag that indicates if there are more
     *   data on the server to proceed.
     *   </li>
     *   <li>
     *   And second is error handler function with signature
     *   <code>function(error:Error):void;</code>, this error will be displayed
     *   using ErrorIndicator, if it defined.
     *   </li>
     * </ul>
     *
     * <listing version="3.0">
     * pullToRefresh.loadFunction = function(resultHandler:Function, errorHandler:Function):void
     * {
     *     // load initial data and call resultHandler(items:Array, hasNewRecords:Boolean) or errorHandler(error:Error);
     * }
     * </listing>
     *
     * @see #loadComplete
     * @see #errorIndicatorFactory
     */
    public function get loadFunction():Function
    {
        return _loadFunction;
    }

    /** @private */
    public function set loadFunction(value:Function):void
    {
        _loadFunction = value;
    }

    //-------------------------------------
    //  refreshFunction
    //-------------------------------------

    /** @private */
    private var _refreshFunction:Function;

    /**
     * A function that used to load new data, that become available on the server
     * after last load or refresh. It takes two arguments:
     *
     * <ul>
     *  <li>
     *   First is result handler function with signature
     *   <code>function(items:Array):void;</code>, where <code>items:Array</code>
     *   are items to be appended into the beginning of the list.
     *   </li>
     *   <li>
     *   And second is error handler function with signature
     *   <code>function(error:Error):void;</code>, this error will be displayed
     *   using ErrorIndicator, if it defined.
     *   </li>
     * </ul>
     *
     * <listing version="3.0">
     * pullToRefresh.refreshFunction = function(resultHandler:Function, errorHandler:Function):void
     * {
     *     // load next items and call resultHandler(items:Array) or errorHandler(error:Error);
     * }
     * </listing>
     *
     * @see #refreshResult
     * @see #errorIndicatorFactory
     */
    public function get refreshFunction():Function
    {
        return _refreshFunction;
    }

    /** @private */
    public function set refreshFunction(value:Function):void
    {
        _refreshFunction = value;
    }

    //-------------------------------------
    //  previousFunction
    //-------------------------------------

    /** @private */
    private var _proceedFunction:Function;

    /**
     * A function that used to load earlier data, that are on server. It takes
     * two arguments:
     *
     * <ul>
     *  <li>
     *   First is result handler function with signature
     *   <code>function(items:Array, hasMoreRecords:Boolean = false):void;</code>,
     *   where <code>items:Array</code> are items to be prepended into ending of
     *   list, and <code>hasMoreRecords</code> is flag that indicates if there
     *   are more data on the server to proceed.
     *   </li>
     *   <li>
     *   And second is error handler function with signature
     *   <code>function(error:Error):void;</code>, this error will be displayed
     *   using ErrorIndicator, if it defined.
     *   </li>
     * </ul>
     *
     * <listing version="3.0">
     * pullToRefresh.proceedFunction = function(resultHandler:Function, errorHandler:Function):void
     * {
     *     // load previous data and call resultHandler(items:Array, hasNewRecords:Boolean) or errorHandler(error:Error);
     * }
     * </listing>
     *
     * @see #loadComplete
     * @see #errorIndicatorFactory
     */

    public function get proceedFunction():Function
    {
        return _proceedFunction;
    }

    /** @private */
    public function set proceedFunction(value:Function):void
    {
        _proceedFunction = value;
    }

    //-------------------------------------
    //  insertDataFunction
    //-------------------------------------

    /** @private */
    private var _insertDataFunction:Function;

    /**
     * A function that allows to override inserting initial items default functionality.
     *
     * <listing version="3.0">
     * pullToRefresh.insertDataFunction = function(items:Array):void
     * {
     *     // handle received items before they will be added to the collection
     *     items.forEach(doSomethingWithArrayItem);
     *
     *     // replace items in collection
     *     pullToRefresh.dataProvider.data = items;
     * }
     * </listing>
     */
    public function get insertDataFunction():Function
    {
        return _insertDataFunction;
    }

    /** @private */
    public function set insertDataFunction(value:Function):void
    {
        _insertDataFunction = value;
    }

    //-------------------------------------
    //  appendDataFunction
    //-------------------------------------

    /** @private */
    private var _appendDataFunction:Function;

    /**
     * A function that allows to override appending new items default functionality.
     *
     * <listing version="3.0">
     * pullToRefresh.appendDataFunction = function(items:Array):void
     * {
     *     // handle received items before they will be added to the collection
     *     items.forEach(doSomethingWithArrayItem);
     *
     *     // add items at the beginning of collection
     *     pullToRefresh.dataProvider.addAllAt(new ListCollection(items), 0);
     * }
     * </listing>
     */
    public function get appendDataFunction():Function
    {
        return _appendDataFunction;
    }

    /** @private */
    public function set appendDataFunction(value:Function):void
    {
        _appendDataFunction = value;
    }

    //-------------------------------------
    //  prependDataFunction
    //-------------------------------------

    /** @private */
    private var _prependDataFunction:Function;

    /**
     * A function that allows to override prepending previous items default
     * functionality.
     *
     * <listing version="3.0">
     * pullToRefresh.prependDataFunction = function(items:Array):void
     * {
     *     // handle received items before they will be added to the collection
     *     items.forEach(doSomethingWithArrayItem);
     *
     *     // add items at the end of collection
     *     pullToRefresh.dataProvider.addAll(new ListCollection(items));
     * }
     * </listing>
     */
    public function get prependDataFunction():Function
    {
        return _prependDataFunction;
    }

    /** @private */
    public function set prependDataFunction(value:Function):void
    {
        _prependDataFunction = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize():void
    {
        super.initialize();

        if (loadImmediately)
            invalidate(INVALIDATION_FLAG_ITEMS);
    }

    override protected function draw():void
    {
        var itemsInvalid:Boolean = isInvalid(INVALIDATION_FLAG_ITEMS);
        var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
        var stateInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STATE);
        var scrollInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SCROLL);
        var stylesInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STYLES);
        var scrollBarInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
        var clippingInvalid:Boolean = isInvalid(INVALIDATION_FLAG_CLIPPING);
        var headerInvalid:Boolean = isInvalid(INVALIDATION_FLAG_HEADER);
        var footerInvalid:Boolean = isInvalid(INVALIDATION_FLAG_FOOTER);

        if (itemsInvalid)
        {
            // TODO: This should reset PTR when dataProvider is reset
            isLoading = isRefreshing = isProceeding = false;

            load();
        }

        if (stateInvalid)
        {
            refreshIndicator();
        }

        if (stateInvalid || sizeInvalid)
        {
            if (currentIndicator)
            {
                currentIndicator.width = actualWidth;
                currentIndicator.height = actualHeight;
            }
        }

        if (headerInvalid)
        {
            if (header)
            {
                removeRawChildInternal(DisplayObject(header), true);
            }

            if (_headerFactory != null)
            {
                header = Header(_headerFactory());
                addRawChildInternal(DisplayObject(header));
            }
        }

        if (footerInvalid)
        {
            if (footer)
            {
                removeRawChildInternal(DisplayObject(footer), true);
            }

            if (_footerFactory != null)
            {
                footer = Footer(_footerFactory());
                addRawChildInternal(DisplayObject(footer));
            }
        }

        if (resetHeaderStateOnNextDraw)
        {
            doResetFreeHeader();
        }

        var oldMaxHorizontalScrollPosition:Number = this._maxHorizontalScrollPosition;
        var oldMaxVerticalScrollPosition:Number = this._maxVerticalScrollPosition;

        super.draw();

        if (oldMaxHorizontalScrollPosition != _maxHorizontalScrollPosition)
        {
            scrollInvalid = true;
        }
        if (oldMaxVerticalScrollPosition != _maxVerticalScrollPosition)
        {
            scrollInvalid = true;
        }

        if (scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || clippingInvalid)
        {
            refreshHeaderFooter();
        }
    }

    protected function refreshHeaderFooter():void
    {
        if (header)
        {
            var headerAsDisplayObject:DisplayObject = header as DisplayObject;

            if (_verticalScrollPosition < 0)
            {
                if (header.state != HeaderState.DONE)
                {
                    showHeader();

                    if (header.state == HeaderState.LOADING)
                    {
                        headerAsDisplayObject.height = Math.max(Math.abs(_verticalScrollPosition), header.headerHeight);

                        if (Math.abs(_verticalScrollPosition) < header.headerHeight)
                        {
                            headerAsDisplayObject.y = Math.abs(_verticalScrollPosition) - header.headerHeight;
                        }
                        else
                        {
                            headerAsDisplayObject.y = 0;
                        }
                    }
                    else
                    {
                        if (header.state == HeaderState.FREE)
                        {
                            if (Math.abs(_verticalScrollPosition) < header.headerHeight)
                            {
                                header.state = HeaderState.PULL;
                            }
                        }
                        else
                        {
                            if (Math.abs(_verticalScrollPosition) > header.headerHeight)
                            {
                                header.state = HeaderState.RELEASE;
                            }
                            else
                            {
                                header.state = HeaderState.PULL;
                            }
                        }

                        headerAsDisplayObject.y = 0;
                        headerAsDisplayObject.height = Math.abs(_verticalScrollPosition)
                    }
                }
                else
                {
                    hideHeader();
                }
            }
            else
            {
                hideHeader();
            }
        }

        if (footer)
        {
            var footerAsDisplayObject:DisplayObject = footer as DisplayObject;

            if (_maxVerticalScrollPosition - footer.footerHeight > 0)
            {
                if (footer.state != FooterState.DONE || showFooterWhenDone)
                {
                    showFooter();

                    if (footer.state == FooterState.LOADING)
                    {

                    }
                    else
                    {
                        if (footer.state == FooterState.FREE)
                        {
                            if (_verticalScrollPosition < _maxVerticalScrollPosition + footer.footerHeight)
                            {
                                if (hasOldRecords)
                                    footer.state = FooterState.PULL;
                                else
                                    footer.state = FooterState.DONE;
                            }
                        }
                        else
                        {
                            if (_verticalScrollPosition > _maxVerticalScrollPosition - footer.footerHeight)
                            {
                                footer.state = FooterState.RELEASE;
                            }
                            else
                            {
                                footer.state = FooterState.PULL;
                            }
                        }
                    }

                    footerAsDisplayObject.y = _viewPort.height - _verticalScrollPosition + _topViewPortOffset + _bottomViewPortOffset;
                    footerAsDisplayObject.height = Math.max(actualHeight - footerAsDisplayObject.y, 0);

//                    if (footer.state == FooterState.FREE)
//                    {
//                        if (_verticalScrollPosition < _maxVerticalScrollPosition + footer.footerHeight + 40)
//                        {
//                            if (hasMoreRecords)
//                                footer.state = FooterState.PULL;
//                            else
//                                footer.state = FooterState.DONE;
//                        }
//                    }
//                    else if (footer.state != FooterState.LOADING && footer.state != FooterState.DONE)
//                    {
//                        if (_verticalScrollPosition > _maxVerticalScrollPosition - footer.footerHeight - 40)
//                        {
//                            footer.state = FooterState.RELEASE;
//                        }
//                        else if (footer.state != FooterState.LOADING)
//                        {
//                            footer.state = FooterState.PULL;
//                        }
//                    }
//
//                    footerAsDisplayObject.y = _viewPort.height - _verticalScrollPosition + _topViewPortOffset + _bottomViewPortOffset;
//                    footerAsDisplayObject.height = Math.max(actualHeight - footerAsDisplayObject.y, 0);
                }
                else
                {
                    hideFooter();
                }
            }
            else
            {
                hideFooter();
            }
        }
    }

    override protected function finishScrollingVertically():void
    {
        super.finishScrollingVertically();

        if (header)
        {
            if (header.state == HeaderState.RELEASE)
            {
                refresh();
            }
        }

        if (footer)
        {
            if (footer.state == FooterState.RELEASE)
            {
                proceed();
            }
        }
    }

    override protected function completeScroll():void
    {
        super.completeScroll();

        resetFreeHeader();
    }

    override protected function throwTo(targetHorizontalScrollPosition:Number = NaN, targetVerticalScrollPosition:Number = NaN, duration:Number = 0.5):void
    {
        if (header)
        {
            if (header.state == HeaderState.RELEASE || header.state == HeaderState.LOADING)
            {
                originalMinScrollPosition = _minVerticalScrollPosition;

                _minVerticalScrollPosition = -header.headerHeight;

                if (header.state == HeaderState.RELEASE)
                {
                    targetVerticalScrollPosition = _minVerticalScrollPosition;
                }
            }
        }

        super.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, duration);
    }

    override protected function refreshMinAndMaxScrollPositions():void
    {
        super.refreshMinAndMaxScrollPositions();

        if (header)
        {
            if (header.state == HeaderState.LOADING)
            {
                originalMinScrollPosition = _minVerticalScrollPosition;

                _minVerticalScrollPosition = -header.headerHeight;
            }
        }

        if (footer)
        {
            if (hasOldRecords)
            {
                originalMaxScrollPosition = _maxVerticalScrollPosition;

                _maxVerticalScrollPosition = _maxVerticalScrollPosition + footer.footerHeight;
            }
        }
    }

    override protected function refreshScrollValues():void
    {
        super.refreshScrollValues();

        if (_bounceBackMode == BounceBackMode.STAY_IN_PLACE &&
            previousScrollPosition == previousScrollPosition &&
            previousMaxScrollPosition == previousMaxScrollPosition)
        {
            // calculate scroll position for "stay in place" mode, considering
            // items received in last refresh

            var targetScrollPosition:Number = _maxVerticalScrollPosition - previousMaxScrollPosition + previousScrollPosition;

            if (targetScrollPosition < _minVerticalScrollPosition)
            {
                targetScrollPosition = _minVerticalScrollPosition;
            }
            else if (targetScrollPosition > _maxVerticalScrollPosition)
            {
                targetScrollPosition = _maxVerticalScrollPosition;
            }

            verticalScrollPosition = targetScrollPosition;

            previousMaxScrollPosition = previousScrollPosition = NaN;

            resetFreeHeader();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  Methods: Load initial data
    //--------------------------------------

    /** Starts loading initial data. */
    protected function load():void
    {
        if (!isLoading)
        {
            if (_loadFunction != null)
            {
                isLoading = true;

                previousState = _currentState;

                setCurrentState(STATE_LOADING);

                _loadFunction(loadComplete, loadError);
            }
        }
    }

    protected function loadComplete(data:Array, hasOldRecords:Boolean = false, hasNewRecords:Boolean = true):void
    {
        isLoading = false;

        if (_dataProvider == null)
            _dataProvider = new ListCollection();

        if (_insertDataFunction != null)
        {
            _insertDataFunction(data);
        }
        else
        {
            _dataProvider.data = data;
        }

        if (_dataProvider.length == 0)
        {
            setCurrentState(STATE_EMPTY);
        }
        else
        {
            setCurrentState(STATE_NORMAL);
        }

        this.hasOldRecords = hasOldRecords;
        this.hasNewRecords = hasNewRecords;

        freeHeader();
        freeFooter();
    }

    protected function loadError(error:*=undefined):void
    {
        isLoading = false;

        if (error == undefined) // cancelled
        {
            setCurrentState(previousState);

            freeHeader();
            freeFooter();
        }
        else // error
        {
            handleError(error);
        }
    }

    //--------------------------------------
    //  Methods: Refresh with new data
    //--------------------------------------

    /** Starts loading new items. */
    protected function refresh():void
    {
        if (!isRefreshing)
        {
            if (isLoading)
            {
                header.state = HeaderState.LOADING;
            }
            else
            {
                if (_refreshFunction != null)
                {
                    header.state = HeaderState.LOADING;

                    _refreshFunction(refreshResult, refreshError);

                    previousMaxScrollPosition = _maxVerticalScrollPosition;
                }
                else
                {
                    header.state = HeaderState.LOADING;

                    freeHeader();
                }
            }
        }
    }

    protected function refreshResult(items:Array, hasNewRecords:Boolean = true, hasOldRecords: * = undefined):void
    {
        if (_appendDataFunction != null)
        {
            _appendDataFunction(items);
        }
        else
        {
            _dataProvider.addAllAt(new ListCollection(items), 0);
        }

        isRefreshing = false;

        if (_dataProvider.length == 0)
        {
            setCurrentState(STATE_EMPTY);
        }
        else
        {
            setCurrentState(STATE_NORMAL);
        }

        this.hasNewRecords = hasNewRecords;

        freeHeader();

        if (hasOldRecords !== undefined) {
            this.hasOldRecords = hasOldRecords;
            freeFooter();
        }

        invalidate(INVALIDATION_FLAG_DATA);
    }

    protected function refreshError(error:*=undefined):void
    {
        isRefreshing = false;

        if (error == undefined) // cancelled
        {
            freeHeader();
        }
        else // error
        {
            handleError(error);
        }
    }

    //--------------------------------------
    //  Methods: Proceed to next data
    //--------------------------------------

    /** Starts loading previous items. */
    protected function proceed():void
    {
        if (!isProceeding && !isLoading)
        {
            if (_proceedFunction != null)
            {
                isProceeding = true;

                footer.state = FooterState.LOADING;

                _proceedFunction(proceedResult, proceedError);
            }
            else
            {
                freeFooter();
            }
        }
    }

    protected function proceedResult(data:Array, hasOldRecords:Boolean = false):void
    {
        if (_prependDataFunction != null)
        {
            _prependDataFunction(data);
        }
        else
        {
            _dataProvider.addAll(new ListCollection(data));
        }

        isProceeding = false;

        if (_dataProvider.length == 0)
        {
            setCurrentState(STATE_EMPTY);
        }
        else
        {
            setCurrentState(STATE_NORMAL);
        }

        this.hasOldRecords = hasOldRecords;

        freeFooter();
    }

    protected function proceedError(error:*=undefined):void
    {
        isProceeding = false;

        if (error == undefined) // cancelled
        {
            freeFooter();
        }
        else // error
        {
            handleError(error);
        }
    }

    //--------------------------------------
    //  Methods: Header
    //--------------------------------------

    public function showHeader():void
    {
        if (header)
        {
            DisplayObject(header).width = actualWidth;
        }
    }

    public function hideHeader():void
    {
        if (header)
        {
            DisplayObject(header).height = 0;
        }
    }

    protected function freeHeader():void
    {
        if (header)
        {
            if (header.state == HeaderState.LOADING)
            {
                header.state = HeaderState.FREE;

                _minVerticalScrollPosition = originalMinScrollPosition;

                originalMinScrollPosition = NaN;

                if (_bounceBackMode == BounceBackMode.JUMP_TO_EDGE || _maxVerticalScrollPosition <= 0)
                {
                    // If bounce-back is "jump to edge" or there are less items than
                    // list's height, scroll to top boundary. Header will be reset
                    // in completeScroll() in this case.

                    finishScrollingVertically();
                }
                else
                {
                    // Otherwise store current scroll position and wait for next
                    // refreshScrollValues() call, where Header will be reset.

                    previousScrollPosition = _verticalScrollPosition;
                }
            }
            else
            {
                if (hasNewRecords)
                {
                    header.state = HeaderState.PULL;
                }
                else
                {
                    header.state = HeaderState.DONE;
                }
            }
        }
    }

    /** If Header is in "free" state, delays reset it to "pull" on the next draw. */
    private function resetFreeHeader():void
    {
//        if (header)
//        {
//            if (header.state == HeaderState.FREE)
//            {
//                resetHeaderStateOnNextDraw = true;
//            }
//        }
    }

    /** Resets Header to "pull" state, if it is in "free" state. */
    private function doResetFreeHeader():void
    {
        resetHeaderStateOnNextDraw = false;

        if (header)
        {
            if (header.state == HeaderState.FREE)
            {
                header.state = HeaderState.PULL;

//                if (hasLaterRecords)
//                {
//                    header.state = HeaderState.PULL;
//                }
//                else
//                {
//                    header.state = HeaderState.DONE;
//                }
            }
        }
    }

    //--------------------------------------
    //  Methods: Footer
    //--------------------------------------

    public function showFooter():void
    {
        if (footer)
        {
            DisplayObject(footer).width = actualWidth;
        }
    }

    public function hideFooter():void
    {
        if (footer)
        {
            DisplayObject(footer).height = 0;
        }
    }

    protected function freeFooter():void
    {
        if (footer)
        {
            if (footer.state == FooterState.LOADING)
            {
                footer.state = FooterState.FREE;

                if (!hasOldRecords)
                    _maxVerticalScrollPosition = originalMaxScrollPosition;

                finishScrollingVertically();
            }
            else
            {
                if (hasOldRecords)
                {
                    footer.state = FooterState.PULL;
                }
                else
                {
                    footer.state = FooterState.DONE;
                }
            }
        }
    }

    //--------------------------------------
    //  Methods: Error
    //--------------------------------------

    protected function handleError(error:Error):void
    {
        // hide footer
        _maxVerticalScrollPosition = originalMaxScrollPosition;

        freeHeader();
        freeFooter();

        if (_dataProvider && _dataProvider.length > 0)
        {
            // show toast
        }
        else
        {
            _errorString = error ? error.message : String(error);

            setCurrentState(STATE_ERROR);
        }
    }

    //--------------------------------------
    //  Methods: FeathersComponent
    //--------------------------------------

    protected function refreshIndicator():void
    {
        var newCurrentIndicator:DisplayObject;

        switch (_currentState)
        {
            case STATE_EMPTY :
                    newCurrentIndicator = _emptyIndicatorFactory != null ? _emptyIndicatorFactory() : null;

                    if (newCurrentIndicator is EmptyIndicator)
                        EmptyIndicator(newCurrentIndicator).emptyString = _emptyString;
                break;

            case STATE_ERROR :
                    newCurrentIndicator = _errorIndicatorFactory != null ? _errorIndicatorFactory() : null;

                    if (newCurrentIndicator is ErrorIndicator)
                        ErrorIndicator(newCurrentIndicator).errorString = _errorString;
                break;

            case STATE_LOADING :
                    if (_dataProvider && _dataProvider.length > 0)
                        newCurrentIndicator = null;
                    else
                        newCurrentIndicator = _loadingIndicatorFactory != null ? _loadingIndicatorFactory() : null;
                break;

            case STATE_NORMAL :
                    newCurrentIndicator = null;
                break;
        }

        if (currentIndicator != newCurrentIndicator)
        {
            if (currentIndicator)
            {
                removeRawChildInternal(currentIndicator);
            }

            currentIndicator = newCurrentIndicator;

            if (currentIndicator)
            {
                addRawChildInternal(currentIndicator);
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------

    override protected function dataProvider_changeHandler(event:Event):void
    {
        super.dataProvider_changeHandler(event);

        if (_dataProvider.length > 0 && _currentState == STATE_EMPTY)
        {
            setCurrentState(STATE_NORMAL);
        }
    }
}
}