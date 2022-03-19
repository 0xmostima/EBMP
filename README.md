## EBMP: Efficient Bitmap Encodings on Ethereum Virtual Machines

Artifacts and experiments for EBMP: Efficient Bitmap Encodings on Ethereum Virtual Machines (SIGBOVIK '22) 

### Running

Benchmarks:
```
cd src && forge test -vvv --gas-report
```

Runtime analysis:
```
cd src && time forge test -vv --match-test testEBMPSpeed
```