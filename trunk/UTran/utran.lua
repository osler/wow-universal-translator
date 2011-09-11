--------------------------------------------------------------------------
-- utran.lua 
--------------------------------------------------------------------------
--[[
Universal Translator v1.7.3

Authors:
	miscman	- miscman@canofsleep.com		(morse)
	Jack Colorado - lord_raphio@yahoo.com   (babel)
	AnduinLothar - karlkfi@yahoo.com		(leet)
	Brachan - eichner_martin@yahoo.com		(international)

This mod is released as is, use at your own risk. For free public use.

If you use our work, give credit where credit is due. Also, contact us 
to let us know how we might have helped you!


[Change Log]
01/17/05 	[jhc] - v1.1
			Unified Miscman's Morse Code interpreter with BabelFish to
			produce the Universal Translator, version 1.0.
			supports all old commands, adds new "/" commands for
			the universal communication.  Defaults to Morse code.

01/18/05	[miscman] - v1.2
			Bugfixes, as the merge went untested due to sleep needs.			

01/19/05	[jhc] - v1.3
			Changed functionality of the chat commands to support
			independant commands for each of the chat types, allowing
			users to quickly switch chat types.  Retaining old style,
			commented out, for possible use later.  Updated Help method.
			Fixed some small bugs.  Added color customization for the System
			Messages.  You now won't hear translations of your own Babel or
			Morse Code.  Default changed back to Babel.

01/20/05	[AnduinLothar] - v1.4
			Added Leet translation and started streamlining language modularity.

01/23/05	[jhc] - v1.5
			Added International translation (uses all numbers)

01/23/05	[AnduinLothar] - v1.6
			Added Optional Cosmos dependancy for use of GUI menu options.
			More streamlining using UTPrefixMap.
			Added the following slash commands and Cosmos options:
				*Special language block,
				*Auto-message translation (changes message),
				*Post-message translation (tranlsates after posting original message)
			Changed it back so your own messages can be converted
			Updated the help dialogue that had been neglected.

01/24/05	[AnduinLothar] - v1.7
			Added Language Selection to Cosmos
			Updated UTHelp to reflect Cosmos Options Use
			Updated Color changing to work with Auto-message translation
			Changed default color settings to reflect user settings
			Fixed show color to reflect default status
			Added Color Defaulting to Cosmos
			Added Color Selection slider bars to Cosmos
			Added Color Testing in Cosmos
			Added Custom Color Reset Button in Cosmos
			Syncronized Cosmos and UT variables

01/27/05	[AnduinLothar] - v1.7.1
			Fixed a bug that wouldn't load the default colors on first install
                        Added /utcolor all reset
                        Added /utcolor (chatmode) reset

01/28/05	[Jack Colorado] - v1.7.2
			Fixed another bug involving an if statement deep in the module.
			Sorry about that... =)

02/15/05	[Jack Colorado] - v1.7.3
			Updated version number.
           

TODO:
	Sticky commands? (say yell party guild)
		Can't do it the same way as the other chat types because the server only accepts the standard ones.
		Might be able to temporarily override default chat header formats or perhaps hook in an additional one.

]]--


--------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------
local version = "1.7.2";
local SavedChatHandler = nil;
local UTNewInstall = false;

TempColors = { };
TempColors.r = 1.0;
TempColors.g = 1.0;
TempColors.b = 1.0;

local UTRAN_HEADER				= "Universal Translator";
local UTRAN_HEADER_INFO			= "Inter-faction communication\nvia automatic special language translation.";

local UTRAN_ENABLE_INCOMING_REPLACE		= "Enable incoming translation replacement";
local UTRAN_ENABLE_INCOMING_REPLACE_INFO	= "Replace incoming messages with their translation.";

local UTRAN_ENABLE_INCOMING_TRANSLATION		= "Enable incoming translation";
local UTRAN_ENABLE_INCOMING_TRANSLATION_INFO	= "Display translation as well as original incoming messages.";

local UTRAN_ENABLE_BLOCK			= "Block incoming special languages";
local UTRAN_ENABLE_BLOCK_INFO		= "Incoming messages with a special language prefix are blocked.";

UTPrefs = { };
UTCosSetColors = { 
		["SAY"] = { },
		["YELL"] = { },
		["GUILD"] = { },
		["PARTY"] = { },
		["SYSTEM"] = { }
		};
RegisterForSave("UTPrefs");

UTPrefixMap = {
		["MORSE"] = {
			prefix = "-- -- ", 
			blocked = "Morse Code Blocked.",
		},
		
		["BABEL"] = {
			prefix = "@#", 
			blocked = "Babel Blocked.",
		},
		
		["LEET"] = {
			prefix = "<]_337> ", 
			blocked = "Leet Blocked.",
		},
		
		["INTERNATIONAL"] = {
			prefix = ":/\\:",
			blocked = "Int'l Blocked.",
			altname = "INTL",
		},
		--remember to assign readfunc and writefunc for each language
};

-- International Character array.
InternationalChars = {};
InternationalChars[0] = " ";
InternationalChars[1] = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
InternationalChars[2] = "Ê¯Â∆ÿ≈¡¬√ƒ«»… ÀÃÕŒœ—“”‘’÷Ÿ⁄€‹›ﬂ‡·‚„‰ÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˘˙˚¸˝ˇ";
InternationalChars[3] = "!\'%&?#=:;.,{[(\\/)]}@§*$+-\"_";


CharToMorse = {
	["a"] = ".-",
	["b"] = "-...",
	["c"] = "-.-.",
	["d"] = "-..",
	["e"] = ".",
	["f"] = "..-.",
	["g"] = "--.",
	["h"] = "....",
	["i"] = "..",
	["j"] = ".---",
	["k"] = "-.-",
	["l"] = ".-..",
	["m"] = "--",
	["n"] = "-.",
	["o"] = "---",
	["p"] = ".--.",
	["q"] = "--.-",
	["r"] = ".-.",
	["s"] = "...",
	["t"] = "-",
	["u"] = "..-",
	["v"] = "...-",
	["w"] = ".--",
	["x"] = "-..-",
	["y"] = "-.--",
	["z"] = "--..",
	["."] = ".-.-.-",
	[","] = "--..--",
	["?"] = "..--..",
	["1"] = ".----",
	["2"] = "..---",
	["3"] = "...--",
	["4"] = "....-",
	["5"] = ".....",
	["6"] = "-....",
	["7"] = "--...",
	["8"] = "---..",
	["9"] = "----.",
	["0"] = "-----",
};

MorseToChar = {
	[".-"] = "a",
	["-..."] = "b",
	["-.-."] = "c",
	["-.."] = "d",
	["."] = "e",
	["..-."] = "f",
	["--."] = "g",
	["...."] = "h",
	[".."] = "i",
	[".---"] = "j",
	["-.-"] = "k",
	[".-.."] = "l",
	["--"] = "m",
	["-."] = "n",
	["---"] = "o",
	[".--."] = "p",
	["--.-"] = "q",
	[".-."] = "r",
	["..."] = "s",
	["-"] = "t",
	["..-"] = "u",
	["...-"] = "v",
	[".--"] = "w",
	["-..-"] = "x",
	["-.--"] = "y",
	["--.."] = "z",
	[".-.-.-"] = ".",
	["--..--"] = ",",
	["..--.."] = "?",
	[".----"] = "1",
	["..---"] = "2",
	["...--"] = "3",
	["....-"] = "4",
	["....."] = "5",
	["-...."] = "6",
	["--..."] = "7",
	["---.."] = "8",
	["----."] = "9",
	["-----"] = "0",
};

