package states;

import objects.AttachedSprite;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var fileName2:String;
	var intendedColor:FlxColor;
	var descBox:AttachedSprite;
	var offsetThing:Float = -75;
	var Changed:Bool = false;
	var Ogp:Array<Array<Float>> = [];

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Credit Flex", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite();
		bg.frames = Paths.getSparrowAtlas('CBG');
		bg.animation.addByPrefix("gltch", 'Anim', 8, true);
		bg.animation.play('gltch');
		bg.scrollFactor.set();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled) pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			["Terminal Team"],
			["Meero",               "Kaisor",           "The Head of Terminal And Coder",						"https://www.youtube.com/@mk_meero",	"0000FF"],
			["AFKBo",               "furry",			"Head Artist + The Goat",								"https://www.youtube.com/@afkbo",		"0000FF"],
			["miniyaht",			"noob",				"UI Artist",											"https://comic.studio/u/MiniYaht",		"0000FF"],
			["jamie",               "computer",         "Bg Artist + UI",										"https://www.youtube.com/@kazuk.i",		"0000FF"],
			["Clover",              "bacon",			"Good Ol' Voice Actor",								"https://www.youtube.com/@double-sonic",	"0000FF"],
			["harley",              "sanic",			"Goofy ahh charter",			"https://www.tiktok.com/@fw.harleyyy?_t=ZN-8yJavFpWcf0&_r=1",	"0000FF"],
			["MilkGod",             "milk",				"Bg Artist",										"https://www.youtube.com/@mk_meero",		"0000FF"],
			["Bambi",				"luffy",			"Composer",											"https://www.youtube.com/@double-sonic",	"0000FF"],
			//["Psych Engine Team"],
			//["Shadow Mario",		"shadowmario",		"Main Programmer and Head of Psych Engine",					"https://ko-fi.com/shadowmario",	"444444"],
			//["Riveren",				"riveren",			"Main Artist/Animator of Psych Engine",						"https://x.com/riverennn",			"14967B"],
			//[""],
			//["Former Engine Members"],
			//["bb-panzu",			"bb",				"Ex-Programmer of Psych Engine",							"https://x.com/bbsub3",				"3E813A"],
			//[""],
			//["Engine Contributors"],
			//["crowplexus",			"crowplexus",	"Linux Support, HScript Iris, Input System v3, and Other PRs",	"https://twitter.com/IamMorwen",	"CFCFCF"],
			//["Kamizeta",			"kamizeta",			"Creator of Pessy, Psych Engine's mascot.",				"https://www.instagram.com/cewweey/",	"D21C11"],
			//["MaxNeton",			"maxneton",			"Loading Screen Easter Egg Artist/Animator.",	"https://bsky.app/profile/maxneton.bsky.social","3C2E4E"],
			//["Keoiki",				"keoiki",			"Note Splash Animations and Latin Alphabet",				"https://x.com/Keoiki_",			"D2D2D2"],
			//["SqirraRNG",			"sqirra",			"Crash Handler and Base code for\nChart Editor's Waveform",	"https://x.com/gedehari",			"E1843A"],
			//["EliteMasterEric",		"mastereric",		"Runtime Shaders support and Other PRs",					"https://x.com/EliteMasterEric",	"FFBD40"],
			//["MAJigsaw77",			"majigsaw",			".MP4 Video Loader Library (hxvlc)",						"https://x.com/MAJigsaw77",			"5F5F5F"],
			//["iFlicky",				"flicky",			"Composer of Psync and Tea Time\nAnd some sound effects",	"https://x.com/flicky_i",			"9E29CF"],
			//["KadeDev",				"kade",				"Fixed some issues on Chart Editor and Other PRs",			"https://x.com/kade0912",			"64A250"],
			//["superpowers04",		"superpowers04",	"LUA JIT Fork",												"https://x.com/superpowers04",		"B957ED"],
			//["CheemsAndFriends",	"cheems",			"Creator of FlxAnimate",									"https://x.com/CheemsnFriendos",	"E1E1E1"],
			//[""],
			//["Funkin' Crew"],
			//["ninjamuffin99",		"ninjamuffin99",	"Programmer of Friday Night Funkin'",						"https://x.com/ninja_muffin99",		"CF2D2D"],
			//["PhantomArcade",		"phantomarcade",	"Animator of Friday Night Funkin'",							"https://x.com/PhantomArcade3K",	"FADC45"],
			//["evilsk8r",			"evilsk8r",			"Artist of Friday Night Funkin'",							"https://x.com/evilsk8r",			"5ABD4B"],
		];
		
		for(i in defaultList)
			creditsStuff.push(i);

		////
		var lastItem:Alphabet = null;
		var lastTitle:Alphabet = null;
		var sectionIndex:Int = 0;
		
		var columnAmount:Int = 4;
		var spacingX:Float = 150;
		var textWidth:Float = 150;
		var sectionWidth:Float = columnAmount * spacingX;
		var offsetX:Float = 45;
	
		for (i => credit in creditsStuff)
		{
			var isTitle:Bool = unselectableCheck(i);

			var optionText:Alphabet = new Alphabet(offsetX, 0, credit[0], isTitle);
			optionText.scrollFactor.set(0, 1);
			grpOptions.add(optionText);

			if (isTitle)
			{
				//optionText.x += (sectionWidth - optionText.width) / 2;
				optionText.y += (lastItem == null) ? 0 : lastItem.y + lastItem.height + 100;

				lastTitle = optionText;
				Ogp.push([optionText.x, optionText.y]);
				sectionIndex = 0;
			}
			else
			{				
				var Column:Int = (sectionIndex % columnAmount);
				var Row:Int = Std.int(sectionIndex / columnAmount);
				
				optionText.x += 150 * Column;
				optionText.y += 300 * Row + (lastTitle==null ? 0 : lastTitle.y + lastTitle.height + 100);

				optionText.scaleX = textWidth / optionText.width;

				lastItem = optionText;
				Ogp.push([optionText.x, optionText.y]);
				sectionIndex++;

				for (letter in optionText.letters) {
					var lettersColor = 255;
					letter.setColorTransform(1, 1, 1, 1, lettersColor, lettersColor, lettersColor);
				}

				////
				if(credit[5] != null)
					Mods.currentModDirectory = credit[5];

				var str:String = 'credits/missing_icon';
				if(credit[1] != null && credit[1].length > 0)
				{
					var fileName = 'credits/' + credit[1];
					fileName2 = 'creditpic/' + credit[1];
					if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;
					else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE)) str = fileName + '-pixel';
					else if (Paths.fileExists('images/$fileName2.png', IMAGE)) str = fileName2;
				}

				var icon:AttachedSprite = new AttachedSprite(str);

				if(str.endsWith('-pixel')) icon.antialiasing = false;
				icon.xAdd = (optionText.width - icon.width) / 2;
				icon.yAdd = -icon.height + 55;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray[i] = icon;
				add(icon);
				Mods.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			//else optionText.alignment = CENTERED;
		}

		descBox = new AttachedSprite();
		descBox.scrollFactor.set();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		//descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText = new FlxText(FlxG.width * 0.55, 0, 590, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		// Portrait Cockulations
		trace(descBox.width);
		trace(descBox.y);

		//bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		//intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_LEFT_P;
				var downP = controls.UI_RIGHT_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					Changed = true;
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					Changed = true;
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
						Changed = true;
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				var lerpVal:Float = Math.exp(-elapsed * 12);
				//if(item.targetY == 0)
				//{
					//var lastX:Float = item.x;
					//item.screenCenter(X);
					//item.x = FlxMath.lerp(item.x - 70, lastX, lerpVal);
				//}
				//else
				//{
					//item.x = FlxMath.lerp(200 + -40 * Math.abs(item.targetY), item.x, lerpVal);
				//}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do
		{
			curSelected = FlxMath.wrap(curSelected + change, 0, creditsStuff.length - 1);
		}
		while(unselectableCheck(curSelected));

		//var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		//trace('The BG color is: $newColor');
		//if(newColor != intendedColor)
		//{
			//intendedColor = newColor;
			//FlxTween.cancelTweensOf(bg);
			//FlxTween.color(bg, 1, bg.color, intendedColor);
		//}

		for (num => item in grpOptions.members)
		{
			item.targetY = num - curSelected;
			if(!unselectableCheck(num)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}

		}
		var icon = iconArray[curSelected];
		if (icon != null) {
			FlxG.camera.follow(icon, LOCKON, 12);
			//FlxG.camera.snapToTarget();
		}

		descText.text = creditsStuff[curSelected][2];
		if(descText.text.trim().length > 0)
		{
			descText.visible = descBox.visible = true;
			//descText.y = FlxG.height - descText.height + offsetThing - 60;
			descText.y = FlxG.height * 0.65;
	
			if(moveTween != null) moveTween.cancel();
			moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});
	
			//descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
			descBox.setGraphicSize(Std.int(descText.width), Std.int(descText.height + 10));
			descBox.updateHitbox();
		}
		else descText.visible = descBox.visible = false;

		for (i => Stuff in grpOptions.members) {
			if (Stuff.bold) continue;
			var offsetos:Float = (FlxG.height * 0.5) - 200;
			// Same shit as line 185
			//trace(offsetos);
			var Showing:Bool = (curSelected == i);
			//trace(i);
			//trace(Ogp); // wrong placement it crashed my pc :p

			if (Showing && (Stuff.x != descText.x || Stuff.y != offsetos)) {
				FlxTween.tween(Stuff, {x: descText.x + 200, y: offsetos}, 1, {
					ease: FlxEase.quadOut
				});
				//Stuff.y = descText.y - 50; //Cuz without ts it is bwoken uwu
				Changed = false;
			}
			else if (!Showing && Changed == true) {
				FlxTween.tween(Stuff, {x: Ogp[i][0], y: Ogp[i][1]}, 1, {
					ease: FlxEase.quadOut
				});
			}
			else if (!Showing && Changed == false) {
				new FlxTimer().start(0.25, function(tmr:FlxTimer) {
					if (Stuff.x != Ogp[i][0] || Stuff.y != Ogp[i][1]) {
						Stuff.x = Ogp[i][0];
						Stuff.y = Ogp[i][1];
					}
				});
			}
		}
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = Paths.mods(folder + '/data/credits.txt');
		
		#if TRANSLATIONS_ALLOWED
		//trace('/data/credits-${ClientPrefs.data.language}.txt');
		var translatedCredits:String = Paths.mods(folder + '/data/credits-${ClientPrefs.data.language}.txt');
		#end

		if (#if TRANSLATIONS_ALLOWED (FileSystem.exists(translatedCredits) && (creditsFile = translatedCredits) == translatedCredits) || #end FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}