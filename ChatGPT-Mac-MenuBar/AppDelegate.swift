//
//  AppDelegate.swift
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


import Cocoa
import SwiftUI
import HotKey

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
	
	private var statusItem: NSStatusItem!
	
	private var popover: NSPopover!
	private var menu: NSMenu!
	
	let hotKey = HotKey(key: .c, modifiers: [.shift, .command])  // Global hotkey
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		
		if let button = statusItem.button {
			let icon = NSImage(named: "menu_bar_icon")
			icon?.isTemplate = true
			button.image = icon
			button.action = #selector(self.handleMenuIconAction(sender:))
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
		}
		
		constructPopover()
		constructMenu()
		
		hotKey.keyUpHandler = { // Global hotkey handler
			self.togglePopover()
		}
	}
	
	@objc func handleMenuIconAction(sender: NSStatusBarButton) {
		let event = NSApp.currentEvent!
		if event.type == NSEvent.EventType.rightMouseUp {
			showMenu()
		} else {
			removeMenu()
			togglePopover()
		}
	}
	
	func menuDidClose(_ menu: NSMenu) {
		removeMenu()
	}
	
	@objc func didTapOne() {
		WebViewHelper.clean()
	}
	
	func constructMenu() {
		menu = NSMenu()
		let one = NSMenuItem(title: "Clean Cookies", action: #selector(didTapOne) , keyEquivalent: "1")
		menu.addItem(one)
		menu.addItem(NSMenuItem.separator())
		menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
		menu.delegate = self
	}
	
	func constructPopover() {
		popover = NSPopover()
		popover.contentViewController = MainNSViewController()
		popover.behavior = NSPopover.Behavior.transient;
	}
	
	func showMenu() {
		statusItem.menu = menu
		statusItem.popUpMenu(menu)
	}
	
	func removeMenu() {
		statusItem.menu = nil
	}
	
	func togglePopover() {
		if popover.isShown {
			popover.performClose(nil)
		} else {
			if let button = statusItem.button {
				NSApplication.shared.activate(ignoringOtherApps: true)
				popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
				popover.contentViewController?.view.window?.makeKey()
			}
		}
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}


}
