package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Sign extends Wall
{
    public static inline var SIGN_WIDTH = 32;
    public static inline var SIGN_HEIGHT = 32;

    public var text:String = '';
    public function new(?X:Float=0, ?Y:Float=0, ?text='')
    {
        super(X, Y, SIGN_WIDTH, SIGN_HEIGHT);
        loadGraphic(AssetPaths.signpost__png);
        this.text = text;
        immovable=true;
    }
}
