// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "ds-test/test.sol";
import "src/EBMP.sol";

contract EBMPTest is DSTest {
    uint8[] img;

    uint randNonce = 0;

    EBMP e_renderer;

    function getRandomColor() public returns (uint8) {
        uint8 random = uint8(uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 256);
        randNonce++;
        return random;
    }

    function updateImage() public {
        for (uint256 i = 0; i < 3072; i++) {
            img[i] = getRandomColor();
        }
    }

    function setUp() public {
        img = new uint8[](3072);
        updateImage();
        e_renderer = new EBMP();
    }

    function testEBMPSpeed() public view {
        string memory ebmp = e_renderer.encode(img, 32, 32, 3);        
        //emit log_string(ebmp);
    }


}
