/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
import XCTest
import Darwin

class PagePoolTest: XCTestCase
{
        let KB = Int64(1024);
        let MB = Int64(1024*1024);
        let GB = Int64(1024*1024*1024);

        override func setUp()
        {
                let dtbPath = String(cString: dtb_path);
                let dtb = NSData(contentsOfFile: dtbPath);
                PAGE_VOFFSET = mmap(UnsafeMutableRawPointer(bitPattern: 0x4800000000),
                                    Int(4*MB), PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
                XCTAssertEqual(Int(bitPattern: PAGE_VOFFSET), 0x4800000000);
                XCTAssertEqual(Int(bitPattern: PAGE_VOFFSET) % 4096, 0);
                XCTAssertGreaterThan(page_pool_setup(dtb!.bytes, 8*KB, 2*GB), 0);
        }

        override func tearDown() {
                munmap(PAGE_VOFFSET, Int(4*MB));
        }

        func testTakeAndDrop()
        {
                for _ in 0..<5000 {
                        let p01 = page_pool_take(1, 4096);
                        let p02 = page_pool_take(4097, 4096);
                        let p03 = page_pool_take(4096, 4096);
                        XCTAssertNotNil(p01);
                        XCTAssertNotNil(p02);
                        XCTAssertNotNil(p03);
                        XCTAssertEqual(Int(bitPattern: p01) % 4096, 0);
                        XCTAssertEqual(Int(bitPattern: p02) - Int(bitPattern: p01), 4096);
                        XCTAssertEqual(Int(bitPattern: p03) - Int(bitPattern: p02), 4096*2);

                        page_pool_drop(p02!, 4097);
                        let p04 = page_pool_take(2, 4096);
                        let p05 = page_pool_take(5, 4096);
                        XCTAssertNotNil(p04);
                        XCTAssertNotNil(p05);
                        XCTAssertEqual(p04, p02);
                        XCTAssertEqual(Int(bitPattern: p05) - Int(bitPattern: p04), 4096);
                        XCTAssertEqual(Int(bitPattern: p03) - Int(bitPattern: p05), 4096);

                        var p06: OpaquePointer?;
                        repeat {
                                p06 = page_pool_take(3, 4096);
                                if (p06 == nil) { raise(SIGINT); }
                                XCTAssertNotNil(p06);    /* search for aligned 4 but not aligned 8 */
                        } while (Int(bitPattern: p06) % (4096*4) != 0 || Int(bitPattern: p06) % (4096*8) == 0);
                        let p07 = page_pool_take(5, 4096*8);
                        XCTAssertNotNil(p07);
                        XCTAssertEqual(Int(bitPattern: p07) % (4096*8), 0);
                        XCTAssertEqual(Int(bitPattern: p07) - Int(bitPattern: p06), 4096*4);
                        let p08 = page_pool_take(8, 4096);
                        let p09 = page_pool_take(8, 4096);
                        let p10 = page_pool_take(8, 4096);
                        XCTAssertNotNil(p08);
                        XCTAssertNotNil(p09);
                        XCTAssertNotNil(p10);
                        XCTAssertEqual(Int(bitPattern: p08) - Int(bitPattern: p06), 4096);
                        XCTAssertEqual(Int(bitPattern: p09) - Int(bitPattern: p08), 4096);
                        XCTAssertEqual(Int(bitPattern: p10) - Int(bitPattern: p09), 4096);
                }
        }
}
