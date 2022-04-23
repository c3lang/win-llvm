@echo off

%WORKING_DRIVE%
cd %WORKING_DIR%

set THIS_DIR=%CD%

cd llvm-project

mkdir llvm\build
cd llvm\build
cmake .. %LLVM_CMAKE_CONFIGURE_FLAGS%
cmake --build . %CMAKE_BUILD_FLAGS%
cmake --build . --target install %CMAKE_BUILD_FLAGS%

dir
cd %THIS_DIR%
dir

7z a -t7z %GITHUB_WORKSPACE%\%LLVM_RELEASE_FILE% %LLVM_RELEASE_NAME%

goto :eof

