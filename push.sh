BLUE='\033[0;34m' # Blue
GREEN='\033[0;32m' # Green
RED='\033[0;31m' # Red
DARK_GRAY='\033[1;30m' # DARK_GRAY
NC='\033[0m' # No Color

for project_name in $@
do
    echo "${BLUE}push.sh > start $project_name${DARK_GRAY}"
    cd $project_name
    git remote remove origin
    git remote add origin git@github.com:aymnms-archives/$project_name.git
    if [ "git push -u origin main" ] ; then
        git push -u origin master
    fi
    echo "${GREEN}push.sh > $project has been pushed on aymnms-archives${DARK_GRAY}"

    # this code delete locally your repository (not remotly)
    # cd ..
    # rm -rf $project_name
    # echo "${BLUE}push.sh > $project_name local folder has been removed${DARK_GRAY}"
fi