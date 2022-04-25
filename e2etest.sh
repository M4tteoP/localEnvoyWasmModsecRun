#!/bin/bash

step=1
total_steps=4
application_url="http://localhost:8000"
envoy_url_unfiltered="http://localhost:8001/"
envoy_url_crs_filtered="http://localhost:8001?arg=<script>%(payload)s</script>>"
envoy_url_custom_filtered="http://localhost:8001?arg=matteo/"

# Testing if the server is up
echo "[$step/$total_steps] Testing application reachability"
status_code=$(curl --write-out "%{http_code}" --silent --output /dev/null $application_url)
if [[ "$status_code" -ne 200 ]] ; then
  echo "[Fail] Unexpected response with code $status_code from $application_url"
  exit 1
fi
echo "[Ok] Got status code $status_code, expected 200"

# Testing envoy container reachability with an unfiltered request
((step+=1))
echo "[$step/$total_steps] Testing true negative request"
status_code=$(curl --write-out "%{http_code}" --silent --output /dev/null $envoy_url_unfiltered)
if [[ "$status_code" -ne 200 ]] ; then
  echo "[Fail] Unexpected response with code $status_code from $envoy_url_unfiltered"
  exit 1
fi
echo "[Ok] Got status code $status_code, expected 200"

# Testing Core Rule Set filtered request
((step+=1))
echo "[$step/$total_steps] Testing true positive request - Core Rule Set"
status_code=$(curl --write-out "%{http_code}" --silent --output /dev/null $envoy_url_crs_filtered)
if [[ "$status_code" -ne 403 ]] ; then
  echo "[Fail] Unexpected response with code $status_code from $envoy_url_filtered"
  exit 1
fi
echo "[Ok] Got status code $status_code, expected 403 - CRS is working"

# Testing Custom rule
((step+=1))
echo "[$step/$total_steps] Testing true positive request - Custom Rule"
status_code=$(curl --write-out "%{http_code}" --silent --output /dev/null $envoy_url_custom_filtered)
if [[ "$status_code" -ne 403 ]] ; then
  echo "[Fail] Unexpected response with code $status_code from $envoy_url_filtered"
  exit 1
fi
echo "[Ok] Got status code $status_code, expected 403 - Custom Rule is working"

echo "[Done] All tests passed"
