#!/bin/bash

# excluding regions that have minimal support, baseline these manually
exclude="ap-northeast-3"

# Remove existing files, and regenerate blank files
for f in *.tf.template
do
  echo $f | sed 's/\(.*\).template/\1/' | xargs rm
done

# iterate all the regions, and populate the files
aws ec2 describe-regions | jq -r '.Regions[].RegionName' | while read -r region; 
do
  for f in *.tf.template
  do
    if [ $region == $exclude ]; then
      echo "excluding $region"
      continue
    fi
    sed "s/replace/$region/" $f >> $f.result
  done
done

for i in *.template.result; do mv $i `basename $i .template.result`; done
