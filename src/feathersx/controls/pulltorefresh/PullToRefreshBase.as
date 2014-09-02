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

import feathersx.controls.pulltorefresh.impl.DefaultFooter;

import feathersx.controls.pulltorefresh.impl.DefaultHeader;
import feathersx.controls.pulltorefresh.impl.DefaultHeader;

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

    public static const STATE_NORMAL:String;
    public static const STATE_ERROR:String;
    public static const STATE_EMPTY:String;
    public static const STATE_LOADING:String;
    public static const STATE_DISABLED:String;

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

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function PullToRefreshBase()
    {
        super();

        padding = 20;

//        scrollBarDisplayMode = "none";
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

    //-------------------------------------
    //  Variables: Flags
    //-------------------------------------

    protected var isLoading:Boolean;

    protected var isRefreshing:Boolean;

    protected var isProceeding:Boolean;

    //-------------------------------------
    //  showFooterWhenDone
    //-------------------------------------

    public var showFooterWhenDone:Boolean;

    //-------------------------------------
    //  loadOnInitialize
    //-------------------------------------

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

    //------------------------------------
    //  stateToSkinFunction
    //------------------------------------

    protected var _stateToSkinFunction:Function;

    public function get stateToSkinFunction():Function
    {
        return this._stateToSkinFunction;
    }

    public function set stateToSkinFunction(value:Function):void
    {
        if (_stateToSkinFunction == value) return;
        this._stateToSkinFunction = value;
        this.invalidate(INVALIDATION_FLAG_STYLES);
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
        var stateInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STATE);
        var headerInvalid:Boolean = isInvalid(INVALIDATION_FLAG_HEADER);
        var footerInvalid:Boolean = isInvalid(INVALIDATION_FLAG_FOOTER);

        if (stateInvalid)
        {

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
                    if (Math.abs(_verticalScrollPosition) > header.refreshHeight)
                    {
                        header.state = HeaderState.RELEASE;
                    }
                    else if (header.state != HeaderState.COMPLETE)
                    {
                        header.state = HeaderState.PULL;
                    }

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

                    if (footer.state == FooterState.LOADING)
                    {
                    }
                    else if (footer.state == FooterState.DONE)
                    {

                    }
                    else
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

    override protected function throwTo(targetHorizontalScrollPosition:Number = NaN, targetVerticalScrollPosition:Number = NaN, duration:Number = 0.5):void
    {
        if (header.state == HeaderState.RELEASE || header.state == HeaderState.LOADING)
        {
            originalMinScrollPosition = _minVerticalScrollPosition;

            _minVerticalScrollPosition = -header.refreshHeight;

            targetVerticalScrollPosition = _minVerticalScrollPosition;
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

    override protected function completeScroll():void
    {
        super.completeScroll();

        if (header.state == HeaderState.COMPLETE)
        {
            header.state = HeaderState.PULL;
        }
    }

    override protected function refreshBackgroundSkin():void
    {
        var oldBackgroundSkin:DisplayObject = currentBackgroundSkin;

        if (_stateToSkinFunction != null)
        {
            var newCurrentBackgroundSkin:DisplayObject = DisplayObject(_stateToSkinFunction(this, _currentState, oldBackgroundSkin));

            if(this.currentBackgroundSkin != newCurrentBackgroundSkin)
            {
                if(this.currentBackgroundSkin)
                {
                    this.removeRawChildInternal(this.currentBackgroundSkin);
                }
                this.currentBackgroundSkin = newCurrentBackgroundSkin;
                if(this.currentBackgroundSkin)
                {
                    this.addRawChildAtInternal(this.currentBackgroundSkin, 0);
                }
            }
            if(this.currentBackgroundSkin)
            {
                //force it to the bottom
                this.setRawChildIndexInternal(this.currentBackgroundSkin, 0);

                if(this.originalBackgroundWidth != this.originalBackgroundWidth) //isNaN
                {
                    this.originalBackgroundWidth = this.currentBackgroundSkin.width;
                }
                if(this.originalBackgroundHeight != this.originalBackgroundHeight) //isNaN
                {
                    this.originalBackgroundHeight = this.currentBackgroundSkin.height;
                }
            }
        }
        else
        {
            super.refreshBackgroundSkin();
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

                loadFunction(insertData, handleError);
            }
        }
    }

    protected function insertData(data:Array, hasMoreRecords:Boolean = true):void
    {
        isLoading = false;

        if (_dataProvider == null)
            _dataProvider = new ListCollection();

        _dataProvider.data = data;

        this.hasMoreRecords = hasMoreRecords;

        completeFooter();
    }

    //--------------------------------------
    //  Methods: Refresh with new data
    //--------------------------------------

    protected function refresh():void
    {
        if (!isRefreshing && !isLoading)
        {
            if (refreshFunction != null)
            {
                header.state = HeaderState.LOADING;

                refreshFunction(appendData, handleError);
            }
            else
            {
                completeHeader();
            }
        }
    }

    protected function appendData(data:Array):void
    {
        isRefreshing = false;

        _dataProvider.addAllAt(new ListCollection(data), 0);

        completeHeader();
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

                proceedFunction(prependData, handleError);
            }
            else
            {
                completeFooter();
            }
        }
    }

    protected function prependData(data:Array, hasMoreRecords:Boolean = true):void
    {
        isProceeding = false;

        _dataProvider.addAll(new ListCollection(data));

        this.hasMoreRecords = hasMoreRecords;

        completeFooter();
    }

    //--------------------------------------
    //  Methods: Handlers
    //--------------------------------------



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

    protected function completeHeader():void
    {
        header.state = HeaderState.COMPLETE;

        _minVerticalScrollPosition = originalMinScrollPosition;

        originalMinScrollPosition  = NaN;

        finishScrollingVertically();
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

    protected function completeFooter():void
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

    //--------------------------------------
    //  Methods: Footer
    //--------------------------------------

    protected function handleError(error:Error):void
    {
        completeHeader();
        completeFooter();

        if (_dataProvider && _dataProvider.length > 0)
        {
            // show toast
        }
        else
        {
            setCurrentState(STATE_ERROR);
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