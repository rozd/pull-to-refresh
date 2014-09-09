/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/5/14
 * Time: 3:16 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh.event
{
import starling.events.Event;

public class ProviderEvent extends Event
{
    public static const RELOAD:String = "reload";

    public function ProviderEvent(type:String, bubbles:Boolean = false, data:Object = null)
    {
        super(type, bubbles, data);
    }
}
}
