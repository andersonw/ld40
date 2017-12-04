package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

class HUD extends FlxTypedGroup<FlxSprite>
{
	private var _remaining:Array<Int>;
	private var _tooltips:Array<FlxText>;
	private var _sprites:Array<FlxSprite>;

	private var _up:FlxSprite;
	private var _left:FlxSprite;
	private var _right:FlxSprite;
	private var _down:FlxSprite;
	private var _c:FlxSprite;

	private var vert_gap = 10;
	private var vert_gap_tt = 15;
	private var horz_gap = 10;
	private var horz_offset = 125;

	public function new(powerdowns:FlxTypedGroup<Powerdown>)
	{
		super();

		createBackground();

		processPowerdowns(powerdowns);
		_tooltips = new Array<FlxText>();
		_sprites = new Array<FlxSprite>();

		_up = new FlxSprite(horz_gap, vert_gap).loadGraphic(AssetPaths.uparrow_keyboard__png);
		add(_up);
		createTooltip(UP);
		_left = new FlxSprite(horz_gap + horz_offset, vert_gap).loadGraphic(AssetPaths.leftarrow_keyboard__png);
		add(_left);
		createTooltip(LEFT);
		_right = new FlxSprite(horz_gap + 2*horz_offset, vert_gap).loadGraphic(AssetPaths.rightarrow_keyboard__png);
		add(_right);
		createTooltip(RIGHT);
		_down = new FlxSprite(horz_gap + 3*horz_offset, vert_gap).loadGraphic(AssetPaths.downarrow_keyboard__png);
		add(_down);
		createTooltip(DOWN);
		_c = new FlxSprite(horz_gap + 4*horz_offset, vert_gap).loadGraphic(AssetPaths.c_keyboard__png);
		add(_c);
		createTooltip(C);

		_sprites.push(_up);
		_sprites.push(_left);
		_sprites.push(_right);
		_sprites.push(_down);
		_sprites.push(_c);


		forEach(function(spr:FlxSprite)
	    {
	        spr.scrollFactor.set(0, 0);
	    });
	}

	private function createBackground()
	{
		var _background = new FlxSprite().makeGraphic(FlxG.width, 50, FlxColor.BLACK);
		_background.alpha = 0.6;
		add(_background);
	}

	private function processPowerdowns(powerdowns:FlxTypedGroup<Powerdown>)
	{
		_remaining = new Array<Int>();
		for(i in 0...5)
			_remaining.push(0);

		for(pd in powerdowns)
		{
			var i = getIndex(pd.key);
			_remaining[i] = _remaining[i]+1;
		}
	}

	public function updateHUD(k:FlxKey)
	{
		var i = getIndex(k);
		_remaining[i] = _remaining[i]-1;
		_tooltips[i].text = ("X  "+_remaining[i]);
		_sprites[i].alpha = 0.4;
	}

	private function createTooltip(k:FlxKey)
	{
		var _tooltip = new FlxText(0,0,50);
		var i = getIndex(k);
		_tooltip.setFormat(AssetPaths.Action_Man__ttf, 20, FlxColor.ORANGE);
		_tooltip.alpha = 0.6;
		_tooltip.text = ("X  "+_remaining[i]);
		_tooltip.x = horz_gap + i*horz_offset + 45;
		_tooltip.y = vert_gap_tt;
		add(_tooltip);

		_tooltips.push(_tooltip);
	}

	private function getIndex(k:FlxKey)
	{
		var i;
		switch(k) {
			case UP: i=0;
			case LEFT: i=1;
			case RIGHT: i=2;
			case DOWN: i=3;
			case C: i=4;
			default: i=0;
		}
		return i;
	}

}