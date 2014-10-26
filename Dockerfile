FROM ruby:2.1.2-onbuild
COPY . /usr/src/app
ENTRYPOINT ["bundle","exec"]
CMD ["actn-api", "console"]