function transfer
   set tmpfile (mktemp -t transferXXX)
   curl --progress-bar --upload-file $argv https://transfer.sh/(basename $argv) >> $tmpfile
   cat $tmpfile
   rm -f $tmpfile
end

alias up=transfer
