/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 8/28/14
 * Time: 5:43 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
import feathersx.controls.*;

import feathers.controls.List;
import feathers.data.ListCollection;

import feathersx.controls.pulltorefresh.impl.DefaultEmptyIndicator;

import feathersx.controls.pulltorefresh.impl.DefaultErrorIndicator;

import feathersx.controls.pulltorefresh.impl.DefaultFooter;

import feathersx.controls.pulltorefresh.impl.DefaultHeader;
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

    public static const INVALIDATION_FLAG_HEADER:String = "header";

    public static const INVALIDATION_FLAG_FOOTER:String = "footer";

    public static const STATE_NORMAL:String = "normal";
    public static const STATE_LOADING:String = "loading";
    public static const STATE_ERROR:String = "error";
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

    //-------------------------------------
    //  Variables: Internal
    //-------------------------------------

    private var originalMinScrollPosition:Number = NaN;
    private var originalMaxScrollPosition:Number = NaN;

    protected var hasMoreRecords:Boolean = false;

    protected var currentIndicator:DisplayObject;

    //-------------------------------------
    //  Variables: Flags
    //-------------------------------------

    protected var isLoading:Boolean;

    protected var isRefreshing:Boolean;

    protected var isProceeding:Boolean;

    public var showFooterWhenDone:Boolean;

    public var loadImmediately:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  currentState
    //-------------------------------------

    private var _currentState:String = STATE_NORMAL;

    public function get currentState():String
    {
        return _currentState;
    }

    protected function setCurrentState(value:String):void
    {
        if (value == _currentState) return;
        _currentState = value;
        invalidate(INVALIDATION_FLAG_STATE);
    }

    //-------------------------------------
    //  headerFactory
    //-------------------------------------

    private var _headerFactory:Function = defaultHeaderFactory;

    public function get headerFactory():Function
    {
        return _headerFactory;
    }

    public function set headerFactory(value:Function):void
    {
        if (_headerFactory == value) return;
        _headerFactory = value;
        this.invalidate(INVALIDATION_FLAG_HEADER);
    }

    //-------------------------------------
    //  footerFactory
    //-------------------------------------

    private var _footerFactory:Function = defaultFooterFactory;

    public function get footerFactory():Function
    {
        return _footerFactory;
    }

    public function set footerFactory(value:Function):void
    {
        if (_footerFactory == value) return;
        _footerFactory = value;
        this.invalidate(INVALIDATION_FLAG_HEADER);
    }

    //-------------------------------------
    //  loadingIndicatorFactory
    //-------------------------------------

    private var _loadingIndicatorFactory:Function = defaultLoadingIndicatorFactory;

    public function get loadingIndicatorFactory():Function
    {
        return _loadingIndicatorFactory;
    }

    public function set loadingIndicatorFactory(value:Function):void
    {
        if (value == _loadingIndicatorFactory) return;
        _loadingIndicatorFactory = value;
        this.invalidate(INVALIDATION_FLAG_STYLES);
    }

    //-------------------------------------
    //  emptyIndicatorFactory
    //-------------------------------------

    private var _emptyIndicatorFactory:Function = defaultEmptyIndicatorFactory;

    public function get emptyIndicatorFactory():Function
    {
        return _emptyIndicatorFactory;
    }

    public function set emptyIndicatorFactory(value:Function):void
    {
        if (value == _emptyIndicatorFactory) return;
        _emptyIndicatorFactory = value;
        this.invalidate(INVALIDATION_FLAG_STYLES);
    }

    //-------------------------------------
    //  errorIndicatorFactory
    //-------------------------------------

    private var _errorIndicatorFactory:Function = defaultErrorIndicatorFactory;

    public function get errorIndicatorFactory():Function
    {
        return _errorIndicatorFactory;
    }

    public function set errorIndicatorFactory(value:Function):void
    {
        if (value == _errorIndicatorFactory) return;
        _errorIndicatorFactory = value;
        this.invalidate(INVALIDATION_FLAG_STYLES);
    }

    //-------------------------------------
    //  errorString
    //-------------------------------------

    private var _errorString:String;

    public function get errorString():String
    {
        return _errorString;
    }

    public function set errorString(value:String):void
    {
        _errorString = value;
    }

    //-------------------------------------
    //  emptyString
    //-------------------------------------

    private var _emptyString:String;

    public function get emptyString():String
    {
        return _emptyString;
    }

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
    //  Overridden properties
    //
    //--------------------------------------------------------------------------


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

            header = Header(_headerFactory());
            addRawChildInternal(DisplayObject(header));
        }

        if (footerInvalid)
        {
            if (footer)
            {
                this.removeRawChildInternal(DisplayObject(footer), true);
            }

            footer = Footer(_footerFactory());
            addRawChildInternal(DisplayObject(footer));
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
                    headerAsDisplayObject.height = Math.max(Math.abs(_verticalScrollPosition), header.refreshHeight);

                    if (Math.abs(_verticalScrollPosition) < header.refreshHeight)
                    {
                        headerAsDisplayObject.y = Math.abs(_verticalScrollPosition) - header.refreshHeight;
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
                        if (Math.abs(_verticalScrollPosition) > header.refreshHeight)
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

            if (_maxVerticalScrollPosition - footer.originalHeight > 0)
            {
                if (footer.state != FooterState.DONE || showFooterWhenDone)
                {
                    showFooter();

                    if (footer.state != FooterState.LOADING && footer.state != FooterState.DONE)
                    {
                        if (_verticalScrollPosition > _maxVerticalScrollPosition - footer.originalHeight - 40)
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

        if (header.state == HeaderState.RELEASE)
        {
            refresh();
        }

        if (footer.state == FooterState.RELEASE)
        {
            proceed();
        }
    }

    override protected function completeScroll():void
    {
        super.completeScroll();

        if (header.state == HeaderState.FREE)
        {
            header.state = HeaderState.PULL;
        }
    }

    override protected function throwTo(targetHorizontalScrollPosition:Number = NaN, targetVerticalScrollPosition:Number = NaN, duration:Number = 0.5):void
    {
        if (header.state == HeaderState.RELEASE || header.state == HeaderState.LOADING)
        {
            originalMinScrollPosition = _minVerticalScrollPosition;

            _minVerticalScrollPosition = -header.refreshHeight;

            if (header.state == HeaderState.RELEASE)
            {
                targetVerticalScrollPosition = _minVerticalScrollPosition;
            }
        }

        super.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, duration);
    }

    override protected function refreshMinAndMaxScrollPositions():void
    {
        super.refreshMinAndMaxScrollPositions();

        if (header.state == HeaderState.LOADING)
        {
            originalMinScrollPosition = _minVerticalScrollPosition;

            _minVerticalScrollPosition = -header.refreshHeight;
        }

        if (hasMoreRecords)
        {
            originalMaxScrollPosition = _maxVerticalScrollPosition;

            _maxVerticalScrollPosition = _maxVerticalScrollPosition + footer.originalHeight;
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

                    refreshFunction(appendData, handleError);
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

            _minVerticalScrollPosition = originalMinScrollPosition;

            originalMinScrollPosition  = NaN;

            finishScrollingVertically();
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

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------

    override protected function dataProvider_resetHandler(event:Event):void
    {
        super.dataProvider_resetHandler(event);
    }
}
}