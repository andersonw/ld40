package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.FlxSound;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxTransitionableState
{
	private var _level:Level;
	private var _player:Player;
    private var _levelFile:String;

	private var _collected:Int;
	private var _tooltip:FlxText;
    private var _deathSound:FlxSound;
    private var _powerdownSound:FlxSound;
    private var _grabSound:FlxSound;
    private var _finishSound:FlxSound;
	
	override public function create():Void
	{
		Registry.init();

		_levelFile = Registry.levelList[Registry.currLevel];
        _level = new Level(_levelFile);

		for(entityGroup in _level.entityGroups)	{
			add(entityGroup);
		}
		_player = new Player(_level.spawn.x, _level.spawn.y);

		_player.resetMovement();
		add(_player);
		add(_player.grabBox);

		for(box in _level.boxes)
		{
			add(box.bottom);
		}

		FlxG.camera.follow(_player, TOPDOWN, 5);
		resetLevelBounds();

		_tooltip = new FlxText(0,0,200);
		_tooltip.setFormat(AssetPaths.pixelmix__ttf, 16, FlxColor.YELLOW);
		_tooltip.visible = false;
		_tooltip.alpha = 0.6;
		add(_tooltip);

        _deathSound = FlxG.sound.load(AssetPaths.death__wav, 0.3);
        _powerdownSound = FlxG.sound.load(AssetPaths.powerdown__wav, 0.3);
        _grabSound = FlxG.sound.load(AssetPaths.grab__wav, 0.3);
        _finishSound = FlxG.sound.load(AssetPaths.finish__wav, 0.3);

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.amazing_song__wav, 0.3, true);
		}

		InputManager.resetDisabledKeys();
		_collected = 0;

		super.create();
	}

	public function playerToTheFloor(player:Player, floor:Wall)
	{
		if(player.isTouching(FlxObject.DOWN)){
			if(floor.wallType == ICE){
				player.onIce = true;
			}else{
				player.onIce = false;
				if(!player.onFloor)
					player.velocity.x *= 0.5;
			}

			player.onFloor = true;
			player.canDash = true;
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
		if(box.isTouching(FlxObject.DOWN))
		{
			box.onFloor = true;
			var fixY = floor.y - box.height;
			if(Math.abs(fixY - box.oldY) < 5){
				box.oldY = fixY;
			}

			if(floor.wallType == ICE){
				box.onIce = true;
			}else{
				box.onIce = false;
			}
		}
	}

	public function playerToThePowerdown(player:Player, powerdown:Powerdown)
	{
		// If player is carrying a box, we don't want the box to pick up the powerdown.
		var playerActuallyTouchingPowerdown:Bool = true;
		if (player.isCarrying) {
			var playerHeight:Float = player.y + 32;
			if (playerHeight > powerdown.y + 32) {
				playerActuallyTouchingPowerdown = false;
			}
		}
		if (!playerActuallyTouchingPowerdown) {
			return;
		}
		
		InputManager.disableKey(powerdown.key);
		powerdown.kill();
        _powerdownSound.play();

		_collected += 1;
		if(_collected == _level.totalPowerdowns){
            _finishSound.play();
        	new FlxTimer().start(0, nextLevel,1);
		}
	}

	public function playerToTheDeath(player:Player, death:DeathWall){
        _deathSound.play();
		resetLevel();
	}

	public function carryBox(grabBox:FlxObject, box:Box){
		if(!box.carried && !_player.isCarrying) {
            _grabSound.play();
			_player.carry(box);
		}
	}

	public function nextLevel(timer:FlxTimer)
	{
		if(Registry.currLevel < (Registry.levelList.length - 1)) {
			Registry.currLevel += 1;
			transOut = Registry.defaultTransOut;
			FlxG.switchState(new PlayState(Registry.defaultTransIn));
		} else {
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

	public function canDrop():Bool
	{
		var oldX = _player.carrying.x;
		var oldY = _player.carrying.y;

		var newPos = _player.carrying.getDroppedPosition();
		_player.carrying.setPosition(newPos.x, newPos.y);

		var isOverlapping = (FlxG.overlap(_player.carrying, _level.walls) 
						  || FlxG.overlap(_player.carrying, _level.boxes));
		_player.carrying.setPosition(oldX, oldY);
		return !isOverlapping;
	}

	override public function update(elapsed:Float):Void
	{
		_tooltip.visible = false;
		//_player.onFloor = false;
		if(_player.onFloor){
			_player.onFloor = (FlxG.overlap(_player.bottom, _level.walls) ||
							   FlxG.overlap(_player.bottom, _level.boxes));
		}
		


		for(box in _level.boxes){
			if(box.onFloor){
				if(!FlxG.overlap(box.bottom, _level.walls)){
					var flag = false;
					for(otherBox in _level.boxes)
					{
						if(box!=otherBox){
							if(FlxG.overlap(box.bottom, otherBox)){
								flag=true;
								break;
							}
						}
					}
					if(!flag)
						box.onFloor = false;
				}
			}
			
			var flag = false;
			for(wall in _level.walls)
			{
				if(wall.wallType == ICE)
				{
					if(FlxG.overlap(box.bottom, wall))
					{
						flag = true;
						break;
					}
				}
			}
			box.onIce = flag;
			
			box.oldX = box.x;
			box.oldY = box.y;
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

		for(box in _level.boxes)
		{
			if(box.onFloor)
			{
				box.y = box.oldY;
				box.velocity.y = 0;
			}
		}

		if(InputManager.isJustPressed(C)){
			if(_player.isCarrying && canDrop()){
                _grabSound.play();
				_player.drop();
			}else{
				FlxG.overlap(_player.grabBox, _level.boxes, carryBox);
			}
		}

		if(InputManager.isJustPressed(V)){
			swapTeleporters();
		}

        if (FlxG.keys.justPressed.R) {
			_deathSound.play();
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


