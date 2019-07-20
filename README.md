#思路：


#0.xx收款前缀 去百度/讯飞/录音 语音合成（demo中为receive.m4a


#1.生成0-10000 1w个 xx收款1111 （只到整数位 默认放在_int文件夹）


#2.生成0.01-0.99 100个 .0.01元 （浮点数 默认放在_float文件夹）

#3.播放时拼接两部分语音

#--- 不压缩优化 10000个约为180M ----

#4.对音频进行压缩（加快语速，减少采样率等 -> 压缩后的文件放在_int-1.3(语速)/ or _float-1.3）




#合并

#ffmpeg -i receive.m4a -i 1.m4a -i thousand.m4a -i 5.m4a -i hundred.m4a -i 8.m4a -i ten.m4a -i 3.m4a -i yuan.m4a  -filter_complex 'concat=n=9:v=0:a=1 [a]' -map [a] -aframes 1000 -y yd_1583.mp3 


#压缩

#ffmpeg -i "test/56.mp3" -b:a 8k -ar 11025 -ac 1  -filter_complex '[0:0] volume=8dB,atempo=1.3 [a]'  -vn -y -map [a] "test/56_rate_1.3.mp3" 


#startMergeHead 1292

#mergeHead

#mergeFoot

#test

#ffmpegRate _float 1.3 


