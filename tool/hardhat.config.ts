import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";

task("encode", "encode")
  .addParam("image", "image")
  .addParam("width", "width")
  .addParam("height", "height")
  .setAction(async (taskArgs, hre) => {

    const header = '<svg image-rendering="pixelated" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" > <image width="100%" height="100%" xlink:href="data:image/bmp;base64,';
    const footer = '" /> </svg>';

    const EBMP = await hre.ethers.getContractFactory("EBMP");
    const ebmp = await EBMP.deploy();
    await ebmp.deployed();
    console.log("EBMP deployed to:", ebmp.address);

    const sharp = require('sharp');
    const fs = require('fs');

    const width = parseInt(taskArgs.width);
    const height = parseInt(taskArgs.height);
    const { data, _ } = await sharp(taskArgs.image)
    .resize({ width, height, fit: 'fill' })
    .raw()
    .toBuffer({ resolveWithObject: true });

    const pixelArray = new Uint8ClampedArray(data.buffer);
    let image = [];
    for (let i = 0; i < pixelArray.length; i++) {
      image.push(pixelArray[i]);
    }

    const base64Rep = header + (await ebmp.encode(image, width, height, 3)) + footer;
    fs.writeFileSync('encoded.html', base64Rep);

  });

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: "0.8.11",
  networks: {
    hardhat: {blockGasLimit: 1000000000000}
  }
};

export default config;
