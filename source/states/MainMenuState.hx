package states;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import Reflect;

enum MainMenuColumn {
	LEFT;
	CENTER;
	RIGHT;
}

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0.4'; // This is also used for Discord RPC
	private static var ModVersion:String = 'Demo';
	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = CENTER;
	var allowMouse:Bool = false; //Turn this off to block mouse movement in menus

	var menuItems:FlxTypedGroup<FlxSprite>;
	var leftItem:FlxSprite;
	var rightItem:FlxSprite;
	var MenuCharSprite:FlxSprite;
	public static var MenuCharName:String;

	//Centered/Text options
	var optionShit:Array<String> = [
		'storymode',
		#if !final 'freeplay', #end
		#if MODS_ALLOWED 'mods', #end
		'credit'
	];

	//var leftOption:String = #if ACHIEVEMENTS_ALLOWED 'achievements' #else null #end;
	var leftOption:String = null;
	var rightOption:String = 'option';

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	static var showOutdatedWarning:Bool = true;
	override function create()
	{
		super.create();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("fuck menus", null);
		#end

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = 0.25;
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

	function setChar(Character:String, CharX:Float, CharY:Float, Size:Float = 1.0):FlxSprite {
		var sprite = new FlxSprite(CharX, CharY); // This is the character sprite

		switch (Character.toLowerCase()) {
			case "john":
				sprite.frames = Paths.getSparrowAtlas("characters/john doe"); // Loads BF's XML & PNG
				sprite.scale.x *= Size;
				sprite.scale.y *= Size;
				sprite.updateHitbox();
				sprite.animation.addByPrefix("chosen", 'Doe idleAnim', 26, true); // Add animation
				sprite.animation.addByPrefix("up", 'Doe upPose', 6, false);
				sprite.animation.addByPrefix("down", 'Doe downPose', 5, false);
				sprite.animation.addByPrefix("left", 'Doe rightPose', 4, false);
				sprite.animation.addByPrefix("right", 'Doe leftPose', 8, false);
				sprite.animation.play("chosen"); // Play it
				sprite.antialiasing = ClientPrefs.data.antialiasing;
				MenuCharName = "john";

			case "kid":
				sprite.frames = Paths.getSparrowAtlas("characters/c00lkidd"); // Loads GF's XML & PNG
				sprite.scale.x *= Size;
				sprite.scale.y *= Size;
				sprite.updateHitbox();
				sprite.animation.addByPrefix("chosen", 'C00lKIDD idleDance', 9, true);
				sprite.animation.addByPrefix("up", 'C00lKIDD upPose', 4, false);
				sprite.animation.addByPrefix("down", 'C00lKIDD downPose', 4, false);
				sprite.animation.addByPrefix("left", 'C00lKIDD rightPose', 4, false);
				sprite.animation.addByPrefix("right", 'C00lKIDD leftPose', 5, false);
				sprite.animation.play("chosen");
				sprite.antialiasing = ClientPrefs.data.antialiasing;
				MenuCharName = "kid";
		}

		add(sprite); // Add the character to the game screen
		return sprite; // Return the sprite
	}

		var randomNumber:Int = FlxG.random.int(0, 1);

		if (randomNumber == 1) {
			MenuCharSprite = setChar("john", 1100, 60, 0.5);
			MenuCharSprite.flipX = true;
			FlxTween.tween(MenuCharSprite, {x: (FlxG.width - MenuCharSprite.width) / 2}, 1.2, {
				ease: FlxEase.backOut
			});
		}
		else if (randomNumber == 0) {
			MenuCharSprite = setChar("kid", 1280, 150, 0.4);
			MenuCharSprite.flipX = true;
			FlxTween.tween(MenuCharSprite, {x: (FlxG.width - MenuCharSprite.width) / 2}, 1.2, {
				ease: FlxEase.backOut
			});
		}



		camFollow = new FlxObject(0, 0, 1, 1);
		//add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (num => option in optionShit) {
			var item:FlxSprite = createMenuItem(option, -640, (num * 230) - 50, 0.5, 0.5);
	
			// Offset for number of items (move whole list up/down depending on count)
			item.y += (4 - optionShit.length) * 0;

			// Animate the entry with bounce
			FlxTween.tween(item, { x: 0 }, 2.4, {
				ease: FlxEase.backOut,
				startDelay: num * 0.25
			});

			new FlxTimer().start(1.5, function(timer:FlxTimer){

				FlxTween.tween(item, {y: item.y - 20},  0.75, {
				ease: FlxEase.sineInOut,
				type: FlxTween.PINGPONG,
				startDelay: num * 0.25
				});
			});
		}

		if (leftOption != null)
		{
			leftItem = createMenuItem(leftOption, FlxG.width - 50, 0);
			FlxTween.tween(leftItem, { x: FlxG.width - 192 }, 1.2, {
				ease: FlxEase.backOut
			});
		}

		if (rightOption != null)
		{
			rightItem = createMenuItem(rightOption, FlxG.width - 50, 0, 0.5, 0.5);
			//rightItem.x -= rightItem.width;
			FlxTween.tween(rightItem, { x: FlxG.width - 300}, 1.2, {
				ease: FlxEase.backOut
			});
			new FlxTimer().start(1.5, function(timer:FlxTimer){
				FlxTween.tween(rightItem, {y: rightItem.y - 20},  0.75, {
					ease: FlxEase.sineInOut,
					type: FlxTween.PINGPONG,
				});
			});
		}
		var terminalver:FlxText = new FlxText(12, FlxG.height - 44, 0, "Terminal Version " + ModVersion, 12);
		terminalver.scrollFactor.set();
		terminalver.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(terminalver);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' vError", 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		#if CHECK_FOR_UPDATES
		if (showOutdatedWarning && ClientPrefs.data.checkForUpdates && substates.OutdatedSubState.updateVersion != psychEngineVersion) {
			persistentUpdate = false;
			showOutdatedWarning = false;
			openSubState(new substates.OutdatedSubState());
		}
		#end

		//FlxG.camera.follow(camFollow, null, 0.15);
	}

	function createMenuItem(name:String, x:Float, y:Float, ?sizex:Float = 1, ?sizey:Float = 1):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/$name');
		menuItem.animation.addByIndices('idle', '$name', [0], "", 0, true);
		menuItem.animation.addByPrefix('selected', '$name', 12, false);
		menuItem.animation.play('idle');
		menuItem.scale.set(sizex, sizey);
		menuItem.updateHitbox();
		
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
		return menuItem;
	}

	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (controls.BACK){
			selectedSomethin = true;
			FlxG.mouse.visible = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new TitleState());
		}

		//Debug Shit
		#if (!final)
		if (FlxG.keys.justPressed.T)
		{
			ClientPrefs.data.Firstlaunch = true;
			ClientPrefs.saveSettings();
			trace("Asgore lol");
		}
		#end
		/*
		if (controls.UI_UP_P) {
			MenuCharSprite.animation.play("up");
			new FlxTimer().start(0.5, function(timer:FlxTimer) {
				MenuCharSprite.animation.play("chosen");
			});
		}
		else if (controls.UI_DOWN_P) {
			MenuCharSprite.animation.play("down");
			new FlxTimer().start(0.5, function(timer:FlxTimer) {
				MenuCharSprite.animation.play("chosen");
			});
		}
		else if (controls.UI_LEFT_P) {
			MenuCharSprite.animation.play("left");
			new FlxTimer().start(0.5, function(timer:FlxTimer) {
				MenuCharSprite.animation.play("chosen");
			});
		}
		else if (controls.UI_RIGHT_P) {
			MenuCharSprite.animation.play("right");
			new FlxTimer().start(0.5, function(timer:FlxTimer) {
				MenuCharSprite.animation.play("chosen");
			});
		}
		*/
		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			var allowMouse:Bool = allowMouse;
			if (allowMouse && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)) //FlxG.mouse.deltaScreenX/Y checks is more accurate than FlxG.mouse.justMoved
			{
				allowMouse = false;
				FlxG.mouse.visible = true;
				timeNotMoving = 0;

				var selectedItem:FlxSprite;
				switch(curColumn)
				{
					case CENTER:
						selectedItem = menuItems.members[curSelected];
					case LEFT:
						selectedItem = leftItem;
					case RIGHT:
						selectedItem = rightItem;
				}

				if(leftItem != null && FlxG.mouse.overlaps(leftItem))
				{
					allowMouse = true;
					if(selectedItem != leftItem)
					{
						curColumn = LEFT;
						changeItem();
					}
				}
				else if(rightItem != null && FlxG.mouse.overlaps(rightItem))
				{
					allowMouse = true;
					if(selectedItem != rightItem)
					{
						curColumn = RIGHT;
						changeItem();
					}
				}
				else
				{
					var dist:Float = -1;
					var distItem:Int = -1;
					for (i in 0...optionShit.length)
					{
						var memb:FlxSprite = menuItems.members[i];
						if(FlxG.mouse.overlaps(memb))
						{
							var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
							if (dist < 0 || distance < dist)
							{
								dist = distance;
								distItem = i;
								allowMouse = true;
							}
						}
					}

					if(distItem != -1 && selectedItem != menuItems.members[distItem])
					{
						curColumn = CENTER;
						curSelected = distItem;
						changeItem();
					}
				}
			}
			else
			{
				timeNotMoving += elapsed;
				if(timeNotMoving > 2) FlxG.mouse.visible = false;
			}

			switch(curColumn)
			{
				case CENTER:
					/* its useless sooo
					if(controls.UI_RIGHT_P && leftOption != null)
					{
						curColumn = LEFT;
						changeItem();
					}
					*/
					if(controls.UI_RIGHT_P && rightOption != null)
					{
						curColumn = RIGHT;
						MenuCharSprite.flipX = false;
						changeItem();
					}

				case LEFT:
					if(controls.UI_LEFT_P)
					{
						curColumn = CENTER;
						changeItem();
					}

				case RIGHT:
					if(controls.UI_LEFT_P)
					{
						curColumn = CENTER;
						MenuCharSprite.flipX = true;
						changeItem();
					}
			}

			if (controls.ACCEPT || (FlxG.mouse.justPressed && allowMouse))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;

				if (ClientPrefs.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				var item:FlxSprite;
				var option:String;

				FlxTween.tween(MenuCharSprite, {x: 1280}, 1.5, {
					ease: FlxEase.backIn
				});

				switch(curColumn)
				{
					case CENTER:
						option = optionShit[curSelected];
						item = menuItems.members[curSelected];

					case LEFT:
						option = leftOption;
						item = leftItem;

					case RIGHT:
						option = rightOption;
						item = rightItem;
				}

				FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					switch (option)
					{
						case 'storymode':
							new FlxTimer().start(0.25, function(timer:FlxTimer) {
								MusicBeatState.switchState(new StoryMenuState());
							});
						case 'freeplay':
							new FlxTimer().start(0.25, function(timer:FlxTimer) {
								MusicBeatState.switchState(new FreeplayState());
							});
						#if MODS_ALLOWED
						case 'mods':
							MusicBeatState.switchState(new ModsMenuState());
						#end

						#if ACHIEVEMENTS_ALLOWED
						case 'achievements':
							new FlxTimer().start(0.25, function(timer:FlxTimer) {
								MusicBeatState.switchState(new AchievementsMenuState());
							});
						#end

						case 'credit':
							new FlxTimer().start(0.25, function(timer:FlxTimer) {
								MusicBeatState.switchState(new CreditsState());
							});
						case 'option':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null)
							{
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
						case 'donate':
							CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
							selectedSomethin = false;
							item.visible = true;
						default:
							trace('Menu Item ${option} doesn\'t do anything');
							selectedSomethin = false;
							item.visible = true;
					}
				});
				
				for (memb in menuItems)
				{
					if(memb == item)
						continue;

					FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
				}
			}
			#if (desktop && !final)
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		if(change != 0) curColumn = CENTER;
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (item in menuItems)
		{
			item.animation.play('idle');
			item.centerOffsets();
		}

		var selectedItem:FlxSprite;
		switch(curColumn)
		{
			case CENTER:
				selectedItem = menuItems.members[curSelected];
			case LEFT:
				selectedItem = leftItem;
			case RIGHT:
				selectedItem = rightItem;
		}
		selectedItem.animation.play('selected');
		selectedItem.centerOffsets();
		camFollow.y = selectedItem.getGraphicMidpoint().y;
	}
}
