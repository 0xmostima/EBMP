// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "ds-test/test.sol";
import "src/EBMP.sol";
import "src/PixelationsRenderer.sol";

contract ContractTest is DSTest {
    uint8[] img;
    bytes img_bytes;
    
    uint randNonce = 0;

    PixelationsRenderer p_renderer;
    EBMP e_renderer;


    function getRandomColor() public returns (uint8) {
        uint8 random = uint8(uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 256);
        randNonce++;
        return random;
    }

    function getRandomByte() public returns (bytes1) {
        bytes1 random = bytes1(getRandomColor());
        randNonce++;
        return random;
    }

    function updateImage() public {
        for (uint256 i = 0; i < 3072; i++) {
            img[i] = getRandomColor();
        }
    }

    function updateImageByte() public {
        for (uint256 i = 0; i < 736; i++) {
            img_bytes[i] = getRandomByte();
        }
    }

    function setUp() public {
        img = new uint8[](3072);
        for (uint256 i = 0; i < 3072; i++) {
            img[i] = getRandomColor();
        }
        img_bytes = new bytes(736);
        p_renderer = new PixelationsRenderer();
        e_renderer = new EBMP();
    }

    function testEBMP() public {

        uint ebmp_length = 0;
        for (uint i = 0; i < 100; i++) {
            updateImage();
            string memory ebmp = e_renderer.encode(img, 32, 32, 3);
            ebmp_length += bytes(ebmp).length;
        }

        ebmp_length /= 100;
        emit log_uint(ebmp_length);
    }

    function testPixelations() public {

        uint pixelation_length = 0;
        for (uint i = 0; i < 100; i++) {
            updateImageByte();
            string memory pixelation = p_renderer.tokenSVG(img_bytes);
            pixelation_length += bytes(pixelation).length;
        }

        pixelation_length /= 100;
        emit log_uint(pixelation_length);
    }
}
