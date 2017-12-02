package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _level:Level;
	private var _player:Player;
    private var _levelFile:String;

	private var _collected:Int = 0;
	
	override public function create():Void
	{
		_levelFile = Registry.levelList[Registry.currLevel];
        _level = new Level(_levelFile);

		for(entityGroup in _level.entityGroups)	{
			add(entityGroup);
		}
		_player = new Player(_level.spawn.x, _level.spawn.y);
		add(_player);

		FlxG.camera.follow(_player);
		resetLevelBounds();

		InputManager.resetDisabledKeys();

		super.create();
	}

	public function playerToTheFloor(player:Player, floor:Wall)
	{
		if((floor.wasTouching & 256) != 0){	
			player.onFloor = true;
			player.canDash = true;
		}
	}

	public function playerToThePowerdown(player:Player, powerdown:Powerdown)
	{
		InputManager.disableKey(powerdown.key);
		powerdown.kill();

		_collected += 1;
		if(_collected == _level.totalPowerdowns){
			nextLevel();
		}
	}

	public function nextLevel()
	{
		if(Registry.currLevel < (Registry.levelList.length - 1)) {
			Registry.currLevel += 1;
			FlxG.switchState(new PlayState());
		}
		else
		{
			// FlxG.switchState(new EndState());
		}	
	}

	override public function update(elapsed:Float):Void
	{
		_player.onFloor = false;

		FlxG.collide(_player, _level.walls, playerToTheFloor);
		
		FlxG.overlap(_player, _level.powerdowns, playerToThePowerdown);

        if (FlxG.keys.justPressed.R) {
			InputManager.resetDisabledKeys();
            FlxG.switchState(new PlayState());
        }

		super.update(elapsed);
	}

	public function resetLevelBounds() {
		_level.updateBounds();
		FlxG.worldBounds.set(_level.bounds.x, _level.bounds.y, _level.bounds.width, _level.bounds.height);
	}
}


