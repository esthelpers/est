if [[ -z $EST_HOME ]];
then 
    EST_HOME="$HOME/.env"
fi

source $EST_HOME/variables.sh
export EST_SOURCED_HELPERS=()

est_check(){
    if ! [[ -e $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER ]]
    then
        echo "$EST_VENDOR/$EST_HELPER is not installed EST package"
        return 2
    fi
    if [[ -e $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER/est.sh ]]
    then
        return 0
    else
        echo "$EST_VENDOR/$EST_HELPER is not valid EST package"
        return 1
    fi
}
est_source(){
    if ! [[ $EST_SOURCED_HELPERS =~ ^.*$EST_VENDOR/$EST_HELPER.*$ ]];
    then
        est_check
        if [[ $? == 1 ]];
        then
            return 1
        fi
        source $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER/est.sh
        EST_SOURCED_HELPERS=($EST_SOURCED_HELPERS $EST_VENDOR/$EST_HELPER)
    fi
}
est_resource()
{
    if [[ $EST_SOURCED_HELPERS =~ ^.*$EST_VENDOR/$EST_HELPER.*$ ]];
    then
        est_check
        if [[ $? == 1 ]]
        then
            source $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER
        fi
    else
        echo "this lib is not sourced"
    fi
}

est_session(){
    for vendor in $(ls $EST_ACTIVE_HELPERS_DIR);
    do
        EST_VENDOR=$vendor
        for helper in $(ls $EST_ACTIVE_HELPERS_DIR/$vendor/);
        do
            EST_HELPER=$helper
            est_source
        done
    done
}
est_session 

