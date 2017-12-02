package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _wall:Wall;
	
	override public function create():Void
	{
		_player = new Player(50, 50);
		add(_player);

		_wall = new Wall(50, 400, 400, 100);
		add(_wall);
		
		super.create();
	}

	public function playerToTheFloor(player:Player, floor:Wall)
	{
		player.onFloor = true;
	}

	override public function update(elapsed:Float):Void
	{
		_player.onFloor = false;
		FlxG.collide(_player, _wall, playerToTheFloor);
		
        if (FlxG.keys.justPressed.R) {
            FlxG.switchState(new PlayState());
        }

		super.update(elapsed);
	}
}