LeetToChar = {
	-- '%' is the gsub escape character for the magic characters ^$()%.[]*+-?
	
	--lowercase suffixed with '.'
	["4%."] = "a",
	["8%."] = "b",
	["%(%."] = "c",
	["%[%)%."] = "d",
	["3%."] = "e",
	["/=%."] = "f",
	["6%."] = "g",
	["%[%-%]%."] = "h",
	["1%."] = "i",
	["_%[%."] = "j",
	["%]<%."] = "k",
	["%]_%."] = "l",
	["//\\/\\%."] = "m",
	["//\\/%."] = "n",
	["0%."] = "o",
	["%]>%."] = "p",
	["<%[%."] = "q",
	["%]2%."] = "r",
	["%$%."] = "s",
	["7%."] = "t",
	["%]_%[%."] = "u",
	["\\\\/%."] = "v",
	["\\\\/\\/%."] = "w",
	["><%."] = "x",
	["'/%."] = "y",
	["5%."] = "z",
	
	--uppercase suffixed with ':'
	["4:"] = "A",
	["8:"] = "B",
	["%(:"] = "C",
	["%[%):"] = "D",
	["3:"] = "E",
	["/=:"] = "F",
	["6:"] = "G",
	["%[%-%]:"] = "H",
	["1:"] = "I",
	["_%[:"] = "J",
	["%]<:"] = "K",
	["%]_:"] = "L",
	["//\\/\\:"] = "M",
	["//\\/:"] = "N",
	["0:"] = "O",
	["%]>:"] = "P",
	["<%[:"] = "Q",
	["%]2:"] = "R",
	["%$:"] = "S",
	["7:"] = "T",
	["%]_%[:"] = "U",
	["\\\\/:"] = "V",
	["\\\\/\\/:"] = "W",
	["><:"] = "X",
	["'/:"] = "Y",
	["5:"] = "Z",
		
};

CharToLeet = {
	-- '\' is an escape char so two '\\' prints one '\'
	
	--lowercase suffixed with '.'
	["a"] = "4.",
	["b"] = "8.",
	["c"] = "(.",
	["d"] = "[).",
	["e"] = "3.",
	["f"] = "/=.",
	["g"] = "6.",
	["h"] = "[-].",
	["i"] = "1.",
	["j"] = "_[.",
	["k"] = "]<.",
	["l"] = "]_.",
	["m"] = "//\\/\\.",
	["n"] = "//\\/.",
	["o"] = "0.",
	["p"] = "]>.",
	["q"] = "<[.",
	["r"] = "]2.",
	["s"] = "$.",
	["t"] = "7.",
	["u"] = "]_[.",
	["v"] = "\\\\/.",
	["w"] = "\\\\/\\/.",
	["x"] = "><.",
	["y"] = "'/.",
	["z"] = "5.",
	
	--uppercase suffixed with ':'
	["A"] = "4:",
	["B"] = "8:",
	["C"] = "(:",
	["D"] = "[):",
	["E"] = "3:",
	["F"] = "/=:",
	["G"] = "6:",
	["H"] = "[-]:",
	["I"] = "1:",
	["J"] = "_[:",
	["K"] = "]<:",
	["L"] = "]_:",
	["M"] = "//\\/\\:",
	["N"] = "//\\/:",
	["O"] = "0:",
	["P"] = "]>:",
	["Q"] = "<[:",
	["R"] = "]2:",
	["S"] = "$:",
	["T"] = "7:",
	["U"] = "]_[:",
	["V"] = "\\\\/:",
	["W"] = "\\\\/\\/:",
	["X"] = "><:",
	["Y"] = "'/:",
	["Z"] = "5:",

};

--------------------------------------------------------------------------
-- INITIALIZATION FUNCTION
--------------------------------------------------------------------------


function UTinit()
-------------------------------------------------------------
-- Purpose: Initializes the Addon.
-- Accepts: N/A
-- Assumes: N/A
-- Returns: N/A
-- Affects: Creates default Preferences if not already loaded,
--	    sets the commands and binds to the Chat Message events.
-------------------------------------------------------------
	-- default values if there are none saved.
	if not UTPrefs["chatmode"] then
		UTPrefs["chatmode"] = "SAY";
	end
	
	if UTPrefs["replace"]==nil then
		UTPrefs["replace"] = true;
	end
	
	if UTPrefs["translate"]==nil then
		UTPrefs["translate"] = false;
	end
	
	if UTPrefs["block"]==nil then
		UTPrefs["block"] = false;
	end

	-- Set the default language to write Babel.... for now.
	if not UTPrefs["language"] then
		UTPrefs["language"] = "BABEL";
	end
        
        if not UTPrefs["colors"] then
            UTResetCustomColors();
            UTNewInstall = true;
	end
	
	
--[[	
	-- Make the "Speak in Morse" command.
	SlashCmdList["MMCHAT"] = MMSlashHandler;
	SLASH_MMCHAT1 = "/mm";

	-- Make the "Speak in Babel" command.
	SlashCmdList["BABEL"] = BabelSlashHandler;
	SLASH_BABEL1 = "/speakbabel";
	SLASH_BABEL2 = "/sb";
	
	-- Make the "Speak in leet" command.
	SlashCmdList["LEET"] = LeetSlashHandler;
	SLASH_LEET1 = "/leet";
]]
	
	SlashCmdList["UTHELP"] = UTHelp;
	SLASH_UTHELP1 = "/uthelp";
	SLASH_UTHELP2 = "/uth";

	SlashCmdList["UTREAD"] = UTManualTranslationHandler;
	SLASH_UTREAD1 = "/utread";
	SLASH_UTREAD2 = "/utr";

--[[
	SlashCmdList["UTLOCK"] = UTLockSlashHandler;
	SLASH_UTLOCK1 = "/utlock";
	SLASH_UTLOCK2 = "/utl";
]]

	SlashCmdList["UTSAY"] = UTSayHandler;
	SLASH_UTSAY1 = "/utsay";
	SLASH_UTSAY2 = "/uts";

-- If you REALLY want yell, uncomment the following code... but don't say we didn't warn you.
--[[
	SlashCmdList["UTYELL"] = UTYellHandler;
	SLASH_UTYELL1 = "/utyell";
	SLASH_UTYELL2 = "/uty";
]]--

	SlashCmdList["UTGUILD"] = UTGuildHandler;
	SLASH_UTGUILD1 = "/utguild";
	SLASH_UTGUILD2 = "/utg";

	SlashCmdList["UTPARTY"] = UTPartyHandler;
	SLASH_UTPARTY1 = "/utparty";
	SLASH_UTPARTY2 = "/utp";
	
	-- Hook the chat event handler on the front
	if (ChatFrame_OnEvent ~= SavedChatHandler) then
		-- This saves the intended destination.
		SavedChatHandler = ChatFrame_OnEvent;
		-- And ties our event to it.
		ChatFrame_OnEvent = UTChatFrameOnEvent;
	end
        
        if UTNewInstall then
            -- Hook the chat event handler on the end
            if CosmosMasterFrame_Show then
                UTSavedOpenCosmosHandler = CosmosMasterFrame_Show;
                CosmosMasterFrame_Show = UTColorUpdate;
            end
        end
        
	if(Cosmos_RegisterConfiguration) then
		UTran_OnLoad_Cosmos();
	else
		SlashCmdList["UTLANG"] = UTLanguageHandler;
		SLASH_UTLANG1 = "/utlanguage";
		SLASH_UTLANG2 = "/utlang";
		
		SlashCmdList["UTREPLACE"] = UTReplaceHandler;
		SLASH_UTREPLACE1 = "/utreplace";
		
		SlashCmdList["UTTRANSLATE"] = UTTranslationHandler;
		SLASH_UTTRANSLATE1 = "/uttranslate";
		
		SlashCmdList["UTBLOCK"] = UTBlockHandler;
		SLASH_UTBLOCK1 = "/utblock";
		SLASH_UTBLOCK2 = "/utb";
		
		SlashCmdList["UTCOLOR"] = UTColorSlashHandler;
		SLASH_UTCOLOR1 = "/utcolor";
		SLASH_UTCOLOR2 = "/utc";
	end
	
	UTChatMsg("You place the Univeral Translator v." .. version .. " in your ear.");
