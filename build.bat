@ECHO OFF

ECHO ================================================================================
ECHO Make sure your Emscripten environment is configured properly 
ECHO Please run %%EMSDK_HOME%%\emsdk_env.bat before running this .bat file
ECHO Otherwise, you will get error 'emcc is not recognized as an internal or external command'
ECHO ================================================================================

set BUILD_DIR=_build
set FILES=wasm/cn.c blake/blake.c cryptonight/cryptonight.c groestl/groestl.c jh/jh_ansi_opt64.c keccak/keccak.c oaes/oaes_lib.c skein/skein.c 
set FLAGS="-O3"
set FLAGS=

if not exist %BUILD_DIR% mkdir %BUILD_DIR%

ECHO.
ECHO 1. Build .wasm (and .js)
call emcc -I. %FLAGS% ^
    -s WASM=1 ^
    %FILES% ^
    -s EXPORTED_FUNCTIONS="['_main', '_cn_hash', '_cn_create_context', '_cn_destroy_context']" ^
    -s ASSERTIONS=0 ^
    -o %BUILD_DIR%/cn.js

ECHO.
ECHO 2. Build .asmjs for non-wasm browser
call emcc -I. %FLAGS% ^
    %FILES% ^
    -s EXPORTED_FUNCTIONS="['_main', '_cn_hash', '_cn_create_context', '_cn_destroy_context']" ^
    -s ASSERTIONS=0 ^
    -o %BUILD_DIR%/cn.asmjs.js
