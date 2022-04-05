//
//  FQDNValidatorTests.swift
//  
//
//  Created by alvin.pratama on 31/03/22.
//

import XCTest

@testable import SuperValidator

internal final class FQDNValidatorTests: XCTestCase {
    private let validator = SuperValidator.shared
    
    internal func testValidFQDN() {
        let domain = "www.tokopedia.com"
        let isFQDN = validator.isFQDN(domain)
        XCTAssertTrue(isFQDN)
    }
    
    internal func testFQDNWithInvalidTLD() {
        let domain = "www.tokopedia.c"
        let isFQDN = validator.isFQDN(domain)
        XCTAssertFalse(isFQDN)
    }
    
    internal func testFQDNWithHypen() {
        let domain = "www.tokopedia-.com"
        let isFQDN = validator.isFQDN(domain)
        XCTAssertFalse(isFQDN)
    }
    
    internal func testFQDNWithUnderscore() {
        let domain = "www.tokopedia_.com"
        let isFQDN = validator.isFQDN(domain)
        XCTAssertFalse(isFQDN)
    }
    
    internal func testFQDNWithUnderscoreAllowed() {
        let domain = "www.tokopedia_.com"
        let isFQDN = validator.isFQDN(domain, options: .init(allowUnderscores: true))
        XCTAssertTrue(isFQDN)
    }
    
    internal func testFQDNWithTrailingDot() {
        let domain = "www.tokopedia.com."
        let isFQDN = validator.isFQDN(domain)
        XCTAssertFalse(isFQDN)
    }
    
    internal func testFQDNWithTrailingDotAllowed() {
        let domain = "www.tokopedia.com."
        let isFQDN = validator.isFQDN(domain, options: .init(allowTrailingDot: true))
        XCTAssertTrue(isFQDN)
    }
    
    internal func testFQDNAllowWildcard() {
        let domain = "*.tokopedia.com"
        let isFQDN = validator.isFQDN(domain, options: .init(allowWildcard: true))
        XCTAssertTrue(isFQDN)
    }
    
    internal func testFQDNDiallowWildcard() {
        let domain = "*.tokopedia.com"
        let isFQDN = validator.isFQDN(domain)
        XCTAssertFalse(isFQDN)
    }
}
