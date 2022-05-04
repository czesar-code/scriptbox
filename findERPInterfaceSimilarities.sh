#!/bin/bash

GREEN=$'\e[1;32m'
YELLOW=$'\e[0;33m'
CYAN=$'\e[1;36m'
PURPLE=$'\033[0;35m'
NOCOLOR=$'\033[0m'

echo "ANALYZING SIMILARITIES"

## data/import/ax/xsd/IAxShopArticle.xsd
## data/import/ax/xsd/IAxShopCampaigns.xsd
## data/import/ax/xsd/IAxShopCoupons.xsd
## data/import/ax/xsd/IAxShopCustomer.xsd
## data/import/ax/xsd/IAxShopDocument.xsd
## data/import/ax/xsd/IAxShopOrder.xsd
## data/import/ax/xsd/IAxShopPermission.xsd
## data/import/ax/xsd/IAxShopPrices.xsd
## data/import/ax/xsd/IAxShopRepresentatives.xsd
## data/import/ax/xsd/IAxShopSalesAgreement.xsd
# data/import/ax/xsd/IAxShopStock.xsd

# input file
xsdfile=$1


# selection of representative CSV files (davpack)
declare -a arr=(
    "data/import/ex/DAVD/Campaign/Out/EX12532125.CSV"
    "data/import/ex/DAVD/Customer/OUT/EX12661000.CSV"
    "data/import/ex/DAVD/Invent/Out/EX12639121.CSV"
    "data/import/ex/DAVD/Prices/Out/EX11220272.CSV"
    "data/import/ex/DAVD/Sales/IN/Transactions20220412104505.csv"
)


equals=-1

elements_count=$(cat $xsdfile | grep '<xs:element' | grep 'minOccurs="1"' | grep -e 'name="' | wc -l | xargs)
elements_name=$(cat $xsdfile | grep -e '<xs:element' | grep -e 'minOccurs="1"' | grep -e 'name="' | sed -e 's/^[[:space:]]*//' | awk -Fname=\" '{ print $2 }' | awk -F\" '{ print $1 }')

echo "$YELLOW ### $xsdfile ($elements_count elements) $NOCOLOR"

el=1
while read -r element; do
    # echo " $el - $element"
    echo "$element"
    el=$((el+1))
done <<< "$elements_name"

echo ""
echo "$PURPLE \_ COMPARING WITH $NOCOLOR"
echo ""

csv=1
for csv_file in "${arr[@]}"
do
    equals=0

    e=1
    first_line=$(head -n 1 "$csv_file")
    columns_count=$(echo "${first_line//|/$'\n'}" | wc -l | sed -e 's/^[[:space:]]*//')
    echo " $YELLOW ### $csv - $csv_file ($columns_count columns) $NOCOLOR"
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
                  equals=$((equals+1))
                  echo "   $GREEN $equals - rf:element:$e \"$element\" EQUAL TO \"$column\" davp:column:$c $NOCOLOR"
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
