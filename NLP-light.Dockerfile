ARG BASE_IMAGE=jupyter/scipy-notebook
FROM $BASE_IMAGE

LABEL maintainer="Mansour Saffar msaffarmehjardy@gmail.com"

USER root

# install java (for stanford CoreNLP)
RUN apt-get update -q && \
    apt-get install -y -q --no-install-recommends apt-utils && \
    apt-get upgrade -y -q && \
    apt-get install -y -q software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update -q && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y -q oracle-java8-installer && \
    apt-get install -q oracle-java8-set-default && \
    apt-get clean

# install latest stanford coreNLP (https://hub.docker.com/r/graham3333/corenlp-complete/dockerfile)
RUN export REL_DATE="2018-10-05"; \
	wget http://nlp.stanford.edu/software/stanford-corenlp-full-${REL_DATE}.zip; \
	unzip stanford-corenlp-full-${REL_DATE}.zip; \
	mv stanford-corenlp-full-${REL_DATE} CoreNLP; \
	cd CoreNLP; \
	export CLASSPATH=""; for file in `find . -name "*.jar"`; do export CLASSPATH="$CLASSPATH:`realpath $file`"; done

# install some of the NLP libraries
RUN conda install --quiet --yes \
    'nltk=3.3*' \
    'spacy=2*'

# download dataset for the NLP libraries
RUN python -m spacy download en_core_web_sm && \
    python -m spacy download en_vectors_web_sm && \
    python -c "import nltk; nltk.download('popular', halt_on_error=False)"

USER $NB_UID

# coreNLP port
EXPOSE 9000
