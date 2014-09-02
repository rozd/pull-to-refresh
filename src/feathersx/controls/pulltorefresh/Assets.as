/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/1/14
 * Time: 10:59 AM
 * To change this template use File | Settings | File Templates.
 */
package feathersx.controls.pulltorefresh
{
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

import starling.display.Image;
import starling.textures.Texture;

public class Assets
{
    [Embed(source="/fonts/fontawesome-webfont.ttf", fontName="FontAwesome", mimeType="application/x-font-truetype",
            embedAsCFF="true", fontStyle="normal", fontWeight="normal", unicodeRange="U+F1CE, U+F0AB")]
    private static const FONT_AWESOME:Class;

    private static const FONT_DESCRIPTION:FontDescription =
        new FontDescription("FontAwesome", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF);

    private static var _arrow:Texture;

    public static function get arrow():Texture
    {
        if (_arrow == null)
        {
            _arrow = createTextureFromGlyph("\uF0AB");
        }

        return _arrow;
    }

    private static var _spinner:Texture;

    public static function get spinner():Texture
    {
        if (_spinner == null)
        {
            _spinner = createTextureFromGlyph("\uF1CE");
        }

        return _spinner;
    }

    private static function createTextureFromGlyph(glyph:String):Texture
    {
        var element:TextElement = new TextElement(glyph, new ElementFormat(FONT_DESCRIPTION, 25, 0x333333));

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
