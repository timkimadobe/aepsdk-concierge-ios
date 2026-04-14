/*
 Copyright 2026 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import UIKit
import XCTest
@testable import AEPBrandConcierge

final class MarkdownTextCoordinatorTests: XCTestCase {

    private var textView: UITextView!

    override func setUp() {
        super.setUp()
        textView = UITextView()
    }

    override func tearDown() {
        super.tearDown()
        textView = nil
    }

    // MARK: - Helpers

    private func makeCoordinator(onOpenLink: @escaping (URL) -> Void) -> MarkdownTextCoordinator {
        let markdownText = MarkdownText(
            attributed: NSAttributedString(string: "test"),
            onOpenLink: onOpenLink
        )
        return MarkdownTextCoordinator(parent: markdownText)
    }

    private func interact(coordinator: MarkdownTextCoordinator, url: URL) -> Bool {
        coordinator.textView(
            textView,
            shouldInteractWith: url,
            in: NSRange(location: 0, length: 1),
            interaction: .invokeDefaultAction
        )
    }

    // MARK: - All links route through onOpenLink

    func testShouldInteractWith_httpLink_callsOnOpenLink() {
        let url = URL(string: "http://www.example.com")!
        var receivedURL: URL?

        let coordinator = makeCoordinator(onOpenLink: { receivedURL = $0 })
        _ = interact(coordinator: coordinator, url: url)

        XCTAssertEqual(receivedURL, url)
    }

    func testShouldInteractWith_httpsLink_callsOnOpenLink() {
        let url = URL(string: "https://www.example.com")!
        var receivedURL: URL?

        let coordinator = makeCoordinator(onOpenLink: { receivedURL = $0 })
        _ = interact(coordinator: coordinator, url: url)

        XCTAssertEqual(receivedURL, url)
    }

    func testShouldInteractWith_telLink_callsOnOpenLink() {
        let url = URL(string: "tel:+1234567890")!
        var receivedURL: URL?

        let coordinator = makeCoordinator(onOpenLink: { receivedURL = $0 })
        _ = interact(coordinator: coordinator, url: url)

        XCTAssertEqual(receivedURL, url)
    }

    func testShouldInteractWith_mailtoLink_callsOnOpenLink() {
        let url = URL(string: "mailto:user@example.com")!
        var receivedURL: URL?

        let coordinator = makeCoordinator(onOpenLink: { receivedURL = $0 })
        _ = interact(coordinator: coordinator, url: url)

        XCTAssertEqual(receivedURL, url)
    }

    func testShouldInteractWith_smsLink_callsOnOpenLink() {
        let url = URL(string: "sms:+1234567890")!
        var receivedURL: URL?

        let coordinator = makeCoordinator(onOpenLink: { receivedURL = $0 })
        _ = interact(coordinator: coordinator, url: url)

        XCTAssertEqual(receivedURL, url)
    }

    func testShouldInteractWith_customSchemeLink_callsOnOpenLink() {
        let url = URL(string: "myapp://example.com/path")!
        var receivedURL: URL?

        let coordinator = makeCoordinator(onOpenLink: { receivedURL = $0 })
        _ = interact(coordinator: coordinator, url: url)

        XCTAssertEqual(receivedURL, url)
    }

    // MARK: - Always returns false to suppress UITextView default handling

    func testShouldInteractWith_httpsLink_returnsFalse() {
        let url = URL(string: "https://www.example.com")!
        let coordinator = makeCoordinator(onOpenLink: { _ in })

        let result = interact(coordinator: coordinator, url: url)

        XCTAssertFalse(result)
    }

    func testShouldInteractWith_telLink_returnsFalse() {
        let url = URL(string: "tel:+1234567890")!
        let coordinator = makeCoordinator(onOpenLink: { _ in })

        let result = interact(coordinator: coordinator, url: url)

        XCTAssertFalse(result)
    }
}
