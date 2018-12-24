if [[ $(which git | wc -l) == 0 ]];
then
    echo "EST is dependent to git if you want to use first install git"
    exit
fi

cd $HOME
if [[ -z $EST_HOME ]]
then
    export EST_HOME=$HOME/.est
fi
if [[ -d $EST_HOME ]]
then
    echo "you have already $EST_HOME"
    exit
fi
git clone https://github.com/esthelpers/est $EST_HOME > /dev/null


chmod +x $EST_HOME/esthelpers.sh
ln -sf $EST_HOME/esthelpers.sh $EST_HOME/bin/est
echo "# put this source in your rc file"
echo "export EST_HOME=\$HOME/.est"
echo "source \$EST_HOME/estlib.sh"
