# We pull the latest NVIDIA NGC Pytorch docker to have the most recent updates
ARG BASE_IMAGE=nvcr.io/nvidia/pytorch:20.03-py3
FROM $BASE_IMAGE

# Install most common NLP libraries
RUN pip install tokenizers && \
    pip install transformers