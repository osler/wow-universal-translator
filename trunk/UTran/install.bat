@ECHO OFF
@echo.
@echo Universal Translator 1.3 Install
@echo -------------------------------------------------------------
@ECHO This Batch file installs UT 1.3 to your computer.
@ECHO If your copy of WoW is not in C:\Program Files\World Of Warcraft,
@ECHO you will have to edit this batch file or manually install.
@ECHO.
@ECHO Installing...
@ECHO Creating UT directory...
mkdir "c:\Program Files\World Of Warcraft\Interface\AddOns\UTran"
@ECHO Installing utran.XML...
copy utran.xml "c:\Program Files\World Of Warcraft\Interface\AddOns\UTran\utran.xml"
@ECHO Installing utran.LUA...
copy utran.lua "c:\Program Files\World Of Warcraft\Interface\AddOns\UTran\utran.lua"
@ECHO Installing utran.TOC...
copy utran.toc "c:\Program Files\World Of Warcraft\Interface\AddOns\UTran\utran.toc"
@ECHO.
@ECHO Attempting to un-install BabelFish...
del "c:\Program Files\World Of Warcraft\Interface\AddOns\BabelFish\BabelFish.xml"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\BabelFish\BabelFish.lua"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\BabelFish\BabelFish.toc"
rmdir "c:\Program Files\World Of Warcraft\Interface\AddOns\BabelFish"
@ECHO Attempting to un-install MorseMod...
del "c:\Program Files\World Of Warcraft\Interface\AddOns\morsemod\morsemod.xml"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\morsemod\morsemod.lua"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\morsemod\morsemod.toc"
rmdir "c:\Program Files\World Of Warcraft\Interface\AddOns\morsemod"
@ECHO Attempting to un-install LeetFilter...
del "c:\Program Files\World Of Warcraft\Interface\AddOns\LeetFilter\.DS_Store"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\LeetFilter\LeetFilter.lua"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\LeetFilter\LeetFilter.toc"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\LeetFilter\LeetFilter.xml"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\LeetFilter\LeetFilterLetters.lua"
del "c:\Program Files\World Of Warcraft\Interface\AddOns\LeetFilter\localization.lua"
@ECHO.
@ECHO.
@ECHO Installation complete.  Be sure to read readme.txt for instructions
@echo on how to use the Universal Translator.  Enjoy!
@echo.
@echo - Miscman and Jackson Howard Colorado
