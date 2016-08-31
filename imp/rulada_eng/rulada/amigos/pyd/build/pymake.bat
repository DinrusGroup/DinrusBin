dmd -ofhello.pyd hello.d .\template\python_dll_windows_boilerplate.d hello.def
pause
hello.py
pause
dmd -ofarraytest.pyd arraytest.d .\template\python_dll_windows_boilerplate.d arraytest.def
pause
arraytest.py
pause
dmd -oftestdll.pyd testdll.d .\template\python_dll_windows_boilerplate.d testdll.def
pause
testdll.py
pause
del *.obj *.map