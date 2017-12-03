package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxAxes;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Powerdown extends FlxEffectSprite
{
    public var key:FlxKey;
    public var sprite:FlxSprite;

    public function new(key:FlxKey, ?X:Float=0, ?Y:Float=0)
    {
        this.sprite = new FlxSprite(X, Y);
        
        // , [new FlxShakeEffect(5, 0.5, null, FlxAxes.Y)]
        this.key = key;
        switch(key) {
            case LEFT: this.sprite.loadGraphic("assets/images/leftarrow.png");
            case RIGHT: this.sprite.loadGraphic("assets/images/rightarrow.png");
            case DOWN: this.sprite.loadGraphic("assets/images/downarrow.png");
            case UP: this.sprite.loadGraphic("assets/images/uparrow.png");
            default: this.sprite.makeGraphic(32, 32, new FlxColor(0xff00ff00));
        }

        var _shake = new FlxShakeEffect(5, 1, null, FlxAxes.Y);
        var _wave = new FlxWaveEffect(FlxWaveMode.ALL);
        super(sprite, [_wave, _shake]);
        setPosition(X, Y);
        immovable=true;
    }

    public override function kill()
    {
        super.kill();
        this.sprite.kill();
    }
}
