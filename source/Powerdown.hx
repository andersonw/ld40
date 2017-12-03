package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxAxes;
import flixel.addons.effects.chainable.FlxRainbowEffect;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Powerdown extends FlxSprite
{
    public var key:FlxKey;

    private var _tween:FlxTween;
    //public var sprite:FlxSprite;

    public function new(key:FlxKey, ?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        this.key = key;
        switch(key) {
            case LEFT: loadGraphic(AssetPaths.leftarrow_keyboard__png);
            case RIGHT: loadGraphic(AssetPaths.rightarrow_keyboard__png);
            case DOWN: loadGraphic(AssetPaths.downarrow_keyboard__png);
            case UP: loadGraphic(AssetPaths.uparrow_keyboard__png);
            case C: loadGraphic(AssetPaths.c_keyboard__png);
            default: makeGraphic(32, 32, new FlxColor(0xff00ff00));
        }

        // var _shake = new FlxShakeEffect(5, 1, null, FlxAxes.Y);
        // var _wave = new FlxRainbowEffect(0.3);
        // effectSprite = new FlxEffectSprite(this, [_wave]);
        // effectSprite.setPosition(X,Y);
        // visible = false;
        //trace(width);
        //trace(height);
        var tweenDelay:Float = Math.random()/2;
        _tween = FlxTween.tween(this, { x: this.x, y: this.y-5 }, 2, 
                                { type: FlxTween.PINGPONG, ease: FlxEase.quadInOut, startDelay: tweenDelay });

        immovable=true;
    }

    public override function kill()
    {
        _tween.cancel();
        super.kill();
    }
}
