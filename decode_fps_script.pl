#!/usr/bin/perl
#!/usr/bin/perl -w
#use Math::Round;
use Env;
use File::Basename;
use Math::BigFloat;

$MAX_EXEC_TIME = 600;
$InputFile;
$TargetFps;
$Duration;
$DumpAdbLogcat;
$DumpAdbLogcat1;

    if (($ARGV[0] eq '-f') && ($ARGV[2] eq '-t') && ($ARGV[4] eq '-d'))
    {
		$InputFile = $ARGV[1];
		$TargetFps = $ARGV[3];
                $Duration  = $ARGV[5] + 3;
    }else {
		printf("Please metioned file name or target value or duration..... \n");
		die("MM Profile : result = fail\n");
	}


$set_serial="echo";
`$set_serial;./adb logcat -c`; 
$Command = './adb shell am start -n com.nvidia.media.amaf/com.nvidia.media.base.MediaAnalyzerHomeActivity -e pkg "com.nvidia.media.profiling" -e cls "MMProfiler" -e mth "playBackTest" -e freq "1" -e file '.$InputFile.' -e fileMeaning "0" -e mode "ALL"';


#print $Command;
print "playback started.....\n";

eval
{       
    printf("1111111");
    local $SIG{ALRM} = sub { die "TimeOut\n" };
    alarm $MAX_EXEC_TIME; #Timeout after 600 sec
    $CmdRetStatus = `$set_serial;$Command`;
    print;
    printf("22222 %d ",$Duration);
    sleep $Duration;
    printf("3333 %d ",$Duration);
    alarm 0;
};

#print $CmdRetStatus;

if (($@ && $@ =~ /TimeOut/)||($CmdRetStatus =~ m/SIGSEGV/m)||($CmdRetStatus =~ m/Test Failed !!!/m) ||($CmdRetStatus =~ m/FAILURES!!!/m)||
     ($CmdRetStatus =~ m/CRC FAILED/m) || ($CmdRetStatus =~ m/Opening of the Input file failed/m) || ($CmdRetStatus =~ m/Input File open failed/m) ||
     ($CmdRetStatus =~ m/Segmentation fault/m))
{
    printf("ERROR :: %s..... \n",$CmdRetStatus);
    die("MM Profile : result = fail\n");
}

$DumpAdbLogcat1 = `$set_serial;./adb logcat -d`;

#$DumpAdbLogcat1 = `$set_serial;./adb logcat -d | grep "MM Profile"`;

#print $DumpAdbLogcat1;

@SplitLog = split(/MM Profile : ActualFPS = /, $DumpAdbLogcat1);
$ActualFps = substr(@SplitLog[1], 0 , 5);
$Fps = $ActualFps * 1;
printf("MM Profile : ActualFps = %s\n",$Fps);

@SplitLog = split(/MM Profile : VideoFrameDrop = /, $DumpAdbLogcat1);
$VideoFrameDrop = substr(@SplitLog[1], 0, 5);
$FrameDrop = $VideoFrameDrop * 1;
printf("MM Profile : VideoFrameDrop = %s\n",$FrameDrop);

@SplitLog = split(/MM Profile : TargetFPS = /, $DumpAdbLogcat1);
$StreamFps = substr(@SplitLog[1], 0, 5);
$Fps1 = $StreamFps * 1;
printf("MM Profile : Stream Fps = %s\n",$Fps1);

$FpsThreshold = (($TargetFps)*97/100);
printf("MM Profile : TargetFps = %s \n",$TargetFps);

if ($ActualFps < $FpsThreshold)
{
    die("MM Profile : result = fail\n");
}

@SplitLog = split(/MM Profile : result = /, $DumpAdbLogcat1);
$Result = substr(@SplitLog[1], 0 , 6);
printf("MM Profile 111 : result = %s\n", $Result);


sub atoi {
   my $t;
   foreach my $d (split(//, shift())) {
   $t = $t * 10 + $d;
   }
   return $t;
}
