
# current GM build uses emscripten at commit 11dfeed10d0fe74d9c47fd0396b87b99f7dde0dc

PATH=/Users/George/Development/emscripten:$PATH

echo "Beginning build"

cd ffmpeg

emconfigure ./configure --cc="emcc" --enable-cross-compile --target-os=none --arch=x86_32 --cpu=generic --disable-ffplay --disable-ffprobe --disable-ffserver --disable-asm --disable-doc --disable-devices --disable-pthreads --disable-w32threads --disable-network --disable-hwaccels --disable-parsers --disable-bsfs --disable-debug --disable-zlib --disable-protocols --disable-indevs --disable-outdevs --enable-protocol=file --enable-pic --enable-small \
  --disable-demuxers --enable-demuxer=image2,wav \
  --disable-decoders --enable-decoder=pam,pcm_s16le \
  --disable-encoders --enable-encoder=mpeg1video,h263,mp2,aac,mpeg4 \
  --disable-filters  --enable-filter=adelay,apad,aperms,aresample,aselect,asendcmd,asetnsamples,format,perms,\
scale,select,sendcmd,amovie,movie,ffbuffersink,ffabuffersink,abuffer,buffer,abuffersink,buffersink,afifo,fifo \
  --disable-muxers   --enable-muxer=mpeg1system,mp4,avi

make clean
make
cp ffmpeg ffmpeg.bc

emcc -s OUTLINING_LIMIT=100000 -s TOTAL_MEMORY=33554432 -O3 --closure 1 -v ffmpeg.bc -o ../ffmpeg-custom.js --pre-js ../ffmpeg_pre.js --post-js ../ffmpeg_post.js

cd ../

echo "Finished build"
