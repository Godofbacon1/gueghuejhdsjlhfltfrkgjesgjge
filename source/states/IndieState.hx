package states;

import backend.MusicBeatState;
import states.TitleState;
import flixel.FlxG;
/*
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;
import flixel.util.FlxTimer;
*/
import hxvlc.flixel.FlxVideoSprite;


class IndieState extends MusicBeatState
{
    var OpenScene:FlxVideoSprite;

    override public function create():Void
    {
        ClientPrefs.loadPrefs();
        //trace(ClientPrefs.data.Firstlaunch);
        if (ClientPrefs.data.Firstlaunch == true) {
            OpenScene = new FlxVideoSprite(FlxG.width / 4, FlxG.height / 4);
            OpenScene.load(Paths.video('memes/Asgore'));
            OpenScene.scale.set(2, 2);
            OpenScene.updateHitbox();
            //OpenScene.screenCenter(XY);
            add(OpenScene);
            OpenScene.play();
            OpenScene.bitmap.onEndReached.add(() -> FlxG.switchState(new FlashingState()));
            ClientPrefs.data.Firstlaunch = false;
            ClientPrefs.saveSettings();
            /*
            if (ClientPrefs.data.Firstlaunch == false)
                trace("its false bitch");
            else
                trace("its a lie");
            */
        }
        else {
            FlxG.switchState(new TitleState());
        }
        super.create();
    }
    /*
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE) {
            OpenScene.destroy();
            FlxG.switchState(new TitleState());
        }
    }
    */
}