package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

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
    public var bottom:FlxObject;

    private var _jumpSound:FlxSound;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        loadGraphic(AssetPaths.cat_sprite_sheet_2_trans__png, true, 32, 32);
        animation.add("r",[0,1],10,true);
        animation.add("l",[3,2],10,true);
        _jumpSound = FlxG.sound.load(AssetPaths.jump__wav, 0.3);
        alpha = DEFAULT_ALPHA;
        facing = FlxObject.RIGHT;

        grabBox = new FlxObject(0, 0, GRABBOX_WIDTH, GRABBOX_HEIGHT);
        bottom = new FlxObject(0, 0, width-BOTTOM_MARGIN, BOTTOM_HEIGHT);
    }

    public function carry(box:Box){
        isCarrying = true;
        carrying = box;

        height = 64;
        offset.y = -32;
        y -= 32;

        box.getCarried(this);
    }

    public function drop(){
        height = 32;   
        offset.y = 0;
        y += 32;     

        carrying.getDropped();
        carrying = null;
        isCarrying = false;
    }

    public function alignGrabbox(){
        grabBox.x = getMidpoint().x - GRABBOX_WIDTH/2;
        grabBox.y = getMidpoint().y - GRABBOX_HEIGHT/2;
    }

    public override function update(elapsed:Float):Void
    {
        movement();
        
        super.update(elapsed);
        alignGrabbox();
        
        //align bottom
        bottom.x = x+BOTTOM_MARGIN/2;
        bottom.y = y + height - BOTTOM_HEIGHT/2;

        if(isCarrying){
            carrying.alignWithCarrier();
        }
    }

    public function resetMovement():Void
    {
        velocity.x = 0;
        velocity.y = 0;
    }

    public function realignCarrying(){
        x = carrying.x - carrying.carrierOffset.x;
        y = carrying.y - carrying.carrierOffset.y;

        resetMovement();
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
        

        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        // horizontal stuff
        var vX:Float = velocity.x;
        var vY:Float = velocity.y;
        if (_left) {
            animation.play("l");
            vX -= HORIZONTAL_ACCELERATION;
            facing = FlxObject.LEFT;
        } else if (_right) {
            animation.play("r");
            vX += HORIZONTAL_ACCELERATION;
            facing = FlxObject.RIGHT;
        }
        else {
            animation.reset();
        }

        vY = vY + GRAVITY;

        if (_up && onFloor && Math.abs(vY-GRAVITY) < 50) {
            vY = -JUMP_SPEED;
            onFloor = false;
            _jumpSound.play();
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
