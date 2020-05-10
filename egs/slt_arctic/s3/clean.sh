# Remove experiment directory
rm -rfv experiments

# Remove "database" generated info
rm -rfv database/feats
rm -rfv database/labels

# Remove some bulk file
rm -rfv logprob.txt

# Clean the configuration directory
(cd conf; git clean -fdx .)
