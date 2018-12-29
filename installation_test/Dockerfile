FROM ubuntu:latest
RUN apt update
RUN apt install -y git wget

RUN wget -O - -o /dev/null https://raw.githubusercontent.com/esthelpers/est/master/install.sh | bash

RUN echo 'export EST_EDITOR=vim' >> $HOME/.bashrc
RUN echo 'export EST_HOME=/root/.config/est/helpers/esthelpers/est' >> $HOME/.bashrc
RUN echo 'source /root/.config/est/helpers/esthelpers/est/estlib.sh' >> $HOME/.bashrc
RUN echo 'est_session' >> $HOME/.bashrc

WORKDIR /root
CMD bash
