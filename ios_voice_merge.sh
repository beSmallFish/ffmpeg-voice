#!/usr/bin/env bash


base=("" "ten.m4a" "hundred.m4a" "thousand.m4a")
#1000 1001 1010 1100


#单个整数音频
function startMergeHead(){
	words=$1
	len=${#words}
	lastNum=0;
	index=-1
	arr=()
	for (( i = len-1; i>=0; i--)); do
		#statemen
		num=${words:i:1}
		#echo $num $lastNum
		if [[ $num -eq 0 && $lastNum -eq 0 && len -ne 1 ]]; then
			continue;
		fi

		lastNum=$num;

		if [[ $num -eq 0 ]]; then
			let index++;
			arr[$index]=0.m4a;
		else
			let lastIndex=$len-1
			#echo $size $i
			#个位没有单位
			if [[ $i -ne $lastIndex ]]; then
				#echo === ${base[$lastIndex-i]} $i $index
				let index++
				arr[$index]=${base[lastIndex-i]}
			fi
			let index++
			arr[$index]=$num.m4a
		fi
	done


	for k in ${arr[@]}; do
		#echo ${k}
		echo > null
	done

	merged=""
	ffmpeg="ffmpeg -i receive.m4a "
	i_index=1
	for (( i = $index; i >= 0; i-- )); do
		#statements
		merged="$merged ${arr[i]}"
		ffmpeg="$ffmpeg -i ${arr[i]} "
		let i_index++
		#echo ${arr[i]}
	done


	ffmpegHeadOriMerge "$ffmpeg" $i_index $words
}


#
function ffmpegHeadOriMerge(){

  echo ffmpegHeadOriMerge: $1 --- $2 --- $3
  mkdir -p _int/
  chmod 777	_int/	

  #ffmpegMerge=$1"-filter_complex 'concat=n=9:v=0:a=1 [a]' -map [a] -y _int/$2.mp3"

  `$1 -filter_complex "concat=n=$2:v=0:a=1 [a]" -map [a] -y _int/$3.mp3`
}

#合成0-10000个 ---->>> xx收款1293
function mergeHead(){
	for (( m = 0; m < 10000; m++ )); do
		#statements
		startMergeHead $m
		#echo $i
	done
}


#合成.01-.99 100个 ---->>> .01元
function mergeFoot(){
	for (( y = 1; y < 100; y++ )); do
		#statements
		float_num=`echo "scale=2;$y / 100"|bc`
		float_num_len=${#float_num}
		let float_num_max_index=$float_num_len-1
		hasZero=0
		#echo ==$float_num_len
		ffmpeg="ffmpeg -i point.m4a"
		for (( o = 1; o <= $float_num_max_index; o++)); do

			num=${float_num:o:1}
			#最后的0不合并 0.10
			if [[ $o -eq $float_num_max_index && $num -eq 0 ]]; then
				hasZero=1
				continue;
			fi
			ffmpeg="$ffmpeg -i $num.m4a "
			#echo $num
		done
		ffmpegFootOriMerge "$ffmpeg" $float_num_len ${float_num/./p} $hasZero
	done
}



function ffmpegFootOriMerge(){
 #ffmpeg audio_length 	
 echo ffmpegFootOriMerge: $1 --- $2 ----$3 ---- $4

  mkdir -p _float/
  chmod 777	_float/
  let mergeLen=$2

  if [[ $4 -eq 0 ]]; then
	 let mergeLen++
  fi
 
  `$1 -i yuan.m4a -filter_complex "concat=n=$mergeLen:v=0:a=1 [a]" -map [a] -y _float/$3.mp3`
}

test(){
	#ss=ffmpeg -i point.m4a -i 0.m4a -i 1.m4a -i yuan.m4a -filter_complex 'concat=n=4:v=0:a=1 [a]' -map [a] -y _float/p01.mp3
	`ffmpeg -i point.m4a -i 0.m4a -i 1.m4a -i yuan.m4a -filter_complex 'concat=n=4:v=0:a=1 [a]' -map [a] -y _float/p01.mp3`
}


#加速 压缩
#input:
#$1->输入文件夹目录 $2->播放语速
#output:
#输出在 输入文件夹-语速/
function ffmpegRate(){
	sourceDir=$1
	rate=$2; #倍速
	mkdir -p "$sourceDir-$rate"
	chmod 777
	rateIndex=0
	for i in `ls $sourceDir`; do

		# if [[ $rateIndex -gt 20 ]]; then
		# 	#statements
		# 	return;
		# fi
		let rateIndex++;

		#echo $i;
		`ffmpeg -i "$sourceDir/$i" -b:a 10k -ar 16k -ac 1  -filter_complex "volume=8dB,atempo=$rate [a]"  -vn -y -map [a] "$sourceDir-$rate/$i" `


	done
	echo $result;
}


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





