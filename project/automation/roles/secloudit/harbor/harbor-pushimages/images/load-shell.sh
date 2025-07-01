#! /bin/bash
LS=$(ls | grep '.*\.tar')
array=(${LS})

for tarstr in "${array[@]}"
do
    docker load -i $tarstr
done