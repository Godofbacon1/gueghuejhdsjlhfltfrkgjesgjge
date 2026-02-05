package backend;

import openfl.utils.Assets;
import hxvlc.flixel.FlxVideoSprite;

class HotEngine 
{
    public static var catchlol:FlxVideoSprite;
    public static var DONE:Bool = false;
    static var smolway:String = '';
    static var isloaded:Bool = false;
    static var test:Array<String> = CoolUtil.coolTextFile(Paths.txt("secretstuff"));
    static var ID2:Int = 0;

    
    public static function kolombos(mogus:Float = 1) {
        if (catchlol == null) catchlol = new FlxVideoSprite();
        new FlxTimer().start(mogus, timer -> {
            smolway = Paths.video('memes/${test[ID2]}');
            isloaded = catchlol.load(smolway);
            if (ID2 < test.length && !isloaded) {
                Assets.getBytes(smolway);
                ID2++;
                kolombos(mogus);
            }
            else if (ID2 >= test.length) {
                DONE = true;
                return;
            }
            else if (isloaded) trace("Broke");
        });
    };
}