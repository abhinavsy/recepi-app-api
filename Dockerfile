FROM  python:3.9-alpine3.13
#python i s the image and the 3.9-alpine3.13 is the tag we are using which is alighter image of the linux

LABEL maintainer="abhinav"

#env buffered is used to print the python response/error directly
ENV PYTHONUNBUFFERED 1

#copy the requirement file from local to the path /tmp//requirements.txt
COPY ./requirements.txt /tmp/requirements.txt

COPY ./requirements.dev.txt /tmp/requirements.dev.txt

#copy the app 
COPY ./app /app


WORKDIR /app

EXPOSE 8000
ARG DEV=false

#run a alpine command new image 
#1. creates a new virtual env
#2. upgrades pip
#3.install dependencies
#4.remove tmp file
#5.adds a new user in our image//not to user root user//to prevent attack
RUN python -m venv /py && \    
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = true ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
     --disabled-password \
     --no-create-home \
     django-user


#env variable in path /updating the variable path and to run commands in the enviornpent file
ENV PATH="/py/bin:$PATH" 

#django-user will run and not the root user
USER root    