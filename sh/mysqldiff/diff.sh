#!/bin/bash
set -e
usage="usage: sh SCRIPT config [patch]
params in config file:
    src -> db connention params file of source
    dst -> db connention params file of destination
    worker.conn -> db connention params file which mysqldiff work on
    export PATH to include mysql and mysqldiff
connention params file:
    whatever after command mysql, include the db name at the end
    worker.conn remove the db name, add a space between -p and password
patch:
    set patch to apply diff result
"
param_error(){
    printf "$usage" 1>&2
    exit 1 
}
bin=$(cd $(dirname $0);pwd)
# load config
config=${1:-$(param_error)}
source $bin/$config
# parma check
src=${src:-$(param_error)}
dst=${dst:-$(param_error)}
worker=${worker:-$(param_error)}
echo runner check
which mysqldiff && which mysql && which mysqldump

dumpsql(){
conn=$1
outFile=$2
mysqldump -d $conn --set-gtid-purged=OFF | sed 's/AUTO_INCREMENT=[0-9]*/ /'| sed 's/MyISAM/InnoDB/' > $outFile
}

diff_result_file=diff.result.sql

do_patch(){
[[ ! -f $diff_result_file ]] && { echo no $diff_result_file found!; exit 1; }
echo "-----patch result to dst --------"
mysql $dst < $diff_result_file 
exit 0
}

if [[ $2 == "patch" ]];then
do_patch
fi
src_sql_file=src.dump.sql
dst_sql_file=dst.dump.sql
echo "---------dump src $1 结构------------------"
dumpsql "$src" $src_sql_file 
echo "---------dump dst $2 结构------------------"
dumpsql "$dst" $dst_sql_file 
if [[ -f $src_sql_file && -f $dst_sql_file ]];then
    echo "------------------对比sql结构--------------------"
    mysqldiff $worker -t '^(?!tmp).*' $dst_sql_file $src_sql_file > $diff_result_file 
else
    echo "缺少数据库dump文件"
    exit 1
fi
echo "------------------请检查SQL $diff_result_file--------------------"
rm $dst_sql_file $src_sql_file
vim $diff_result_file
read -p "Enter y to patch, other to abort:" patch
[[ $patch == "y" ]] && do_patch
