//
//  MainNSViewController.swift
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
import AppKit

class MainNSViewController: NSViewController {
	override func loadView() {
		// create a hosting controller with your SwiftUI view
		let hostingController = NSHostingController(rootView: MainUI())
		self.view = hostingController.view
		self.view.frame = CGRect(origin: .zero, size: .init(width: 500, height: 600))
	}
	override func mouseDragged(with event: NSEvent) {
		guard let appDelegate: AppDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
		var size = appDelegate.popover?.contentSize ?? CGSize.zero
		size.width += event.deltaX
		size.height += event.deltaY
		// Update popover size depend on your reference
		appDelegate.popover?.contentSize = size
	}
}

