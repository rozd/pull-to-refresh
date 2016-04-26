/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 12:07 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh.impl
{
import feathers.core.FeathersControl;

import feathersx.controls.pulltorefresh.impl.DefaultAssets;
import feathersx.controls.pulltorefresh.Header;
import feathersx.controls.pulltorefresh.HeaderState;

import flash.debugger.enterDebugger;

import flash.geom.Rectangle;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Quad;

public class DefaultHeader extends FeathersControl implements Header
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function DefaultHeader()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var arrow:DisplayObject;

    protected var spinner:DisplayObject;

    protected var background:DisplayObject;

    protected var spinnerTween:Tween;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  state
    //-------------------------------------

    private var _state:String

    public function get state():String
    {
        return _state;
    }

    public function set state(value:String):void
    {
        if (value == _state) return;
        _state = value;
        invalidate(INVALIDATION_FLAG_STATE);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize():void
    {
        super.initialize();

        // background

        background = createBackground();
        addChild(background);

        // arrow

        arrow = createArrow();
        arrow.pivotX = arrow.width / 2;
        arrow.pivotY = arrow.height / 2;
        arrow.visible = false;
        addChild(arrow);

        // spinner

        spinner = createSpinner();
        spinner.pivotX = spinner.width / 2;
        spinner.pivotY = spinner.height / 2;
        spinner.visible = false;
        addChild(spinner);
    }

    override protected function draw():void
    {
        super.draw();

        var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
        var stateInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STATE);

        if (stateInvalid)
        {
            switch (_state)
            {
                case HeaderState.PULL :

                    arrow.visible = true;
                    spinner.visible = false;

                    arrow.rotation = 0;

                    break;

                case HeaderState.RELEASE :

                    arrow.visible = true;
                    spinner.visible = false;

                    arrow.rotation = Math.PI;

                    break;

                case HeaderState.LOADING :

                    arrow.visible = false;
                    spinner.visible = true;

                    spinner.rotation = 0;

                    spinnerTween = new Tween(spinner, 0.5);
                    spinnerTween.repeatCount = 0;
                    spinnerTween.animate("rotation", Math.PI * 2);

                    Starling.juggler.add(spinnerTween);

                    break;

                case HeaderState.FREE :

                    arrow.visible = false;
                    spinner.visible = true;

                    Starling.juggler.remove(spinnerTween);
                    spinnerTween = null;

                    break;
            }
        }

        if (sizeInvalid)
        {
            var percent:Number = Math.min(1.0, actualHeight / headerHeight);

            if (arrow != null)
            {
                arrow.x = actualWidth / 2;


                arrow.y = -arrow.height / 2 + percent * (arrow.height / 2 + headerHeight / 2);
            }

            if (spinner != null)
            {
                spinner.x = actualWidth / 2;

                spinner.y = -spinner.height / 2 + percent * (spinner.height / 2 + headerHeight / 2);
            }

            background.width = actualWidth;
            background.height = actualHeight;

            clipRect = new Rectangle(0, 0, actualWidth, actualHeight);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Methods: API
    //-------------------------------------

    public function get headerHeight():Number
    {
        return 52;
    }

    //-------------------------------------
    //  Methods: Internal
    //-------------------------------------

    protected function createBackground():DisplayObject
    {
        var background:Quad = new Quad(100, 100, 0xAAAAAA);
        background.alpha = 0.2;

        return background;
    }

    protected function createArrow():DisplayObject
    {
        return new Image(DefaultAssets.headerArrow);
    }

    protected function createSpinner():DisplayObject
    {
        return new Image(DefaultAssets.headerSpinner);
    }
}
}
