//
//  SocialMediaURLValidatorTests.swift
//  
//
//  Created by alvin.pratama on 22/03/22.
//

import XCTest

@testable import SuperValidator

internal final class SocialMediaURLValidatorTests: XCTestCase {
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
    
    // MARK: - Instagram + Error Reasons
    
    internal func testValidInstagramURL_ErrorReason() {
        let url = "https://instagram.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .instagram)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testInstagramURLWithInvalidProtocol_ErrorReason() {
        let url = "ftp://www.instagram.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .instagram)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidProtocol)
        }
    }

    internal func testInstagramURLWithInvalidHostname_ErrorReason() {
        let url = "www.tiktok.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .instagram)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidHost)
        }
    }

    internal func testInstagramURLWithoutPath_ErrorReason() {
        let url = "www.instagram.com/"
        let result = self.validator.validateURL(url, socialMedia: .instagram)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidPath)
        }
    }

    internal func testInstagramURLWithInvalidPath_ErrorReason() {
        let url = "www.instagram.com/user/a"
        let result = self.validator.validateURL(url, socialMedia: .instagram)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidPath)
        }
    }

    internal func testInstagramURLWithWhiteSpace_ErrorReason() {
        let url = "www. instagram.com/myuser/a"
        let result = self.validator.validateURL(url, socialMedia: .instagram)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.containsWhitespace)
        }
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
        let url = "invalid.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertFalse(isURL)
    }
    
    internal func testTiktokURLWithInvalidPath() {
        let url = "https://vt.tiktok.com/myuser/a"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertFalse(isURL)
    }
    
    internal func testTiktokURLWithWhiteSpace() {
        let url = "vt.tiktok.com/myus er"
        let isURL = self.validator.isURL(url, socialMedia: .tiktok)
        XCTAssertFalse(isURL)
    }
    
    // MARK: - Tiktok + ErrorReasons
    
    internal func testValidTiktokURL_ErrorReason() {
        let url = "https://vt.tiktok.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .tiktok)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }

    internal func testTiktokURLWithWWW_ErrorReason() {
        let url = "https://www.vt.tiktok.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .tiktok)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidHost)
        }
    }

    internal func testTiktokURLWithInvalidProtocol_ErrorReason() {
        let url = "ftp://vt.tiktok.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .tiktok)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidProtocol)
        }
    }

    internal func testTiktokURLWithInvalidHostname_ErrorReason() {
        let url = "invalid.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .tiktok)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidHost)
        }
    }

    internal func testTiktokURLWithInvalidPath_ErrorReason() {
        let url = "https://vt.tiktok.com/myuser/a"
        let result = self.validator.validateURL(url, socialMedia: .tiktok)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidPath)
        }
    }

    internal func testTiktokURLWithWhiteSpace_ErrorReason() {
        let url = "vt.tiktok.com/myus er"
        let result = self.validator.validateURL(url, socialMedia: .tiktok)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.containsWhitespace)
        }
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
    
    internal func testYoutubeURLWithCPath() {
        let url = "www.youtube.com/c/mychannel"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertTrue(isURL)
    }
    
    internal func testYoutubeURLWithIDPath() {
        let url = "www.youtube.com/id/123"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertTrue(isURL)
    }
    
    internal func testYoutubeURLWithChannelPath() {
        let url = "www.youtube.com/channel/mychannel"
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
        let url = "www.youtube.com/profile/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertFalse(isURL)
    }
    
    internal func testYoutubeURLWithInvalidPath2() {
        let url = "www.youtube.com/myuser"
        let isURL = self.validator.isURL(url, socialMedia: .youtube)
        XCTAssertFalse(isURL)
    }
    
    internal func testYoutubeURLWithWhiteSpace() {
        let url = "www.youtube.com/myus er"
        let isURL = self.validator.isURL(url, socialMedia: .twitter)
        XCTAssertFalse(isURL)
    }
    
    // MARK: - Youtube + Error Reasons
    
    internal func testValidYoutubeURL_ErrorReason() {
        let url = "https://youtube.com/user/myuser"
        let result = self.validator.validateURL(url, socialMedia: .youtube)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testYoutubeURLWithInvalidProtocol_ErrorReason() {
        let url = "ftp://www.youtube.com/user/myuser"
        let result = self.validator.validateURL(url, socialMedia: .youtube)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidProtocol)
        }
    }
    
    internal func testYoutubeURLWithInvalidHostname_ErrorReason() {
        let url = "www.youtuber.com/user/myuser"
        let result = self.validator.validateURL(url, socialMedia: .youtube)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidHost)
        }
    }
    
    internal func testYoutubeURLInvalidPath_ErrorReason() {
        let url = "www.youtube.com/profile/myuser"
        let result = self.validator.validateURL(url, socialMedia: .youtube)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidPath)
        }
    }
    
    internal func testYoutubeURLWithInvalidPath2_ErrorReason() {
        let url = "www.youtube.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .youtube)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidPath)
        }
    }
    
    internal func testYoutubeURLWithWhiteSpace_ErrorReason() {
        let url = "www.youtube.com/myus er"
        let result = self.validator.validateURL(url, socialMedia: .youtube)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.containsWhitespace)
        }
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
    
    internal func testTwitterURLWithoutPath() {
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
    
    // MARK: - Twitter + Error Reasons
    
    internal func testValidTwitterURL_ErrorReason() {
        let url = "https://twitter.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .twitter)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testTwitterURLWithInvalidProtocol_ErrorReason() {
        let url = "ftp://www.twitter.com/myuser"
        let result = self.validator.validateURL(url, socialMedia: .twitter)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidProtocol)
        }
    }
    
    internal func testTwitterURLWithInvalidHostname_ErrorReason() {
        let url = "www.twitter.co.id/myuser"
        let result = self.validator.validateURL(url, socialMedia: .twitter)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidHost)
        }
    }
    
    internal func testTwitterURLWithoutPath_ErrorReason() {
        let url = "https://twitter.com/"
        let result = self.validator.validateURL(url, socialMedia: .twitter)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidPath)
        }
    }
    
    internal func testTwitterURLWithInvalidPath_ErrorReason() {
        let url = "www.twitter.com/user/myuser"
        let result = self.validator.validateURL(url, socialMedia: .twitter)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidPath)
        }
    }
    
    internal func testTwitterURLWithWhiteSpace_ErrorReason() {
        let url = "www.twitter.c om/myuser"
        let result = self.validator.validateURL(url, socialMedia: .twitter)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.containsWhitespace)
        }
    }
}
