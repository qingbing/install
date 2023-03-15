#!/bin/bash
# author qingbing<780042175@qq.com>
# 本脚步使用方法
# ./make.sh commitMsg

########################### 函数库 START ###########################

# 打印分隔消息
function printLineTip()
{
	echo -e "==========  $1  ==========";
}

########################### 函数库 END   ###########################

# 获取脚本所在目录
rPath=$(cd "$(dirname "${0}")" || exit; pwd)
# 1.进入根目录
printLineTip 1.进入根目录
cd "${rPath}" || exit

# 2.重新生成目录
printLineTip 2.重新生成索引文件
./index.sh

# 3.添加 README.md
printLineTip 3.添加README.md
git add README.md

# 4.git commit
printLineTip 4.commit
commitMsg=$1
# check comment
if [[ -z $commitMsg ]]; 
then
	commitMsg=$(date "+%Y%m%d%H%M")
fi
git commit -m "${commitMsg}"

# 提交 git
printLineTip 5.push
git push origin master

printLineTip 提交成功
