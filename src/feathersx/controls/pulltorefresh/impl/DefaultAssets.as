/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 10:59 AM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh.impl
{
import feathersx.controls.pulltorefresh.core.*;
import feathersx.controls.pulltorefresh.DefaultAssetsProvider;
import feathersx.controls.pulltorefresh.core.Config;
import feathersx.controls.pulltorefresh.impl.FontawesomeDefaultAssetsProvider;

import starling.textures.Texture;

public class DefaultAssets
{
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    private static const defaultAssetProvider:DefaultAssetsProvider = new FontawesomeDefaultAssetsProvider();

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    private static var _assetProvider:DefaultAssetsProvider;

    public static function get provider():DefaultAssetsProvider
    {
        if (_assetProvider == null)
        {
            _assetProvider = Config.newInstance(DefaultAssetsProvider) as DefaultAssetsProvider;

            if (_assetProvider == null)
            {
                _assetProvider = defaultAssetProvider;
            }
        }

        return _assetProvider;
    }

    //--------------------------------------------------------------------------
    //
    //  Class getters
    //
    //--------------------------------------------------------------------------

    public static function get spinner():Texture
    {
        return provider.getSpinnerTexture() || defaultAssetProvider.getSpinnerTexture();
    }

    public static function get emptyState():Texture
    {
        return provider.getEmptyTexture() || defaultAssetProvider.getEmptyTexture();
    }

    public static function get errorState():Texture
    {
        return provider.getWarningTexture() || defaultAssetProvider.getWarningTexture();
    }

    public static function get headerArrow():Texture
    {
        return provider.getHeaderArrowTexture() || defaultAssetProvider.getHeaderArrowTexture();
    }

    public static function get headerSpinner():Texture
    {
        return provider.getHeaderSpinnerTexture() || defaultAssetProvider.getHeaderSpinnerTexture();
    }

    public static function get footerSpinner():Texture
    {
        return provider.getFooterSpinnerTexture() || defaultAssetProvider.getFooterSpinnerTexture();
    }
}
}
