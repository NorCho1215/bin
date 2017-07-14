echo =========================ADSP
export TEGRA_TOP=$(pwd)
export TOOLCHAIN_PREFIX=$TEGRA_TOP/arm-eabi-4.8/bin/arm-eabi-
export NVFX_SDK_TOP=$TEGRA_TOP/multimedia/nvfx
export NVFX_SDK_INT=$NVFX_SDK_TOP/include
export PROJECT=adsp
export BUILD_OUT_PATH=$TEGRA_TOP/adsp/adsp-t21x
#export ADSP_TOP=$BUILD_OUT_PATH/build-adsp/adsp_sdk ## ADSP source
export ADSP_TOP=$TEGRA_TOP/adsp/sdk ## ADSP prebuilt
cd $BUILD_OUT_PATH/build-adsp/adsp-sdk ## build ADSP
make TARGET=t186 PREFIX=$BUILD_OUT_PATH LKINC=$TEGRA_TOP/adsp/adsp-t18x -C $TEGRA_TOP/adsp/adsp-t21x WITH_MATH_LIB=1 WITH_DBELL=0 ## build ADSP.
echo ========================NVFX
cd $NVFX_SDK_TOP
make TARGET=t186 SDK_BUILD=1 BUILDROOT=$ADSP_TOP CONFIG_ADMA_BUFFER=1 -C $ADSP_TOP SDK_EXT_MK=$NVFX_SDK_TOP/nvfx.mk



