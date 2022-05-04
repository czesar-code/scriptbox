#!/bin/bash

GREEN=$'\e[1;32m'
YELLOW=$'\e[0;33m'
CYAN=$'\e[1;36m'
NOCOLOR=$'\033[0m'

echo "ANALYZING SIMILARITIES"

### campaign
# ProductGroupUsageId|Code|Description
csvfile_campaign=data/import/ex/DAVD/Campaign/Out/EX12532125.CSV
xmlfile_campaign=data/import/ax/dev/de/Campaign/Out/de_campaign_198.xml
xsdfile_campagin=data/import/ax/xsd/IAxShopCampaigns.xsd
### customer
csvfile_customer_out=data/import/ex/DAVD/Customer/OUT/EX12661000.CSV
csvfile_customer_in=data/import/ex/DAVD/Customer/IN/Addresses20220411065501.csv

# current file
csvfile=$csvfile_campaign

# selection of representative CSV files (davpack)
declare -a arr=(
    "data/import/ex/DAVD/Campaign/Out/EX12532125.CSV"
    "data/import/ex/DAVD/Customer/OUT/EX12661000.CSV"
    "data/import/ex/DAVD/Invent/Out/EX12639121.CSV"
    "data/import/ex/DAVD/Prices/Out/EX11220272.CSV"
    "data/import/ex/DAVD/Sales/IN/Transactions20220412104505.csv"
)

i=1
equals=-1
# loop existing interfaces (ratioform)
for filename in data/import/ax/xsd/*.xsd; do
    [ -e "$filename" ] || continue

    elements_count=$(cat $filename | grep '<xs:element' | grep 'minOccurs="1"' | grep -e 'name="' | wc -l | xargs)
    elements_name=$(cat $filename | grep -e '<xs:element' | grep -e 'minOccurs="1"' | grep -e 'name="' | sed -e 's/^[[:space:]]*//' | awk -Fname=\" '{ print $2 }' | awk -F\" '{ print $1 }')

    echo "$YELLOW ### $i - $filename ($elements_count elements) $NOCOLOR"

    el=1
    while read -r element; do
        # echo " $el - $element"
        echo "$element"
        el=$((el+1))
    done <<< "$elements_name"

    echo "  \_ COMPARING WITH:"

    csv=1
    for csv_file in "${arr[@]}"
    do
        equals=0

        e=1
        echo "   ### $csv - $csv_file"
        first_line=$(head -n 1 "$csv_file")
        echo "${first_line//|/$'   '}" | wc -w
        echo "${first_line//|/$'\n'}"
        while read -r element; do

            ro=1
            while read -r row; do
                if [[ "$ro" == "2" ]]; then
                    # echo -e "row $r : $row"
                    # echo "$ro   ${row//|/$' '}"
                    break
                fi

                c=1
                for column in ${row//|/ }
                do
                    element_lower_case=$(echo "$element" | tr '[:upper:]' '[:lower:]')
                    column_lower_case=$(echo "$column" | tr '[:upper:]' '[:lower:]')
                    if [[ "$column_lower_case" == "$element_lower_case" ]]; then
                      echo "   $GREEN $equals - rf:element:$e \"$element\" EQUAL TO \"$column\" davp:column:$c $NOCOLOR"
                      equals=$((equals+1))
                    fi
                    c=$((c+1))
                done
                # echo -e "   ### number of columns $c"

                ro=$((ro+1))
            done < "$csv_file"

            # echo "$e element = $element";
            e=$((e+1))
        done <<< "$elements_name"
        if [[ "$equals" != "0" ]]; then
            echo "   $CYAN |==> $equals / $elements_count equal elements found $NOCOLOR"
        fi
        csv=$((csv+1))
    done

    echo ""
    i=$((i+1))
done

# cat data/import/ax/xsd/IAxShopSalesAgreement.xsd | grep '<xs:element'
