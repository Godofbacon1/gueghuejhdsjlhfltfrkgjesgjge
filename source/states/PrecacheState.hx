package states;

import backend.HotEngine;
import openfl.desktop.InteractiveIcon;
import hxvlc.flixel.FlxVideo;
import openfl.media.Sound;
import backend.MusicBeatState;
import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;
import flixel.util.FlxTimer;
import openfl.utils.Assets;

class PrecatchState extends MusicBeatState
{
    var test:Array<String> = CoolUtil.coolTextFile(Paths.txt("secretstuff"));
    var ID2:Int = 0;
    var testvideos:FlxVideoSprite;
    var smolway:String = '';
    var Time:Float;
    var isloaded:Bool = false;
    override public function create()
    {
        super.create();

        var text = new FlxText(0, 0, 0, "Loading", 32);
        text.screenCenter();
        add(text);
        var calmway:Sound = Paths.music('snowfall');

        FlxTween.tween(text, {alpha: 0}, 2, {ease:FlxEase.sineInOut, type:PINGPONG});

        FlxG.mouse.visible = false;

        FlxG.sound.playMusic(calmway);

        var Speed:Float = FlxG.random.float(0.25, 1);

        Time = test.length / Speed;

        HotEngine.kolombos(Time);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (HotEngine.DONE == true) FlxG.switchState(new IndieState());

        if (FlxG.keys.justPressed.SIX && FlxG.keys.justPressed.SEVEN) { //6676767676767676767
            FlxG.sound.music.volume = 0;
            FlxG.switchState(new IndieState());
        }
    }
}