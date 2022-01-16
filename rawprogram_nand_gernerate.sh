#!/bin/bash
# 2022 - @defencore
# This test script allows you generate rawprogram nand xml:
# rawprogram_nand_p2K_b256K_update.xml
# rawprogram_nand_p2K_b128K_update.xml

# Save GPT table using https://github.com/bkerler/edl.git
# edl printgpt | awk '/sbl/,0' > partition.save
input="partition.save"
PAGES_PER_BLOCK="64"
SECTOR_SIZE_IN_BYTES="4096"
physical_partition_number="0"

function xml_nand_str(){
  local start_sector=$1 num_partition_sectors=$2 filename=$3
  echo "     <!-- ${filename} -->"
  echo "     <erase PAGES_PER_BLOCK=${PAGES_PER_BLOCK} SECTOR_SIZE_IN_BYTES=${SECTOR_SIZE_IN_BYTES} num_partition_sectors=${num_partition_sectors} physical_partition_number=${physical_partition_number} start_sector=${start_sector}/>"
  echo "     <program PAGES_PER_BLOCK=${PAGES_PER_BLOCK} SECTOR_SIZE_IN_BYTES=${SECTOR_SIZE_IN_BYTES} filename=${filename} num_partition_sectors=${num_partition_sectors} physical_partition_number=${physical_partition_number} start_sector=${start_sector}/>"
}

echo '<?xml version="1.0" ?>'
echo '<data>'

while IFS= read -r line
do
  filename=$(echo $line | awk '{print $1}')
  start_sector=$(("0x$(echo $line | awk '{print $2}')"/${SECTOR_SIZE_IN_BYTES}))
  num_partition_sectors=$(("0x$(echo $line | awk '{print $3}')"/${SECTOR_SIZE_IN_BYTES}))
  xml_nand_str $start_sector $num_partition_sectors $filename
done < "$input"
echo "</data>"