end 


function UTran_OnLoad_Cosmos()
-------------------------------------------------------------
-- Purpose: Cosmos setup-function.
-- Accepts: N/A
-- Assumes: N/A
-- Returns: N/A
-- Affects: Register with the CosmosMaster,
--	    sets the commands and binds to the Chat Message events.
-------------------------------------------------------------
	
	local UTRAN_HEADER				= "Universal Translator";
	local UTRAN_HEADER_INFO			= "Inter-faction communication\nvia automatic special language translation.";

	local UTRAN_ENABLE_INCOMING_REPLACE		= "Enable incoming translation replacement";
	local UTRAN_ENABLE_INCOMING_REPLACE_INFO	= "Replaces incoming messages with their translation.";
	
	local UTRAN_ENABLE_INCOMING_TRANSLATION		= "Enable incoming translation";
	local UTRAN_ENABLE_INCOMING_TRANSLATION_INFO	= "Displays translation as well as original incoming messages.";

	local UTRAN_ENABLE_BLOCK			= "Block incoming special languages";
	local UTRAN_ENABLE_BLOCK_INFO		= "Incoming messages with a special language prefix are blocked.";
	
	local UTRAN_LANGUAGE_SELECTION		= "Avalible Languages";
	local UTRAN_LANGUAGE_SELECTION_INFO = "Set a language to be spoken.";
	
	local UTRAN_COLOR_SELECTION			= "Custom Color Settings";
	local UTRAN_COLOR_SELECTION_INFO	= "Set the color of each translated chat type";

	
	Cosmos_RegisterConfiguration("COS_UTRAN_HEADER",
		"SECTION",
		UTRAN_HEADER,
		UTRAN_HEADER_INFO
		);
	Cosmos_RegisterConfiguration("COS_UTRAN_HEADER_SECTION",
		"SEPARATOR",
		UTRAN_HEADER,
		UTRAN_HEADER_INFO
		);
	Cosmos_RegisterConfiguration("COS_UTRAN_ENABLE_INCOMING_REPLACE",
		"CHECKBOX",
		UTRAN_ENABLE_INCOMING_REPLACE,
		UTRAN_ENABLE_INCOMING_REPLACE_INFO,
		UTCosReplaceHandler,
		UTbooleanToBinary(UTPrefs["replace"])
	);
	Cosmos_RegisterConfiguration("COS_UTRAN_ENABLE_INCOMING_TRANSLATION",
		"CHECKBOX",
		UTRAN_ENABLE_INCOMING_TRANSLATION,
		UTRAN_ENABLE_INCOMING_TRANSLATION_INFO,
		UTCosTranslationHandler,
		UTbooleanToBinary(UTPrefs["translate"])
	);
	Cosmos_RegisterConfiguration("COS_UTRAN_ENABLE_BLOCK",
		"CHECKBOX",
		UTRAN_ENABLE_BLOCK,
		UTRAN_ENABLE_BLOCK_INFO,
		UTCosBlockHandler,
		UTbooleanToBinary(UTPrefs["block"])
	);
	Cosmos_RegisterConfiguration("COS_UTRAN_LANGUAGE_SELECTION",
		"SEPARATOR",
		UTRAN_LANGUAGE_SELECTION,
		UTRAN_LANGUAGE_SELECTION_INFO
	);
	for langKey, langMode in UTPrefixMap do
		local LANG_STRING = UTprettyTitle(langKey);
		Cosmos_RegisterConfiguration("COS_UTRAN_LANGUAGE_"..langKey,
			"BUTTON", 
			LANG_STRING, 
			"Set "..LANG_STRING.." as the language used in outgoing messages.\n(/uts /uty /utg /utp)",
			langMode.setAsOutput,
			0,
			0,
			0,
			0,
			"Set"
		);
	end
	Cosmos_RegisterConfiguration("COS_UTRAN_COLOR_SELECTION",
		"SEPARATOR",
		UTRAN_COLOR_SELECTION,
		UTRAN_COLOR_SELECTION_INFO
	);
	for chatIndex, chatmode in { "SAY", "YELL", "GUILD", "PARTY" } do
		Cosmos_RegisterConfiguration("COS_UTRAN_COLOR_DEFAULT_"..chatmode,
			"CHECKBOX",
			"Enable "..chatmode.." color settings.",
			"Override system defaults for these special language messages.",
			UTCosSetColors[chatmode]["default"],
			UTbinaryInvert(UTPrefs["colors"][chatmode]["default"])
		);
		for colorIndex, color in { "red", "green", "blue" } do
			Cosmos_RegisterConfiguration("COS_UTRAN_COLOR_"..chatmode.."_"..string.upper(color),
				"SLIDER",
				chatmode.." Color",														--Title
				"Set color of special language "..string.lower(color).." messages.",	--Long Disc
				UTCosSetColors[chatmode][color],										--Handler Function
				1,										--Checked by default
				UTPrefs["colors"][chatmode][color],		--Default Slider Value
				0,										--Min Value
				255,									--Max Value
				color,									--Slider Text (optional)
				1,										--Slider Increment
				1,										--Slider Text On/Off toggle
				"",										--Curr Value Suffix
				1										--Value Text Multiplier?
			);
		end
		Cosmos_RegisterConfiguration("COS_UTRAN_COLOR_TEST_"..chatmode,
			"BUTTON", 
			"Test "..chatmode.." Color.", 
			"Test "..chatmode.." Color.",
			UTCosSetColors[chatmode]["test"],
			0,
			0,
			0,
			0,
			"Test"
		);
	end
	
	Cosmos_RegisterConfiguration("COS_UTRAN_COLOR_DEFAULT_SYSTEM",
		"CHECKBOX",
		"Enable SYSTEM color settings.",
		"Override system defaults for Universal Translator system messages.",
		UTCosSetColors["SYSTEM"]["default"],
		UTbinaryInvert(UTPrefs["colors"]["SYSTEM"]["default"])
	);
	for colorIndex, color in { "red", "green", "blue" } do
		Cosmos_RegisterConfiguration("COS_UTRAN_COLOR_SYSTEM_"..string.upper(color),
			"SLIDER",
			"SYSTEM Color",
			"Set color of Universal Translator system messages.",
			UTCosSetColors["SYSTEM"][color],
			1,										--Checked by default
			UTPrefs["colors"]["SYSTEM"][color],		--Default Slider Value
			0,										--Min Value
			255,									--Max Value
			color,									--Slider Text (optional)
			1,										--Slider Increment
			1,										--Slider Text On/Off toggle
			"",										--Curr Value Suffix
			1										--Value Text Multiplier?
		);
	end
	
	Cosmos_RegisterConfiguration("COS_UTRAN_COLOR_TEST_SYSTEM",
		"BUTTON", 
		"Test SYSTEM Color.", 
		"Test SYSTEM Color.",
		UTCosSetColors["SYSTEM"]["test"],
		0,
		0,
		0,
		0,
		"Test"
	);
	
	Cosmos_RegisterConfiguration("COS_UTRAN_COLOR_RESET",
		"BUTTON", 
		"CUSTOM COLOR RESET", 
		"WARNING: Previous values not retrievable once reset!\n(closes cosmos options frame)",
		UTResetCustomColors,
		0,
		0,
		0,
		0,
		"*RESET*"
	);

