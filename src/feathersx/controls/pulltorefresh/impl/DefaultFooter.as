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
import feathersx.controls.pulltorefresh.Assets;

import flash.geom.Rectangle;

import starling.animation.Tween;
import starling.core.Starling;
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

    protected var spinner:Image;

    protected var background:Quad;

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

        background = new Quad(10, 10, 0xAAAAAA);
        background.alpha = 0.2;
        addChild(background);

        // spinner

        spinner = new Image(Assets.spinner());
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
            }
        }

        if (sizeInvalid)
        {
            var percent:Number = Math.min(1.0, actualHeight / originalHeight);

            if (spinner != null)
            {
                spinner.x = actualWidth / 2;

                spinner.y = -spinner.height / 2 + percent * (spinner.height / 2 + originalHeight / 2);
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

    public function get originalHeight():Number
    {
        return 40;
    }
}
}
