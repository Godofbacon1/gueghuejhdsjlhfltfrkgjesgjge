package states.stages;

import states.stages.objects.*;
import flixel.math.FlxPoint;

class Crossroads extends BaseStage
{

	var KID:FlxSprite;
	var OP:FlxPoint; // Original Pos
	var sd:Bool = false; //switch Directions ;-;
	var speed:Float = 150;

	override function createPost()
	{
		KID = getStageObject('c00lkidd');
		OP = new FlxPoint(KID.x, KID.y);

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (KID != null) {

			KID.x += (sd ? (speed * elapsed) : -(speed * elapsed));
			/*
			if (sd == false)
				KID.x -= speed * elapsed;
			else if (sd == true)
				KID.x += speed * elapsed;
			*/

			if (KID.x <= -525) {
				sd = true;
				KID.flipX = false;
			}
			else if (KID.x >= 2200) {
				sd = false;
				KID.flipX = true;
			}
		}
		else
			trace('where the kid at?!!');
	}
}