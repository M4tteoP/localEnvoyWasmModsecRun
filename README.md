# WAF-WASM modules local run test with func-e

Start a local server
```bash
python3 -m http.server 8000 &
```
Start envoy via [func-e](https://func-e.io/)
```bash
func-e run -c thesis-modsec-envoy-config.yaml &
```
Run the tests
```bash
./e2etest.sh
```
