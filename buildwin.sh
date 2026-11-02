#!/bin/bash

echo "Deleting stuff..."

rm -rf build
rm -rf ldc-lib
rm ldc2-1.40.0-windows-x64.7z
echo "Starting Build process..."

echo "getting LDC-LIB libraries..."
curl -LO "https://github.com/ldc-developers/ldc/releases/download/v1.40.0/ldc2-1.40.0-windows-x64.7z"



echo "unzipping ldc-lib..."
echo "$(pwd)"
7z x "ldc2-1.40.0-windows-x64.7z"
cd "ldc2-1.40.0-windows-x64"


echo "moving lib folder..."
mv "lib" "../ldc-lib"
echo "$(pwd)"

echo "Building..."
cd ..
echo "$(pwd)"
chmod +x win.sh
rm ldc2-1.40.0-windows-x64.7z
rm -rf ldc2-1.40.0-windows-x64

rm -rf build

read -p "What Platform are you on Supported: Windows and Linux " platform


if [ "$platform" == "linux" ]; then
    
    echo "LINUX SELECTED!"

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
        --dla "-L=/LIBPATH:/home/$USER/.xwin/sdk/lib/um/x86_64" \
        --dla "-L=/LIBPATH:/home/$USER/.xwin/sdk/lib/ucrt/x86_64" \
        --dla "-L=/LIBPATH:/home/$USER/.xwin/crt/lib/x86_64" \
        --dla "-L=/LIBPATH:$(pwd)/ldc-lib" \
        -s llvm-strip \
        --ar llvm-ar \          
    fi

fi


meson setup build --cross-file crossfile-windows.ini -Dbuildtype=release
./crossport --fixpath "build/build.ninja" 
ninja -C build