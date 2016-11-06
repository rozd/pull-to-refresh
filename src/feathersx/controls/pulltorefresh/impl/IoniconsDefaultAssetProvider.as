/**
 * Created by max on 4/26/16.
 */
package feathersx.controls.pulltorefresh.impl
{
import feathersx.controls.pulltorefresh.DefaultAssetsProvider;

import flash.display.BitmapData;

import flash.geom.Matrix;

import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.FontLookup;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;
import flash.text.engine.TextLine;

import starling.textures.Texture;

public class IoniconsDefaultAssetProvider implements DefaultAssetsProvider
{
    //--------------------------------------------------------------------------
    //
    //  Embedded assets
    //
    //--------------------------------------------------------------------------

    [Embed(source="/fonts/ionicons.ttf", fontName="IoniconsPullToRefresh", mimeType="application/x-font-truetype",
        embedAsCFF="true", fontStyle="normal", fontWeight="normal", unicodeRange="U+F428, U+F366, U+F100, U+F29C, U+F35D")]
    private static const IONICONS:Class;

    private static const FONT_DESCRIPTION:FontDescription =
        new FontDescription("IoniconsPullToRefresh", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);
   
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    protected static const FONT_SIZE:int = 26;
    
    protected static const FONT_COLOR:int = 0x0000CC;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    public function IoniconsDefaultAssetProvider()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var inbox:Texture = createTextureFromGlyph("\uF428", {fontSize : 48, color : 0x666666});

    private var arrow:Texture = createTextureFromGlyph("\uF35D");

    private var warning:Texture = createTextureFromGlyph("\uF100", {fontSize : 48, color : 0x666666});

    private var largeSpinner:Texture = createTextureFromGlyph("\uF29C", {fontSize: 48, color: 0x666666});

    private var smallSpinner:Texture = createTextureFromGlyph("\uF29C");

    //--------------------------------------------------------------------------
    //
    //  Getters
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Methods: API
    //-------------------------------------

    public function getEmptyTexture():Texture
    {
        return inbox;
    }

    public function getSpinnerTexture():Texture
    {
        return largeSpinner;
    }

    public function getWarningTexture():Texture
    {
        return warning;
    }

    public function getHeaderSpinnerTexture():Texture
    {
        return smallSpinner;
    }

    public function getFooterSpinnerTexture():Texture
    {
        return smallSpinner;
    }

    public function getHeaderArrowTexture():Texture
    {
        return arrow;
    }

    //-------------------------------------
    //  Methods: Private
    //-------------------------------------

    protected function createTextureFromGlyph(glyph:String, options:Object=null):Texture
    {
        var format:ElementFormat = new ElementFormat(FONT_DESCRIPTION, FONT_SIZE, FONT_COLOR);

        if (options != null)
        {
            for (var name:String in options)
            {
                if (format.hasOwnProperty(name))
                {
                    format[name] = options[name];
                }
            }
        }

        var element:TextElement = new TextElement(glyph, format);

        var textBlock:TextBlock = new TextBlock(element);
        var textLine:TextLine = textBlock.createTextLine(null);

        var size:Number = Math.max(textLine.width, textLine.height) + 1;

        var matrix:Matrix = new Matrix();
        matrix.tx = (size - textLine.width) / 2;
        matrix.ty = textLine.ascent + (size - textLine.height) / 2;

        var bmd:BitmapData = new BitmapData(size, size, true, 0x00FF0000);
        bmd.draw(textLine, matrix, null, null, null, true);

        return Texture.fromBitmapData(bmd);
    }

}
}
