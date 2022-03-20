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

We've also provided a demo to show how to use EBMP in hardhat. To run:
```
cd tool && yarn && npx hardhat compile && npx hardhat encode --image {YOUR_IMAGE} --width 64 --height 64 
```

### Citing

```
@inproceedings{mostima22,
 author = {0xmostima and Liu, Yunsong and Liao, Peiyuan},
 title = {EBMP: Efficient Bitmap Encodings on Ethereum Virtual Machines},
 booktitle = {The Sixteenth Annual Intercalary Robot Dance Party in Celebration of Workshop on Symposium about 2^6th Birthdays; in Particular, that of Harry Q. Bovik (SIGBOVIK)},
 year = {2022},
 url = {http://sigbovik.org/},
 address = {Pittsburgh, PA, USA},
}
```