end

--Capitolizes the first letter only
function UTprettyTitle(text)
	return string.upper(string.sub(text,1,1))..string.lower(string.sub(text,2)).."";
end

-- 1 => 0, 0 => 1
function UTbinaryInvert(oneZero)
	if oneZero == 1 then
		return 0;
	else 
		return 1;
	end
end

-- true => 1, false => 0
function UTbooleanToBinary(trueFalse)
	if trueFalse then
		return 1;
	else 
		return 0;
	end
end


--------------------------------------------------------------------------
-- UT Cosmos Color Option Handlers
--------------------------------------------------------------------------

UTCosSetColors["SAY"]["default"] = function(checked)
	UTPrefs["colors"]["SAY"]["default"] = UTbinaryInvert(checked);
end

UTCosSetColors["SAY"]["red"] = function(checked, count)
	UTPrefs["colors"]["SAY"]["red"] = count;
end

UTCosSetColors["SAY"]["green"] = function(checked, count)
	UTPrefs["colors"]["SAY"]["green"] = count;
end

UTCosSetColors["SAY"]["blue"] = function(checked, count)
	UTPrefs["colors"]["SAY"]["blue"] = count;
end

UTCosSetColors["SAY"]["test"] = function()
	UTShowColor("SAY");
end

UTCosSetColors["YELL"]["default"] = function(checked)
	UTPrefs["colors"]["YELL"]["default"] = UTbinaryInvert(checked);
end

UTCosSetColors["YELL"]["red"] = function(checked, count)
	UTPrefs["colors"]["YELL"]["red"] = count;
end

UTCosSetColors["YELL"]["green"] = function(checked, count)
	UTPrefs["colors"]["YELL"]["green"] = count;
end

UTCosSetColors["YELL"]["blue"] = function(checked, count)
	UTPrefs["colors"]["YELL"]["blue"] = count;
end

UTCosSetColors["YELL"]["test"] = function()
	UTShowColor("YELL");
end

UTCosSetColors["GUILD"]["default"] = function(checked)
	UTPrefs["colors"]["GUILD"]["default"] = UTbinaryInvert(checked);
end

UTCosSetColors["GUILD"]["red"] = function(checked, count)
	UTPrefs["colors"]["GUILD"]["red"] = count;
end

UTCosSetColors["GUILD"]["green"] = function(checked, count)
	UTPrefs["colors"]["GUILD"]["green"] = count;
end

UTCosSetColors["GUILD"]["blue"] = function(checked, count)
	UTPrefs["colors"]["GUILD"]["blue"] = count;
end

UTCosSetColors["GUILD"]["test"] = function()
	UTShowColor("GUILD");
end

UTCosSetColors["PARTY"]["default"] = function(checked)
	UTPrefs["colors"]["PARTY"]["default"] = UTbinaryInvert(checked);
end

UTCosSetColors["PARTY"]["red"] = function(checked, count)
	UTPrefs["colors"]["PARTY"]["red"] = count;
end

UTCosSetColors["PARTY"]["green"] = function(checked, count)
	UTPrefs["colors"]["PARTY"]["green"] = count;
end

UTCosSetColors["PARTY"]["blue"] = function(checked, count)
	UTPrefs["colors"]["PARTY"]["blue"] = count;
end

UTCosSetColors["PARTY"]["test"] = function()
	UTShowColor("PARTY");
end

UTCosSetColors["SYSTEM"]["default"] = function(checked)
	UTPrefs["colors"]["SYSTEM"]["default"] = UTbinaryInvert(checked);
end

UTCosSetColors["SYSTEM"]["red"] = function(checked, count)
	UTPrefs["colors"]["SYSTEM"]["red"] = count;
end

UTCosSetColors["SYSTEM"]["green"] = function(checked, count)
	UTPrefs["colors"]["SYSTEM"]["green"] = count;
end

UTCosSetColors["SYSTEM"]["blue"] = function(checked, count)
	UTPrefs["colors"]["SYSTEM"]["blue"] = count;
end

UTCosSetColors["SYSTEM"]["test"] = function()
	UTShowColor("SYSTEM");
end


--------------------------------------------------------------------------
-- UT Option Handlers
--------------------------------------------------------------------------


function UTReplaceHandler()
-------------------------------------------------------------
-- Purpose: Handles "Replace with Translation" toggling from slash commands.
-- Accepts: [Optional] arg1 (String) - "on/off" from slash command
-- Assumes: N/A
-- Returns: N/A
-- Affects: Toggles incoming language translation replacement
-------------------------------------------------------------
	if (arg1=="on" or (not UTPrefs["replace"] and arg1==nil)) then
		UTPrefs["replace"] = true;
		UTChatMsg("Auto-replacement translation enabled");
	else
		UTPrefs["replace"] = false;
		UTChatMsg("Auto-replacement translation disabled");
	end
end

function UTCosReplaceHandler(checked)
-------------------------------------------------------------
-- Purpose: Handles "Replace with Translation" toggling from Cosmos options.
-- Accepts: checked (Int) - checkbox value
-- Assumes: N/A
-- Returns: N/A
-- Affects: Toggles incoming language translation replacement
-------------------------------------------------------------
	UTPrefs["replace"] = (checked == 1);
end

function UTTranslationHandler()
-------------------------------------------------------------
-- Purpose: Handles "Translation" toggling.
-- Accepts: [Optional] arg1 (String) - "on/off" from slash command
-- Assumes: N/A
-- Returns: N/A
-- Affects: Toggles incoming language translation
-------------------------------------------------------------
	if (arg1=="on" or (not UTPrefs["translate"] and arg1==nil)) then
		UTPrefs["translate"] = true;
		UTChatMsg("Translation message enabled");
	else
		UTPrefs["translate"] = false;
		UTChatMsg("Translation message disabled");
	end
end

function UTCosTranslationHandler(checked)
-------------------------------------------------------------
-- Purpose: Handles "Translation" toggling from Cosmos options.
-- Accepts: checked (Int) - checkbox value 
-- Assumes: N/A
-- Returns: N/A
-- Affects: Toggles incoming language translation
-------------------------------------------------------------
	UTPrefs["translate"] = (checked == 1);
end

function UTBlockHandler()
-------------------------------------------------------------
-- Purpose: Handles "Block Incomming" toggling from slash commands.
-- Accepts: [Optional] arg1 (String) - "on/off" from slash command
-- Assumes: N/A
-- Returns: N/A
-- Affects: Toggles incoming language message block
-------------------------------------------------------------
	if (arg1=="on" or (not UTPrefs["block"] and arg1==nil)) then
		UTPrefs["block"] = true;
		UTChatMsg("Translation blocking enabled");
	else
		UTPrefs["block"] = false;
		UTChatMsg("Translation blocking disabled");
	end
end

function UTCosBlockHandler(checked)
-------------------------------------------------------------
-- Purpose: Handles "Block Incomming" toggling from Cosmos options.
-- Accepts: checked (Int) - checkbox value
-- Assumes: N/A
-- Returns: N/A
-- Affects: Toggles incoming language message block
-------------------------------------------------------------
	UTPrefs["block"] = (checked == 1);
