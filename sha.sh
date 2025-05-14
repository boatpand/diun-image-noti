SHA256_HASH="fbdbaea47b9ae4ecc2082ecdb4e1cea81e32176ffb1dcf643d422ad07427e5d9"
NAMESPACE='library'
REPO_NAME='redis'

for i in {1..1000}; do 
    if [ $i -eq 100 ]; then
        echo -e "\e[35mSleeping for 7 seconds on page $i...\e[0m"
        sleep 7
    fi

    echo "Looking into page: $i"

    result=$(
        curl -s "https://registry.hub.docker.com/v2/repositories/$NAMESPACE/$REPO_NAME/tags/?page=$i" \
        | jq -r ".results[] | select(.[\"images\"][][\"digest\"] == \"sha256:$SHA256_HASH\" or .digest == \"sha256:$SHA256_HASH\")"
    ) || break

    if [ ! -z "$result" ]; then
        echo "$result" | jq '.'
        break
    fi
done