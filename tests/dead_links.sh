returncode=0

# Parse default routes
grep -roh "^ *default: .*" ./pages | awk '{print $2}' | tr -d "'" | sort | uniq > .known_pages

# Parse aliases
grep -rh "^---$" ./pages -B 50 | grep "^   *\- '/" | awk '{print $2}' | tr -d "'" | sort | uniq >> .known_pages

# Find all markdown links and generate a list of filename.md:N:linktarget   (with N the line number)
for LINK in $(grep -nr -o -E "\]\(\/?(\w|-)+\)" ./pages)
do
    PAGE=$(echo $LINK | awk -F: '{print $3}' | tr -d ']()/')

    grep -qw "$PAGE" ./.known_pages || { echo $LINK; returncode=1; }
done

exit $returncode
