#!/bin/bash
# 2022 - @defencore
# This test script allows you to print offsets from rawprogram nand xml:
# rawprogram_nand_p2K_b256K_update.xml
# rawprogram_nand_p2K_b128K_update.xml
#└─$ ./rawnand_xml_parse.sh EC25EFAR06A01M4G/update/firehose/rawprogram_nand_p4K_b256K_update.xml

NAND_XML=$1
echo -e "Offset\t\tLength\t\tImage"
echo -e "---------------------------------------------------------------------------"
cat ${NAND_XML} | grep '<program' | while IFS= read -r line
do
        for x in $(echo $line | sed -e 's/<program //g' -e 's/\/>//g'); do
                eval $x
        done
        printf '%08x\t' $(($start_sector*$SECTOR_SIZE_IN_BYTES)) | tr '[:lower:]' '[:upper:]'
        printf '%08x\t' $(($num_partition_sectors*$SECTOR_SIZE_IN_BYTES)) | tr '[:lower:]' '[:upper:]'
        printf '%s\n' $filename
done | sort
