FROM openjdk:8-jre-alpine

WORKDIR /home

ENV componentName "CloudConfigService"
ENV componentVersion 3.0.1

RUN apk --no-cache add \
	git \
	unzip \
	wget \
	bash \
	&& git clone --branch master --single-branch --depth 1 https://github.com/symbiote-h2020/CloudConfigProperties.git \
	&& echo "Downloading $componentName $componentVersion" \
	&& wget "https://jitpack.io/com/github/symbiote-h2020/$componentName/$componentVersion/$componentName-$componentVersion-run.jar" \
    	&& touch bootstrap.properties \
    	&& echo "spring.cloud.config.server.git.uri=file://$PWD/CloudConfigProperties" >> bootstrap.properties \
    	&& echo "server.port=8888" >> bootstrap.properties \
	&& rm CloudConfigProperties/application.properties \
	&& ln -s $PWD/application-custom.properties CloudConfigProperties/application.properties

EXPOSE 8888

CMD java $JAVA_HTTP_PROXY $JAVA_HTTPS_PROXY $JAVA_NON_PROXY_HOSTS -jar $(ls *run.jar)
