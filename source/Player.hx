package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
    public static var DEFAULT_ALPHA = 0.6;

    // TODO: these dudes should be constants somewhere
    public var gravity:Float = 10;
    public var jumpSpeed:Float = 400;
    public var horizontalTerminalSpeed:Float = 200;
    public var verticalTerminalSpeed:Float = 400;
    public var horizontalAcceleration:Float = 50;
    public var verticalDrag:Float = 0.99;
    public var horizontalDrag:Float = 0.98;
    public var floorDrag:Float = 0.85;

    public var dashLength:Float = 150;

    public var onFloor:Bool = false;
    public var canDash:Bool = false;

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

        _up = InputManager.isPressed(UP);
        _down = InputManager.isPressed(DOWN);
        _left = InputManager.isPressed(LEFT);
        _right = InputManager.isPressed(RIGHT);

        var _upDash = InputManager.isJustPressed(W);
        var _leftDash = InputManager.isJustPressed(A);
        var _rightDash = InputManager.isJustPressed(D);
        var _downDash = InputManager.isJustPressed(S);

        // only consider dash input if dash input is pressed
        if(canDash && (_upDash || _leftDash || _rightDash || _downDash)){
            if(_upDash){
                y -= dashLength;
                onFloor = false;
            }else if(_leftDash){
                x -= dashLength;
            }else if(_rightDash){
                x += dashLength;
            }else if(_downDash){
                y += dashLength;
            }

            canDash = false;
            return;
        }
        

        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        // horizontal stuff
        var vX:Float = velocity.x;
        var vY:Float = velocity.y;
        if (_left) {
            vX -= horizontalAcceleration;
        } else if (_right) {
            vX += horizontalAcceleration;
        }

        // terminal horizontal velocity
        if(vX > horizontalTerminalSpeed){
            vX = horizontalTerminalSpeed;
        }else if(vX < -horizontalTerminalSpeed){
            vX = -horizontalTerminalSpeed;
        }

        vY = vY + gravity;

        if (_up && onFloor) {
            vY = -jumpSpeed;
            onFloor = false;
        }

        // apply drag
        if (onFloor) {
            // no drag if holding left or right
            if(!(_left || _right)){
                vX *= floorDrag;    
            }
        } else {
            vX *= horizontalDrag;
        }
        vY *= verticalDrag;


        if (vX < 0.01 && vX > -0.01) vX = 0;
        velocity.set(vX, vY);
    }
}
