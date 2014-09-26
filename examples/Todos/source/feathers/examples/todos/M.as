/**
 * Created by mobitile on 9/25/14.
 */
package feathers.examples.todos
{
import feathers.controls.Drawers;
import feathers.examples.todos.Settings;
import feathers.themes.MetalWorksMobileTheme;

public class M extends Drawers
{
    public function M()
    {
        super();

        var content:Main = new Main();

        this.content = content;

        var settings:Settings = new Settings();
        settings.provider = content.provider;
        settings.pullToRefresh = content.list;

        this.rightDrawer = settings;

        openGesture = Drawers.OPEN_GESTURE_DRAG_CONTENT;
    }

    override protected function initialize():void
    {
        super.initialize();

        new MetalWorksMobileTheme();
    }
}
}
