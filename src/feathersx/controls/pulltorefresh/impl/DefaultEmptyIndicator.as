/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/2/14
 * Time: 4:43 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh.impl
{
import feathers.controls.Label;
import feathers.core.FeathersControl;

import feathersx.controls.pulltorefresh.EmptyIndicator;

import feathersx.controls.pulltorefresh.Assets;

import starling.display.Image;

public class DefaultEmptyIndicator extends FeathersControl implements EmptyIndicator
{
    public function DefaultEmptyIndicator()
    {
        super()
    }

    protected var icon:Image;

    protected var label:Label;

    private var _emptyString:String;

    public function get emptyString():String
    {
        return _emptyString;
    }

    public function set emptyString(value:String):void
    {
        if (value == _emptyString) return;
        _emptyString = value;
        invalidate(INVALIDATION_FLAG_DATA);
    }

    override protected function initialize():void
    {
        super.initialize();

        icon = new Image(Assets.inbox({fontSize : 48, color : 0x666666}));
        icon.pivotX = icon.width / 2;
        icon.pivotY = icon.height / 2;
        addChild(icon);

        label = new Label();
        label.wordWrap = true;
        addChild(label);
    }

    override protected function draw():void
    {
        var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
        var dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);

        if (dataInvalid)
        {
            label.text = _emptyString;
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
