// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "ds-test/test.sol";
import "src/EBMP.sol";
import "src/EBMPnoReshard.sol";
import "src/PixelationsRenderer.sol";
import "src/Brotchain.sol";

contract BenchmarkTest is DSTest {
    uint8[] img;
    bytes r_img;
    bytes er_img;
    bytes img_bytes;
    
    uint randNonce = 0;

    PixelationsRenderer p_renderer;
    Brotchain b_renderer;
    EBMP e_renderer;
    EBMPnoReshard er_renderer;

    bytes palette;

    function calc_mean(uint[] memory input) internal pure returns (uint) {
        uint s = 0;
        for (uint i = 0; i < input.length; i ++) {
            s += input[i];
        }
        return s / input.length;
    }
    
    function sqrt(uint x) internal pure returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
    
    function calc_stddev(uint[] memory input) internal pure returns (uint) {
        uint m = calc_mean(input);
        int s = 0;
    
        unchecked {
            for (uint i = 0; i < input.length; i ++) {
                int sq = int(input[i]) - int(m);
                s = s + sq * sq;
            }
        }
    
        return uint(s) / input.length;
    }

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

        for (uint256 i = 0; i < 1024; i++) {
            r_img[i] = getRandomByte();
        }

        for (uint256 i = 0; i < 3072; i++) {
            er_img[i] = getRandomByte();
        }
    }

    function setUp() public {
        img = new uint8[](3072);
        r_img = new bytes(1024);
        er_img = new bytes(3072);
        updateImage();
        img_bytes = new bytes(736);
        updateImageByte();
        p_renderer = new PixelationsRenderer();
        e_renderer = new EBMP();
        b_renderer = new Brotchain();
        er_renderer = new EBMPnoReshard();
        palette = b_renderer.grayscale();
    }

    function testEBMP() public {

        uint[] memory ebmp_length = new uint[](100);
        for (uint i = 0; i < 100; i++) {
            updateImage();
            string memory ebmp = e_renderer.encode(img, 32, 32, 3);
            ebmp_length[i] = bytes(ebmp).length;
        }

        emit log_uint(calc_mean(ebmp_length));
        emit log_uint(calc_stddev(ebmp_length));
    }

    function testEBMBnoReshard() public {

        uint[] memory ebmp_length = new uint[](100);
        for (uint i = 0; i < 100; i++) {
            updateImageByte();
            string memory ebmp = er_renderer.encode(er_img, 32, 32, 3);
            ebmp_length[i] = bytes(ebmp).length;
        }

        emit log_uint(calc_mean(ebmp_length));
        emit log_uint(calc_stddev(ebmp_length));
    }

    function testBrotchain() public {

        uint[] memory brotchain_length = new uint[](100);
        for (uint i = 0; i < 100; i++) {
            updateImageByte();
            string memory brotchain = b_renderer.bmpDataURI(b_renderer.bmp(r_img, 32, 32, palette));
            brotchain_length[i] = bytes(brotchain).length;
        }

        emit log_uint(calc_mean(brotchain_length));
        emit log_uint(calc_stddev(brotchain_length));
    }

    function testPixelations() public {

        uint[] memory pixelation_length = new uint[](100);
        for (uint i = 0; i < 100; i++) {
            updateImageByte();
            string memory pixelation = p_renderer.tokenSVG(img_bytes);
            pixelation_length[i] = bytes(pixelation).length;
        }

        emit log_uint(calc_mean(pixelation_length));
        emit log_uint(calc_stddev(pixelation_length));
    }
}
