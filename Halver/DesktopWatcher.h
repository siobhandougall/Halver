//
//  DesktopWatcher.h
//  Halver
//
//  Created by Sean Dougall on 7/31/12.
//  Copyright (c) 2012 Sean Dougall. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DesktopWatcher;

@protocol DesktopWatcherDelegate

- (void)watcher:(DesktopWatcher *)sender observedNewFileAtPath:(NSString *)path;

@end

#pragma mark -

@interface DesktopWatcher : NSObject

@property (nonatomic, weak) id <DesktopWatcherDelegate> delegate;

@end
