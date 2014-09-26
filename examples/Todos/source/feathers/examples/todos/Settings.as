/**
 * Created by mobitile on 9/24/14.
 */
package feathers.examples.todos
{
import feathers.controls.Check;
import feathers.controls.List;
import feathers.controls.PickerList;
import feathers.controls.ScrollContainer;
import feathers.controls.NumericStepper;
import feathers.data.ListCollection;
import feathers.examples.todos.controls.MyCheck;
import feathers.examples.todos.provider.TodoProvider;
import feathers.layout.AnchorLayoutData;

import feathersx.controls.PullToRefresh;

import feathersx.controls.pulltorefresh.BounceBackMode;

import starling.events.Event;

public class Settings extends ScrollContainer
{
    public function Settings()
    {
    }

    public var provider:TodoProvider;
    public var pullToRefresh:PullToRefresh;

    private var list:List;
    private var bounceBackModePicker:PickerList;
    private var itemsInResponseStepper:NumericStepper;
    private var hasNewRecordsCheck:Check;
    private var hasOldRecordsCheck:Check;
    private var showFooterWhenDoneCheck:Check;
    
    override protected function initialize():void
    {
        super.initialize();

        bounceBackModePicker = new PickerList();
        bounceBackModePicker.dataProvider = new ListCollection([{mode:BounceBackMode.JUMP_TO_EDGE, label:"Jump To Edge"},{mode:BounceBackMode.STAY_IN_PLACE, label:"Stay In Place"}]);
        bounceBackModePicker.prompt = "Bounce Back";
        bounceBackModePicker.selectedIndex = pullToRefresh.bounceBackMode == BounceBackMode.JUMP_TO_EDGE ? 0 : 1;
        bounceBackModePicker.addEventListener(Event.CHANGE, bounceBackModePicker_changeHandler);

        itemsInResponseStepper = new NumericStepper();
        itemsInResponseStepper.minimum = 0;
        itemsInResponseStepper.value = provider.numItemsInResponse;
        itemsInResponseStepper.step = 10;
        itemsInResponseStepper.maximum = 1000;
        itemsInResponseStepper.addEventListener(Event.CHANGE, itemsInResponseStepper_changeHandler);

        hasNewRecordsCheck = new Check();
        hasNewRecordsCheck.isSelected = provider.hasNewRecords;
        hasNewRecordsCheck.addEventListener(Event.CHANGE, hasNewRecordsCheck_changeHandler);

        hasOldRecordsCheck = new Check();
        hasOldRecordsCheck.isSelected = provider.hasOldRecords;
        hasOldRecordsCheck.addEventListener(Event.CHANGE, hasOldRecordsCheck_changeHandler);

        showFooterWhenDoneCheck = new Check();
        showFooterWhenDoneCheck.isSelected = pullToRefresh.showFooterWhenDone;
        showFooterWhenDoneCheck.addEventListener(Event.CHANGE, showFooterWhenDoneCheck_changeHandler);

        list = new List();
        list.isSelectable = false;
        list.dataProvider = new ListCollection(
            [
                { label: "Bounce Back Mode", accessory: bounceBackModePicker },
                { label: "Items In Response", accessory: itemsInResponseStepper },
                { label: "Has New Records", accessory: hasNewRecordsCheck },
                { label: "Has Old Records", accessory: hasOldRecordsCheck },
                { label: "Show Footer if No Old Records", accessory: showFooterWhenDoneCheck },
            ]);
        list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
        list.clipContent = false;
        list.autoHideBackground = true;
        addChild(list);
    }

    private function bounceBackModePicker_changeHandler(event:Event):void
    {
        if (bounceBackModePicker.selectedItem)
            pullToRefresh.bounceBackMode = bounceBackModePicker.selectedItem.mode;
    }

    private function hasNewRecordsCheck_changeHandler(event:Event):void
    {
        provider.hasNewRecords = hasNewRecordsCheck.isSelected;
    }

    private function itemsInResponseStepper_changeHandler(event:Event):void
    {
        provider.numItemsInResponse = itemsInResponseStepper.value;
    }

    private function hasOldRecordsCheck_changeHandler(event:Event):void
    {
        provider.hasOldRecords = hasOldRecordsCheck.isSelected;
    }

    private function showFooterWhenDoneCheck_changeHandler(event:Event):void
    {
        pullToRefresh.showFooterWhenDone = showFooterWhenDoneCheck.isSelected;
    }
}
}