end


--------------------------------------------------------------------------
-- Automatic Translation
--------------------------------------------------------------------------


function UTChatFrameOnEvent(event)
-------------------------------------------------------------
-- Purpose: Provides automatic "READ" translation functionality.
--	    translates Babel, Leet or Morse Code.
-- Accepts: event (String) - The Chat Message Event taking place.
--			optional arg1 - the chat message
--			optional arg2 - the message sender
-- Assumes: N/A
-- Returns: N/A
-- Affects: Writes the translated text to the chat console.
-------------------------------------------------------------
	local translation = "";
	local type;
	-- If the event is a Chat Message of any sort, prepare to test for a need to convert.
	if ( string.sub(event, 1, 8) == "CHAT_MSG" ) then
		type = strsub(event, 10);
		-- If the type is a Say, a Guild, a Yell or a Party conversation, convert.
		if ( type == "SAY" or type == "GUILD" or type == "YELL" or type == "PARTY") then
			for langKey, langMode in UTPrefixMap do
				-- loop through conversion languages
				if arg1 and (string.find(arg1, langMode.prefix, 1 , true) == 1) then
					-- Block Translation
					if UTPrefs["block"] then
						if langMode.blocked then
							arg1 = langMode.blocked;
						else
							arg1 = "";
						end
						-- Pass control on to the original chathandler
						SavedChatHandler(event);
						return;
					end
					-- Translate the special language in the chunk of text excluding the prefix.
					translation = langMode.readfunc(string.sub(arg1,string.len(langMode.prefix)+1));
					-- Check for alternate printing name
					local displayName;
					if langMode.altname then
						displayName = langMode.altname;
					else
						displayName = langKey;
					end
					if UTPrefs["replace"] then
						-- Replace message with translation
						arg1 = "("..displayName..") "..translation;
					end
					-- If default disabled temporarily change text color
					if UTPrefs["colors"][type]["default"] == 0 then
						UTOverwriteColors(type, type);
					end
					-- Pass control on to the original chathandler
					SavedChatHandler(event);
					-- Restore user colors
					if UTPrefs["colors"][type]["default"] == 0 then
						UTRestoreColors(type);
					end
					if UTPrefs["translate"] then
						-- Print Translation
						WriteOutput(UTGenerateHeader(type, arg2, displayName)..translation, type, this);
					end
					return;
				end
			end
		end
	end
	-- If there's been no change pass the control on to the original chathandler
	SavedChatHandler(event);
end

--------------------------------------------------------------------------
-- Manual Translator Function
--------------------------------------------------------------------------

function UTManualTranslationHandler(msg)
-------------------------------------------------------------
-- Purpose: Manually translates a given message.
-- Accepts: msg (String) - The message to translate.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Writes the translated text to the chat console.
-------------------------------------------------------------
	-- For manual translation, default to the "Say" colors.
	local type = "SAY";
	local translation = "";
	local knownPrefixes = ""
	for langKey, langMode in UTPrefixMap do
		-- loop through conversion languages
		if msg and (string.find(msg, langMode.prefix, 1 , true) == 1) then
			-- Translate the special language in the chunk of text excluding the prefix.
			translation = "Translation: "..langMode.readfunc(string.sub(msg,string.len(langMode.prefix)+1));
			WriteOutput(UTprettyTitle(langKey)..": "..msg, type, DEFAULT_CHAT_FRAME);
			WriteOutput(translation, type, DEFAULT_CHAT_FRAME);
			return;
		end
		if knownPrefixes ~= "" then
			knownPrefixes = knownPrefixes..", ";
		end
		knownPrefixes = knownPrefixes..langMode.prefix;
	end
	WriteOutput("Prefix not recognized. ", type, DEFAULT_CHAT_FRAME);
	WriteOutput("Known Prefixes: "..knownPrefixes, type, DEFAULT_CHAT_FRAME);
end


--------------------------------------------------------------------------
-- Language Choosing Function
--------------------------------------------------------------------------


function UTLanguageHandler(msg)
-------------------------------------------------------------
-- Purpose: Changes the default language. 
-- Accepts: msg (String) - The language that the user has
--			   requested a change to.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Changes UTPrefs["language"] to the new requested language,
--	    writes an acknowledgement message to the user.
-------------------------------------------------------------
	-- Drop it to upper case for comparison purposes.
	local NewLang = string.upper(msg)
	local found = false;
	-- If it's morse, change the default language to Morse code.
	for langKey, langMode in UTPrefixMap do
		if (NewLang == langKey or NewLang == langMode.altname) then
			UTPrefs["language"] = langKey;
			UTChatMsg("Language changed to "..langKey);
			found = true;
		end
	end
	-- If it's not found, it's unrecognized.  Tell the user.
	if not found then
		UTChatMsg("Unrecognized language format.");
	end
end

UTPrefixMap["MORSE"].setAsOutput = function()
-------------------------------------------------------------
-- Purpose: Changes the default language to Morse. 
-- Accepts: N/A
-- Assumes: N/A
-- Returns: N/A
-- Affects: Changes UTPrefs["language"] to "MORSE".
-------------------------------------------------------------
	UTPrefs["language"] = "MORSE";
end

UTPrefixMap["BABEL"].setAsOutput = function()
-------------------------------------------------------------
-- Purpose: Changes the default language to Babel. 
-- Accepts: N/A
-- Assumes: N/A
-- Returns: N/A
-- Affects: Changes UTPrefs["language"] to "BABEL".
-------------------------------------------------------------
	UTPrefs["language"] = "BABEL";
end

UTPrefixMap["LEET"].setAsOutput = function()
-------------------------------------------------------------
-- Purpose: Changes the default language to Leet. 
-- Accepts: N/A
-- Assumes: N/A
-- Returns: N/A
-- Affects: Changes UTPrefs["language"] to "LEET".
-------------------------------------------------------------
	UTPrefs["language"] = "LEET";
end

UTPrefixMap["INTERNATIONAL"].setAsOutput = function()
-------------------------------------------------------------
-- Purpose: Changes the default language to International. 
-- Accepts: N/A
-- Assumes: N/A
-- Returns: N/A
-- Affects: Changes UTPrefs["language"] to "INTERNATIONAL".
-------------------------------------------------------------
	UTPrefs["language"] = "INTERNATIONAL";
end

--------------------------------------------------------------------------
-- Speech Handling Functions
--------------------------------------------------------------------------


function UTSayHandler(msg)
-------------------------------------------------------------
-- Purpose: Handles "Say" write to Universal requests.
-- Accepts: msg (String) - The string to translate to the default
--			   language.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Calls one of the other handlers, depending on the
--	    default language.
-------------------------------------------------------------
	-- Tell the Master Write Handler that we are issuing a "Say".
	UTMasterWriteHandler(msg, "SAY");
end


function UTYellHandler(msg)
-------------------------------------------------------------
-- Purpose: Handles "Yell" write to Universal requests.
-- Accepts: msg (String) - The string to translate to the default
--			   language.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Calls one of the other handlers, depending on the
--	    default language.
-------------------------------------------------------------
	-- Tell the Master Write Handler that we are issuing a "Yell".
	UTMasterWriteHandler(msg, "YELL");
end


function UTGuildHandler(msg)
-------------------------------------------------------------
-- Purpose: Handles "Guild" write to Universal requests.
-- Accepts: msg (String) - The string to translate to the default
--			   language.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Calls one of the other handlers, depending on the
--	    default language.
-------------------------------------------------------------
	-- Tell the Master Write Handler that we are issuing a "Guild"
	UTMasterWriteHandler(msg, "GUILD");
