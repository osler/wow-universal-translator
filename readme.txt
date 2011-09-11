--------------------------------------------------------
-- The Universal Translator for WoW 1.7.3
--------------------------------------------------------
Created by AnduinLothar, Brachan, Jack Colorado and miscman, 2005, for public domain usage.


-----------------------------------
CONTENTS
-----------------------------------
I. Introduction
II. What's New
III. Installation, and uninstalling MorseMod, LeetSpeak and BabelFish
IV. Instructions
V. A Question of Ethics
VI. The Future Plan for the UT, and Acknowledgements
VII. Contact Us



-----------------------------------
I. Introduction
-----------------------------------

This is a simple AddOn for use in World of Warcraft, that
allows you to speak to and understand other factions and
languages, when those who speak said other languages wish for
you to hear their message.

The extent to which this will work depends entirely on
the amount of people that use it: the Universal Translator
translates any in-game language into an intermediate code, which 
your console will then translate for you automatically!  However,
the speaking player must be using the Universal Translator's 
translation script in order for the translation to work properly,
so spread the word!

This particular mod, the Universal Translator, is a collaborative
effort between me and my colleagues, Miscman (the creator
of MorseMod), AnduinLothar (the creator of LeetFilter) and Brachan
(the creator of the new International Language).  We decided to 
collaborate in an attempt to make sure that there are no language barriers
in the "language barrier-freeing" category of UI Mods.  The Universal
Translator perfectly understands and translates Babel, Leetspeak, 
Morse Code, and International, thus rendering the previous programs obsolete.
This is the only Mod you now need for cross communication!

With our uniting, we are adding the best features from both Mods:
we now have color customization and a help command from MorseMod, GUI and
several convenience features from LeetFilter, International Character support
from Brachan's Language and the quick access/task switching chat commands of 
BabelFish.

This file is available for free distribution.  Host it,
rant about it, do whatever you want with it as long as we retain
credit for the original work.  But do tell us what you're doing with
it, we're interested in hearing how this has helped people!




-----------------------------------
II. What's New in v1.7.2
-----------------------------------
* Updated to latest version number.
-----------------------------------
II. What's New in v1.7.2
-----------------------------------
* Fixed a bug that wouldn't load the default colors on first install
* Added Slashcommands:
    /utcolor all reset - reset all UT chat colors to default
    /utcolor (chatmode) reset - reset a single UT chat color to default
* Updated Readme Errors
-----------------------------------
II. What's New in v1.7
-----------------------------------
We've added several features, thanks to the brilliant contributions of
AnduinLothar and Brachan (Welcome to the team, guys! =) ):

* Full Backwords-Compatible support for LeetFilter's Leetspeak.
* Support for a new, International-Character supporting language (that is
  expandable without backwords-compatibility issues - more character support
  is to come!)
* Cosmos GUI Settings support
* Language Replacement Option (No more seeing the intermediate characters!)
* Language Blocking/Filtering Option 


-----------------------------------
III. Installation, and Uninstalling MorseMod, LeetFilter and BabelFish
-----------------------------------

There's the easy way or the hard way...

* The Easy Way (for those who installed WoW to their C drive in a normal location)

1) Unzip the contents of this ZIP file anywhere.

2) Run "install.bat" (found inside the UTran directory that you just unzipped)

3) You're done!  Don't worry if you see any "File not found" messages: that
   is simply the batch file checking to see if older versions are installed
   so it can remove them.


* The Hard Way (For those who want to do it themselves, or have WoW in
	a Nonstandard location.)

1) Create Interface folder if it doesn't exist.
	In your World Of Warcraft directory, there is a
	subdirectory labeled "Interface".  If it doesn't exist,
	create it with that exact spelling.

2) Create AddOns directory under Interface if it doesn't exist.
	Under the Interface directory there should be an "AddOns"
	folder.  If there isn't one, create it under the "Interface"
	folder.

3) Add the folder included in this ZIP file into the "AddOns" directory.
	Take the whole folder (not the contents, but the folder itself),
	and place it under the "AddOns" directory.

4) Before you run World of Warcraft, go into your AddOns directory
   and delete the "MorseMod", "LeetFilter" and/or "BabelFish" folders from the
   directory.  This will successfully uninstall the two predecessor programs.

4) Run World of Warcraft.  If you see a message saying that the Universal
   Translator is running, you are done!

