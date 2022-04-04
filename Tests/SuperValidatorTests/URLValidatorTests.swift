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
        let url = "https://www.example.com/path/test"
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
}
