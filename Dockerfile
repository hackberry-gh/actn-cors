FROM ruby:2.1.2-onbuild
RUN curl -O http://nodejs.org/dist/v0.10.30/node-v0.10.30-linux-x64.tar.gz && tar xvfz node-v0.10.30-linux-x64.tar.gz && mv node-v0.10.30-linux-x64/bin/node /usr/local/bin/node && rm -rf node-v0.10.30-linux-x64.tar.gz node-v0.10.30-linux-x64
RUN curl -L https://npmjs.org/install.sh | sh
RUN npm install --g coffee-script
COPY . /usr/src/app
ENTRYPOINT ["bundle","exec"]
CMD ["actn-api", "console"]