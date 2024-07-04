@echo off

if not exist %WORKING_DIR% mkdir %WORKING_DIR%

:: download LLVM sources

if /i "%BUILD_MASTER%" == "true" (
	git clone --depth=1 %LLVM_MASTER_URL% %WORKING_DIR%\llvm-git
	move %WORKING_DIR%\llvm-git\llvm %WORKING_DIR%
	if exist %WORKING_DIR%\llvm-git\cmake move %WORKING_DIR%\llvm-git\cmake %WORKING_DIR%
) else (
	powershell "Invoke-WebRequest -Uri %LLVM_DOWNLOAD_URL% -OutFile %WORKING_DIR%\%LLVM_DOWNLOAD_FILE%"
	7z x -y %WORKING_DIR%\%LLVM_DOWNLOAD_FILE% -o%WORKING_DIR%
	7z x -y %WORKING_DIR%\llvm-%LLVM_VERSION%.src.tar -o%WORKING_DIR%
	ren %WORKING_DIR%\llvm-%LLVM_VERSION%.src llvm

	if not "%LLVM_CMAKE_DOWNLOAD_URL%" == "" (
		powershell "Invoke-WebRequest -Uri %LLVM_CMAKE_DOWNLOAD_URL% -OutFile %WORKING_DIR%\%LLVM_CMAKE_DOWNLOAD_FILE%"
		7z x -y %WORKING_DIR%\%LLVM_CMAKE_DOWNLOAD_FILE% -o%WORKING_DIR%
		7z x -y %WORKING_DIR%\cmake-%LLVM_VERSION%.src.tar -o%WORKING_DIR%
		ren %WORKING_DIR%\cmake-%LLVM_VERSION%.src cmake
	)
)

if "%CONFIGURATION%" == "Debug" goto dbg
goto :eof

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: on Debug builds:
:: - patch llvm-config/CMakeLists.txt to always build and install llvm-config
:: - patch AddLLVM.cmake to also install PDBs on Debug builds

:dbg

echo set_target_properties(llvm-config PROPERTIES EXCLUDE_FROM_ALL FALSE) >> %WORKING_DIR%\llvm\tools\llvm-config\CMakeLists.txt
echo install(TARGETS llvm-config RUNTIME DESTINATION bin) >> %WORKING_DIR%\llvm\tools\llvm-config\CMakeLists.txt

perl pdb-patch.pl %WORKING_DIR%\llvm\cmake\modules\AddLLVM.cmake

::..............................................................................