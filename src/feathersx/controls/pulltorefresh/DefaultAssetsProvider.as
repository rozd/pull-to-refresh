/**
 * Created by max on 4/26/16.
 */
package feathersx.controls.pulltorefresh
{
import starling.textures.Texture;

public interface DefaultAssetsProvider
{
    function getEmptyTexture():Texture;

    function getSpinnerTexture():Texture;

    function getWarningTexture():Texture;
    
    function getHeaderSpinnerTexture():Texture;
    
    function getFooterSpinnerTexture():Texture;
    
    function getHeaderArrowTexture():Texture;
}
}
