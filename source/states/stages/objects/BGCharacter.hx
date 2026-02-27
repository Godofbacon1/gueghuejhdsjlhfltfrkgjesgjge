package states.stages.objects;

import flixel.graphics.frames.FlxAtlasFrames;

class BGCharacter extends FlxSprite
{
	public function new(image:String, xmlshit:String, x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas(image);
		animation.addByPrefix('dance', xmlshit, 24, true);
		if (animation.getByName('dance') == null)
			animation.addByPrefix('idle', xmlshit, 24, true);
		antialiasing = ClientPrefs.data.antialiasing;
	}

	public function dance():Void
	{

		if (animation.getByName('dance') == null)
			animation.play('idle', true);
		else
			animation.play('dance', true);
	}
}
