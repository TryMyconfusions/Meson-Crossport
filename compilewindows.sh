rm -rf build


./crossport \
-v \
-a x86_64 \
-p windows \
-e little \
-d ldc2 \
-c clang \
-cpp clang++ \
--da "[
'-gcc=clang'
]" \
--dla "['-L=LIBPATH:/home/voided/.xwin/sdk/lib/um/x86_64','-L=LIBPATH:/home/voided/.xwin/sdk/lib/ucrt/x86_64','-L=LIBPATH:/home/voided/.xwin/crt/lib'
]"

meson setup build
ninja -C build