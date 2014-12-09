#!/bin/bash

    beginday=$2
    endday=$3
   

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

function countAll() {
    for user  in `git log --pretty='%aN' | sort -u`;do
         git log --author=$user --shortstat --pretty=format:"" | sed /^$/d >.tmp.count
         count;
         rm .tmp.count
   done
}

function countToday() {
    local current=`date +%s`;
    local begin=`date +%Y-%m-%d |xargs date +%s -d`;
    local minutes=$(($current - $begin));

    for user  in `git log --pretty='%aN' | sort -u`;do
	    git log --author=$user --since="$minutes seconds ago" --shortstat --pretty=format:"" | sed /^$/d >.tmp.count
	    count;
	    rm .tmp.count
	    done

}

function countOneDay() {
    for user  in `git log --pretty='%aN' | sort -u`;do
	    git log --author=liuyanshan --since="1 days ago" --shortstat --pretty=format:"" | sed /^$/d >.tmp.count
	    count;
	    rm .tmp.count
	done

}

function countDayToDay() {
    for user  in `git log --pretty='%aN' | sort -u`;do
	    git log --author=$user --since="$beginday days ago" --before="$endday days ago" --shortstat --pretty=format:"" | sed /^$/d >.tmp.count
	    count;
	    rm .tmp.count
	done

}


if [[ ! -n $1 ]] || [[ $1 = "all" ]] ; then 
    countAll;
elif [[ $1 = "oneday" ]]; then
    countOneDay;
elif [[ $1 = "today" ]]; then
    countToday;
elif [[ $1 = "daytoday" ]]; then
    countDayToDay;
else
    echo "args: all | oneday | today | daytoday";
fi

