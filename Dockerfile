FROM java:openjdk-7-jdk

MAINTAINER zsx <thinkernel@gmail.com>

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
ENV GERRIT_HOME /var/gerrit
ENV GERRIT_SITE ${GERRIT_HOME}/review_site
ENV GERRIT_WAR ${GERRIT_HOME}/gerrit.war
ENV GERRIT_VERSION 2.9.3
ENV GERRIT_USER gerrit2

RUN useradd -m -d "$GERRIT_HOME" -u 1000 -U  -s /bin/bash $GERRIT_USER

#Download gerrit.war
RUN curl -L https://gerrit-releases.storage.googleapis.com/gerrit-${GERRIT_VERSION}.war -o $GERRIT_WAR
#only for local test
#COPY gerrit-${GERRIT_VERSION}.war $GERRIT_WAR

COPY gerrit*.sh ${GERRIT_HOME}/
RUN chown ${GERRIT_USER}:${GERRIT_USER} ${GERRIT_HOME}/gerrit*.sh \
 && chmod +x ${GERRIT_HOME}/gerrit*.sh

USER $GERRIT_USER

RUN mkdir -p $GERRIT_SITE

#RUN java -jar $GERRIT_WAR init --batch -d $GERRIT_SITE
ENTRYPOINT ["/var/gerrit/gerrit-entrypoint.sh"]

EXPOSE 8080 29418

CMD ["/var/gerrit/gerrit-start.sh"]

