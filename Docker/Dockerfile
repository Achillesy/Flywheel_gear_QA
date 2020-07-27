# Start with the Matlab r2019b runtime container
FROM flywheel/matlab-mcr:v97

# Make directory for flywheel spec (v0)
ENV FLYWHEEL=/flywheel/v0
RUN mkdir -p ${FLYWHEEL}

# Copy and configure run script and metadata code
# COPY autoQA ${FLYWHEEL}/autoQA
# RUN chmod +x ${FLYWHEEL}/autoQA
# COPY run ${FLYWHEEL}/run
# RUN chmod +x ${FLYWHEEL}/run
# COPY manifest.json ${FLYWHEEL}/manifest.json

# Configure entrypoint
ENTRYPOINT ["/flywheel/v0/run"]