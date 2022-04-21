# SuperValidator

SuperValidator is option-based validator for Swift.

## Installation

### Pods

```swift
pod 'SuperValidator', :git => 'https://github.com/tokopedia/ios-supervalidator.git'
```

### Swift Package Manager
https://www.swift.org/package-manager/


## Basic Usage

Return a boolean value
```swift
let validator = SuperValidator.shared
let url = "https://www.tokopedia.com/shop/test"
let options = SuperValidator.Option.URL = .init(
    protocols: ["https", "http"],
    requireProtocol: true,
    requireValidProtocol: true,
    paths: ["/shop/{shopSlug}"],
    allowQueryComponents: false,
    domainWhitelist: [#"(www\.)?(tokopedia\.com)"#],
    domainBlacklist: [],
    fqdn: .init()
)

let isURL = validator.isURL(url, options: options)
print(isURL) // true
```

Return result success or error with reasons
```swift
let validator = SuperValidator.shared
let url = "https://www.tokopedia.com/shop/test"
let result = validateURL(url, options: .init())

switch result {
case let .failure(error):
    switch error {
    case .notUrl:
        print("Please enter an url")
    case .containsWhitespace:
        print("Can't have whitespace")
    case .containsQueryComponents:
        print("Can't contains query components")
    case .invalidProtocol:
        print("Only allow HTTPS")
    case .noProtocol:
        print("Please provide protocol / scheme")
    case .invalidPath:
        print("Url path is invalid")
    case .invalidDomain:
        print("Wrong domain")
    case .blacklistedDomain:
        print("Domain not allowed")
    case .invalidFQDN:
        print("Enter a valid url")
    }

case .success: break
}
```

## Validators
- [URL](https://github.com/tokopedia/ios-supervalidator/blob/main/Sources/SuperValidator/Validators/URL.swift) 
- [FQDN](https://github.com/tokopedia/ios-supervalidator/blob/main/Sources/SuperValidator/Validators/FQDN.swift)
- [Email](https://github.com/tokopedia/ios-supervalidator/blob/main/Sources/SuperValidator/Validators/Email.swift)
- [Phone Number](https://github.com/tokopedia/ios-supervalidator/blob/main/Sources/SuperValidator/Validators/Phone%20Number/PhoneNumber.swift)
  
##  Help

If you want to discuss the SuperPlayer or have a question about how to use it to solve your video player problem, you can start a topic in the [issues](https://github.com/tokopedia/ios-supervalidator/issues) tab of this repo

## Future Plans
- Bind with TextField
- Bind with Rx
- More incoming validators

##  License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
