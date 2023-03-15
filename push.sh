#!/bin/bash
# 清屏幕
# clear

# 操作的分支， 默认当前的分支。 用 "-b" 指定
BRANCH=$(git branch | grep '\*' | awk -F ' ' '{print $2}')
# 操作的 commit 注释，默认当前时间。 用 "-c" 指定
COMMIT_MSG=$(date "+%Y%m%d%H%M")
# 操作的git-origin， 默认 origin。 用 "-o" 指定
ORIGIN=origin

# 指定变量
until [ $# -eq 0 ]; do
  case $1 in
  -b)
    BRANCH=$2
    shift
    ;;
  -c)
    COMMIT_MSG=$2
    shift
    ;;
  -o)
    ORIGIN=$2
    shift
    ;;
  *) ;;
  esac
  shift
done

# commit the comment
git commit -m "${COMMIT_MSG}"

# push
git push "${ORIGIN}" "${BRANCH}"
# tip
if [[ $? -ne 0 ]]; then
	echo "push fail"
else
	echo "push success"
fi
