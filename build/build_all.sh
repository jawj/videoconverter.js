# Current build uses emscripten at commit df11c6f1fd1636a355b83a1c48b3a890596e6a32
echo "Beginning Build:"

mkdir -p dist

# cd libogg
# make clean
# emconfigure ./configure --prefix=$(pwd)/../dist
# emmake make
# emmake make install
# cd ..

# cd libvorbis
# make clean
# emconfigure ./configure --disable-oggtest --prefix=$(pwd)/../dist
# emmake make
# emmake make install
# cd ..

# cd libvpx
# make clean
# ./emcc-build.sh
# cd ..

cd libvpx2
make clean
emconfigure ./configure --prefix=$(pwd)/../dist --disable-examples --disable-vp8 --disable-docs --disable-multithread --target=generic-gnu
emmake make
emmake make install
cd ..

cd ffmpeg

# --extra-ldflags="-L$(pwd)/../dist/lib"
emconfigure ./configure --cc="emcc" --prefix=$(pwd)/../dist --extra-cflags="-I$(pwd)/../dist/include"  --enable-cross-compile --target-os=none --arch=x86_32 --cpu=generic \
    --disable-ffplay --disable-ffprobe --disable-ffserver --disable-asm --disable-doc --disable-devices --disable-pthreads --disable-w32threads --disable-network --disable-hwaccels \
    --disable-parsers --disable-bsfs --disable-debug --disable-zlib --disable-protocols --disable-indevs --disable-outdevs --enable-protocol=file \
    --enable-libvpx --enable-nonfree --enable-gpl --enable-version3

# --enable-pic
# --enable-decoder=libvorbis --enable-encoder=libvorbis \
#--enable-libvorbis --enable-demuxer=ogg --enable-decoder=libvorbis --enable-encoder=libvorbis --enable-muxer=ogg \

make clean
make
make install

cd ..

rm dist/*.bc

# cp dist/lib/libogg.a dist/libogg.bc
# cp dist/lib/libvorbis.a dist/libvorbis.bc
cp dist/lib/libvpx.a dist/libvpx.bc
cp ffmpeg/ffmpeg dist/ffmpeg.bc

# ["-t", "5", "-i", "input.webm", "-vf", "showinfo", "-strict", "experimental", "-c:v", "libvpx-vp9", "output.webm"] terminal.js:78
# Uncaught Assertion failed: ((intptr_t)xd->subpix.filter_x & 0xff) == 0, at: vp9/common/vp9_reconinter.c,40,vp9_setup_interp_filters at Error
#    at stackTrace (http://localhost/videoconverter.js/build/ffmpeg_asm.js:1082:15)
#    at ___assert_fail (h...<omitted>...4) /videoconverter.js/build/ffmpeg_asm.js:58539

# -t 5 -i input.webm -vf showinfo -strict -2 -c:v vp9 output.webm
#libvorbis.bc libogg.bc

cd dist
#  libvorbis.bc libogg.bc
emcc -s OUTLINING_LIMIT=100000 -s VERBOSE=1 -s TOTAL_MEMORY=33554432 -O2 -v ffmpeg.bc libvpx.bc -o ../ffmpeg_asm.js --pre-js ../ffmpeg_pre.js --post-js ../ffmpeg_post.js
cd ..


echo "Finished Build"
