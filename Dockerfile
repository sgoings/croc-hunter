FROM quay.io/deis/base:v0.3.4

MAINTAINER Lachlan Evenson <lachlan.evenson@gmail.com>

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/lachie83/croc-hunter" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

COPY /bin /bin
COPY /static /static

CMD ["croc-hunter"]

EXPOSE 8080
