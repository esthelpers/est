if [[ $(which git | wc -l) == 0 ]];
then
    echo "EST is dependent to git if you want to use first install git"
    exit
fi

cd $HOME
if [[ -z $EST_HOME ]]
then
    export EST_HOME=$HOME/.config/est/helpers/esthelpers/est
fi
if [[ -d $EST_HOME ]]
then
    echo "you have already $EST_HOME"
    exit
else
    mkdir -p $EST_HOME
fi
$(git clone https://github.com/esthelpers/est $EST_HOME/helpers/esthelpers/est > /dev/null)
echo "# put this source in your rc file"
echo "export EST_EDITOR=vim"
echo "export EST_HOME=\$HOME/.config/est/helpers/esthelpers/est"
echo "source \$EST_HOME/estlib.sh"
