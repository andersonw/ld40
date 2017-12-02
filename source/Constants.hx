package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class PlayerPhysics{
    public static inline var GRAVITY:Float = 10;

    public static inline var HORIZONTAL_TERMINAL_SPEED:Float = 200;
    public static inline var VERTICAL_TERMINAL_SPEED:Float = 600;

    public static inline var VERTICAL_DRAG:Float = 0.99;
    public static inline var HORIZONTAL_DRAG:Float = 1.00;
    public static inline var FLOOR_DRAG:Float = 0.85;

    public static inline var HORIZONTAL_ACCELERATION:Float = 50;
    public static inline var JUMP_SPEED:Float = 600;
    public static inline var DASH_LENGTH:Float = 150;

    public static inline var GRABBOX_WIDTH:Float = 40;
    public static inline var GRABBOX_HEIGHT:Float = 4;
}

class BoxPhysics{
    public static inline var GRAVITY:Float = 10;

    public static inline var HORIZONTAL_TERMINAL_SPEED:Float = 200;
    public static inline var VERTICAL_TERMINAL_SPEED:Float = 400;
    
    public static inline var VERTICAL_DRAG:Float = 0.99;
    public static inline var HORIZONTAL_DRAG:Float = 0.98;
    public static inline var FLOOR_DRAG:Float = 0.85;
}