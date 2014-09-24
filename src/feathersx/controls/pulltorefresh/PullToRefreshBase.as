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

import feathersx.controls.pulltorefresh.impl.DefaultEmptyIndicator;
import feathersx.controls.pulltorefresh.impl.DefaultErrorIndicator;
import feathersx.controls.pulltorefresh.impl.DefaultFooter;
import feathersx.controls.pulltorefresh.impl.DefaultHeader;
import feathersx.controls.pulltorefresh.impl.DefaultLoadingIndicator;

import starling.core.Starling;
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

    //-------------------------------------
    //  Variables: Flags
    //-------------------------------------

    /** Indicates if Server has data to proceed */
    protected var hasMoreRecords:Boolean = false;

    /** Indicates if loading initial data in progress */
    protected var isLoading:Boolean;

    /** Indicates if loading new data in progress */
    protected var isRefreshing:Boolean;

    /** Indicates if loading previous data in progress */
    protected var isProceeding:Boolean;

    /** Indicates if Footer is visible when there is no previous data on the Server */
    public var showFooterWhenDone:Boolean;

    /** Indicates if loading should be started immediately on List created. */
    public var loadImmediately:Boolean;

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
        this.invalidate(INVALIDATION_FLAG_HEADER);
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
        this.invalidate(INVALIDATION_FLAG_FOOTER);
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
        this.invalidate(INVALIDATION_FLAG_STYLES);
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
        this.invalidate(INVALIDATION_FLAG_STYLES);
    }

    //-------------------------------------
    //  errorIndicatorFactory
    //-------------------------------------

    /** @private */
    private var _errorIndicatorFactory:Function = defaultErrorIndicatorFactory;

    /**
     * A function that used to create ErrorIndicator instance.
     *
     * <listing version="3.0">
     * pullToRefresh.errorIndicatorFactory = function():DisplayObject
     * {
     *     return new DefaultErrorIndicator();
     * }
     * </listing>
     *
     * @see ErrorIndicator
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
        this.invalidate(INVALIDATION_FLAG_STYLES);
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
    //  initialFunction
    //-------------------------------------

    public var loadFunction:Function;

    //-------------------------------------
    //  refreshFunction
    //-------------------------------------

    public var refreshFunction:Function;

    //-------------------------------------
    //  previousFunction
    //-------------------------------------

    public var proceedFunction:Function;

    //-------------------------------------
    //  insertDataFunction
    //-------------------------------------

    public var insertDataFunction:Function;

    //-------------------------------------
    //  appendDataFunction
    //-------------------------------------

    public var appendDataFunction:Function;

    //-------------------------------------
    //  prependDataFunction
    //-------------------------------------

    public var prependDataFunction:Function;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize():void
    {
        super.initialize();

        if (loadImmediately)
            load();
    }

    override protected function draw():void
    {
        var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
        var stateInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STATE);
        var headerInvalid:Boolean = isInvalid(INVALIDATION_FLAG_HEADER);
        var footerInvalid:Boolean = isInvalid(INVALIDATION_FLAG_FOOTER);

        if (stateInvalid)
        {
            refreshIndicator();
        }

        if (stateInvalid || sizeInvalid)
        {
            if (currentIndicator)
            {
                currentIndicator.width = this.actualWidth;
                currentIndicator.height = this.actualHeight;
            }
        }

        if (headerInvalid)
        {
            if (header)
            {
                this.removeRawChildInternal(DisplayObject(header), true);
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
                this.removeRawChildInternal(DisplayObject(footer), true);
            }

            if (_footerFactory != null)
            {
                footer = Footer(_footerFactory());
                addRawChildInternal(DisplayObject(footer));
            }
        }

        super.draw();
    }

    override protected function refreshClipRect():void
    {
        super.refreshClipRect();

        if (header)
        {
            var headerAsDisplayObject:DisplayObject = header as DisplayObject;

            if (_verticalScrollPosition < 0)
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
                    if (header.state != HeaderState.FREE)
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

        if (footer)
        {
            var footerAsDisplayObject:DisplayObject = footer as DisplayObject;

            if (_maxVerticalScrollPosition - footer.footerHeight > 0)
            {
                if (footer.state != FooterState.DONE || showFooterWhenDone)
                {
                    showFooter();

                    if (footer.state != FooterState.LOADING && footer.state != FooterState.DONE)
                    {
                        if (_verticalScrollPosition > _maxVerticalScrollPosition - footer.footerHeight - 40)
                        {
                            footer.state = FooterState.RELEASE;
                        }
                        else if (footer.state != FooterState.LOADING)
                        {
                            footer.state = FooterState.PULL;
                        }
                    }

                    footerAsDisplayObject.y = _viewPort.height - _verticalScrollPosition + _topViewPortOffset + _bottomViewPortOffset;
                    footerAsDisplayObject.height = Math.max(actualHeight - footerAsDisplayObject.y, 0);
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

        if (header)
        {
            if (header.state == HeaderState.FREE)
            {
                header.state = HeaderState.PULL;
            }
        }
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
            if (hasMoreRecords)
            {
                originalMaxScrollPosition = _maxVerticalScrollPosition;

                _maxVerticalScrollPosition = _maxVerticalScrollPosition + footer.footerHeight;
            }
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
            if (loadFunction != null)
            {
                isLoading = true;

                setCurrentState(STATE_LOADING);

                loadFunction(insertData, handleError);
            }
        }
    }

    protected function insertData(data:Array, hasMoreRecords:Boolean = false):void
    {
        if (_dataProvider == null)
            _dataProvider = new ListCollection();

        if (insertDataFunction != null)
        {
            insertDataFunction(data);
        }
        else
        {
            _dataProvider.data = data;
        }

        isLoading = false;

        if (_dataProvider.length == 0)
        {
            setCurrentState(STATE_EMPTY);
        }
        else
        {
            setCurrentState(STATE_NORMAL);
        }

        this.hasMoreRecords = hasMoreRecords;

        freeHeader();
        freeFooter();
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
                if (refreshFunction != null)
                {
                    header.state = HeaderState.LOADING;

                    refreshFunction(appendData, refreshError);

                    previousMaxScrollPosition = _maxVerticalScrollPosition;
                }
                else
                {
                    freeHeader();
                }
            }
        }
    }

    protected function appendData(data:Array):void
    {
        if (appendDataFunction != null)
        {
            appendDataFunction(data);
        }
        else
        {
            _dataProvider.addAllAt(new ListCollection(data), 0);
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

        freeHeader();
    }

    protected function refreshError(error:Error):void
    {
        isRefreshing = false;

        handleError(error);
    }

    //--------------------------------------
    //  Methods: Proceed to next data
    //--------------------------------------

    /** Starts loading previous items. */
    protected function proceed():void
    {
        if (!isProceeding && !isLoading)
        {
            if (proceedFunction != null)
            {
                isProceeding = true;

                footer.state = FooterState.LOADING;

                proceedFunction(prependData, proceedError);
            }
            else
            {
                freeFooter();
            }
        }
    }

    protected function prependData(data:Array, hasMoreRecords:Boolean = false):void
    {
        if (prependDataFunction != null)
        {
            prependDataFunction(data);
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

        this.hasMoreRecords = hasMoreRecords;

        freeFooter();
    }

    protected function proceedError(error:Error):void
    {
        isProceeding = false;

        handleError(error);
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
            header.state = HeaderState.FREE;

            stopScrolling();

            _minVerticalScrollPosition = originalMinScrollPosition;

            originalMinScrollPosition  = NaN;

            if (_bounceBackMode == BounceBackMode.JUMP_TO_EDGE || _maxVerticalScrollPosition <= 0)
            {
                finishScrollingVertically();
            }
            else
            {
                previousScrollPosition = _verticalScrollPosition;
            }
        }
    }

    override protected function clampScrollPositions():void
    {
        super.clampScrollPositions();

        if (header.state == HeaderState.FREE)
        {
            Starling.juggler.delayCall(
                function():void
                {
                    header.state = HeaderState.PULL;
                },
            0.1);
        }

        if (_bounceBackMode == BounceBackMode.STAY_IN_PLACE && previousMaxScrollPosition == previousMaxScrollPosition && previousScrollPosition == previousScrollPosition)
        {
            var targetScrollPosition:Number = _maxVerticalScrollPosition - previousMaxScrollPosition + previousScrollPosition;

            if (targetScrollPosition < _minVerticalScrollPosition)
            {
                targetScrollPosition = _minVerticalScrollPosition;
            }
            else if (targetScrollPosition > _maxVerticalScrollPosition)
            {
                targetScrollPosition = _maxVerticalScrollPosition;
            }

            this.verticalScrollPosition = targetScrollPosition;

            previousMaxScrollPosition = previousScrollPosition = NaN;
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
            if (hasMoreRecords)
            {
                footer.state = HeaderState.PULL;
            }
            else
            {
                footer.state = FooterState.DONE;
            }
        }
    }

    //--------------------------------------
    //  Methods: Error
    //--------------------------------------

    protected function handleError(error:Error):void
    {
        isLoading = false;

        freeHeader();
        freeFooter();

        if (_dataProvider && _dataProvider.length > 0)
        {
            // show toast
        }
        else
        {
            _errorString = String(error);

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
                this.removeRawChildInternal(this.currentIndicator);
            }

            currentIndicator = newCurrentIndicator;

            if (currentIndicator)
            {
                this.addRawChildInternal(currentIndicator);
            }
        }
    }
}
}