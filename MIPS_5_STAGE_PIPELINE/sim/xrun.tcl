
 database -open waves -into waves.shm -event -default
probe -create -shm tb_mips32 -all -depth all

#probe -create top -all -memories -depth all -tasks -functions -all -database waves -waveform
run 2000 ns
exit
