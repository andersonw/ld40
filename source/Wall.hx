package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

enum WallType{
    REGULAR;
    ICE;
}

class Wall extends FlxSprite
{
    public static var COLOR_REGULAR = new FlxColor(0xff98fb98);
    public static var OUTLINE_REGULAR = new FlxColor(0xff2d4b2d);
    public static var COLOR_ICE = new FlxColor(0xffa5f2f3);
    public static var OUTLINE_ICE = new FlxColor(0xff0099ff);

    public var wallType:WallType = REGULAR;
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32, ?wallType:WallType)
    {
        super(X, Y);
        this.wallType = wallType;

        makeGraphic(width, height, FlxColor.TRANSPARENT, true);
        switch(wallType){
            case REGULAR:
                FlxSpriteUtil.drawRoundRect(this, 0, 0, width, height, 5, 5, OUTLINE_REGULAR);
                FlxSpriteUtil.drawRoundRect(this, 2, 2, width-4, height-4, 5, 5, COLOR_REGULAR);
            case ICE:
                FlxSpriteUtil.drawRoundRect(this, 0, 0, width, height, 5, 5, OUTLINE_ICE);
                FlxSpriteUtil.drawRoundRect(this, 2, 2, width-4, height-4, 5, 5, COLOR_ICE);
            default:
                makeGraphic(width, height, COLOR_REGULAR);
        }
        immovable=true;
    }
}

/*
FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
        if(pickedUp)
        {
            if(inBin)
                FlxSpriteUtil.drawEllipse(this, 0, 0, frameWidth, frameHeight, FlxColor.GREEN);
            else
                FlxSpriteUtil.drawEllipse(this, 0, 0, frameWidth, frameHeight, FlxColor.RED);
            FlxSpriteUtil.drawEllipse(this, 2, 2, frameWidth-4, frameHeight-4, FlxColor.ORANGE);
        }else{
            FlxSpriteUtil.drawEllipse(this, 0, 0, frameWidth, frameHeight, FlxColor.ORANGE);
        }
        
        */
