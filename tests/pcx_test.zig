const ImageInStream = zigimg.ImageInStream;
const ImageSeekStream = zigimg.ImageSeekStream;
const PixelFormat = zigimg.PixelFormat;
const assert = std.debug.assert;
const color = zigimg.color;
const errors = zigimg.errors;
const pcx = zigimg.pcx;
const std = @import("std");
const testing = std.testing;
const zigimg = @import("zigimg");
usingnamespace @import("helpers.zig");

test "PCX bpp1 (linear)" {
    const file = try testOpenFile(testing.allocator, "tests/fixtures/pcx/test-bpp1.pcx");
    defer file.close();

    var fileInStream = file.inStream();
    var fileSeekStream = file.seekableStream();

    var pcxFile = pcx.PCX{};
    const pixels = try pcxFile.read(testing.allocator, @ptrCast(*ImageInStream, &fileInStream.stream), @ptrCast(*ImageSeekStream, &fileSeekStream.stream));
    defer pixels.deinit(testing.allocator);

    expectEq(pcxFile.width, 27);
    expectEq(pcxFile.height, 27);
    expectEq(pcxFile.pixel_format, PixelFormat.Bpp1);

    testing.expect(pixels == .Bpp1);

    expectEq(pixels.Bpp1.indices[0], 0);
    expectEq(pixels.Bpp1.indices[15], 1);
    expectEq(pixels.Bpp1.indices[18], 1);
    expectEq(pixels.Bpp1.indices[19], 1);
    expectEq(pixels.Bpp1.indices[20], 1);
    expectEq(pixels.Bpp1.indices[22 * 27 + 11], 1);

    expectEq(pixels.Bpp1.palette[0].R, 102);
    expectEq(pixels.Bpp1.palette[0].G, 90);
    expectEq(pixels.Bpp1.palette[0].B, 155);

    expectEq(pixels.Bpp1.palette[1].R, 115);
    expectEq(pixels.Bpp1.palette[1].G, 137);
    expectEq(pixels.Bpp1.palette[1].B, 106);
}

test "PCX bpp4 (linear)" {
    const file = try testOpenFile(testing.allocator, "tests/fixtures/pcx/test-bpp4.pcx");
    defer file.close();

    var fileInStream = file.inStream();
    var fileSeekStream = file.seekableStream();

    var pcxFile = pcx.PCX{};
    const pixels = try pcxFile.read(testing.allocator, @ptrCast(*ImageInStream, &fileInStream.stream), @ptrCast(*ImageSeekStream, &fileSeekStream.stream));
    defer pixels.deinit(testing.allocator);

    expectEq(pcxFile.width, 27);
    expectEq(pcxFile.height, 27);
    expectEq(pcxFile.pixel_format, PixelFormat.Bpp4);

    testing.expect(pixels == .Bpp4);

    expectEq(pixels.Bpp4.indices[0], 1);
    expectEq(pixels.Bpp4.indices[1], 9);
    expectEq(pixels.Bpp4.indices[2], 0);
    expectEq(pixels.Bpp4.indices[3], 0);
    expectEq(pixels.Bpp4.indices[4], 4);
    expectEq(pixels.Bpp4.indices[14 * 27 + 9], 6);
    expectEq(pixels.Bpp4.indices[25 * 27 + 25], 7);

    expectEq(pixels.Bpp4.palette[0].R, 0x5e);
    expectEq(pixels.Bpp4.palette[0].G, 0x37);
    expectEq(pixels.Bpp4.palette[0].B, 0x97);

    expectEq(pixels.Bpp4.palette[15].R, 0x60);
    expectEq(pixels.Bpp4.palette[15].G, 0xb5);
    expectEq(pixels.Bpp4.palette[15].B, 0x68);
}

test "PCX bpp8 (linear)" {
    const file = try testOpenFile(testing.allocator, "tests/fixtures/pcx/test-bpp8.pcx");
    defer file.close();

    var fileInStream = file.inStream();
    var fileSeekStream = file.seekableStream();

    var pcxFile = pcx.PCX{};
    const pixels = try pcxFile.read(testing.allocator, @ptrCast(*ImageInStream, &fileInStream.stream), @ptrCast(*ImageSeekStream, &fileSeekStream.stream));
    defer pixels.deinit(testing.allocator);

    expectEq(pcxFile.width, 27);
    expectEq(pcxFile.height, 27);
    expectEq(pcxFile.pixel_format, PixelFormat.Bpp8);

    testing.expect(pixels == .Bpp8);

    expectEq(pixels.Bpp8.indices[0], 37);
    expectEq(pixels.Bpp8.indices[3 * 27 + 15], 60);
    expectEq(pixels.Bpp8.indices[26 * 27 + 26], 254);

    expectEq(pixels.Bpp8.palette[0].R, 0x46);
    expectEq(pixels.Bpp8.palette[0].G, 0x1c);
    expectEq(pixels.Bpp8.palette[0].B, 0x71);

    expectEq(pixels.Bpp8.palette[15].R, 0x41);
    expectEq(pixels.Bpp8.palette[15].G, 0x49);
    expectEq(pixels.Bpp8.palette[15].B, 0x30);

    expectEq(pixels.Bpp8.palette[219].R, 0x61);
    expectEq(pixels.Bpp8.palette[219].G, 0x8e);
    expectEq(pixels.Bpp8.palette[219].B, 0xc3);
}

test "PCX bpp24 (planar)" {
    const file = try testOpenFile(testing.allocator, "tests/fixtures/pcx/test-bpp24.pcx");
    defer file.close();

    var fileInStream = file.inStream();
    var fileSeekStream = file.seekableStream();

    var pcxFile = pcx.PCX{};
    const pixels = try pcxFile.read(testing.allocator, @ptrCast(*ImageInStream, &fileInStream.stream), @ptrCast(*ImageSeekStream, &fileSeekStream.stream));
    defer pixels.deinit(testing.allocator);

    expectEq(pcxFile.header.planes, 3);
    expectEq(pcxFile.header.bpp, 8);

    expectEq(pcxFile.width, 27);
    expectEq(pcxFile.height, 27);
    expectEq(pcxFile.pixel_format, PixelFormat.Rgb24);

    testing.expect(pixels == .Rgb24);

    expectEq(pixels.Rgb24[0].R, 0x34);
    expectEq(pixels.Rgb24[0].G, 0x53);
    expectEq(pixels.Rgb24[0].B, 0x9f);

    expectEq(pixels.Rgb24[1].R, 0x32);
    expectEq(pixels.Rgb24[1].G, 0x5b);
    expectEq(pixels.Rgb24[1].B, 0x96);

    expectEq(pixels.Rgb24[26].R, 0xa8);
    expectEq(pixels.Rgb24[26].G, 0x5a);
    expectEq(pixels.Rgb24[26].B, 0x78);

    expectEq(pixels.Rgb24[27].R, 0x2e);
    expectEq(pixels.Rgb24[27].G, 0x54);
    expectEq(pixels.Rgb24[27].B, 0x99);

    expectEq(pixels.Rgb24[26 * 27 + 26].R, 0x88);
    expectEq(pixels.Rgb24[26 * 27 + 26].G, 0xb7);
    expectEq(pixels.Rgb24[26 * 27 + 26].B, 0x55);
}
