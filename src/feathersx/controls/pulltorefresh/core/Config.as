/**
 * Created by max on 4/26/16.
 */
package feathersx.controls.pulltorefresh.core
{
import feathersx.controls.pulltorefresh.DefaultAssetsProvider;
import feathersx.controls.pulltorefresh.impl.FontawesomeDefaultAssetsProvider;

import flash.utils.Dictionary;

public class Config
{
    //--------------------------------------------------------------------------
    //
    //  Class functions
    //
    //--------------------------------------------------------------------------

    private static var _implementations:Dictionary = new Dictionary();
    {
        _implementations[DefaultAssetsProvider] = FontawesomeDefaultAssetsProvider;
    }

    public static function setImplementation(contract:Class, implementation:Class):void
    {
        _implementations[contract] = implementation;
    }

    public static function getImplementation(contract:Class):Class
    {
        return _implementations[contract];
    }

    public static function newInstance(contract:Class):Object
    {
        var Impl:Class = getImplementation(contract);

        return Impl != null ? new Impl() : null;
    }
}
}
