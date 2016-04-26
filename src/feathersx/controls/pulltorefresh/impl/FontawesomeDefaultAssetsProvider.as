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

public class FontawesomeDefaultAssetsProvider implements DefaultAssetsProvider
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    [Embed(source="/fonts/fontawesome-webfont.ttf", fontName="FontAwesomeEmbedded", mimeType="application/x-font-truetype",
        embedAsCFF="true", fontStyle="normal", fontWeight="normal", unicodeRange="U+F1CE, U+F0AB, U+F071, U+F01C")]
    private static const FONT_AWESOME:Class;

    private static const FONT_DESCRIPTION:FontDescription =
        new FontDescription("FontAwesomeEmbedded", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    public function FontawesomeDefaultAssetsProvider()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var inbox:Texture = createTextureFromGlyph("\uF01C", {fontSize : 48, color : 0x666666});

    private var arrow:Texture = createTextureFromGlyph("\uF0AB");
    
    private var warning:Texture = createTextureFromGlyph("\uF071", {fontSize : 48, color : 0x666666});

    private var largeSpinner:Texture = createTextureFromGlyph("\uF1CE", {fontSize:48, color:0x666666});
    
    private var smallSpinner:Texture = createTextureFromGlyph("\uF1CE");

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

    private static function createTextureFromGlyph(glyph:String, options:Object=null):Texture
    {
        var format:ElementFormat = new ElementFormat(FONT_DESCRIPTION, 25, 0x0000CC);

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

        var arrowBlock:TextBlock = new TextBlock(element);
        var arrowTextLine:TextLine = arrowBlock.createTextLine(null);

        var size:Number = Math.max(arrowTextLine.width, arrowTextLine.height) + 1;

        var matrix:Matrix = new Matrix();
        matrix.tx = (size - arrowTextLine.width) / 2;
        matrix.ty = arrowTextLine.ascent + (size - arrowTextLine.height) / 2;

        var bmd:BitmapData = new BitmapData(size, size, true, 0x00FF0000);
        bmd.draw(arrowTextLine, matrix, null, null, null, true);

        return Texture.fromBitmapData(bmd);
    }
}
}
