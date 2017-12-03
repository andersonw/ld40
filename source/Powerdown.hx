package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxAxes;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Powerdown extends FlxSprite
{
    public var key:FlxKey;
    public var effectSprite:FlxEffectSprite;
    //public var sprite:FlxSprite;

    public function new(key:FlxKey, ?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        this.key = key;
        switch(key) {
            case LEFT: loadGraphic("assets/images/leftarrow.png");
            case RIGHT: loadGraphic("assets/images/rightarrow.png");
            case DOWN: loadGraphic("assets/images/downarrow.png");
            case UP: loadGraphic("assets/images/uparrow.png");
            default: makeGraphic(32, 32, new FlxColor(0xff00ff00));
        }

        var _shake = new FlxShakeEffect(5, 1, null, FlxAxes.Y);
        var _wave = new FlxWaveEffect(FlxWaveMode.ALL);
        effectSprite = new FlxEffectSprite(this, [_wave, _shake]);
        effectSprite.setPosition(X,Y);

        //trace(width);
        //trace(height);

        immovable=true;
    }

    public override function kill()
    {
        super.kill();
        effectSprite.kill();
    }
}
