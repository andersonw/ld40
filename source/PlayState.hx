package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;


class PlayState extends FlxState
{
	private var _level:Level;
	private var _player:Player;
    private var _levelFile:String;

	private var _collected:Int;
	private var _tooltip:FlxText;
	
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

		FlxG.camera.follow(_player, TOPDOWN, 5);
		resetLevelBounds();

		_tooltip = new FlxText();
		_tooltip.setFormat(AssetPaths.pixelmix__ttf, 16, FlxColor.YELLOW);
		_tooltip.visible = false;
		_tooltip.alpha = 0.6;
		add(_tooltip);

		InputManager.resetDisabledKeys();
		_collected = 0;

		super.create();
	}

	public function playerToTheFloor(player:Player, floor:Wall)
	{
		if(player.isTouching(FlxObject.DOWN)){
			player.onFloor = true;
			player.canDash = true;

			if(floor.wallType == ICE){
				player.onIce = true;
			}else{
				player.onIce = false;
			}
		}

		if(player.onFloor){
			if(player.isTouching(FlxObject.LEFT) || 
			   player.isTouching(FlxObject.RIGHT)){
				player.y -= 3;
				if(player.isTouching(FlxObject.LEFT)){
					player.x += 2;
				}
				else
				{
					player.x -= 2;
				}
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

	public function swapTeleporters(){
		if(!_level.hasTeleporters){
			return;
		}

		var t1contents:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();
		var t2contents:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

		for(entityGroup in _level.entityGroups)
		{
			for(entity in entityGroup)
			{
				if(_level.teleporter1.contains(entity))
				{
					t1contents.add(entity);
				}
				if(_level.teleporter2.contains(entity))
				{
					t2contents.add(entity);
				}
			}
		}
		if(_level.teleporter1.contains(_player)){
			t1contents.add(_player);
		}
		if(_level.teleporter2.contains(_player)){
			t2contents.add(_player);
		}

		for(entity in t1contents)
		{
			entity.x = _level.teleporter2.x + (entity.x - _level.teleporter1.x);
			entity.y = _level.teleporter2.y + (entity.y - _level.teleporter1.y);
		}

		for(entity in t2contents)
		{
			entity.x = _level.teleporter1.x + (entity.x - _level.teleporter2.x);
			entity.y = _level.teleporter1.y + (entity.y - _level.teleporter2.y);
		}
	}

	public function resetLevel(){
		FlxG.switchState(new PlayState());
	}

	public function updateTooltip(player:Player, sign:Sign)
	{
		var helpText:String = sign.text;
		if (helpText != "")
		{
			_tooltip.text = helpText;
			_tooltip.x = sign.x+(sign.width-_tooltip.width)/2;
			_tooltip.y = sign.y-_tooltip.height;
			_tooltip.visible = true;
		}
	}

	override public function update(elapsed:Float):Void
	{
		_tooltip.visible = false;
		_player.onFloor = false;
		for(box in _level.boxes){
			box.onFloor = false;
		}

		// only collide with boxes you're not carrying
		for(box in _level.boxes){
			if(!box.carried){
				FlxG.collide(_player, box, playerToTheFloor);
			}
		}

		FlxG.collide(_level.boxes, _level.boxes, boxToTheFloor);
		FlxG.collide(_level.boxes, _level.walls, boxToTheFloor);

		FlxG.collide(_player, _level.walls, playerToTheFloor);
		

		FlxG.overlap(_player, _level.deathWalls, playerToTheDeath);
		FlxG.overlap(_player, _level.powerdowns, playerToThePowerdown);

		FlxG.overlap(_player, _level.signs, updateTooltip);

		if(InputManager.isJustPressed(C)){
			if(_player.isCarrying){
				_player.drop();
			}else{
				FlxG.overlap(_player.grabBox, _level.boxes, carryBox);
			}
		}

		if(InputManager.isJustPressed(V)){
			swapTeleporters();
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


