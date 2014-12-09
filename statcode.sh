#!/bin/bash

function count() {
	local insert=0
	local delete=0
	while read line ;do
		current=`echo $line| awk -F',' '{printf $2}' | awk '{printf $1}'`
		if [[ -n $current ]]; then 
			insert=`expr $insert + $current`
		fi
		current=`echo $line | sed -n 's/.*, //p' | awk '{printf $1}'`
		if [[ -n $current ]]; then
			delete=`expr $delete + $current`
		fi
	done < .tmp.count
	echo "$insert insertions, $delete deletions"
}

action=$1
beginday=$2
endday=$3

users=($(git log --pretty='%aN' | sort -u))
current=`date +%s`;
begin=`date +%Y-%m-%d |xargs date +%s -d`;
minutes=$(($current - $begin));
cmd='';

for user  in ${users[@]};do

	if [[ ! -n $action ]] || [[ $action = "all" ]] ; then 
		cmd=`git log --author=$user --shortstat --pretty=format:"" | sed /^$/d >.tmp.count`
	elif [[ $action = "oneday" ]]; then
		cmd=`git log --author=$user --since="1 days ago" --shortstat --pretty=format:"" | sed /^$/d >.tmp.count`
	elif [[ $action = "today" ]]; then
		cmd=`git log --author=$user --since="$minutes seconds ago" --shortstat --pretty=format:"" | sed /^$/d >.tmp.count`
	elif [[ $action = "daytoday" ]]; then
		cmd=`git log --author=$user --since="$beginday days ago" --before="$endday days ago" --shortstat --pretty=format:"" | sed /^$/d >.tmp.count`
	else
		echo "args: all | oneday | today | daytoday";
		exit -1;
	fi
	echo $user;
	count;
	rm .tmp.count
done
