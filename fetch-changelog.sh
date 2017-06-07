# Build changelog
if [[ $PREVIOUS_VERSION == "" ]]; then
  GIT_HISTORY=$(git log --no-merges --format="- %s (%an)")
else
  GIT_HISTORY=$(git log --no-merges --format="- %s (%an)" $PREVIOUS_VERSION..HEAD)
fi;

GIT_HISTORY_CLEANED=$(echo "${GIT_HISTORY}" | grep -v 'ci skip' | grep -v 'changelog skip')
MAJOR_CHANGES=$(echo "${GIT_HISTORY_CLEANED}" | grep '\[major\]')
MINOR_CHANGES=$(echo "${GIT_HISTORY_CLEANED}" | grep '\[minor\]')
PATCH_CHANGES=$(echo "${GIT_HISTORY_CLEANED}" | grep '\[patch\]')

OTHER_CHANGES=$(grep -vo '\[major\]' <<< "${GIT_HISTORY_CLEANED}" | grep -vo '\[minor\]' | grep -vo '\[patch\]' | wc -l)
OTHER_CHANGES=$(expr $OTHER_CHANGES + 0)

CHANGELOG=""
if [[ "${MAJOR_CHANGES}" != "" ]]; then
  CHANGELOG="${CHANGELOG}**Major changes**: "$'\n'"${MAJOR_CHANGES}"$'\n'
fi;

if [[ "${MINOR_CHANGES}" != "" ]]; then
  CHANGELOG="${CHANGELOG}**Minor changes**: "$'\n'"${MINOR_CHANGES}"$'\n'
fi;

if [[ "${PATCH_CHANGES}" != "0" ]]; then
  CHANGELOG="${CHANGELOG}**Patches and bug fixes**: "$'\n'"${PATCH_CHANGES}"$'\n'
fi;

if [[ "${OTHER_CHANGES}" != "0" ]]; then
  CHANGELOG="${CHANGELOG}"$'\n'" **${OTHER_CHANGES} other** changes."
fi;

if [[ "${CHANGELOG}" == "" ]]; then
  CHANGELOG="${GIT_HISTORY_CLEANED}"
fi;

CHANGELOG="${CHANGELOG/\[major\]/}"
CHANGELOG="${CHANGELOG/\[minor\]/}"
CHANGELOG="${CHANGELOG/\[patch\]/}"

echo
echo "Changelog: "
echo -e "${CHANGELOG}"

export CHANGELOG=$CHANGELOG
