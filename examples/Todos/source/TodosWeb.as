package
{
import feathers.examples.todos.M;
import feathers.examples.todos.Main;

import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.utils.getDefinitionByName;

	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	[SWF(width="320",height="480",frameRate="60",backgroundColor="#4a4137")]
	public class TodosWeb extends MovieClip
	{
		public function TodosWeb()
		{
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			this.contextMenu = menu;
			
			if(this.stage)
			{
				this.stage.align = StageAlign.TOP_LEFT;
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
			}

			//pretends to be an iPhone Retina screen
			DeviceCapabilities.dpi = 160;
			DeviceCapabilities.screenPixelWidth = 320;
			DeviceCapabilities.screenPixelHeight = 480;
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		private var _starling:Starling;
		
		private function start():void
		{
			this.gotoAndStop(2);
			this.graphics.clear();
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
//			var MainType:Class = getDefinitionByName("feathers.examples.todos.Main") as Class;
			this._starling = new Starling(M, this.stage);
			this._starling.enableErrorChecking = false;
			this._starling.start();
		}
		
		private function loaderInfo_completeHandler(event:Event):void
		{
			this.start();
		}
	}
}