-----------------------------------
IV. Instructions
-----------------------------------

  * Using Cosmos with the Universal Translator

	The Universal Translator will automatically bind itself to Cosmos if
	Cosmos is available, making many of these settings (such as color, blocking
	etc...) available through the Cosmos GUI.  However, even without cosmos
	you may use the slash commands listed below to change settings in UT.

  * Manually Reading/Interpreting Universal Languages (not often done)

	The Universal Translator (UT) will AUTOMATICALLY interpret any Babel,
	LeetSpeak, Int'l or Morse Code that is typed in "Say" mode (standard speech).

	If you ever feel the need to manually interpret Babel or Morse, 
	you may	use the following command:

	/utr (UniversalText)

	or, alternatively:

	/utread (UniversalText)

	Where (UniversalText) is the text, including the "@#" opening characters,
	to be translated from Babel to standard readable language.  If you are
	translating Morse, you must prefix the Morse code with "--  --".

  * Speaking in Universal Languages

	Speaking in Universal is just as easy!  Though not automatic,
	simply use the following commands to speak in your chosen
	Universal Language (UT users can understand either of them):

	*** "Say" Command ***

	/utsay (NormalText)

	or

	/uts (NormalText)

	EXAMPLE:	/uts Crazy!
	OUTPUT:		(Says "Crazy!" in Universal Language)

	*** "Yell" Command ***

	/utyell (NormalText)

	or

	/uty (NormalText)

	EXAMPLE:	/uty Crazy!
	OUTPUT:		(Yells "Crazy!" in Universal Language)

	NOTE: The Yell command has been disabled by default in this
	      version.  To enable it, you must edit the lua file.
	      We do not condone the use of this command, and have
	      left it merely for backwords compatibility.

	*** "Guild" Command ***

	/utguild (NormalText)

	or

	/utg (NormalText)

	EXAMPLE:	/utg Crazy!
	OUTPUT:		(Says "Crazy!" in Universal Language to your Guild)

	*** "Party" Command ***

	/utparty (NormalText)

	or

	/utp (NormalText)

	EXAMPLE:	/utp Crazy!
	OUTPUT:		(Says "Crazy!" in Universal Language to your Party)

	Where (NormalText) is what you intended to say.  It will output
	as a command in Babel for people of all factions or races
	to interpret.

	The Party and Guild commands aren't as useful for the Universal
	conversation purposes, but we figured we'd put them in... perhaps
	you can find a good use for them!

  * Editing the Default Colors

	You can edit the default output colors for the Universal Translator.
	
	*** Changing Colors ***

	/utcolor (TextType) (Red) (Blue) (Green)

	or

	/utc (TextType) (Red) (Blue) (Green)

	EXAMPLE:  /utc system 255 0 0
	OUTPUT: Changes your System messages to bright red.

	Where (TextType) is "SAY", "YELL", "GUILD", "PARTY", or "SYSTEM".
	(for system messages such as the boot up message, or the help message.)
	And (Red), (Blue), and (Green) are numbers between 0 and 255.


	*** Restoring Default Colors ***

	/utcolor (TextType) Default (Off | On)

	EXAMPLE:  /utc say Default On
	OUTPUT: Turns your Default colors back on.

	Where (TextType) is "SAY", "YELL", "GUILD", "PARTY", or "SYSTEM".
	And (Off | On) is a choice between typing "off" or "on".

	
	*** Seeing the current color selection ***

	/utcolor (TextType) Show

	EXAMPLE:  /utc "YELL" Show
	OUTPUT: Shows you if the default value is on for Yell, as well as what
		the colors would be if you weren't using the default value.

	Where (TextType) is "SAY", "YELL", "GUILD", "PARTY", or "SYSTEM".


  * Changing your Default Language

	If you wish, you can alternate between speaking either of the
	Universal Languages.  Find the one that you like the most!

	*** Changing your Universal Language ***

	/utlang (Babel | Morse | Leet | Intl)

	EXAMPLE: /utlang Babel
	OUTPUT: Changes your output Language to Babel.

	Where (Babel | Morse | Leet | Intl) is a choice between "Babel",
	"Leet", "International" and "Morse" languages.

  * Replacing the Garbage Text with the proper Translation

	To replace the garbage text seen between translations with
	the actual translation itself, type this helpful command:

	*** Replacing the Intermediate "Garbage" text ***

	/utreplace (on | off)

	EXAMPLE: /utreplace on
	OUTPUT: Replaces any intermediate languages with the translation,
		so you never have to see the untranslated text again.

	Where (on | off) is a choice between "on" or "off".
	Enabled by default.

  * Seeing Original Message and Translation

	For displaying a translation immediately following the encoded message:

	*** Toggling Post-Message Translation ***

	/uttranslate (on | off)

	EXAMPLE: /uttranslate on
	OUTPUT: Turns on Post-Message Translation (on by default)

	Where (on | off) is a choice between "on" or "off".
	Note: Enabling both "Translation" and "Replacement" would result in the 
	translation being received twice and is not recommended.

  * Blocking the languages

	To completely block the viewing and the transmitting of both
	the untranslated or translated versions of any languages,
	use the following command.  It replaces the garbage text seen
	with nothing at all, leaving your window clean of both translated
	and untranslated text.

	*** Blocking Languages ***

	/utb (on | off)

	EXAMPLE: /utb on
	OUTPUT: Blocks all languages from being seen in translated and
		untranslated form.

	Where (on | off) is a choice between "on" or "off".

  * Accessing the help Message

	If at any time you need to remember the commands, type

	/uthelp

	or

	/uth

	and the Help message will pop up in your chat window.

