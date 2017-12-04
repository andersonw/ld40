package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class EndState extends FlxState
{
	var endText:FlxText;
    var helpText:FlxText;

	var redSquare:FlxSprite;

	override public function create():Void
	{
		super.create();

		endText = new FlxText(40, 100, 0, "You beat the game!\nThanks for playing!");
		endText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
        endText.x = (400-endText.width)/2;
		add(endText);

        helpText = new FlxText(100, 250, 0, "Press [SPACE] to return to the menu");
		helpText.setFormat(AssetPaths.Action_Man__ttf, 16, FlxColor.WHITE);
		add(helpText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.music.stop();
			FlxG.sound.music = null;
			FlxG.switchState(new MenuState());
		}
	}
}
