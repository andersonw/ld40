package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	var titleText:FlxText;
	var helpText:FlxText;

	var redSquare:FlxSprite;

	private var _shrinkSound:FlxSound;

	private var _helpTextTweening = false;

	override public function create():Void
	{
		super.create();

		bgColor = new FlxColor(0xFFFFC0CB);

		titleText = new FlxText(40, 150, 0, "Keyboard Kitten ");
		titleText.setFormat(AssetPaths.Action_Man_Shaded_Italic__ttf, 48, FlxColor.RED);
		titleText.width += 10;
		add(titleText);
		FlxTween.angle(titleText, 0, 359, 1,
					   {type: FlxTween.LOOPING, ease: FlxEase.sineInOut});

		helpText = new FlxText(300, 250, 0, "[SPACE] START");
		helpText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE);
		add(helpText);

		FlxG.mouse.visible = false;

		FlxG.sound.playMusic(AssetPaths.amazing_song__wav, 1, true);

		Registry.currLevel = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!_helpTextTweening) {
			_helpTextTweening = true;
			var newX:Float = Math.random() * (FlxG.width - helpText.width);
			var newY:Float = Math.random() * (FlxG.height - helpText.height);
			var finishTween = function(tween:FlxTween) {_helpTextTweening = false;}
			FlxTween.tween(helpText, {x: newX, y: newY}, 1,
						   {type: FlxTween.ONESHOT, ease: FlxEase.sineInOut, onComplete: finishTween});
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.music.stop();
			FlxG.sound.music = null;
			FlxG.switchState(new PlayState());
		}
	}
}
