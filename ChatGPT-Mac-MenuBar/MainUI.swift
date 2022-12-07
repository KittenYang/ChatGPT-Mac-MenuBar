//
//  MainUI.swift
//  ChatGPT-Mac-MenuBar
//
//  Created by Qitao Yang on 12/5/22.
//
//  Copyright (c) 2022 KittenYang <kittenyang@icloud.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import SwiftUI
import WebKit

struct MainUI: View {
	@State private var action = WebViewAction.idle
	@State private var state = WebViewState.empty
	@State private var address = "https://chat.openai.com/chat"
	
	var webConfig: WebViewConfig {
		var defaultC = WebViewConfig.default
		defaultC.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
//		defaultC.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36"
		return defaultC
	}
	
	var body: some View {
		VStack(spacing:0.0) {
			navigationToolbar
			errorView
			WebView(config: webConfig,
					action: $action,
					state: $state,
					restrictedPages: nil)
			Image(systemName: "line.3.horizontal")
		}
		.onAppear {
			if let url = URL(string: address) {
				action = .load(URLRequest(url: url))
			}
		}
		.background(Color.init(nsColor: .windowBackgroundColor))
	}
	
	private var navigationToolbar: some View {
		HStack(spacing: 10) {
			if state.isLoading {
				if #available(iOS 14, macOS 10.15, *) {
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
				} else {
					Text("Loading")
				}
			}
			Spacer()
			Button(action: {
				action = .reload
			}) {
				Image(systemName: "arrow.counterclockwise")
					.imageScale(.large)
					.foregroundColor(.init(nsColor: .labelColor))
			}
			if state.canGoBack {
				Button(action: {
					action = .goBack
				}) {
					Image(systemName: "chevron.left")
						.imageScale(.large)
						.foregroundColor(.init(nsColor: .labelColor))
				}
			}
			if state.canGoForward {
				Button(action: {
					action = .goForward
				}) {
				Image(systemName: "chevron.right")
						.imageScale(.large)
						.foregroundColor(.init(nsColor: .labelColor))
					
				}
			}
		}.background(Color.init(nsColor: .windowBackgroundColor))
			.padding([.top,.leading,.trailing,.bottom],15.0)
	}
	
	private var errorView: some View {
		Group {
			if let error = state.error {
				Text(error.localizedDescription)
					.foregroundColor(.red)
			}
		}
	}
}

struct WebViewHelper {
	static func clean() {
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		print("[WebCacheCleaner] All cookies deleted")
		
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			records.forEach { record in
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
				print("[WebCacheCleaner] Record \(record) deleted")
			}
		}
	}
}

struct MainUI_Previews: PreviewProvider {
    static var previews: some View {
        MainUI()
    }
}
