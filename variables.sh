if [[ -z $EST_HOME ]];
then 
    EST_HOME="$HOME/.env"
fi
PATH="$PATH:$EST_HOME/bin"
EST_CONFIG=$HOME/.config/est
EST_HELPERS_DIR=$EST_CONFIG/helpers
EST_ACTIVE_HELPERS_DIR=$EST_CONFIG/active_helpers
EST_FROM="https://github.com/"

if ! [[ -d $EST_CONFIG ]];
then
    mkdir $EST_CONFIG
fi
if ! [[ -d $EST_HELPERS_DIR ]];
then
    mkdir $EST_HELPERS_DIR
fi
if ! [[ -d $EST_ACTIVE_HELPERS_DIR ]];
then
    mkdir $EST_ACTIVE_HELPERS_DIR
fi
