package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class InputManager
{
	public static var disabledKeys:Array<FlxKey> = new Array<FlxKey>();

    public static function disableKey(key:FlxKey){
        if(disabledKeys.indexOf(key)==-1){
            disabledKeys.push(key);
        }
    }

    public static function resetDisabledKeys(){
        disabledKeys = new Array<FlxKey>();
    }

    public static function isPressed(key:FlxKey){
        if(disabledKeys.indexOf(key)!=-1){
            return false;
        }

        return FlxG.keys.anyPressed([key]);
    }

    public static function isJustPressed(key:FlxKey){
        if(disabledKeys.indexOf(key)!=-1){
            return false;
        }

        return FlxG.keys.anyJustPressed([key]);
    }
}


