source $EST_HOME/variables.sh
export EST_SOURCED_HELPERS=()

est_echo(){
    if ! [[ $EST_SILENT == 1 ]];
    then
        echo $@
    fi
}

est_check(){
    if ! [[ -e $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER ]]
    then
        est_echo "$EST_VENDOR/$EST_HELPER is not installed EST package"
        return 2
    fi
    if [[ -e $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER/est.sh ]]
    then
        return 0
    else
        est_echo "$EST_VENDOR/$EST_HELPER is not valid EST package"
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
        export $EST_VENDOR"_"$EST_HELPER=$EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER
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
        est_echo "this lib is not sourced"
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
est_activate(){
    if ! [[ -d $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/ ]]
    then
        mkdir $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR
    fi
    est_check 
    if [[ $? == 0 ]]
    then
        ln -sf $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/;
        est_source
        est_echo $EST_VENDOR/$EST_HELPER activated
    fi
}
est_deactivate(){
    if [[ -d $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/$EST_HELPER/ ]]
    then
        rm $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/$EST_HELPER
        est_echo $EST_VENDOR/$EST_HELPER deactivated
        est_echo "This helper dont be deactivate until you restart your shell"
    fi
}
est(){

    if [[ $# > 1 ]] && [[ $1 == silent ]];
    then
        export EST_SILENT=1
        shift
    else
        export EST_SILENT=0
    fi
    if [[ $# == 1 ]];
    then
        cmd=$1
        case "$cmd" in
            *)
                esthelpers.sh $@
                ;;
        esac

    elif [[ $# == 2 ]];
    then

        cmd=$1
        helper=$2
        if [[ $helper =~ ^.*/.*$ ]]
        then
            export EST_VENDOR=${helper%/*}
        else
            export EST_VENDOR="esthelpers"
        fi
        export EST_HELPER=${helper#*/}
        case "$cmd" in
            install)
                esthelpers.sh $@
                est_activate
                ;;
            activate)
                est_activate
                ;;
            deactivate)
                est_deactivate
                ;;
            *)
                esthelpers.sh $@
                ;;
        esac
    fi
}