-----------------------------------
V. On the Question of Ethics
-----------------------------------

	I am including this in the Universal Translator, for I still feel
	that it is both true, and that this message should be heard.  So what
	follows is the original Ethics message that came with BabelFish 1.0.
	-------------------------------------------------------------------

	When I began this project, many people were on my side, and just as
	many people, it seems, were against it.  However, I think the BabelFish
	is the perfect solution to both sides of the issue.

	I, like many of the people playing the game, feel that a language barrier
	between the Factions is artificial and limits our Roleplaying creativity.
	We should be free to communicate, and open the door to new styles of
	play outside of the box of the standard Blizzard plotline.  This provides
	that level of communication, and the potential for cross-species Roleplaying
	and interaction that otherwise would have been impossible.

	On the other side, the BabelFish directly addresses the concerns of those
	who felt that a translation routine would be a "cheat"... for instance,
	that it would be a way to pick up on messages that would otherwise go
	undetected such as battle plans during an invasion.  The fact that the sender
	must consciously send the message using the BabelFish syntax makes it so
	that messages that are meant to be for Horde only **STAY** for Horde only.
	The end user will only use Babelfish when he or she actually wants to
	interact with the other Faction, thus not making this an unfair advantage
	at all in situations such as Battlefields or Raids.

	Anyways, I hope everyone can enjoy this product, and see the good that
	comes out of it for people who want to do "outside the box" roleplaying or
	just talk with their friends who may be on the other side.


-----------------------------------
VI. The Future Plan for the UT, and Acknowledgements
-----------------------------------

	Recently, AnduinLothar joined our Collaboration, making the Universal
	Translator the official source for any of the currently existing
	"Transitional Languages" as we call it (languages that allow for communication
	across dividing lines such as factions).

	Along with his excellent product, LeetFilter, he brought his incredible skills
	at GUI interfaces and a sharp mind regarding coding technique.  With his new
	additions, the UT is now fully Cosmos compatible.

	Brachan came to us three while we were all at an online meeting discussing
	the future of the UT, and he brought an idea not thought of before by us
	to the table: full support for the international character sets.  He had
	already produced a prototype solution for the problem, and that prototype is
	what you see today: a scalable language, supporting Int'l character sets,
	that can be easily built on in the future as we discover more previously
	unknown Universal characters compatible with the game.

	I personally would like to extend my thanks to these two: Anduin, for his
	"Leet" skills and sharp ideas, as well as for officially uniting all three of
	the existing languages... and Brachan, for his enormous contribution to the
	international community with his excellent idea.

	Miscman, AnduinLothar, and Brachan are three of the most skilled programmers
	I have had the pleasure of working with, and we hope to have more improvements
	for the "Free Language" community as the months progress.  Feel free
	to send suggestions for improvements to any of us, as we will be more than
	happy to hear them and try our best to make the changes you want!

	Also, I'd like to thank Destian for getting the word out when this whole thing
	began.  He's an incredible press release man! =)

	Thank you for supporting our product with your use!	

	-Miscman, Jack Colorado, AnduinLothar, and Brachan

-----------------------------------
VII. Contact Us
-----------------------------------


	We want to hear from you!  If this program has helped you roleplay
	more creatively in WoW, or get along with people you'd never have
	expected to, tell us your stories!  We want to hear 'em!

	Miscman (Creator of MorseMod) - miscman@canofsleep.com
	AnduinLothar (Creator of LeetFilter) - karlkfi@yahoo.com
	Brachan (Creator of Intl) - eichner_martin@yahoo.com
	Jack Colorado (Creator of BabelFish) - lord_raphio@yahoo.com