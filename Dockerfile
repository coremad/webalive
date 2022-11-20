FROM perl
# WORKDIR /opt/mojo-hello_world
COPY . .
RUN cpanm --skip-installed --installdeps -n .
RUN cpanm --skip-installed -n -i JSON
EXPOSE 3000
# CMD ./script/mojo-hello_world prefork
