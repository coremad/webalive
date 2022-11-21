FROM perl
COPY . .
RUN cpanm --skip-installed --installdeps -n .
EXPOSE 3000
