FROM perl
COPY . .
RUN cpanm --skip-installed --installdeps -n .
RUN cpanm --skip-installed -n -i JSON
EXPOSE 3000
