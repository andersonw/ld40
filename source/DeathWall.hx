package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class DeathWall extends Wall
{
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32)
    {
        super(X, Y, width, height);
<<<<<<< HEAD
        makeGraphic(width, height, new FlxColor(0x00000000));
=======
        makeGraphic(width, height, new FlxColor(0xffdeaded));
        alpha = 0;
>>>>>>> 8f41018e602ec4d70145ef278a7e6755b20a8450
        immovable=true;
    }
}
