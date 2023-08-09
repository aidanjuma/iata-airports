#!/bin/bash

AIRPORTS_JSON="https://raw.githubusercontent.com/mwgg/Airports/master/airports.json"
OUTPUT_FILE="iata-airports.json"

# Fetch "airports.json" using curl and store it in a variable.
data=$(curl -s "$AIRPORTS_JSON")

if [ $? -eq 0 ]; then
    # Successfully fetched "airports.json".
    # Filter the data to get objects with a populated "iata" field.
    filtered_data=$(echo "$data" | jq -c 'map(select(.iata? and .iata != ""))')

    # Check if the filtered_data is different from the existing content in "iata-airports.json,"
    # ...or if the file is non-existent.
    if [ ! -f "$OUTPUT_FILE" ] || ! echo "$filtered_data" | cmp -s - "$OUTPUT_FILE"; then
        # Save the filtered data to the "iata-airports.json" file.
        echo "$filtered_data" | jq '.' >"$OUTPUT_FILE"
        echo "Filtered data has been saved to 'iata-airports.json'."
    else
        echo "Filtered data is the same as the existing content in 'iata-airports.json'. File will not be overwritten."
    fi
else
    echo "Failed to fetch 'airports.json' from mwgg's repository. Could not reformat into 'iata-airports.json'."
fi
