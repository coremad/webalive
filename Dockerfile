FROM perl
# WORKDIR /opt/mojo-hello_world
COPY . .
RUN cpanm -T -i JSON
RUN cpanm -T -i DBI
RUN cpanm -T -i DBD::Pg
RUN cpanm --installdeps -n .
EXPOSE 3001
# CMD ./script/mojo-hello_world prefork
