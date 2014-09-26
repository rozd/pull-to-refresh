package feathers.examples.todos
{
import feathers.controls.Button;
import feathers.controls.Callout;
import feathers.controls.Header;
import feathers.controls.PanelScreen;
import feathers.controls.PickerList;
import feathers.controls.ScrollContainer;
import feathers.controls.TextInput;
import feathers.controls.ToggleButton;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.examples.todos.Settings;
import feathers.examples.todos.controls.TodoItemRenderer;
import feathers.examples.todos.provider.TodoProvider;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.themes.MetalWorksMobileTheme;

import feathersx.controls.PullToRefresh;
import feathersx.controls.pulltorefresh.BounceBackMode;

import starling.display.DisplayObject;
import starling.events.Event;

public class Content extends PanelScreen
{
    public function Content()
    {
        this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }

    public var provider:TodoProvider = new TodoProvider();
    public var list:PullToRefresh = new PullToRefresh();

    private var _input:TextInput;
    private var _editButton:ToggleButton;
    private var _resetButton:Button;
    private var _toolbar:ScrollContainer;

    private function customHeaderFactory():Header
    {
        var header:Header = new Header();
        header.title = "TODOS";
        header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;

        if(!this._input)
        {
            this._input = new TextInput();
            this._input.prompt = "What needs to be done?";

            //we can't get an enter key event without changing the returnKeyLabel
            //not using ReturnKeyLabel.GO here so that it will build for web
            this._input.textEditorProperties.returnKeyLabel = "go";

            this._input.addEventListener(FeathersEventType.ENTER, input_enterHandler);
        }

        header.rightItems = new <DisplayObject>
        [
            this._input
        ];

        return header;
    }

    private function customFooterFactory():ScrollContainer
    {
        if(!this._toolbar)
        {
            this._toolbar = new ScrollContainer();
            this._toolbar.styleNameList.add(ScrollContainer.ALTERNATE_NAME_TOOLBAR);
        }
        else
        {
            this._toolbar.removeChildren();
        }

        if(!this._editButton)
        {
            this._editButton = new ToggleButton();
            this._editButton.label = "Edit";
            this._editButton.addEventListener(Event.CHANGE, editButton_changeHandler);
        }
        this._toolbar.addChild(this._editButton);


        if(!this._resetButton)
        {
            this._resetButton = new Button();
            this._resetButton.label = "Reset";
            this._resetButton.addEventListener(Event.TRIGGERED, resetButton_triggeredHandler);
        }
        this._toolbar.addChild(this._resetButton);

        return this._toolbar;
    }

    override protected function initialize():void
    {
        //never forget to call super.initialize()
        super.initialize();

        this.width = this.stage.stageWidth;
        this.height = this.stage.stageHeight;

        this.layout = new AnchorLayout();

        this.headerFactory = this.customHeaderFactory;
        this.footerFactory = this.customFooterFactory;

        this.list.isSelectable = false;
        this.list.dataProvider = provider;
        this.list.itemRendererType = TodoItemRenderer;
        this.list.itemRendererProperties.labelField = "description";
        var listLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
        listLayoutData.topAnchorDisplayObject = this._input;
        this.list.layoutData = listLayoutData;
        this.addChild(this.list);
    }

    private function addedToStageHandler():void
    {
        this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
    }

    private function removedFromStageHandler():void
    {
        this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
    }

    private function input_enterHandler():void
    {
        if(!this._input.text)
        {
            return;
        }

        this.list.dataProvider.addItem(new TodoItem(this._input.text));
        this._input.text = "";
    }

    private function editButton_changeHandler(event:Event):void
    {
        var isEditing:Boolean = this._editButton.isSelected;
        this.list.itemRendererProperties.isEditable = isEditing;
        this._input.visible = !isEditing;
    }

    private function resetButton_triggeredHandler(event:Event):void
    {
        provider.reset();
    }

    private function stage_resizeHandler():void
    {
        this.width = this.stage.stageWidth;
        this.height = this.stage.stageHeight;
    }
}
}