end


function UTPartyHandler(msg)
-------------------------------------------------------------
-- Purpose: Handles "Party" write to Universal requests.
-- Accepts: msg (String) - The string to translate to the default
--			   language.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Calls one of the other handlers, depending on the
--	    default language.
-------------------------------------------------------------
	-- Tell the Master Write Handler that we are issuing a "Party"
	UTMasterWriteHandler(msg, "PARTY");
end


function UTMasterWriteHandler(msg, ChatMode)
-------------------------------------------------------------
-- Purpose: Direct handlers pass the message and Chat Mode to
--	    this function so that it can send the message to the
--	    specific language encoder.
-- Accepts: msg (String) - The string to encode.
--	    ChatMode (String) - The Chat Mode being used.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Calls the language encoder to write the message.
-------------------------------------------------------------
	for langKey, langMode in UTPrefixMap do
		if UTPrefs["language"] == langKey then
			UTPrefixMap[langKey].writefunc(msg, ChatMode)
		end
	end
end


UTPrefixMap["MORSE"].writefunc = function (msg, ChatMode)
-------------------------------------------------------------
-- Purpose: Handles "Write to Morse Code" requests. 
-- Accepts: msg (String) - The string to translate to Morse Code.
--	    ChatMode (String) - The Chat Mode.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sends a chat message in the pre-defined chat mode
--	    so that others can recieve it.
-------------------------------------------------------------
	msg = string.lower(msg);
	local text = UTPrefixMap["MORSE"].prefix;
	for i = 1, string.len(msg), 1 do
		local char = string.sub(msg,i,i);
		if CharToMorse[char] then
			text = text .. CharToMorse[char] .. " ";
		else
			text = text .. char .. " ";
		end
	end
	SendChatMessage(text, ChatMode, GetDefaultLanguage());
end

UTPrefixMap["INTERNATIONAL"].writefunc = function (msg, ChatMode)
-------------------------------------------------------------
-- Purpose: Handles "Write to International" requests.
-- Accepts: msg (String) - The string to translate to International.
--	    ChatMode (String) - The Chat Mode.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sends a chat message in the pre-defined chat mode
--	    so that others can recieve it.
-------------------------------------------------------------
	local i = 1;
	local a = "";
	local b = "";
	local j = 1;
	local AUTMsg = "";
	AUTMsg = UTPrefixMap["INTERNATIONAL"].prefix;

	for i=1,strlen(msg) do
		a = strsub(msg,i,i);
		for j=0,3 do
			b = strfind(InternationalChars[j],a,1);
			if b ~= nil then
				if j ~= 0 then
					if b < 10 then b="0"..b; end
					AUTMsg = AUTMsg..j..b;
				else
					AUTMsg = AUTMsg..j;
				end
			end
		end
	end
	SendChatMessage(AUTMsg, ChatMode, GetDefaultLanguage());
end


UTPrefixMap["BABEL"].writefunc = function (msg, ChatMode)
-------------------------------------------------------------
-- Purpose: Handles "Write to Babel" requests. 
-- Accepts: msg (String) - The string to translate to Babel.
--	    ChatMode (String) - The Chat Mode.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sends a chat message in the pre-defined chat mode
--	    so that others can recieve it.
-------------------------------------------------------------
	local Output = UTPrefixMap["BABEL"].prefix;
	-- Loop through the message, and for every character add the ascii number
	-- to the output.
	for i = 1, string.len(msg) do
		Output = Output .. string.byte(msg, i) .. "#";
	end
	SendChatMessage(Output, ChatMode, GetDefaultLanguage());
end

UTPrefixMap["LEET"].writefunc = function (msg, ChatMode)
-------------------------------------------------------------
-- Purpose: Handles "Write to Leet" requests. 
-- Accepts: msg (String) - The string to translate to Leet.
--	    ChatMode (String) - The Chat Mode.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sends a chat message in the pre-defined chat mode
--	    so that others can recieve it.
-------------------------------------------------------------
	local text = UTPrefixMap["LEET"].prefix;
	for i = 1, string.len(msg), 1 do
		local char = string.sub(msg,i,i);
		if CharToLeet[char] then
			text = text .. CharToLeet[char];
		else
			text = text .. char .. " ";
		end
	end
	SendChatMessage(text, ChatMode, GetDefaultLanguage());
	--[[
	local TranslatedText = msg;
	for key, value in CharToLeet do
		TranslatedText, instances = gsub(TranslatedText, key, value);
	end
	SendChatMessage(UTPrefixMap["LEET"].prefix..TranslatedText, ChatMode, GetDefaultLanguage());
	]]--
end


--[[function UTLockSlashHandler(msg)
-------------------------------------------------------------
-- Purpose: Changes the chat mode to the user requested mode.
-- Accepts: msg (String) - The chat mode to switch to.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Changes UTPrefs["chatmode"] to the desired mode.
--	    sends a message to the Chat window about the result.
-------------------------------------------------------------
	-- Convert to upper case for use later in Message functions.
	msg = string.upper(msg);
	-- Find the meat of what we want.
	local startpos, endpos, chatmode = string.find(msg, "(%w+)");
	-- If the requested chatmode is valid, set it.
	if chatmode == "SAY" or chatmode == "YELL" or chatmode == "GUILD" or chatmode == "PARTY" then
		UTPrefs["chatmode"] = chatmode;
		UTChatMsg("Translation Chat Mode changed to " .. chatmode .. ".");
	-- Otherwise, inform the user it was invalid.
	else
		UTChatMsg("Invalid Chat Mode.");
	end
end
]]


--------------------------------------------------------------------------
-- Color Selection Handler
--------------------------------------------------------------------------


function UTColorSlashHandler(msg)
-------------------------------------------------------------
-- Purpose: Changes/sets the color settings of the Translator.
-- Accepts: msg (String) - The colors to change, and/or settings to change.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Changes the color settings found in UTPrefs["colors"] for
--	    the given chat mode(s).
-------------------------------------------------------------
	-- Again, set to upper for use later.
	msg = string.upper(msg);	
        
        -- If first time loading reset colors
        if UTNewInstall then
            UTResetCustomColors();
            UTNewInstall = false;
        end

	local startpos, endpos, chatmode, red, green, blue = string.find(msg, "(%w+) (%d+) (%d+) (%d+)");	
	if chatmode and red and green and blue and (chatmode == "SYSTEM" or chatmode == "SAY" or chatmode == "YELL" or chatmode == "GUILD" or chatmode == "PARTY") then
		UTPrefs["colors"][chatmode]["default"] = 0;
		UTPrefs["colors"][chatmode]["red"] = red;
		UTPrefs["colors"][chatmode]["green"] = green;
		UTPrefs["colors"][chatmode]["blue"] = blue;
		UTShowColor(chatmode);
	else
		local command, onoff;
		startpos, endpos, chatmode, command = string.find(msg, "(%w+) (%w+)");
		if chatmode and command and (chatmode == "SYSTEM" or chatmode == "SAY" or chatmode == "YELL" or chatmode == "GUILD" or chatmode == "PARTY") then
			onoff = string.sub(msg,endpos+2);
			if command == "DEFAULT" and onoff then
				if onoff == "ON" then
					UTPrefs["colors"][chatmode]["default"] = 1;
					UTShowColor(chatmode);
				end
				if onoff == "OFF" then
					UTPrefs["colors"][chatmode]["default"] = 0;
					UTShowColor(chatmode);
				end
			end
			if command == "SHOW" then
				UTShowColor(chatmode);
			end
                        if command == "RESET" then
				UTDefaultColors(chatmode);
			end
                elseif chatmode == "ALL" and command == "RESET" then
                        UTResetCustomColors();
                else
			UTHelp();
		end
	end
