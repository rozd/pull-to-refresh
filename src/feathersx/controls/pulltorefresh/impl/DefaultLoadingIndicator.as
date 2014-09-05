/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/2/14
 * Time: 4:25 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh.impl
{
import feathers.core.FeathersControl;

import feathersx.controls.pulltorefresh.Assets;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Image;

public class DefaultLoadingIndicator extends FeathersControl
{
    public function DefaultLoadingIndicator()
    {
        super();
    }

    protected var spinner:Image;

    override protected function initialize():void
    {
        super.initialize();

        spinner = new Image(Assets.spinner({fontSize:48, color:0x666666}));
        spinner.pivotX = spinner.width / 2;
        spinner.pivotY = spinner.height / 2;
        addChild(spinner);

        var tween:Tween = new Tween(spinner, 0.5);
        tween.repeatCount = 0;
        tween.animate("rotation", Math.PI * 2);

        Starling.current.juggler.add(tween);
    }

    override protected function draw():void
    {
        var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);

        if (sizeInvalid)
        {
            spinner.x = actualWidth / 2;
            spinner.y = actualHeight / 2;
        }
    }
}
}
