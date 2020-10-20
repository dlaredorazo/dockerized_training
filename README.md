dockerized_training

To run the container follow these instructions:

1. Build the docker container by running:
 docker build --no-cache  --build-arg ssh_prv_key="$(cat keys/id_rsa)" --build-arg ssh_pub_key="$(cat keys/id_rsa.pub)" --tag ml_training .

2. Run the docker image
 docker run -dit --name ml_training ml_training

3. Specify the model you want to train and the data you want to use for the training using the config.json file

4. Copy the config.json file to the docker image using the command:
 docker cp config.json ml_training:/usr/src/app/config.json

5. Run the pipeline with:
 docker exec -ti ml_training sh /usr/src/app/train_ml.sh 

6. If everything was successfull you the model will be trained and uploaded to the git repository

config.json description

config.json is a file used to instruct the python scripts which models to train, using which data and if the data needs to be preprocessed before training. The .json has the following fields

{
  "data_version": Specify the version of the data to be used for the training (the data needs to be present in the model_and_data repository)
  "model_label": Specify the model that will be trained (the base model needs to be present in the model_and_data repository)
  "model_version": Specify a version (git commit id) of the model that will be trained
  "training_type": Specify if the model will be trained from scratch or if it will be re-trained with new data
  "preprocess_data": Specify if the data will be preprocessed before training the model or if it will take processed data from the repository
}