rm -rf build

./crossport \
-v \
-a x86_64 \
-e little \
-p windows \
-c clang \
-d ldc2 \
--cpp clang++ \
--dla "-L=/LIBPATH:/home/$USER/.xwin/sdk/lib/um/x86_64" \
--dla "-L=/LIBPATH:/home/$USER/.xwin/sdk/lib/ucrt/x86_64" \
--dla "-L=/LIBPATH:/home/$USER/.xwin/crt/lib/x86_64" \
--dla "-L=/LIBPATH:$(pwd)/ldc-lib" \
-s llvm-strip \
--ar llvm-ar \


meson setup build --cross-file crossfile-windows.ini -Dbuildtype=release
./crossport --fixpath "build/build.ninja" 
ninja -C build