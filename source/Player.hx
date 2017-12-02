package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

import Constants.PlayerPhysics.*;

class Player extends FlxSprite
{
    public static var DEFAULT_ALPHA = 0.6;

    public var onFloor:Bool = false;
    public var onIce:Bool = false;
    public var canDash:Bool = false;

    public var isCarrying:Bool = false;
    public var carrying:Box;

    public var grabBox:FlxObject;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(32, 32, FlxColor.RED);
        alpha = DEFAULT_ALPHA;

        grabBox = new FlxObject(0, 0, GRABBOX_WIDTH, GRABBOX_HEIGHT);
    }

    public function carry(box:Box){
        isCarrying = true;
        carrying = box;

        box.getCarried(this);
    }

    public function drop(){
        carrying.getDropped();
        carrying = null;
        isCarrying = false;
    }

    public function alignGrabbox(){
        grabBox.x = this.getMidpoint().x - GRABBOX_WIDTH/2;
        grabBox.y = this.getMidpoint().y - GRABBOX_HEIGHT/2;
    }

    public override function update(elapsed:Float):Void
    {
        alignGrabbox();
        movement();
        
        super.update(elapsed);

        if(isCarrying){
            carrying.alignWithCarrier();
        }
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
                y -= DASH_LENGTH;
            }else if(_downDash){
                y += DASH_LENGTH;
            }else if(_leftDash){
                x -= DASH_LENGTH;
            }else if(_rightDash){
                x += DASH_LENGTH;
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
            vX -= HORIZONTAL_ACCELERATION;
        } else if (_right) {
            vX += HORIZONTAL_ACCELERATION;
        }

        vY = vY + GRAVITY;

        if (_up && onFloor) {
            vY = -JUMP_SPEED;
            onFloor = false;
        }

        // apply drag
        if (onFloor) {
            // no drag if holding left or right or if on ice
            if(!(_left || _right || onIce)){
                vX *= FLOOR_DRAG;    
            }
        } else {
            vX *= HORIZONTAL_DRAG;
        }
        vY *= VERTICAL_DRAG;


        // terminal speeds
        // (for the most part air resistance should take care of this) 
        if(vX > HORIZONTAL_TERMINAL_SPEED){
            vX = HORIZONTAL_TERMINAL_SPEED;
        }else if(vX < -HORIZONTAL_TERMINAL_SPEED){
            vX = -HORIZONTAL_TERMINAL_SPEED;
        }

        if(vY > VERTICAL_TERMINAL_SPEED){
            vY = VERTICAL_TERMINAL_SPEED;
        }else if(vY < -VERTICAL_TERMINAL_SPEED){
            vY = -VERTICAL_TERMINAL_SPEED;
        }

        if (vX < 0.01 && vX > -0.01) vX = 0;
        velocity.set(vX, vY);
    }
}