end


--------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------


function UTShowColor(chatmode)
-------------------------------------------------------------
-- Purpose: Displays a message regarding the current color settings.
-- Accepts: chatmode (String) - The chat mode to display color settings for.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sends a message about the color settings to the Chat Window.
-------------------------------------------------------------
	local ct = UTPrefs["colors"][chatmode];
	local info = ChatTypeInfo[chatmode];
	local show = "Settings for "..chatmode..": Default = ";
	if ct.default == 1 then
		show = show .. "ON";
	end
	if ct.default == 0 then
		show = show .. "OFF";
	end
	show = show .. " Custom Color = " .. ct.red .. " " .. ct.green .. " " .. ct.blue;
	if UTPrefs["colors"][chatmode]["default"] == 1 then
		DEFAULT_CHAT_FRAME:AddMessage(show, info.r, info.g, info.b, info.id);
	else
		DEFAULT_CHAT_FRAME:AddMessage(show, ct.red/255, ct.green/255, ct.blue/255, info.id);
	end
end


function UTChatMsg(msg)
-------------------------------------------------------------
-- Purpose: Sends the given message to the Chat Window.
-- Accepts: msg (String) - The message to display.
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sends the message to the chat window.
-------------------------------------------------------------
	local info = ChatTypeInfo["SYSTEM"];
	local ct = UTPrefs["colors"]["SYSTEM"];
	if (UTPrefs["colors"]["SYSTEM"]["default"] == 1) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, info.r, info.g, info.b);
	else
		DEFAULT_CHAT_FRAME:AddMessage(msg, ct.red/255, ct.green/255, ct.blue/255);
	end
end


function UTHelp()
-------------------------------------------------------------
-- Purpose: Displays help in the chat window.
-- Accepts: N/A
-- Assumes: N/A
-- Returns: N/A
-- Affects: Writes help text to the chat window.
-------------------------------------------------------------
        -- If first time loading reset colors
        if UTNewInstall then
            UTResetCustomColors();
            UTNewInstall = false;
        end
        
	UTChatMsg("Universal Translator v." .. version .. " help");
	UTChatMsg("----------------------------------------------");
	UTChatMsg("*** Chat Commands ***");
	UTChatMsg("/uts (your-text-here) - UT Say Command");
--	UTChatMsg("/uty (your-text-here) - UT Yell Command");
	UTChatMsg("/utg (your-text-here) - UT Guild Command");
	UTChatMsg("/utp (your-text-here) - UT Party Command");
	UTChatMsg("/utr (your-text-here) - Manually translate any language. Requires prefix.");
	UTChatMsg("*** Utility Commands ***");
	if not Cosmos_RegisterConfiguration then
		UTChatMsg("/utlang (language) - Choose your Default Language");
		UTChatMsg("        language = Morse | Intl | Babel | Leet | Intl");
		UTChatMsg("/utreplace [on/off] - "..UTRAN_ENABLE_INCOMING_REPLACE_INFO);
		UTChatMsg("/uttranslate [on/off] - "..UTRAN_ENABLE_INCOMING_TRANSLATION_INFO);
		UTChatMsg("/utb [on/off] - "..UTRAN_ENABLE_BLOCK_INFO);
		UTChatMsg("/utcolor (chatmode) show - Show Current Color Scheme");
		UTChatMsg("/utcolor (chatmode) (red) (green) (blue) - Change Color Scheme");
		UTChatMsg("/utcolor (chatmode) default (on|off) - Set Default Color Scheme");
		UTChatMsg("         chatmode = say | yell | guild | party | system");
		UTChatMsg("         red, green, blue = values between [0 and 255]");
                UTChatMsg("/utcolor (chatmode) reset - Reset Chatmode to Default Color Scheme");
                UTChatMsg("/utcolor all reset - Reset All Chatmode's to Default Color Scheme");
	else
		UTChatMsg("USE THE COSMOS OPTIONS MENU FOR MAIN CONTROLS.");
	end
	UTChatMsg("/uthelp - UT Help File");
	UTChatMsg("*** Current Settings ***");
	UTChatMsg("Speaking language set to "..UTPrefs["language"]..".");
	UTChatMsg("Replacement Translation "..BooleanToEnabledDisabled(UTPrefs["replace"])..".");
	UTChatMsg("Post-Message Translation "..BooleanToEnabledDisabled(UTPrefs["translate"])..".");
	UTChatMsg("Special Language Blocking "..BooleanToEnabledDisabled(UTPrefs["block"])..".");
	UTShowColor("SAY");
	UTShowColor("YELL");
	UTShowColor("GUILD");
	UTShowColor("PARTY");
	UTShowColor("SYSTEM");
end

function BooleanToEnabledDisabled(onoff)
	if onoff then
		return "Enabled";
	end
	return "Disabled";
end

-- hook Cosmos Options Menu to reset values on the first time openned.
function UTColorUpdate()
    UTResetCustomColors("keepOpen");
    UTNewInstall = false;
    UTSavedOpenCosmosHandler(this);
    CosmosMasterFrame_Show = UTSavedOpenCosmosHandler;
end


function UTResetCustomColors()
-------------------------------------------------------------
-- Purpose: Sets all UT colors back to default colors.
-- Accepts: [Optional] arg1 (String) - "keepOpen" doesn't close the cosmos options
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sets all UTPrefs["colors"] to their ChatTypeInfo equivalent.
--			Syncs with cosmos.
-------------------------------------------------------------
	UTPrefs["colors"] = { };
	UTDefaultColors("SAY");
	UTDefaultColors("YELL");
	UTDefaultColors("PARTY");
	UTDefaultColors("GUILD");
	UTDefaultColors("SYSTEM");
	if Cosmos_RegisterConfiguration then
		if (CosmosMasterFrame:IsVisible()) then
			PlaySound("gsTitleOptionOK");
			CosmosMaster_Save();
                        if arg1 ~= "keepOpen" then
                            HideUIPanel(CosmosMasterFrame);
                        end
		end
	end
end


function UTDefaultColors(UTPrefsIndex)
-------------------------------------------------------------
-- Purpose: Sets UT colors back to default colors.
-- Accepts: UTPrefsIndex (String) - UTPrefs["colors"] index string
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sets UTPrefs["colors"][UTPrefsIndex] to it's ChatTypeInfo equivalent.
--			Syncs with cosmos.
-------------------------------------------------------------
	UTPrefs["colors"][UTPrefsIndex] = { };
	UTPrefs["colors"][UTPrefsIndex]["default"] = 1;
	UTPrefs["colors"][UTPrefsIndex]["red"] = floor(ChatTypeInfo[UTPrefsIndex].r*255);
	UTPrefs["colors"][UTPrefsIndex]["green"] = floor(ChatTypeInfo[UTPrefsIndex].g*255);
	UTPrefs["colors"][UTPrefsIndex]["blue"] = floor(ChatTypeInfo[UTPrefsIndex].b*255);
	if Cosmos_RegisterConfiguration then
		Cosmos_UpdateValue( "COS_UTRAN_COLOR_DEFAULT_"..UTPrefsIndex, CSM_CHECKONOFF, 0 );
		Cosmos_UpdateValue( "COS_UTRAN_COLOR_"..UTPrefsIndex.."_RED", CSM_SLIDERVALUE, floor(ChatTypeInfo[UTPrefsIndex].r*255) );
		Cosmos_UpdateValue( "COS_UTRAN_COLOR_"..UTPrefsIndex.."_GREEN", CSM_SLIDERVALUE, floor(ChatTypeInfo[UTPrefsIndex].g*255) );
		Cosmos_UpdateValue( "COS_UTRAN_COLOR_"..UTPrefsIndex.."_BLUE", CSM_SLIDERVALUE, floor(ChatTypeInfo[UTPrefsIndex].b*255) );
	end
