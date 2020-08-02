# Start with the Matlab r2019b runtime container
FROM flywheel/matlab-mcr:v97

RUN cd /opt/mcr/v97/bin/glnxa64 && \
    mv libexpat.so.1 libexpat.so.1.NOFIND && \
    apt-get -qq update && \
    apt-get -qq -y upgrade && \
    apt-get -qq install -y \
    apt-utils \
    python3 \
    python3-pip && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install flywheel-sdk && \
    rm -rf /var/cache/apt/*

# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
RUN mkdir -p ${FLYWHEEL}

# Copy and configure run script and metadata code
COPY autoQA ${FLYWHEEL}/autoQA
RUN chmod +x ${FLYWHEEL}/autoQA
COPY run ${FLYWHEEL}/run
RUN chmod +x ${FLYWHEEL}/run
COPY manifest.json ${FLYWHEEL}/manifest.json

# Configure entrypoint
# ENTRYPOINT ["sh", "-c", "ls -al $FLYWHEEL"]