package;

class Registry
{
    public static var levelList:Array<String> = [
        // test levels
        AssetPaths.box_hell__tmx,
        AssetPaths.teleporters__tmx,
        AssetPaths.boxy__tmx,
        // real levels start here (should be ordered like how we want them in the actual game)
        AssetPaths.basic_movement__tmx,
        AssetPaths.tutorial_level_one__tmx,
<<<<<<< HEAD
=======
        AssetPaths.tutorial_reset__tmx,
        AssetPaths.box_intro_level__tmx,
>>>>>>> d3b72f41e875ad203b4e532d8fef9c51a45f2624
        AssetPaths.jumping_test__tmx,
        AssetPaths.box_intro_level__tmx,
        AssetPaths.two_jumps__tmx,
        AssetPaths.tutorial_level_two__tmx, 
        AssetPaths.big_cave__tmx,
        AssetPaths.long_icy_floor__tmx,
        AssetPaths.boxy_advanced__tmx
    ];

    public static var currLevel:Int = 0; 
}