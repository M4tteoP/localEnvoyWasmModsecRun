# WAF-WASM modules local run test with func-e

Start a local server:
```bash
python3 -m http.server 8000 &
```
Start envoy via [func-e](https://func-e.io/):
```bash
func-e run -c thesis-modsec-envoy-config.yaml &
```
Run the tests:
```bash
./e2etest.sh
```

Expected output:
```
[1/4] Testing application reachability
[Ok] Got status code 200, expected 200
[2/4] Testing true negative request
[Ok] Got status code 200, expected 200
[3/4] Testing true positive request - Core Rule Set
[Ok] Got status code 403, expected 403 - CRS is working
[4/4] Testing true positive request - Custom Rule
[Ok] Got status code 403, expected 403 - Custom Rule is working
[Done] All tests passed
```
