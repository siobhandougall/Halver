//
//  AppDelegate.m
//  Halver
//
//  Created by Sean Dougall on 7/31/12.
//  Copyright (c) 2012 Figure 53. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.resizer = [ImageResizer new];
    self.watcher = [DesktopWatcher new];
    self.watcher.delegate = self;
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusItem.menu = self.menu;
    self.statusItem.title = @"½";
    self.statusItem.highlightMode = YES;
}

#pragma mark - DesktopWatcherDelegate

- (void)watcher:(DesktopWatcher *)sender observedNewFileAtPath:(NSString *)path
{
    NSString *filename = [path lastPathComponent];
    if ( [filename rangeOfString:@"Screen Shot"].location == 0 &&   ///< If this file is a screen shot
        [[filename pathExtension] isEqualToString:@"png"] &&
        [filename rangeOfString:@"@2x"].location == NSNotFound )    ///< and not the result of a previous processing, ...
    {
        NSString *twoXFilePath = [[path stringByDeletingPathExtension] stringByAppendingString:@"@2x.jpg"];
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:twoXFilePath] )  ///< ... and there isn't another file from a previous processing (just to be sure), ...
        {
            [self.resizer resizeImageAtPath:path];              ///< ... process this screen shot.
        }
    }
}

@end
