#!/bin/bash
cd system/lib/
cp libcrypto.so libGLES_trace.so  libsigchain.so libunwind.so libc.so liblog.so libstdc++.so libutils.so   libcutils.so libm.so libstlport.so libz.so libbacktrace.so libEGL.so libsync.so libbinder.so libgccdemangle.so libunwind-ptrace.so ../../root/early
cd ../..
cd system/bin
cp linker ../../root/early/bin
cd ../..
cd system/vendor/lib
cp libnvddk_2d_v2.so libnvparser.so libnvmedia_isc.so libnvrm.so libnvddk_vic.so libnvrm_graphics.so libnvavp.so libnvmedia.so libnvtvmr.so libnvdc.so libnvos.so libphs.so libnvhwc_service.so ../../../root/early
cd ../../..
cp /home/ncho/Projects/upload/audio/nv.264 root/early
