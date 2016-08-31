@echo off
"%DINRUS%\pango-querymodules.exe" > "%DINRUS%\..\etc\pango\pango.modules"
rem "%DINRUS%\gdk-pixbuf-query-loaders.exe" > "%DINRUS%\..\etc\gtk-2.0\gdk-pixbuf.loaders"
"%DINRUS%\gtk-query-immodules-2.0.exe" > "%DINRUS%\..\etc\gtk-2.0\gtk.immodules"
rem "%DINRUS%\gtk-update-icon-cache.exe"
