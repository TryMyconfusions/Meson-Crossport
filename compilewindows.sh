rm -rf build

./crossport \
-v \
-a x86_64 \
-p windows \
-e little \
-d "ldc2" \
-c clang \
--cpp clang++ \
--da "-gcc=clang" \
--da "-mtriple=x86_64-windows-msvc" \
--da "-mscrtlib=msvcrtd" \
-s llvm-strip \
--ar llvm-ar \
--dla    '-L=/NODEFAULTLIB:libcmt' \
--dla    '-L=/NODEFAULTLIB:libvcruntime' \
--dla    '-L=/DEFAULTLIB:legacy_stdio_definitions.lib' \
--dla    '-L=/LIBPATH:/home/voided/.xwin/crt/lib/x86_64' \
--dla    '-L=/LIBPATH:/home/voided/.xwin/sdk/lib/um/x86_64' \
--dla    '-L=/LIBPATH:/home/voided/.xwin/sdk/lib/ucrt/x86_64' \
--dla    '-L=/LIBPATH:/home/voided/Documents/D-projects/crossport/win-libs/Lib'
meson setup build --cross-file crossfile-windows.txt
#ninja -C build
./crossport --fixpath "build/build.ninja"
ninja -C build