FROM python:3.8

ARG ssh_prv_key
ARG ssh_pub_key

WORKDIR usr/src/app
COPY requirements.txt .
#COPY train_ml.sh .
RUN pip install -r requirements.txt

#Install git and download repositories
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y emacs && \
    apt-get install -y jq

# add credentials on build
RUN mkdir -p ~/.ssh && \
    chmod 0700 ~/.ssh

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > ~/.ssh/id_rsa && \
    echo "$ssh_pub_key" > ~/.ssh/id_rsa.pub && \
    chmod 600 ~/.ssh/id_rsa && \
    chmod 600 ~/.ssh/id_rsa.pub


#COPY ./id_rsa ~/.ssh/id_rsa
#COPY ./id_rsa.pub ~/.ssh/id_rsa.pub
#RUN eval "$(ssh-agent -s)"
#RUN ssh-add -l -E sha256

# make sure your domain is accepted
RUN touch ~/.ssh/known_hosts
RUN ssh-keyscan -t rsa github.com | tee github-key-temp | ssh-keygen -lf -
RUN cat github-key-temp >> ~/.ssh/known_hosts
#RUN ssh -T git@github.com

#Clone repos
RUN git clone git@github.com:dlaredorazo/ml_training.git
RUN git clone git@github.com:dlaredorazo/models_and_data.git

RUN cp ml_training/train_ml.sh train_ml.sh

#RUN python3 /app/train.py