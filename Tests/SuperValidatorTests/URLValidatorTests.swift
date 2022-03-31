//
//  URLValidatorTests.swift
//  
//
//  Created by alvin.pratama on 22/03/22.
//

import XCTest

@testable import SuperValidator

internal final class URLValidatorTests: XCTestCase {
    private let validator = SuperValidator.shared
    
    // MARK: - Default Options
    
    internal func testValidURL_UseDefaultOptions() {
        let url = "https://www.example.com/path/test?myID=123&myName=test#Test"
        let isURL = self.validator.isURL(url)
        XCTAssertTrue(isURL)
    }
    
    internal func testValidURLWithFTPProtocol_UseDefaultOptions() {
        let url = "ftp://www.example.com/path/test"
        let isURL = self.validator.isURL(url)
        XCTAssertTrue(isURL)
    }
    
    internal func testValidURLWithoutProtocol_UseDefaultOptions() {
        let url = "www.example.com/path/test"
        let isURL = self.validator.isURL(url)
        XCTAssertTrue(isURL)
    }
    
    internal func testValidShortURL_UseDefaultOptions() {
        let url = "example.com"
        let isURL = self.validator.isURL(url)
        XCTAssertTrue(isURL)
    }
    
    internal func testInvalidShortURL_UseDefaultOptions() {
        let url = "example"
        let isURL = self.validator.isURL(url)
        XCTAssertFalse(isURL)
    }
    
    internal func testURLWithWhiteSpace_UseDefaultOptions() {
        let url = "www.example.com/use r/test"
        let isURL = self.validator.isURL(url)
        XCTAssertFalse(isURL)
    }
    
    internal func testURLWithInvalidProtocol_UseDefaultOptions() {
        let url = "asd://www.example.com/path/test"
        let isURL = self.validator.isURL(url)
        XCTAssertFalse(isURL)
    }
    
    // MARK: - Custom Options
    
    private var customOptions: SuperValidator.Option.URL = .init(
        protocols: ["https", "http"],
        requireProtocol: true,
        requireValidProtocol: true,
        paths: ["/shop/{shopSlug}"],
        allowQueryComponents: false,
        hostWhitelist: [#"(www\.)?(tokopedia\.com)"#],
        hostBlacklist: [],
        fdqn: .init()
    )
    
    internal func testValidURL_UseCustomOptions() {
        let url = "https://www.tokopedia.com/shop/test"
        let isURL = self.validator.isURL(url, options: customOptions)
        XCTAssertTrue(isURL)
    }
    
    internal func testValidURLWithoutWWW_UseCustomOptions() {
        let url = "https://tokopedia.com/shop/test"
        let isURL = self.validator.isURL(url, options: customOptions)
        XCTAssertTrue(isURL)
    }
    
    internal func testURLWithInvalidProtocol_UseCustomOptions() {
        let url = "ftp://tokopedia.com/shop/test"
        let isURL = self.validator.isURL(url, options: customOptions)
        XCTAssertFalse(isURL)
    }
    
    internal func testURLWithoutProtocol_UseCustomOptions() {
        let url = "www.tokopedia.com/shop/test"
        let isURL = self.validator.isURL(url, options: customOptions)
        XCTAssertFalse(isURL)
    }
    
    internal func testURLWithInvalidHostname_UseCustomOptions() {
        let url = "https://www.example.com/shop/test"
        let isURL = self.validator.isURL(url, options: customOptions)
        XCTAssertFalse(isURL)
    }
    
    internal func testURLWithInvalidPath_UseCustomOptions() {
        let url = "https://www.tokopedia.com/product/test"
        let isURL = self.validator.isURL(url, options: customOptions)
        XCTAssertFalse(isURL)
    }
    
    internal func testURLWithBlacklistedHostname_UseCustomOptions() {
        let blacklistedOptions: SuperValidator.Option.URL = .init(
            protocols: ["https", "http"],
            requireProtocol: false,
            requireValidProtocol: true,
            paths: [],
            allowQueryComponents: false,
            hostWhitelist: [],
            hostBlacklist: [#"(www\.)?(blacklisted\.com)"#],
            fdqn: .init()
        )
        
        let url = "https://www.tokopedia.com/product/test"
        let isURL = self.validator.isURL(url, options: blacklistedOptions)
        XCTAssertTrue(isURL)
        
        let blacklistedURL = "https://www.blacklisted.com/shop/test"
        let isBlacklistedURL = self.validator.isURL(blacklistedURL, options: blacklistedOptions)
        XCTAssertFalse(isBlacklistedURL)
    }
    
    // MARK: - Error Reasons
    
    internal func testValidURL_ErrorReason() {
        let url = "https://www.tokopedia.com/shop/test"
        let result = self.validator.validateURL(url, options: customOptions)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testNotURL_ErrorReason() {
        let url = "asd."
        let result = self.validator.validateURL(url, options: customOptions)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.notUrl)
        }
    }
    
    internal func testURLWithWhitespace_ErrorReason() {
        let url = "https://www.tokopedia.com/sh op/test"
        let result = self.validator.validateURL(url, options: customOptions)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.containsWhitespace)
        }
    }

    internal func testURLWithInvalidProtocol_ErrorReason() {
        let url = "ftp://tokopedia.com/shop/test"
        let result = self.validator.validateURL(url, options: customOptions)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidProtocol)
        }
    }

    internal func testURLWithoutProtocol_ErrorReason() {
        let url = "www.tokopedia.com/shop/test"
        let result = self.validator.validateURL(url, options: customOptions)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.noProtocol)
        }
    }

    internal func testURLWithInvalidHostname_ErrorReason() {
        let url = "https://www.example.com/shop/test"
        let result = self.validator.validateURL(url, options: customOptions)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidHost)
        }
    }

    internal func testURLWithInvalidPath_ErrorReason() {
        let url = "https://www.tokopedia.com/product/test"
        let result = self.validator.validateURL(url, options: customOptions)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.invalidPath)
        }
    }
    
    internal func testURLWithQueryComponents_ErrorReason() {
        let url = "https://www.tokopedia.com/product/test?productID=123#Desk"
        let result = self.validator.validateURL(url, options: customOptions)
        switch result {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.containsQueryComponents)
        }
    }

    internal func testURLWithBlacklistedHostname_ErrorReason() {
        let blacklistedOptions: SuperValidator.Option.URL = .init(
            protocols: ["https", "http"],
            requireProtocol: false,
            requireValidProtocol: true,
            paths: [],
            allowQueryComponents: false,
            hostWhitelist: [],
            hostBlacklist: [#"(www\.)?(blacklisted\.com)"#],
            fdqn: .init()
        )

        let url = "https://www.tokopedia.com/product/test"
        let result = self.validator.validateURL(url, options: blacklistedOptions)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }

        let blacklistedURL = "https://www.blacklisted.com/shop/test"
        let blacklistedResult = self.validator.validateURL(blacklistedURL, options: blacklistedOptions)
        switch blacklistedResult {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.URLError.blacklistedHost)
        }
    }
}
