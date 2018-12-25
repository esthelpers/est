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
est_activate(){
    if ! [[ -d $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/ ]]
    then
        mkdir $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR
    fi
    est_check 
    if [[ $? == 0 ]]
    then
        ln -sf $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/;
        echo $EST_VENDOR/$EST_HELPER activated
        est_source
    fi
}
est_deactivate(){
    rm $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/$EST_HELPER
    echo $EST_VENDOR/$EST_HELPER deactivated
    echo "This helper dont be deactivate until you restart your shell"
}
est(){
    if [[ $# == 1 ]];
    then
        cmd=$1
        shift
        case "$cmd" in
            *)
                esthelpers $@
                ;;
        esac

    fi
    if [[ $# < 2 ]];
    then
        echo "EST gets at least two parameters"
        est_help
    fi

    cmd=$1
    shift
    helper=$1
    shift
    for additional in $@;do
        if [[ ${additional%:*} == from ]];
        then
            parameter=${additional#*:}
            est_choose_from $parameter
        fi
    done
    if [[ $helper =~ ^.*/.*$ ]]
    then
        export EST_VENDOR=${helper%/*}
    else
        export EST_VENDOR="esthelpers"
    fi
    export EST_HELPER=${helper#*/}
    case "$cmd" in
        activate)
            est_activate
            ;;
        deactivate)
            est_deactivate
            ;;
        *)
            esthelpers $@
            ;;
    esac
}
est_session 

