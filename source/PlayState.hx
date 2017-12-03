package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _level:Level;
	private var _player:Player;
    private var _levelFile:String;

	private var _collected:Int;
	
	override public function create():Void
	{
		_levelFile = Registry.levelList[Registry.currLevel];
        _level = new Level(_levelFile);

		for(entityGroup in _level.entityGroups)	{
			add(entityGroup);
		}
		_player = new Player(_level.spawn.x, _level.spawn.y);

		_player.resetMovement();
		add(_player);
		add(_player.grabBox);

		FlxG.camera.follow(_player);
		resetLevelBounds();

		InputManager.resetDisabledKeys();
		_collected = 0;

		super.create();
	}

	public function playerToTheFloor(player:Player, floor:Wall)
	{
		//trace(floor.wasTouching);
		if((floor.wasTouching & 256) != 0){	
			player.onFloor = true;
			player.canDash = true;

			if(floor.wallType == ICE){
				player.onIce = true;
			}else{
				player.onIce = false;
			}
		}

		if(player.onFloor){
			if((floor.wasTouching & 1) != 0 || (floor.wasTouching & 16) != 0){
				player.y -= 3;
			}
		}
		
	}

	public function boxToTheFloor(box:Box, floor:Wall)
	{
		// trace(floor.wasTouching);
		box.onFloor = true;

		if(floor.wallType == ICE){
			box.onIce = true;
		}else{
			box.onIce = false;
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

	public function playerToTheDeath(player:Player, death:DeathWall){
		resetLevel();
	}

	public function carryBox(grabBox:FlxObject, box:Box){
		if(!box.carried && !_player.isCarrying)
		{
			_player.carry(box);
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

	public function resetLevel(){
		FlxG.switchState(new PlayState());
	}

	override public function update(elapsed:Float):Void
	{
		_player.onFloor = false;
		for(box in _level.boxes){
			box.onFloor = false;
		}

		//hacky fix to make boxes not move when players run into them
		/*
		for(box in _level.boxes){
			if(!box.carried) box.immovable=true;
		}*/
		FlxG.collide(_player, _level.boxes, playerToTheFloor);
		/*
		for(box in _level.boxes){
			box.immovable=false;
		}*/
		FlxG.collide(_level.boxes, _level.boxes, boxToTheFloor);
		FlxG.collide(_level.boxes, _level.walls, boxToTheFloor);

		FlxG.collide(_player, _level.walls, playerToTheFloor);
		
		FlxG.overlap(_player, _level.deathWalls, playerToTheDeath);
		FlxG.overlap(_player, _level.powerdowns, playerToThePowerdown);

		if(InputManager.isJustPressed(C)){
			if(_player.isCarrying){
				_player.drop();
			}else{
				FlxG.overlap(_player.grabBox, _level.boxes, carryBox);
			}
		}

        if (FlxG.keys.justPressed.R) {
            resetLevel();
        }

        if (FlxG.keys.justPressed.N) {
			InputManager.resetDisabledKeys();
            if (Registry.currLevel + 1 < Registry.levelList.length) {
                Registry.currLevel += 1;
            } 
            FlxG.switchState(new PlayState());
        }

        if (FlxG.keys.justPressed.B) {
			InputManager.resetDisabledKeys();
            if (Registry.currLevel != 0) {
                Registry.currLevel -= 1;
            }
            FlxG.switchState(new PlayState());
        }

		super.update(elapsed);
	}

	public function resetLevelBounds() {
		_level.updateBounds();
		FlxG.worldBounds.set(_level.bounds.x, _level.bounds.y, _level.bounds.width, _level.bounds.height);
		FlxG.camera.setScrollBoundsRect(_level.bounds.x, _level.bounds.y, _level.bounds.width, _level.bounds.height);
	}
}


