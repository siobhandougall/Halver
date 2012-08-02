//
//  AppDelegate.h
//  Halver
//
//  Created by Sean Dougall on 7/31/12.
//  Copyright (c) 2012 Sean Dougall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DesktopWatcher.h"
#import "ImageResizer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, DesktopWatcherDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *menu;
@property (strong) NSStatusItem *statusItem;
@property (strong) DesktopWatcher *watcher;
@property (strong) ImageResizer *resizer;

@end
