adb shell saf775x_util pset sec-out-r tdm0-in2
if [ $1 == '0' ]; then
   adb shell tinymix "APBIF0 Mux" "ADX0-0"
   adb shell tinymix "APBIF1 Mux" "ADX0-1"
#   adb shell tinymix "DAM0-0 Mux" "APBIF1"
#   adb shell tinymix "DAM0-1 Mux" "APBIF0"
else
   adb shell tinymix "APBIF0 Mux" "ADX0-1"
   adb shell tinymix "APBIF1 Mux" "ADX0-0"
#   adb shell tinymix "DAM0-0 Mux" "APBIF1"
#   adb shell tinymix "DAM0-1 Mux" "APBIF0"
fi
