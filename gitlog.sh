#!/bin/bash
#仓库提交者排名前 5（如果看全部，去掉 head 管道即可）：
git log --pretty='%aN' | sort | uniq -c | sort -k1 -n -r | head -n 5
#仓库提交者（邮箱）排名前 5： 这个统计可能不会太准，因为很多人有不同的邮箱，但会使用相同的名字.
git log --pretty=format:%ae | gawk -- '{ ++c[$0]; } END { for(cc in c) printf "%5d %s\n",c[cc],cc; }' | sort -u -n -r | head -n 5
#贡献者统计：
git log --pretty='%aN' | sort -u | wc -l
#提交数统计：
git log --oneline | wc -l
#添加或修改的代码行数：
git log --stat|perl -ne 'END { print $c } $c += $1 if /(\d+) insertions/;'
#仓库提交者（邮箱）排名前 5： 这个统计可能不会太准，因为很多人有不同的邮箱，但会使用相同的名字.
git log --pretty=format:%ae | gawk -- '{ ++c[$0]; } END { for(cc in c) printf "%5d %s\n",c[cc],cc; }' | sort -u -n -r | head -n 5
#贡献者统计：
git log --pretty='%aN' | sort -u | wc -l
#提交数统计：
git log --oneline | wc -l
#添加或修改的代码行数：
git log --stat|perl -ne 'END { print $c } $c += $1 if /(\d+) insertions/;'
