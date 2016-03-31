package {

import feathers.system.DeviceCapabilities;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.TextField;

import pulltorefresh.examples.PagedListScreen;

import pulltorefresh.examples.PullToRefreshScreen;

import starling.core.Starling;

[SWF(width="320",height="480",frameRate="60",backgroundColor="#4a4137")]
public class HelloWorld extends Sprite
{
    public function HelloWorld()
    {
        if (this.stage)
        {
            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
        }

        DeviceCapabilities.dpi = 160;
        DeviceCapabilities.screenPixelWidth = 320;
        DeviceCapabilities.screenPixelHeight = 480;

        this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
    }

    private var _starling:Starling;

    private function start():void
    {
        Starling.handleLostContext = true;
        Starling.multitouchEnabled = true;
        this._starling = new Starling(PagedListScreen, this.stage);
        this._starling.enableErrorChecking = false;
        this._starling.start();
    }

    private function loaderInfo_completeHandler(event:Event):void
    {
        this.start();
    }
}
}
