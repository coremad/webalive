FROM perl
# WORKDIR /opt/mojo-hello_world
COPY . .
RUN cpanm --skip-installed -n -i JSON
RUN cpanm --skip-installed -n -i DBI
RUN cpanm --skip-installed -n -i DBD::Pg
RUN cpanm --skip-installed -n -i YAML
RUN cpanm --installdeps -n .
EXPOSE 3000
# CMD ./script/mojo-hello_world prefork
