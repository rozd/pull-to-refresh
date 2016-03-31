/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 8/29/14
 * Time: 12:36 PM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
public class HeaderState
{
    /**
     * Indicates normal state.
     */
    public static const PULL:String = "pull";

    /**
     * Indicates state when User should release scrolling to start loading.
     */
    public static const RELEASE:String = "release";

    /**
     * Indicates loading state.
     */
    public static const LOADING:String = "loading";

    /**
     * Indicates state when loading is complete (succeeded or failed).
     */
    public static const FREE:String = "free";

    /**
     * Indicates state when Server will never have new items to refresh.
     */
    public static const DONE:String = "done";
}
}
