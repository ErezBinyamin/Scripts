@ECHO OFF
COLOR A
rd /s /q %systemdrive%\$RECYCLE.BIN
rd /s /q %TMP%
:: Pause
PAUSE