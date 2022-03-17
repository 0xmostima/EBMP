// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

import {Base64} from "./Base64.sol";

library EBMP {
    function uint32ToLittleEndian(uint32 a) internal pure returns (uint32) {
        unchecked {
            uint32 b1 = (a >> 24) & 255;
            uint32 b2 = (a >> 16) & 255;
            uint32 b3 = (a >> 8) & 255;
            uint32 b4 = a & 255;
            return uint32(b1 | (b2 << 8) | (b3 << 16) | (b4 << 24));
        }
    }

    function encode(
        uint8[] memory image,
        uint32 width,
        uint32 height,
        uint32 channels
    ) internal pure returns (string memory) {
        bytes memory BITMAPFILEHEADER =
            abi.encodePacked(
                string("BM"),
                uint32(
                    uint32ToLittleEndian(14 + 40 + width * height * channels)
                ), // the size of the BMP file in bytes
                uint16(0), // Reserved 
                uint16(0), // Reserved
                uint32(uint32ToLittleEndian(14 + 40)) 
                // the offset, i.e. starting address, of the byte where the bitmap 
                // image data (pixel array) can be found
            ); // total 2 + 4 + 2 + 2 + 4 = 14 bytes long
        bytes memory BITMAPINFO =
            abi.encodePacked(
                uint32(0x28000000), // the size of this header, in bytes (40)
                uint32(uint32ToLittleEndian(width)), // the bitmap width in pixels (signed integer)
                uint32(uint32ToLittleEndian(height)), // the bitmap height in pixels (signed integer)
                uint16(0x0100), // the number of color planes (must be 1)
                uint16(0x1800), // the number of bits per pixel
                uint32(0x00000000), // the compression method being used
                uint32(uint32ToLittleEndian(width * height * channels)), // the image size
                uint32(0xc30e0000), // the horizontal resolution of the image
                uint32(0xc30e0000), // the vertical resolution of the image
                uint32(0), // the number of colors in the color palette, or 0 to default to 2n
                uint32(0) // the number of important colors used, or 0 when every color is important
            ); // total 40 bytes long
        bytes memory data = new bytes(width * height * channels);
        for (uint256 r = 0; r < height; r++) {
            for (uint256 c = 0; c < width; c++) {
                for (uint256 color = 0; color < channels; color++) {
                    data[(r * width + c) * channels + color] = bytes1(
                        image[((height - 1 - r) * width + c) * channels + color]
                    );
                }
            }
        }
        string memory encoded =
            Base64.encode(
                abi.encodePacked(
                    BITMAPFILEHEADER,
                    BITMAPINFO,
                    data
                )
            );
        return encoded;
    }
}