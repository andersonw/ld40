package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _wall:Wall;
	private var _wall2:Wall;
	
	override public function create():Void
	{
		_player = new Player(50, 50);
		add(_player);

		_wall = new Wall(50, 400, 400, 100);
		add(_wall);

		_wall2 = new Wall(150, 250, 200, 100);
		add(_wall2);
		
		super.create();
	}

	public function playerToTheFloor(player:Player, floor:Wall)
	{
		if((floor.wasTouching & 256) != 0){	
			player.onFloor = true;
		}
	}

	override public function update(elapsed:Float):Void
	{
		_player.onFloor = false;
		FlxG.collide(_player, _wall, playerToTheFloor);
		FlxG.collide(_player, _wall2, playerToTheFloor);
		
		super.update(elapsed);
	}
}


