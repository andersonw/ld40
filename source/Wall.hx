package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

enum WallType{
    REGULAR;
    ICE;
}

class Wall extends FlxSprite
{
    public static var COLOR_REGULAR = new FlxColor(0xffa0a0a0);
    public static var COLOR_ICE = new FlxColor(0xffa5f2f3);

    public var wallType:WallType = REGULAR;
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32, ?wallType:WallType)
    {
        super(X, Y);
        this.wallType = wallType;

        switch(wallType){
            case REGULAR:
                makeGraphic(width, height, COLOR_REGULAR);
            case ICE:
                makeGraphic(width, height, COLOR_ICE);
            default:
                makeGraphic(width, height, COLOR_REGULAR);
        }
        immovable=true;
    }
}
