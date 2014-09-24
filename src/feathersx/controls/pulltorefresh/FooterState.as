/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 8/29/14
 * Time: 4:08 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
public class FooterState
{
    /**
     * Indicates normal state.
     */
    public static const PULL:String     = "pull";

    /**
     * Indicates state when User should release scrolling to start loading.
     */
    public static const RELEASE:String  = "release";

    /**
     * Indicates loading state
     */
    public static const LOADING:String  = "loading";

    /**
     * Indicates state when there is no more data on the Server to proceed.
     */
    public static const DONE:String     = "done";
}
}
