package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Registry
{
    public static var levelList:Array<String> = [
<<<<<<< HEAD
        // test levels
    //    AssetPaths.box_hell__tmx,
    //    AssetPaths.teleporters__tmx,
    //    AssetPaths.boxy__tmx,
=======
        // // test levels
        // AssetPaths.box_hell__tmx,
        // AssetPaths.teleporters__tmx,
        // AssetPaths.boxy__tmx,
>>>>>>> 8f41018e602ec4d70145ef278a7e6755b20a8450
        // real levels start here (should be ordered like how we want them in the actual game)
        AssetPaths.basic_movement__tmx,
        AssetPaths.tutorial_level_one__tmx,
        AssetPaths.jumping_test__tmx,
        AssetPaths.tutorial_level_two__tmx, 
        AssetPaths.big_cave__tmx,
        AssetPaths.two_jumps__tmx,
        AssetPaths.long_icy_floor__tmx,
        AssetPaths.six_platforms__tmx,
        AssetPaths.box_intro_level__tmx,
        AssetPaths.box_ice_test__tmx,
        AssetPaths.skiing__tmx,
        AssetPaths.boxy_advanced__tmx
    ];

    public static var levelInitialized:Array<Bool> = [for (i in 0...levelList.length) false];

    public static var levelNames:Array<String> = [
<<<<<<< HEAD
    //    "Cats love test levels! ",
    //    "Cats love test levels! ",
    //    "Cats love test levels! ",
=======
        // "Cats love test levels! ",
        // "Cats love test levels! ",
        // "Cats love test levels! ",
>>>>>>> 8f41018e602ec4d70145ef278a7e6755b20a8450
        "Cats love moving around! ",
        "Cats love keys! ",
        "Cats love jumping! ",
        "Cats love ice! ",
        "Cats love stacks! ",
        "Cats love platforms! ",
        "Cats love adventures! ",
        "Cats love big spaces! ",
        "Cats love boxes! ",
<<<<<<< HEAD
        "Cats love high places! ",
=======
        "Cats love heights! ",
>>>>>>> 8f41018e602ec4d70145ef278a7e6755b20a8450
        "Cats love skiing! ",
        "Cats love puzzles! "
    ];

    public static var currLevel:Int = 0; 

    public static var defaultTransIn:TransitionData;
    public static var defaultTransOut:TransitionData;

    private static var _initialized:Bool = false;

    public static function init() {
        if (_initialized) return;

        _initialized = true;

		defaultTransIn = new TransitionData();
		defaultTransOut = new TransitionData();
			
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileCircle);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
			
        defaultTransIn.color = FlxColor.WHITE;
        defaultTransOut.color = FlxColor.WHITE;
        defaultTransIn.direction = new FlxPoint(1, 0);
        defaultTransOut.direction = new FlxPoint(-1, 0);
        defaultTransIn.duration = 1.0;
        defaultTransOut.duration = 1.0;
        defaultTransIn.type = TransitionType.FADE;
        defaultTransOut.type = TransitionType.FADE;
		defaultTransIn.tileData = { asset: diamond, width: 32, height: 32 };
		defaultTransOut.tileData = { asset: diamond, width: 32, height: 32 };
    }

}