if [[ $(which wget | wc -l) == 0 ]];
then
    est_echo "EST is dependent to wget if you want to use first install git"
    exit
fi
if [[ $(which git | wc -l) == 0 ]];
then
    est_echo "EST is dependent to git if you want to use first install git"
    exit
fi
if [[ -z $EST_CONFIG ]];
then
    EST_CONFIG=$HOME/.config/est
fi
if [[ -z $EST_HOME ]];
then 
    EST_HOME="$EST_CONFIG/helpers/esthelpers/est"
fi
if ! [[ -d $EST_CONFIG ]];
then
    mkdir $EST_CONFIG
fi
EST_HELPERS_DIR=$EST_CONFIG/helpers
if ! [[ -d $EST_HELPERS_DIR ]];
then
    mkdir $EST_HELPERS_DIR
fi
EST_ACTIVE_HELPERS_DIR=$EST_CONFIG/active_helpers
if ! [[ -d $EST_ACTIVE_HELPERS_DIR ]];
then
    mkdir $EST_ACTIVE_HELPERS_DIR
fi
PATH="$PATH:$EST_HOME"
EST_FROM="https://github.com/"
EST_SILENT=0

