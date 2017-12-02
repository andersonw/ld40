package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _level:Level;

	private var _player:Player;
	
	override public function create():Void
	{
		_level = new Level(AssetPaths.test_level__tmx);

		for(entityGroup in _level.entityGroups)	{
			add(entityGroup);
		}
		_player = new Player(_level.spawn.x, _level.spawn.y);
		add(_player);
		FlxG.camera.follow(_player);
		resetLevelBounds();

		super.create();
	}

	public function playerToTheFloor(player:Player, floor:Wall)
	{
		player.onFloor = true;
	}

	override public function update(elapsed:Float):Void
	{
		_player.onFloor = false;
		FlxG.collide(_player, _level.walls, playerToTheFloor);
		
        if (FlxG.keys.justPressed.R) {
            FlxG.switchState(new PlayState());
        }

		super.update(elapsed);
	}

	public function resetLevelBounds() {
		_level.updateBounds();
		FlxG.worldBounds.set(_level.bounds.x, _level.bounds.y, _level.bounds.width, _level.bounds.height);
	}
}


