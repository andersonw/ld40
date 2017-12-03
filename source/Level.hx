package;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import Wall.WallType;

// adapted from https://github.com/HaxeFlixel/flixel-demos/blob/master/Editors/TiledEditor/source/TiledLevel.hx
class Level extends TiledMap {
    public var walls:FlxTypedGroup<Wall>;
    public var boxes:FlxTypedGroup<Box>;
    public var powerdowns:FlxTypedGroup<Powerdown>;
    public var deathWalls:FlxTypedGroup<DeathWall>;
    public var signs:FlxTypedGroup<Sign>;

    public var bounds:FlxRect;

    public var entityGroups:Array<FlxTypedGroup<Dynamic>>;

    public var spawn:FlxPoint;

    public var totalPowerdowns:Int;

    public function new(levelPath:String) {
        super(levelPath);

        walls = new FlxTypedGroup<Wall>();
        boxes = new FlxTypedGroup<Box>();
        powerdowns = new FlxTypedGroup<Powerdown>();
        deathWalls = new FlxTypedGroup<DeathWall>();
        signs = new FlxTypedGroup<Sign>();

        entityGroups = [walls, boxes, powerdowns, deathWalls, signs];

        for (layer in layers) {
            if (layer.type != TiledLayerType.OBJECT) continue;

            var objectLayer:TiledObjectLayer = cast layer;
            for (obj in objectLayer.objects) {
                switch(objectLayer.name) {
                    case "Walls":
                        var wallType:WallType = REGULAR;
                        if(obj.name == "ICE"){
                            wallType = ICE;
                        }
                        var levelObj:Wall = new Wall(obj.x, obj.y, obj.width, obj.height, wallType);
                        walls.add(levelObj);
                    case "Boxes":
                        var levelObj:Box = new Box(obj.x, obj.y, obj.width, obj.height);
                        boxes.add(levelObj);
                    case "Locations":
                        if(obj.name == "start")
                            spawn = new FlxPoint(obj.x, obj.y);
                    case "Powerdowns":
                        var levelObj:Powerdown = new Powerdown(FlxKey.fromString(obj.name), obj.x, obj.y);
                        powerdowns.add(levelObj);
                    case "Death":
                        var levelObj:DeathWall = new DeathWall(obj.x, obj.y, obj.width, obj.height);
                        deathWalls.add(levelObj);
                    case "Signs":
                        var levelObj:Sign = new Sign(obj.x, obj.y, obj.name);
                        signs.add(levelObj);
                }
            }
        }

        totalPowerdowns = powerdowns.length;

        // set level bounds (used for collision)
        updateBounds();
    }

    public function updateBounds() {
        // update bounds
        var minX:Float=0.;
        var maxX:Float=0.;
        var minY:Float=0.;
        var maxY:Float=0.;
        
        for(entityGroup in entityGroups) {
            for(obj in entityGroup) {
                minX = Math.min(minX, obj.x);
                maxX = Math.max(maxX, obj.x+obj.width);
                minY = Math.min(minY, obj.y);
                maxY = Math.max(maxY, obj.y+obj.height);
            }
        }

        bounds = new FlxRect(minX-100, minY-100, maxX-minX+200, maxY-minY+200);
    }
}