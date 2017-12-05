package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Teleporter extends Wall
{
    public static inline var TELEPORTER_WIDTH = 48;
    public static inline var TELEPORTER_HEIGHT = 48;

    public var target:Teleporter;
    public var isLinked:Bool = false;
    public function new(?X:Float=0, ?Y:Float=0, ?text='')
    {
        super(X, Y, TELEPORTER_WIDTH, TELEPORTER_HEIGHT);
        makeGraphic(TELEPORTER_WIDTH, TELEPORTER_HEIGHT, 
                    new FlxColor(0xffff1010));
        immovable=true;
    }

    public function link(target:Teleporter)
    {
        this.target = target;
        isLinked = true;
    }

    public function contains(obj:FlxObject)
    {
        return ((obj.x > x) && 
                (obj.x + obj.width < x + width) &&
                (obj.y > y) &&
                (obj.y + obj.height < y + height));
    }
}
