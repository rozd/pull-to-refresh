/**
 * Created by mobitile on 9/25/14.
 */
package feathers.examples.todos
{
import feathers.controls.Drawers;
import feathers.examples.todos.Settings;
import feathers.themes.MetalWorksMobileTheme;

public class Main extends Drawers
{
    public function Main()
    {
        super();

        var content:GroupedContent = new GroupedContent();

        this.content = content;

        var settings:Settings = new Settings();
//        settings.provider = content.provider;
//        settings.pullToRefresh = content.list;
        settings.groupedProvider = content.provider;
        settings.groupedPullToRefresh = content.list;

        this.rightDrawer = settings;

        openGesture = Drawers.OPEN_GESTURE_DRAG_CONTENT;

        rightDrawerToggleEventType = "toggleSettings";
    }

    override protected function initialize():void
    {
        super.initialize();

        new MetalWorksMobileTheme();
    }
}
}
