package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
    public static var DEFAULT_ALPHA = 0.6;

    // TODO: these dudes should be constants somewhere
    public var speed:Float = 200;
    public var gravity:Float = 5;
    public var jumpSpeed:Float = 400;
    public var verticalTerminalSpeed:Float = 400;
    public var verticalDrag:Float = 0.99;
    public var horizontalDrag:Float = 0.99;
    public var floorDrag:Float = 0.9;

    public var onFloor:Bool = false;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(32, 32, FlxColor.RED);
        alpha = DEFAULT_ALPHA;
    }

    public override function update(elapsed:Float):Void
    {
        movement();

        super.update(elapsed);
    }

    private function movement():Void
    {
        // adapted from http://haxeflixel.com/documentation/groundwork/
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;

        _up = FlxG.keys.anyPressed([UP]);
        _down = FlxG.keys.anyPressed([DOWN]);
        _left = FlxG.keys.anyPressed([LEFT]);
        _right = FlxG.keys.anyPressed([RIGHT]);

        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        // horizontal stuff
        var vX:Float = velocity.x;
        var vY:Float = velocity.y;
        if(_left){
            vX = -speed;
        }else if(_right){
            vX = speed;
        }

        vY = vY + gravity;
        /*
        if(vY > verticalTerminalSpeed){
            vY = verticalTerminalSpeed;
        }*/

        if(_up && onFloor){
            vY = -jumpSpeed;
            onFloor = false;
        }

        // apply drag
        if(onFloor){
            vX *= floorDrag;    
        }else{
            vX *= horizontalDrag;
        }
        vY *= verticalDrag;

        velocity.set(vX, vY);
/*
        if (_up || _down || _left || _right) {
            var mA:Float = 0;
            if(_up){
                mA = -90;
                if (_left){
                    mA -= 45;
                }else if(_right){
                    mA += 45;
                }
            }else if(_down){
                mA = 90;
                if(_left){
                    mA += 45;
                }else if(_right){
                    mA -= 45;
                }
            }else if(_left){
                mA = 180;
            }else if(_right){
                mA = 0;
            }
            velocity.set(speed, 0);
            velocity.rotate(FlxPoint.weak(0,0), mA);
        }
        else {
            velocity.set(0, 0);
        }*/
    }
}
