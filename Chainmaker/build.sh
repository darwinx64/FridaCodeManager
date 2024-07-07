# prepare #
if [ -d .tmp ]; then
    rm -rf .tmp
fi
mkdir -p .tmp .tmp/procursus .tmp/toolchain .tmp/toolchain/bin .tmp/toolchain/lib

# toolchain packages download #
packages=("coreutils" "libreadline8" "libiosexec1" "libncursesw6" "libintl8" "libssl3" "libedit0" "libzstd1" "libxar1" "dash" "ld64" "libuuid16" "libtapi" "odcctools" "libllvm16" "libclang-cpp16" "clang-16" "libclang-common-16-dev" "ldid" "zip" "unzip" "libplist3" "shell-cmds" "curl" "libcurl4" "libc-ares2" "libnghttp2-14" "libidn2-0" "librtmp1" "libgmp10" "libgnutls30" "libhogweed6" "libnettle8" "libssh2-1" "libssl3" "libbrotli1" "libunistring5" "libp11-kit0" "libtasn1-6" "libffi8")

for package in "${packages[@]}"; do
    echo -e "\e[38;5;208mdownloading $package\e[0m"
    cd .tmp/procursus
    while ! apt download --download-only "$package" > /dev/null 2>&1; do
        echo -e "failed, retry!"
        echo -e "\e[38;5;208mdownloading $package\e[0m"
    done
    dpkg --extract "${package}"*.deb ./
    rm "${package}"*.deb
    cd ../../
done

# toolchain creation #
echo -e "\033[32mcreating toolchain\e[0m"

## ENV ##
echo -e "\e[38;5;208msetting environment\e[0m"
ROOT_BIN=.tmp/procursus/var/jb/usr/bin
ROOT_LIB=.tmp/procursus/var/jb/usr/lib
ROOT_RPATH=/var/jb/usr/lib
CHAIN_BIN=.tmp/toolchain/bin
CHAIN_LIB=.tmp/toolchain/lib
CHAIN_RPATH=@loader_path/../lib

## COPY STAGE ##
echo -e "\e[38;5;208mcopy stage\e[0m"
binaries=("dash" "echo" "mkdir" "rmdir" "cp" "mv" "rm" "ls" "ld" "ln" "install_name_tool" "otool" "ldid" "zip" "unzip" "killall" "curl")
libraries=("libedit.0.dylib" "libiosexec.1.dylib" "libreadline.8.dylib" "libhistory.8.dylib" "libncursesw.6.dylib" "libintl.8.dylib" "libzstd.1.dylib" "libxar.1.dylib" "libcrypto.3.dylib" "libuuid.16.dylib" "libtapi.dylib" "libplist-2.0.3.dylib" "libcurl.4.dylib" "libcares.2.dylib" "libnghttp2.14.dylib" "libidn2.0.dylib" "librtmp.1.dylib" "libgmp.10.dylib" "libgnutls.30.dylib" "libhogweed.6.dylib" "libnettle.8.dylib" "libssh2.1.dylib" "libssl.3.dylib" "libbrotlidec.1.dylib" "libbrotlicommon.1.dylib" "libunistring.5.dylib" "libp11-kit.0.dylib" "libtasn1.6.dylib" "libffi.8.dylib")

for binary in "${binaries[@]}"; do
    cp $ROOT_BIN/$binary $CHAIN_BIN/$binary
done
for library in "${libraries[@]}"; do
    cp -L $ROOT_LIB/$library $CHAIN_LIB/$library
done

## Special Stuff ##
cp $ROOT_LIB/llvm-16/bin/clang-16 $CHAIN_BIN/clang-16
cp -rL $ROOT_LIB/llvm-16/lib/*.dylib $CHAIN_LIB
cp -r $ROOT_LIB/llvm-16/lib/clang $CHAIN_LIB

## @RPATH PATCH ##
echo -e "\e[38;5;208mpatching @rpath\e[0m"
for dir in $CHAIN_BIN $CHAIN_LIB; do
    for file in "$dir"/*; do
        if [ ! -d "$file" ]; then
            install_name_tool -delete_rpath $ROOT_RPATH "$file"
            install_name_tool -add_rpath $CHAIN_RPATH "$file"
            echo "relinked $file"
        fi
    done
done

# post patching #
echo -e "\e[32;5;208mpost patching Stage\e[0m"
## CURL CACERT FIX
echo -e "\e[38;5;208mapplying curl cacert fix\e[0m"
mkdir -p .tmp/toolchain/share/curl
cp cacert.pem .tmp/toolchain/share/curl