#!/bin/bash

echo "Deleting stuff..."

rm -rf build
rm -rf ldc-lib
echo "Starting Build process..."

rm -rf build

read -p "What Platform are you on Supported: Windows and Linux " platform


if [ "$platform" == "linux" ]; then
    
    echo "LINUX SELECTED!"

    ./crossport \
    -v \
    -a x86_64 \
    -e little \
    -p linux \
    -c clang \
    -d ldc2 \
    --cpp clang++ \
    -s llvm-strip \
    --ar llvm-ar \

else

    if [ "$platform" == "windows" ]; then
        echo "WINDOWS SELECTED!"
        crossport.exe \
        -v \
        -a x86_64 \
        -e little \
        -p windows \
        -c clang \
        -d ldc2 \
        --cpp clang++ \
        -s llvm-strip \
        --ar llvm-ar \          
    fi

fi


meson setup build --cross-file crossfile-linux.ini -Dbuildtype=release
./crossport --fixpath "build/build.ninja" 
ninja -C build