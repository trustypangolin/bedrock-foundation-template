#!/bin/bash

# excluding regions that have minimal support, baseline these manually
declare -a exclude=(ap-northeast-3 ap-southeast-2)

# Remove existing files, and regenerate blank files
for f in *.tf.region
do
  echo $f | sed 's/\(.*\).region/\1/' | xargs rm
done

# iterate all the regions, and populate the files
aws ec2 describe-regions | jq -r '.Regions[].RegionName' | while read -r region; 
do
  for f in *.tf.region
  do
    if [[ ${exclude[*]} =~ "${region}" ]]; then
      echo "excluding $region"
      continue
    fi
    sed "s/replace/$region/" $f >> $f.result
  done
done

for i in *.region.result; do mv $i `basename $i .region.result`; done
