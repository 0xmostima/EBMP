// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "ds-test/test.sol";
import "src/EBMP.sol";
import "src/PixelationsRenderer.sol";

contract ContractTest is DSTest {
    uint8[] img;
    PixelationsRenderer renderer;
    bytes img_bytes;
    function setUp() public {
        img = new uint8[](3072);
        img_bytes = new bytes(736);
        renderer = new PixelationsRenderer();
    }

    function testEBMP() public {
        string memory ebmp = EBMP.encode(img, 32, 32, 3);
        emit log_uint(bytes(ebmp).length);
    }

    function testPixelations() public {
        string memory pixelation = renderer.tokenSVG(img_bytes);
        emit log_uint(bytes(pixelation).length);
    }
}
