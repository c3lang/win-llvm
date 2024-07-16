@echo off

%WORKING_DRIVE%
cd %WORKING_DIR%

::..............................................................................

set THIS_DIR=%CD%

mkdir llvm-project\llvm\build
cd llvm-project\llvm\build
cmake .. %LLVM_CMAKE_CONFIGURE_FLAGS%
cmake --build . %CMAKE_BUILD_FLAGS%
cmake --build . --target install %CMAKE_BUILD_FLAGS%

cd %THIS_DIR%

mkdir llvm-project\runtimes\build
cd llvm-project\runtimes\build
cmake .. %RUNTIMES_CMAKE_CONFIGURE_FLAGS%
cmake --build . %CMAKE_BUILD_FLAGS%
cmake --build . --target install %CMAKE_BUILD_FLAGS%

cd %THIS_DIR%

7z a -t7z %GITHUB_WORKSPACE%\%LLVM_RELEASE_FILE% %LLVM_RELEASE_NAME%