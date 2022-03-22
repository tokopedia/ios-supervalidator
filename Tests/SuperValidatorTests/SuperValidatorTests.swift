//
//  SuperValidatorTests.swift
//  
//
//  Created by alvin.pratama on 22/03/22.
//

import XCTest

@testable import SuperValidator

internal final class SuperValidatorTests: XCTestCase {
    private let validator = SuperValidator.shared
    
    // MARK: - Instagram
    
    internal func testValidInstagramURL() {
        let url = "https://instagram.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .instagram)
        XCTAssertTrue(isURL)
    }
    
    internal func testInstagramURLWithoutProtocol() {
        let url = "instagram.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .instagram)
        XCTAssertTrue(isURL)
    }
    
    internal func testInstagramURLWithWWW() {
        let url = "https://www.instagram.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .instagram)
        XCTAssertTrue(isURL)
    }
    
    internal func testInstagramURLWithInvalidProtocol() {
        let url = "ftp://www.instagram.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .instagram)
        XCTAssertFalse(isURL)
    }
    
    internal func testInstagramURLWithInvalidHostname() {
        let url = "www.tiktok.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .instagram)
        XCTAssertFalse(isURL)
    }
    
    internal func testInstagramURLWithoutPath() {
        let url = "www.instagram.com/"
        let isURL = self.validator.isURL(url, socialMedia: .instagram)
        XCTAssertFalse(isURL)
    }
    
    internal func testInstagramURLWithInvalidPath() {
        let url = "www.instagram.com/user/a"
        let isURL = self.validator.isURL(url, socialMedia: .instagram)
        XCTAssertFalse(isURL)
    }
    
    internal func testInstagramURLWithWhiteSpace() {
        let url = "www. instagram.com/myuser/a"
        let isURL = self.validator.isURL(url, socialMedia: .instagram)
        XCTAssertFalse(isURL)
    }
    
    // MARK: - Tiktok
    
    internal func testValidTiktokURL() {
        let url = "https://vt.tiktok.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertTrue(isURL)
    }
    
    internal func testTiktokURLWithoutProtocol() {
        let url = "vt.tiktok.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertTrue(isURL)
    }
    
    internal func testTiktokURLWithWWW() {
        let url = "https://www.vt.tiktok.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertFalse(isURL)
    }
    
    internal func testTiktokURLWithInvalidProtocol() {
        let url = "ftp://vt.tiktok.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertFalse(isURL)
    }
    
    internal func testTiktokURLWithInvalidHostname() {
        let url = "tiktok.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertFalse(isURL)
    }
    
    internal func testTiktokURLWithInvalidPath() {
        let url = "https://vt.tiktok.com/myuser/a"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertFalse(isURL)
    }
    
    internal func testTiktokURLWithWhiteSpace() {
        let url = "vt. tiktok.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertFalse(isURL)
    }
    
    // MARK: - Youtube
    
    internal func testValidYoutubeURL() {
        let url = "https://youtube.com/user/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertTrue(isURL)
    }
    
    internal func testYoutubeURLWithoutProtocol() {
        let url = "youtube.com/user/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertTrue(isURL)
    }
    
    internal func testYoutubeURLWithWWW() {
        let url = "www.youtube.com/user/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertTrue(isURL)
    }
    
    internal func testYoutubeURLWithInvalidProtocol() {
        let url = "ftp://www.youtube.com/user/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertFalse(isURL)
    }
    
    internal func testYoutubeURLWithInvalidHostname() {
        let url = "www.youtuber.com/user/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertFalse(isURL)
    }
    
    internal func testYoutubeURLInvalidPath() {
        let url = "www.youtuber.com/profile/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertFalse(isURL)
    }
    
    internal func testYoutubeURLWithInvalidPath2() {
        let url = "www.youtuber.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertFalse(isURL)
    }
    
    internal func testYoutubeURLWithWhiteSpace() {
        let url = "www.youtuber.com/myus er"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertFalse(isURL)
    }
    
    // MARK: - Twitter
    
    internal func testValidTwitterURL() {
        let url = "https://twitter.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertTrue(isURL)
    }
    
    internal func testTwitterURLWithoutProtocol() {
        let url = "twitter.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertTrue(isURL)
    }
    
    internal func testTwitterURLWithWWW() {
        let url = "www.twitter.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertTrue(isURL)
    }
    
    internal func testTwitterURLWithInvalidProtocol() {
        let url = "ftp://www.twitter.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertFalse(isURL)
    }
    
    internal func testTwitterURLWithInvalidHostname() {
        let url = "www.twitter.co.id/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertFalse(isURL)
    }
    
    internal func testITwitterURLWithoutPath() {
        let url = "https://twitter.com/"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertFalse(isURL)
    }
    
    internal func testTwitterURLWithInvalidPath() {
        let url = "www.twitter.com/user/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertFalse(isURL)
    }
    
    internal func testTwitterURLWithWhiteSpace() {
        let url = "www.twitter.c om/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertFalse(isURL)
    }
}
