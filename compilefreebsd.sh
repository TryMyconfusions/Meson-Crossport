rm -rf build

./crossport -v \
  -a x86_64 \
  -p freebsd \
  -e little \
  -d ldc2 \
  -c clang \
  --ca "-mtriple=x86_64-unknown-freebsd14.0" \
  --ca "-linker=lld" \
  --ca "-Xcc=--sysroot=/opt/freebsd-sysroot"


meson setup build --cross-file crossfile-freebsd.ini -Dbuildtype=release
./crossport --fixpath "build/build.ninja" 
ninja -C build