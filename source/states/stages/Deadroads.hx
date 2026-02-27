package states.stages;

import states.stages.objects.*;

class Deadroads extends BaseStage
{
	var sowitch:Bool = false;

	override function sectionHit()
	{
    	if (curSection % 4 == 0 && !sowitch && !PlayState.SONG.notes[curSection].mustHitSection)
    	{
        	sowitch = true;
    	}
    	else if (sowitch)
    	{
        	sowitch = false;
    	}
	}

	override function update(elapsed:Float) 
	{
		PlayState.instance.Switch = sowitch;
	}

}