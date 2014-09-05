/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/2/14
 * Time: 4:28 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh.impl
{
import feathers.controls.Label;
import feathers.core.FeathersControl;

import feathersx.controls.pulltorefresh.ErrorIndicator;

import feathersx.controls.pulltorefresh.Assets;

import starling.display.Image;

public class DefaultErrorIndicator extends FeathersControl implements ErrorIndicator
{
    public function DefaultErrorIndicator()
    {
    }

    protected var icon:Image;

    protected var label:Label;

    private var _errorString:String;

    public function get errorString():String
    {
        return _errorString;
    }

    public function set errorString(value:String):void
    {
        if (value == _errorString) return;
        _errorString = value;
        invalidate(INVALIDATION_FLAG_DATA);
    }
    
    override protected function initialize():void
    {
        super.initialize();

        icon = new Image(Assets.warning({fontSize : 48, color : 0x666666}));
        icon.pivotX = icon.width / 2;
        icon.pivotY = icon.height / 2;
        addChild(icon);

        label = new Label();
        addChild(label);
    }

    override protected function draw():void
    {
        var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
        var dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);

        if (dataInvalid)
        {
            label.text = _errorString;
        }

        if (sizeInvalid)
        {
            icon.x = actualWidth / 2;
            icon.y = actualHeight / 2;

            label.maxWidth = actualWidth;

            label.validate();

            label.x = (actualWidth - label.width) / 2;
            label.y = icon.y + icon.height;
        }
    }
}
}