end


function UTOverwriteColors(ChatTypeIndex, UTPrefsIndex)
-------------------------------------------------------------
-- Purpose: Sets the Chat Type colors to match UTPrefs values.
-- Accepts: ChatTypeIndex (String) - ChatTypeInfo index string
--			UTPrefsIndex (String) - UTPrefs["colors"] index string
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sets the colors of ChatTypeInfo[ChatTypeIndex].
-------------------------------------------------------------
	TempColors.r = ChatTypeInfo[ChatTypeIndex].r;
	TempColors.g = ChatTypeInfo[ChatTypeIndex].g;
	TempColors.b = ChatTypeInfo[ChatTypeIndex].b;
	ChatTypeInfo[ChatTypeIndex].r = UTPrefs["colors"][UTPrefsIndex]["red"]/255;
	ChatTypeInfo[ChatTypeIndex].g = UTPrefs["colors"][UTPrefsIndex]["green"]/255;
	ChatTypeInfo[ChatTypeIndex].b = UTPrefs["colors"][UTPrefsIndex]["blue"]/255;
end

function UTRestoreColors(ChatTypeIndex)
-------------------------------------------------------------
-- Purpose: Sets the Chat Type colors to match UTPrefs values.
-- Accepts: ChatTypeIndex (String) - ChatTypeInfo index string
--			UTPrefsIndex (String) - UTPrefs["colors"] index string
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sets the colors of ChatTypeInfo[ChatTypeIndex].
-------------------------------------------------------------
	ChatTypeInfo[ChatTypeIndex].r = TempColors.r;
	ChatTypeInfo[ChatTypeIndex].g = TempColors.g;
	ChatTypeInfo[ChatTypeIndex].b = TempColors.b;
end



function UTGenerateHeader(ChatType, Author, Language)
-------------------------------------------------------------
-- Purpose: Generates a header for post-message translation
--		given the type of Chat and the person saying it.
-- Accepts: ChatType (String) - The type of chat (SAY, YELL, GUILD or PARTY)
--			Author (String) - The name of the person who says it.
--			Language (String) - The language it was translated from.
-- Assumes: N/A
-- Returns: String - The header generated.
-------------------------------------------------------------
	local header = nil;
	if ChatType == "SAY" then
		header = "[" .. Author .. "] says: ("..Language..") ";
	end
	if ChatType == "YELL" then
		header = "[" .. Author .. "] yells: ("..Language..") ";
	end
	if ChatType == "GUILD" then
		header = "[Guild] [" .. Author .. "]: ("..Language..") ";
	end
	if ChatType == "PARTY" then
		header = "[Party] [" .. Author .. "]: ("..Language..") ";
	end
	return header;
end


UTPrefixMap["MORSE"].readfunc = function (TextToRead)
-------------------------------------------------------------
-- Purpose: Translates morse code given a block of Morse text.
-- Accepts: TextToRead (String) - The text to be translated.
-- Assumes: N/A
-- Returns: String - the text, translated into standard language.
-------------------------------------------------------------
	local letter = "";
	local morsechar = "";
	local TranslatedText = "";
	for i = 1, string.len(TextToRead), 1 do
		letter = "";
		morsechar = string.sub(TextToRead, i, i);
		while not(morsechar == " ") and i <= string.len(TextToRead) do 
			letter = letter .. morsechar;
			i = i + 1;
			morsechar = string.sub(TextToRead, i, i);
		end

		if MorseToChar[letter] then
			TranslatedText = TranslatedText .. MorseToChar[letter];
		else
			TranslatedText = TranslatedText .. letter;
			if morsechar == " " and string.sub(TextToRead, i+1, i+1) == " " then
				TranslatedText = TranslatedText .. " ";
				i=i+1;
			end
		end
	end
	return TranslatedText;
end


UTPrefixMap["INTERNATIONAL"].readfunc = function (TextToRead)
-------------------------------------------------------------
-- Purpose: Translates Int'l given a block of Int'l text.
-- Accepts: TextToRead (String) - The text to be translated.
-- Assumes: N/A
-- Returns: String - the text, translated into standard language.
-------------------------------------------------------------
	local i = 1;
	local a = ""
	local l = 0;
	local b = "";
	local AUTMsg = "";
	for i=1,strlen(TextToRead), 3 do
		a = strsub(TextToRead, i,i+2);
		if (tonumber(strsub(a,1,1)) == 0) then
                        i = i-2;
                        AUTMsg = AUTMsg.." ";
		elseif (tonumber(strsub(a,2,3))) then
	 		l = tonumber(strsub(a,2,3));
			b = strsub(InternationalChars[tonumber(strsub(a,1,1))],l,l);
			AUTMsg = AUTMsg..b;
		end
	end
	return AUTMsg;
end


UTPrefixMap["BABEL"].readfunc = function (TextToRead)
-------------------------------------------------------------
-- Purpose: Translates Babel given a block of Babel text.
-- Accepts: TextToRead (String) - The text to be translated.
-- Assumes: N/A
-- Returns: String - the text, translated into standard language.
-------------------------------------------------------------
	local CurAscii = ""
	local Output = ""
	for i = 1, string.len(TextToRead) do
		-- If we've come to a #, use the current Ascii holder to add to output.
		if string.sub(TextToRead, i, i) == "#" then
			-- Add a character to the output.
			if tonumber(CurAscii) then
				Output = Output .. string.char(tonumber(CurAscii));
			end
			-- Reset the Current Ascii holder.
			CurAscii = "";
		else
			-- Append this number character to the Ascii holder.
			CurAscii = CurAscii .. string.sub(TextToRead, i, i);
		end
	end
	return Output;
end

UTPrefixMap["LEET"].readfunc = function (TextToRead)
-------------------------------------------------------------
-- Purpose: Translates leet given a block of leet text.
-- Accepts: TextToRead (String) - The text to be translated.
-- Assumes: N/A
-- Returns: String - the text, translated into standard language.
-------------------------------------------------------------
	local TranslatedText = TextToRead;
	for key, value in LeetToChar do
		TranslatedText, instances = gsub(TranslatedText, key, value);
	end
	return TranslatedText;
end

function WriteOutput(TextOutput, TextType, ChatFrame)
-------------------------------------------------------------
-- Purpose: Writes the output of a translation in the given Text type.
-- Accepts: TextOutput (String) - The pre-formatted translated text
--				  to display.
--	    	TextType (String) - The type of message to display (SAY, YELL, GUILD, PARTY)
--			ChatFrame - Where to display it
-- Assumes: N/A
-- Returns: N/A
-- Affects: Sends a message to the chat window with the translated
--	    text in the proper color for the chat type.
-------------------------------------------------------------
	local info = ChatTypeInfo[TextType];
	if UTPrefs["colors"][TextType]["default"] == 1 then
		ChatFrame:AddMessage(TextOutput, info.r, info.g, info.b, info.id);
	else
		local ct = UTPrefs["colors"][TextType];
		ChatFrame:AddMessage(TextOutput, ct.red/255, ct.green/255, ct.blue/255, info.id);
	end
end

