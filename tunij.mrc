;Tunij v1.2 for mirc & adiirc by bbqnut

;tunij.key = key/password/text to hide from stream urls posted publicly
alias tunij.key return YOUR_KEY_HERE
;alias tunij.response $iif($isid,return,say) ·Tüñ¹j· $iif(!$artist || !$title,$+($chr(34),$fulltitle,$chr(34)),$+($artist,$chr(32),$chr(34),$title,$chr(34))) $+ $iif($length == 00:00,$+(·,Stream,$chr(58),$chr(32),$replace($songfile,$tunij.key,$null),$chr(32),·),· $+ $bitrate $+ kbps· $+ $replace($frequency,44100,44.1,000,$null) $+ kHz· $+ $replace($mode,$chr(32),$null) $+ · $+ $replace($size,$chr(32),$null,MB,mb) $+ · $+ $length $+ · $+ [ $+ $progress $+ ]· $+ $percentl $+ $chr(37) $+ ·)
alias showtags {
  if ($1- == $null) { echo 2 -e * /showtags: please specify filename, eg. /showtags file.mp3 | halt }
  echo 1 id3: $sound($1-).id3
  echo 1 tags: $sound($1-).tags
  var %n = $sound($1-,0).tag
  while (%n > 0) {
    echo 1 tag: $sound($1-,%n).tag
    dec %n
  }
}
dialog tunij.dialog {
  title $tunij.title $tunij.ver
  icon $scriptdirtunij.ico,index
  option dbu
  size -1 -1 124 128
  tab "Options", 1,-1 -2 124 128
  tab "About", 2,
  box "Toggles",101,1 13 120 110, tab 1
  button "Close", 199,4 111 115 10, flat, tab 1
  box "Tunij",901,1 13 120 110, tab 2
  text Tunij $+ $chr(58) A Picture Window mp3 Player, 902,4 23 115 8, center tab 2
  text "For mIRC && AdiIRC", 903,4 31 115 8, center tab 2
  text "©bbqnut", 904,4 39 115 8, center tab 2
  link "Email bbqnut", 905,4 55 115 8, center tab 2
  link "Tunij github page", 906,4 75 115 8, center tab 2
  ;link "Connect to CoffeeIRC", 907,4 95 115 8, center tab 2
  button "Close", 997,4 111 115 10, flat, tab 2
  button "", 998,1 1 0 0,cancel
}
on *:dialog:tunij.dialog:init:*:{
  ;
}
on *:dialog:tunij.dialog:sclick:*:{
  if ($did == 199) { dialog -x tunij.dialog }
  if ($did == 997) { dialog -x tunij.dialog }
}
alias npt $iif($insong,tunij.np,echo -a $tunij.not No file playing.)
alias tunij.web url http://github.com/bbqnut/
alias tunij.title return Tunij
alias tunij.ver return v1.2
alias tunij.not return $timestamp $+(**,$tunij.title $tunij.ver,**,$chr(58),)
alias tunij.defsep return $iif(%tunij.defsep == $null,$chr(45),%tunij.defsep)
alias tunij.adtag return $iif(!%tunij.adtag,Tunij,%tunij.adtag)
alias tunij.adtag.x return $+($tunij.defsep,$tunij.adtag,$tunij.defsep)
alias tunij.chk $iif(!$window(@Tunij),tunij.pl.load,tunij.close)
alias tunij.np $iif($isid,return,say) $tunij.msg
alias tunij.stop splay stop | titlebar
alias tunij.ass splay $scriptdirllamasass.mp3
alias tunij.options $iif($dialog(tunij.dialog),halt,dialog -m tunij.dialog tunij.dialog)
alias tunij.tbar {
  toolbar -auz1 Tunij "Tunij" $scriptdirtunijtb.gif "/tunij.chk" @tunij
  toolbar -auz1 TunijPR "Previous" $scriptdirprev.ico "/tunijprevplay" @tunij
  toolbar -auz1 TunijSB "Seek Backward 10 secs" $scriptdirseekb.ico "/tunij.seek.b" @tunij
  toolbar -auz1 TunijPL "Play" $scriptdirplay.ico "/tunijplay" @tunij
  toolbar -auz1 TunijPA "Pause" $scriptdirpause.ico "/tunij.p" @tunij
  toolbar -auz1 TunijST "Stop" $scriptdirstop.ico "/tunij.stop" @tunij
  toolbar -auz1 TunijSF "Seek Forward 10 secs" $scriptdir\seekf.ico "/tunij.seek.f" @tunij
  toolbar -auz1 TunijNE "Next" $scriptdirnext.ico "/tunijnextplay" @tunij
}
alias tunij.tbar.del {
  toolbar -d tunij
  toolbar -d tunijPR
  toolbar -d tunijSB
  toolbar -d tunijPL
  toolbar -d tunijPA
  toolbar -d tunijST
  toolbar -d tunijSF
  toolbar -d tunijNE
}
alias tunij.track {
  if ($sound($insong.fname).artist || $sound($insong.fname).title) {
    return $sound($insong.fname).artist $+(",$sound($insong.fname).title,")
  }
  return $remove($nopath($insong.fname),.mp3)
}
alias tunij.msg.network { return $iif(%tunij.msg.network,%tunij.msg.network,null) }
alias tunij.do.msg {
  titlebar $tunij.msg
  set %tunij.out off
  if (!$server || %tunij.msg.network = $null) {
    echo -s $tunij.msg
    if (%tunij.out == on) { tunij.out }
    halt
  }
  var %y = $tunij.msg.network,%x = $scon(0)
  while (%x) {
    if ($scon(%x).network == %y) {
      scid $scon(%x)
      set %a $tunij.defsep
      set %b $tunij.adtag.x
      set %c $tunij.track
      set %z $+(%b,$chr(32),%c,%a,$mp3($insong.fname).bitrate $+ kbps,%a,$calc($sound($insong.fname).sample / 1000) $+ khz,%a,$sound($insong.fname).mode,%a,$round($bytes($lof($insong.fname)),2) $+ mb,%a,$tunijdurc($round($calc($insong.length / 1000),0)),%a)
      titlebar %z
      $iif(%tunij.rc.spam = on,%tunij.msg $tunij.rc.text.bb(%z),%tunij.msg %z)
      scid -r
    }
    dec %x
  }
  if (%tunij.out == on) { tunij.out }
}
alias tunij.msg {
  var %a = $tunij.defsep,%b = $tunij.adtag.x,%c = $tunij.track,%z = $+(%b,$chr(32),%c,%a,$mp3($insong.fname).bitrate $+ kbps,%a,$calc($sound($insong.fname).sample / 1000) $+ khz,%a,$sound($insong.fname).mode,%a,$round($bytes($lof($insong.fname)),2) $+ mb,%a,$tunijdurc($round($calc($insong.length / 1000),0)),%a)
  if (!$insong) {
    return $+(%b,$chr(32),Off,$chr(32),%a)
    halt
  }
  if (%tunij.rc.spam == on) {
    return $tunij.rc.text.rv(%z)
  }
  return %z
}
;alias tunij.out {
;  if ($isfile($scriptdircurl.exe)) {
;    %a = $scriptdircurl.exe
;    %b = $scriptdirout.txt
;    %c = $tunij.msg
;    write -cn %a %c
;    if (%tftpu && %tftpp && %tftpa) {
;      echo -s $tunij.not $+($chr(40),TUNIJ_OUT_NULL,$chr(41),$chr(58)) run %a -T %b -u $+(%tftpu,$chr(58),%tftpp) %tftpa $+($chr(40),$tunij.msg,$chr(41))
;    }
;    else echo -a $tunij.not Missing settings! Please check your ftp settings.
;  }
;  else echo -a $tunij.not curl.exe not found! For full functionality of the tunij-data-file-sender, please put curl.exe in $+($scriptdir,$chr(46)) curl.exe official can be downloaded at $+(https://curl.haxx.se/,.)
;}
alias tunij {
  %tunij.dir = $iif(%tunij.sdir,$$sdir(%tunij.sdir,Select Mp3 Directory),$$sdir($scriptdir,Select Mp3 Directory))
  write -c $+(",$scriptdirtunijlist.txt,")
  var %i = $ticks
  .fopen -o tunijlist $+(",$scriptdirtunijlist.txt,")
  if ($ferr) { echo -a $tunij.not fopen Error: $ferr | .fclose tunijlist | halt }
  echo -a $tunij.not Compiling List (may freeze your client for a few seconds if the directory is large)
  var %x = $findfile($+(",%tunij.dir,"),*.mp3,0,.fwrite -n tunijlist $1-)
  .fclose tunijlist
  echo -a $tunij.not List Containing $lines($+(",$scriptdirtunijlist.txt,")) files Compiled In $calc(($ticks - %i) /1000) Seconds.
  tunij.pl.load
}
alias tunij.adddir {
  %tunij.dir.add = $iif(%tunij.sdir,$$sdir(%tunij.sdir,Select Mp3 Directory),$$sdir($scriptdir,Select Mp3 Directory))
  write -c $+(",$scriptdirtunijlistadd.txt,")
  var %i = $ticks
  .fopen -o tunijlistadd $+(",$scriptdirtunijlistadd.txt,")
  if ($ferr) { echo -a $tunij.not fopen Error: $ferr | .fclose tunijlistadd | halt }
  echo -a $tunij.not Adding new Directory and Re-Compiling List (may freeze your client for a few seconds if the directory is large)
  var %x = $findfile($+(",%tunij.dir.add,"),*.mp3,0,.fwrite -n tunijlistadd $1-)
  .fclose tunijlistadd
  echo -a $tunij.not Updated List Added $lines($+(",$scriptdirtunijlistadd.txt,")) files, Compiled In $calc(($ticks - %i) /1000) Seconds.
  tunij.pl.load.add
}
alias tunij.pl.load.add {
  %a = $scriptdirtunijlistadd.txt
  filter -ffct 1 9 $+(",%a,") $+(",%a,") *.mp3*
  loadbuf @Tunij $+(",%a,")
  window -a @Tunij
}
alias tunij.close {
  close -@ @Tunij
  tunij.stop
}
alias tunij.pl.load {
  %a = $scriptdirtunijlist.txt
  window -c @Tunij
  window -lk0z @Tunij $scriptdirtunij.ico
  filter -ffct 1 9 $+(",%a,") $+(",%a,") *.mp3*
  loadbuf @Tunij $+(",%a,")
  window -a @Tunij
}
alias tunij.pl.load2 {
  %b = $sfile($scriptdir,Please select a playlist to load..,Load)
  .copy -o %b $scriptdirtunijlist.txt
  tunij.pl.load
}
alias tunij.pl.loadff {
  %c = $sfile($scriptdir,Please select a playlist to add..,Add)
  .copy -o %c $scriptdirtunijlistadd.txt
  echo -a $tunij.not Updated List Adding $lines($+(",$scriptdirtunijlistadd.txt,")) mp3s
  tunij.pl.load.add
}
alias tunij.pl.reload {
  close -@ @Tunij
  tunij.pl.load
}
alias tunijdurc {
  if (!$1) { return $+(0,$chr(58),0) }
  if ($1) { return $+($int($calc($1 / 60)),$chr(58),$right($calc($1 % 60 + 100),2)) }
}
alias tunijnum {
  if ($lines($+(",$scriptdirtunijlist.txt,")) == 0) { return n/a }
  var %x = $read($scriptdirtunijlist.txt,w,* $+ $insong.fname $+ *)
  var %y = $readn
  return %y
  unset %x
  unset %y
}
alias tunij.seek.b $iif($inmp3.pos > 10,splay -p seek $calc($inmp3.pos - 10))
alias tunij.seek.f $iif($calc($inmp3.length - $inmp3.pos) > 10,splay -p seek $calc($inmp3.pos + 10))
alias tunij.p {
  if ($insong.pause) {
    splay -p resume
  }
  elseif ($insong && !$insong.pause) {
    splay -p pause
  } 
}
alias tunijplay {
  if (!$window(@Tunij)) tunij.pl.load
  if (!$sline(@Tunij,1)) tunijrandplay
  else {
    set %tunij.sel.line $sline(@Tunij,1)
    splay %tunij.sel.line
    .timer 1 1 tunij.do.msg
  }
}
alias tunijrandplay {
  var %a = $read($+(",$scriptdirtunijlist.txt,"))
  var %b = $readn
  sline @Tunij %b
  splay %a
  .timer 1 1 tunij.do.msg
}
alias tunijprevplay {
  var %a = $sline(@Tunij,1)
  var %b = $sline(@Tunij,1).ln
  var %c = $calc(%b - 1)
  var %d = $line(@Tunij,%c)
  if (%c < 1) {
    sline @Tunij $line(@Tunij,0)
    splay $sline(@Tunij,1)
  }
  else {
    sline @Tunij %c
    splay $sline(@Tunij,1)
  }
  .timer 1 1 tunij.do.msg
}
alias tunijnextplay {
  if (%tunij.rand == on) {
    tunijrandplay
    goto end
  }
  var %a = $sline(@Tunij,1)
  var %b = $sline(@Tunij,1).ln
  var %c = $calc(%b + 1)
  var %d = $line(@Tunij,%c)
  if (%c > $line(@Tunij,0)) {
    sline @Tunij 1
    splay $sline(@Tunij,1)
  }
  else {
    sline @Tunij %c
    splay $sline(@Tunij,1)
  }
  .timer 1 1 tunij.do.msg
  :end
}
alias tunijrepeat {
  splay %tunij.sel.line
  .timer 1 1 tunij.do.msg
}
; Reverse
alias tunij.rc.text.rv return $+(,$1)
;Random Color Black Background
alias tunij.rc.text.bb {
  var %rc.a = $len($1-),%rc.b = 1
  while (%rc.b <= %rc.a) {
    var %rc.e =  $+ $rand(2,15)
    while ($len(%rc.e) == 2) {
      var %rc.f = $left(%rc.e,1) $+ 0 $+ $right(%rc.e,1)
      var %rc.e = %rc.f
    }
    var %rc.c = $iif($mid($1-,%rc.b,1) == $chr(32),$chr(1),%rc.e $+ $mid($1-,%rc.b,1))
    var %rc.d = %rc.d $+ %rc.c
    inc %rc.b
  }
  return 01,01 $+ $replace(%rc.d,$chr(1),$chr(32))
  unset %rc.a %rc.b %rc.c %rc.d %rc.e %vf
}
; random color with no background
alias tunij.rc.text.nb {
  var %rc.d
  if ($1 == $null) { halt }
  var %rc.a = $len($1-),%rc.b = 1
  while (%rc.b <= %rc.a) {
    var %rc.e =  $+ $rand(3,15)
    while ($len(%rc.e) == 2) {
      var %rc.f = $left(%rc.e,1) $+ 0 $+ $right(%rc.e,1)
      var %rc.e = %rc.f
    }
    var %rc.c = $iif($mid($1-,%rc.b,1) == $chr(32),$chr(1),%rc.e $+ $mid($1-,%rc.b,1))
    var %rc.d = %rc.d $+ %rc.c
    inc %rc.b
  }
  return $replace(%rc.d,$chr(1),$chr(32))
  unset %rc.a %rc.b %rc.c %rc.d %rc.e
}
on *:text:.tunij:#:{ msg $chan $tunij.msg }
on *:start:{ tunij.tbar }
on *:close:{ @Tunij:tunij.stop | titlebar }
on *:mp3end: {
  if (%tunij.rep == on) { tunijrepeat }
  if (%tunij.rand == on) { tunijrandplay }
  if (%tunij.seq == on) { tunijnextplay }
  titlebar
}
on *:load:{
  set %tunij.rand off
  set %tunij.seq off
  set %tunij.rep off
  set %tunij.msg echo -a
  set %tunij.adtag Tunij
  set %tunij.defsep -
  set %tunij.rc.spam off
  set %tunij.out off
  write -c $+(",$scriptdirtunijlist.txt,") $scriptdirllamasass.mp3
  tunij.pl.load
  tunij.ass
  echo -a $+($tunij.not loaded! Use /tunij or the menus to open the player/window,$chr(46))
}
on *:unload:{
  echo -a $+($tunij.not Unloading $tunij.title $tunij.ver,$chr(46),$chr(46),$chr(46))
  tunij.stop
  unset %tunij*
  tunij.tbar.del
  echo -a $+($tunij.not Unload of $tunij.title $tunij.ver is complete,$chr(46))
  titlebar
}
menu @Tunij {
  dclick:{
    set %tunij.sel.line $+(",$line(@Tunij,$1-),")
    splay stop
    splay %tunij.sel.line
    .timer 1 1 tunij.do.msg
  }
  $iif($insong,$+(Current,$chr(58),$chr(32),$tunij.track)):return
  -
  $iif(!$insong,Play) :tunijplay
  $iif($insong,Previous) :tunijprevplay
  $iif($insong,Seek Back $+($chr(40),10sec,$chr(41))) :tunij.seek.b
  $iif($insong,Seek Forward $+($chr(40),10sec,$chr(41))) :tunij.seek.f
  $iif($insong,Stop) :tunij.stop
  $iif($insong,Pause) :tunij.p
  $iif($insong,Next) :tunijnextplay
  -
  Playlist
  .New Playlist:tunij
  .New Playlist from file:tunij.pl.load2
  .-
  .Add to Playlist $+ $chr(58)
  ..Directory:tunij.adddir
  ..-
  ..Playlist File:tunij.pl.loadff
  .-
  .Save Playlist as..:copy -o $scriptdirtunijlist.txt $scriptdir $+ \ $+ $$?"Enter a name for the playlist." $+ .txt
  .-
  .Set Search Start Directory
  ..Current-> $iif(%tunij.sdir,%tunij.sdir,$scriptdir) :halt
  ..-
  ..Set Search Start Directory:set %tunij.sdir $$sdir($scriptdir)
  ..Un-Set Search Start Directory:unset %tunij.sdir
  .-
  .$iif(!$window(@Tunij),Open,Close):tunij.chk
  -
  Continuous Play $+ $chr(58)
  .$iif(%tunij.rand == on || %tunij.seq == on || %tunij.rep == on,Disable) :set %tunij.rand off | set %tunij.seq off | set %tunij.rep off
  .$iif(%tunij.rand == off && %tunij.seq == off && %tunij.rep == off,$style(1) Disabled) :halt
  .-
  .$iif(%tunij.seq == on,$style(1) Sequential) :halt
  .$iif(%tunij.seq == off,Sequential) :set %tunij.seq on | set %tunij.rand off | set %tunij.rep off
  .-
  .$iif(%tunij.rand == on,$style(1) Random) :halt
  .$iif(%tunij.rand == off,Random) :set %tunij.rand on | set %tunij.seq off | set %tunij.rep off
  .-
  .$iif(%tunij.rep == on,$style(1) Repeat) :halt
  .$iif(%tunij.rep == off,Repeat) :set %tunij.rep on | set %tunij.seq off | set %tunij.rand off
  -
  Spam!
  .Spam! $iif($insong,$+($chr(91),%tunij.msg,$chr(93)) now):tunij.do.msg
  .Spam! *TARGET*:msg $$?"Enter Channel or nickname target" $tunij.msg
  .-
  .Set Default Network to Spam $+($chr(91),%tunij.msg.network,$chr(93)):set %tunij.msg.network $?="Enter Network Name:"
  .Set Default Auto-Spam Style $+($chr(91),%tunij.msg,$chr(93)):set %tunij.msg $$?"msg active/msg channel/amsg/echo?"
  .Set Default Tag $+($chr(91),$chr(32),%tunij.adtag,$chr(32),$chr(93)):set %tunij.adtag $$?"Enter a Tag."
  .Set Default Separator $+($chr(91),$chr(32),%tunij.defsep,$chr(32),$chr(93)):set %tunij.defsep $$?"Enter a Separator."
  .$iif(%tunij.rc.spam == on,$style(1) Random Color [Click to disable]) :set %tunij.rc.spam off
  .$iif(%tunij.rc.spam == off,Random Color [Click to enable]) :set %tunij.rc.spam on
  -
  Toolbar $+ $chr(58) $iif($toolbar(Tunij),Enabled,Disabled)
  .$iif($toolbar(Tunij),Disable):tunij.tbar.del
  .$iif(!$toolbar(Tunij),Enable):tunij.tbar
  ;-
  ;Tunij Out $+ $chr(58) $iif(%tunij.out == off,Disabled,Enabled)
  ;.$iif(%tunij.out == on,Disable):set %tunij.out off
  ;.$iif(%tunij.out == off,Enable):set %tunij.out on
  ;.-
  ;.Configuration Dialog:tunij.options
  -
  Configuration Dialog:tunij.options
  -
  $tunij.title $tunij.ver Website:tunij.web
}
menu status,channel,menubar {
  $tunij.title $tunij.ver
  .$iif($insong,* $tunij.track *):return
  .-
  .$iif(!$insong,Play):tunijplay
  .$iif($insong,Previous):tunijprevplay
  .$iif($insong,Seek Back $+($chr(40),10sec,$chr(41))):tunij.seek.b
  .$iif($insong,Seek Forward $+($chr(40),10sec,$chr(41))):tunij.seek.f
  .$iif($insong,Stop):tunij.stop
  .$iif($insong,Pause):tunij.p
  .$iif($insong,Next):tunijnextplay
  .-
  .Continuous Play $+ $chr(58)
  ..$iif(%tunij.rand == on || %tunij.seq == on || %tunij.rep == on,Disable) :set %tunij.rand off | set %tunij.seq off | set %tunij.rep off
  ..$iif(%tunij.rand == off && %tunij.seq == off && %tunij.rep == off,$style(1) Disabled) :halt
  ..-
  ..$iif(%tunij.seq == on,$style(1) Sequential) :halt
  ..$iif(%tunij.seq == off,Sequential) :set %tunij.seq on | set %tunij.rand off | set %tunij.rep off
  ..-
  ..$iif(%tunij.rand == on,$style(1) Random) :halt
  ..$iif(%tunij.rand == off,Random) :set %tunij.rand on | set %tunij.seq off | set %tunij.rep off
  ..-
  ..$iif(%tunij.rep == on,$style(1) Repeat) :halt
  ..$iif(%tunij.rep == off,Repeat) :set %tunij.rep on | set %tunij.seq off | set %tunij.rand off
  .-
  ..Playlist
  ..New Playlist from Directory:tunij
  ..New Playlist from file:tunij.pl.load2
  ..-
  ..Add to Playlist $+ $chr(58)
  ...Directory:tunij.adddir
  ...-
  ...Playlist File:tunij.pl.loadff
  ..-
  ..Save Playlist as..:copy -o $scriptdirtunijlist.txt $scriptdir $+ \ $+ $$?"Enter a name for the playlist." $+ .txt
  ..-
  ..Set Search Start Directory
  ...Current-> $iif(%tunij.sdir,%tunij.sdir,$scriptdir) :halt
  ...-
  ...Set Search Start Directory:set %tunij.sdir $$sdir($scriptdir)
  ...Un-Set Search Start Directory:unset %tunij.sdir
  ..-
  ..$iif(!$window(@Tunij),Open $tunij.title,Close $tunij.title):tunij.chk
  .-
  .Spam!
  ..$iif($insong && $active ischan,Spam $active now):msg $chan $tunij.msg
  ..$iif($insong && $active == Status Window,Echo to $active now):echo -at $tunij.msg
  ..Spam! *TARGET*:msg $$?"Enter Channel or nickname target" $tunij.msg
  ..-
  ..Set Default Network to Spam $+($chr(91),%tunij.msg.network,$chr(93)):set %tunij.msg.network $?="Enter Network Name:"
  ..Set Default Spam Command $+($chr(91),%tunij.msg,$chr(93)):set %tunij.msg $$?"msg active/msg channel/amsg/echo?"
  ..Set Default Tag $+($chr(91),$chr(32),%tunij.adtag,$chr(32),$chr(93)):set %tunij.adtag $$?"Enter a Tag."
  ..Set Default Separator $+($chr(91),$chr(32),%tunij.defsep,$chr(32),$chr(93)):set %tunij.defsep $$?"Enter a Separator."
  ..$iif(%tunij.rc.spam == on,$style(1) Color [Click to disable]):set %tunij.rc.spam off
  ..$iif(%tunij.rc.spam == off,Color [Click to enable]):set %tunij.rc.spam on
  .-
  .Toolbar $+ $chr(58)
  ..$iif($toolbar(Tunij),$style(1) Enabled):halt
  ..$iif($toolbar(Tunij),Disable):tunij.tbar.del
  ..$iif(!$toolbar(Tunij),$style(1) Disabled):halt
  ..$iif(!$toolbar(Tunij),Enable):tunij.tbar
  ;.-
  ;.Tunij Out $+ $chr(58)
  ;..$iif(%tunij.out == on,$style(1) Enabled):halt
  ;..$iif(%tunij.out == on,Disable):set %tunij.out off
  ;..$iif(%tunij.out == off,$style(1) Disabled):halt
  ;..$iif(%tunij.out == off,Enable):set %tunij.out on
  ;..-
  ;..Configure:tunij.options
  .-
  .Configure:tunij.options
  .-
  .Tunij Website:tunij.web
}
