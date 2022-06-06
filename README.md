![CoverImage](https://user-images.githubusercontent.com/85599884/164430652-afc86a0e-bcf1-4d69-bc6f-4359cc9c9725.png)

# SuperValidator

SuperValidator is option-based validator for Swift.

## Installation

### Pods
To install via Pods just add this to your podfile.
```swift
pod 'SuperValidator', :git => 'https://github.com/tokopedia/ios-supervalidator.git'
```

### Swift Package Manager
To install via [SPM](https://www.swift.org/package-manager/) just press '+' sign in Xcode list of packages and paste repo address: '[https://github.com/tokopedia/ios-supervalidator](https://github.com/tokopedia/ios-supervalidator)' into the search field and click `Add Package`:

![SPM installation](https://user-images.githubusercontent.com/85599884/164421707-8adb8ebb-455a-4494-ac39-682e58fd74c0.png)



## Basic Usage

Return a boolean value

```swift
let validator = SuperValidator.shared
let url = "https://www.tokopedia.com/shop/test"
let isURL = validateURL(url, options: .init())
print(isURL) // true
```

With custom options. For detail explanation [here](https://github.com/tokopedia/ios-supervalidator/blob/add-readme/Sources/SuperValidator/Validators/URL.swift).

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
- [Social Media URL](https://github.com/tokopedia/ios-supervalidator/blob/main/Sources/SuperValidator/Validators/SocialMediaURL.swift) 
- [FQDN](https://github.com/tokopedia/ios-supervalidator/blob/main/Sources/SuperValidator/Validators/FQDN.swift)
- [Email](https://github.com/tokopedia/ios-supervalidator/blob/main/Sources/SuperValidator/Validators/Email.swift)
- [Phone Number](https://github.com/tokopedia/ios-supervalidator/blob/main/Sources/SuperValidator/Validators/Phone%20Number/PhoneNumber.swift)
  
##  Help

If you want to discuss the SuperValidator or have a question about how to use it to solve your video player problem, you can start a topic in the [issues](https://github.com/tokopedia/ios-supervalidator/issues) tab of this repo

## Future Plans

- Bind with TextField
- Bind with Rx
- More incoming validators

## Credits

SuperValidator is written and maintaned by Tokopedia iOS Superman Squad. [Alvin Matthew Pratama](https://www.linkedin.com/in/alvin-matthew-pratama-8778011b0/) actively works to maintain SuperValidator. Thanks to [Christopher Teddy Mienarto](https://www.linkedin.com/in/christophermienarto/) for helps creating email, phone number and more  incoming validators.

##  License

This library is released under the Apache license. See [LICENSE](https://github.com/tokopedia/ios-supervalidator/blob/add-readme/LICENSE.md) for details.
