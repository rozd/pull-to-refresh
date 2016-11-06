/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 8/29/14
 * Time: 3:05 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh.impl
{
import feathers.core.FeathersControl;

import feathersx.controls.pulltorefresh.Footer;
import feathersx.controls.pulltorefresh.FooterState;
import feathersx.controls.pulltorefresh.impl.DefaultAssets;

import flash.geom.Rectangle;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;

public class DefaultFooter extends FeathersControl implements Footer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function DefaultFooter()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

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

    private var _state:String = FooterState.PULL;

    public function get state():String
    {
        return _state;
    }

    public function set state(value:String):void
    {
        if (value == _state) return;
        trace(value);
        _state = value;
        invalidate(INVALIDATION_FLAG_STATE);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize():void
    {
        // background

        background = createBackground();
        addChild(background);

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
                case FooterState.PULL :

                    spinner.visible = true;

                    Starling.juggler.remove(spinnerTween);
                    spinnerTween = null;

                    break;

                case FooterState.RELEASE :

                    spinner.visible = true;

                    break;

                case FooterState.LOADING :

                    spinner.visible = true;

                    spinner.rotation = 0;

                    spinnerTween = new Tween(spinner, 0.5);
                    spinnerTween.repeatCount = 0;
                    spinnerTween.animate("rotation", Math.PI * 2);

                    Starling.juggler.add(spinnerTween);

                    break;

                case FooterState.DONE :

                    spinner.visible = false;

                    Starling.juggler.remove(spinnerTween);
                    spinnerTween = null;

                    break;

                case FooterState.FREE :

                    spinner.visible = true;

                    Starling.juggler.remove(spinnerTween);
                    spinnerTween = null;

                    break;
            }
        }

        if (sizeInvalid)
        {
            var percent:Number = Math.min(1.0, actualHeight / footerHeight);

            if (spinner != null)
            {
                spinner.x = actualWidth / 2;

                spinner.y = -spinner.height / 2 + percent * (spinner.height / 2 + footerHeight / 2);
            }

            background.width = actualWidth;
            background.height = actualHeight;
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

    public function get footerHeight():Number
    {
        return 40;
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

    protected function createSpinner():DisplayObject
    {
        return new Image(DefaultAssets.headerSpinner);
    }
}
}
