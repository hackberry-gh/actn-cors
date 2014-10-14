web_cors_connect: bundle exec actn-api connect -p 6001 -sv
web_cors_query:   bundle exec actn-api query   -p 6002 -sv 
web_cors_upsert:  bundle exec actn-api upsert  -p 6003 -sv 
web_cors_delete:  bundle exec actn-api delete  -p 6004 -sv 

worker_jobs: bundle exec rake jobs:work

web: haproxy -f ./haproxy.cfg
