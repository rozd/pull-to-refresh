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
import feathers.examples.todos.provider.GroupedTodoProvider;
import feathers.examples.todos.provider.TodoProvider;
import feathers.layout.AnchorLayoutData;

import feathersx.controls.GroupedPullToRefresh;

import feathersx.controls.PullToRefresh;

import feathersx.controls.pulltorefresh.BounceBackMode;

import starling.events.Event;

public class Settings extends ScrollContainer
{
    public function Settings()
    {
    }

    public var provider:TodoProvider;
    public var groupedProvider:GroupedTodoProvider;
    public var pullToRefresh:PullToRefresh;
    public var groupedPullToRefresh:GroupedPullToRefresh;

    private var list:List;
    private var bounceBackModePicker:PickerList;
    private var itemsInResponseStepper:NumericStepper;
    private var hasNewRecordsCheck:Check;
    private var hasOldRecordsCheck:Check;
    private var showFooterWhenDoneCheck:Check;
    private var simulateErrorCheck:Check;
    
    override protected function initialize():void
    {
        super.initialize();

        bounceBackModePicker = new PickerList();
        bounceBackModePicker.dataProvider = new ListCollection([{mode:BounceBackMode.JUMP_TO_EDGE, label:"Jump To Edge"},{mode:BounceBackMode.STAY_IN_PLACE, label:"Stay In Place"}]);
        bounceBackModePicker.prompt = "Bounce Back";
//        bounceBackModePicker.selectedIndex = pullToRefresh.bounceBackMode == BounceBackMode.JUMP_TO_EDGE ? 0 : 1;
        bounceBackModePicker.selectedIndex = groupedPullToRefresh.bounceBackMode == BounceBackMode.JUMP_TO_EDGE ? 0 : 1;
        bounceBackModePicker.addEventListener(Event.CHANGE, bounceBackModePicker_changeHandler);

        itemsInResponseStepper = new NumericStepper();
        itemsInResponseStepper.minimum = 0;
        itemsInResponseStepper.step = 5;
        itemsInResponseStepper.maximum = 1000;
//        itemsInResponseStepper.value = provider.numItemsInResponse;
        itemsInResponseStepper.value = groupedProvider.numItemsInResponse;
        itemsInResponseStepper.addEventListener(Event.CHANGE, itemsInResponseStepper_changeHandler);

        hasNewRecordsCheck = new Check();
//        hasNewRecordsCheck.isSelected = provider.hasNewRecords;
        hasNewRecordsCheck.isSelected = groupedProvider.hasNewRecords;
        hasNewRecordsCheck.addEventListener(Event.CHANGE, hasNewRecordsCheck_changeHandler);

        hasOldRecordsCheck = new Check();
//        hasOldRecordsCheck.isSelected = provider.hasOldRecords;
        hasOldRecordsCheck.isSelected = groupedProvider.hasOldRecords;
        hasOldRecordsCheck.addEventListener(Event.CHANGE, hasOldRecordsCheck_changeHandler);

        showFooterWhenDoneCheck = new Check();
//        showFooterWhenDoneCheck.isSelected = pullToRefresh.showFooterWhenDone;
        showFooterWhenDoneCheck.isSelected = groupedPullToRefresh.showFooterWhenDone;
        showFooterWhenDoneCheck.addEventListener(Event.CHANGE, showFooterWhenDoneCheck_changeHandler);

        simulateErrorCheck = new Check();
//        simulateErrorCheck.isSelected = provider.simulateError;
        simulateErrorCheck.isSelected = groupedProvider.simulateError;
        simulateErrorCheck.addEventListener(Event.CHANGE, simulateErrorCheck_changeHandler);

        list = new List();
        list.isSelectable = false;
        list.dataProvider = new ListCollection(
            [
                { label: "Bounce Back Mode", accessory: bounceBackModePicker },
                { label: "Items In Response", accessory: itemsInResponseStepper },
                { label: "Has New Records", accessory: hasNewRecordsCheck },
                { label: "Has Old Records", accessory: hasOldRecordsCheck },
                { label: "Show Footer if No Old Records", accessory: showFooterWhenDoneCheck },
                { label: "Simulate Error", accessory: simulateErrorCheck },
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
        if (provider)
            provider.hasNewRecords = hasNewRecordsCheck.isSelected;

        if (groupedProvider)
            groupedProvider.hasNewRecords = hasNewRecordsCheck.isSelected;
    }

    private function itemsInResponseStepper_changeHandler(event:Event):void
    {
        if (provider)
            provider.numItemsInResponse = itemsInResponseStepper.value;

        if (groupedProvider)
            groupedProvider.numItemsInResponse = itemsInResponseStepper.value;
    }

    private function hasOldRecordsCheck_changeHandler(event:Event):void
    {
        if (provider)
            provider.hasOldRecords = hasOldRecordsCheck.isSelected;

        if (groupedProvider)
            groupedProvider.hasOldRecords = hasOldRecordsCheck.isSelected;
    }

    private function showFooterWhenDoneCheck_changeHandler(event:Event):void
    {
        if (pullToRefresh)
            pullToRefresh.showFooterWhenDone = showFooterWhenDoneCheck.isSelected;

        if (groupedPullToRefresh)
            groupedPullToRefresh.showFooterWhenDone = showFooterWhenDoneCheck.isSelected;
    }

    private function simulateErrorCheck_changeHandler(event:Event):void
    {
        if (provider)
            provider.simulateError = simulateErrorCheck.isSelected;

        if (groupedProvider)
            groupedProvider.simulateError = simulateErrorCheck.isSelected;
    }
}
}
