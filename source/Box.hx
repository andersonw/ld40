package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;


import Constants.BoxPhysics.*;

class Box extends Wall
{
    public var carrier:FlxSprite;
    public var carried:Bool = false;
    public var carrierOffset:FlxPoint;

    public var onFloor:Bool = false;
    public var onIce:Bool = false;

    public var oldX:Float;
    public var oldY:Float;

    public var bottom:FlxObject;

    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32)
    {
        super(X, Y, width, height);
        loadGraphic(AssetPaths.cardboard_box__png);
        immovable=false;

        bottom = new FlxObject(0,0,width-BOTTOM_MARGIN, BOTTOM_HEIGHT);
    }

    public function getCarried(carrier:FlxSprite){
        this.carrier = carrier;
        //carrierOffset = new FlxPoint(x - carrier.x, y - carrier.y);
        carrierOffset = new FlxPoint(0, 0);
        
        carried = true;
    }

    public function getDroppedPosition():FlxPoint
    {
        var ny = carrier.y;
        var nx = carrier.x;
        if(carrier.facing == FlxObject.RIGHT)
        {
            nx += (carrier.width+3);
        }
        else
        {
            nx -= (carrier.width+3);
        }

        return new FlxPoint(nx, ny);
    }

    public function getDropped(){
        this.velocity.x = carrier.velocity.x;
        this.velocity.y = carrier.velocity.y;

        // drop offset

        var newLoc = getDroppedPosition();
        setPosition(newLoc.x, newLoc.y);

        carrier = null;
        carried = false;

        onFloor = false;
        onIce = false;
    }

    public override function update(elapsed:Float):Void
    {
        movement();

        super.update(elapsed);

        //align bottom
        bottom.x = x+BOTTOM_MARGIN/2;
        bottom.y = y + height - BOTTOM_HEIGHT/2;
    }

    public function alignWithCarrier():Void
    {
        x = carrier.x + carrierOffset.x;
        y = carrier.y + carrierOffset.y;
        velocity.x = carrier.velocity.x;
        velocity.y = carrier.velocity.y;
    }

    private function movement():Void
    {
        if(!carried){
            // horizontal stuff
            var vX:Float = velocity.x;
            var vY:Float = velocity.y;
            vY = vY + GRAVITY;

            // apply drag
            if (onFloor) {
                // no drag if holding left or right or if on ice
                if(!onIce){
                    vX *= FLOOR_DRAG;    
                }
            } else {
                vX *= HORIZONTAL_DRAG;
            }
            vY *= VERTICAL_DRAG;

            if (onFloor) {
                vY = 0;
            }

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
}
