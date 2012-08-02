//
//  DesktopWatcher.m
//  Halver
//
//  Created by Sean Dougall on 7/31/12.
//  Copyright (c) 2012 Sean Dougall. All rights reserved.
//

#import "DesktopWatcher.h"
#import <CoreServices/CoreServices.h>

@interface DesktopWatcher ()

@property (assign) FSEventStreamRef stream;
- (void)startWatching;
- (void)stopWatching;
void streamCallback( ConstFSEventStreamRef streamRef,
                     void *clientCallBackInfo,
                     size_t numEvents,
                     void *eventPaths,
                     const FSEventStreamEventFlags eventFlags[],
                     const FSEventStreamEventId eventIds[] );
@end

#pragma mark -

@implementation DesktopWatcher

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.delegate = nil;
    }
    return self;
}

- (void)dealloc
{
    [self stopWatching];
}

- (void)setDelegate:(id<DesktopWatcherDelegate>)delegate
{
    _delegate = delegate;
    if ( _delegate )
        [self startWatching];
}

- (void)startWatching
{
    [self stopWatching];
    CFArrayRef paths = (__bridge CFArrayRef)@[ [@"~/Desktop/" stringByExpandingTildeInPath] ];
    CFAbsoluteTime latency = 1.0;
    FSEventStreamContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
    self.stream = FSEventStreamCreate( NULL,
                                       &streamCallback,
                                       &context,
                                       paths,
                                       kFSEventStreamEventIdSinceNow,
                                       latency,
                                       kFSEventStreamCreateFlagIgnoreSelf | kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagUseCFTypes );
    FSEventStreamScheduleWithRunLoop( self.stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode );
    FSEventStreamStart( self.stream );
}

- (void)stopWatching
{
    if ( self.stream )
    {
        FSEventStreamStop( self.stream );
        FSEventStreamInvalidate( self.stream );
        FSEventStreamRelease( self.stream );
        self.stream = nil;
    }
}

void streamCallback( ConstFSEventStreamRef streamRef,
                     void *clientCallBackInfo,
                     size_t numEvents,
                     void *eventPaths,
                     const FSEventStreamEventFlags eventFlags[],
                     const FSEventStreamEventId eventIds[] )
{
    int i = 0;
    CFArrayRef paths = (CFArrayRef)eventPaths;
    DesktopWatcher *watcher = (__bridge DesktopWatcher *)clientCallBackInfo;
    if ( !watcher )
        NSLog( @"Warning: No watcher in place." );
    
    for ( NSString *path in (__bridge NSArray *)paths )
    {
        if ( eventFlags[i] & kFSEventStreamEventFlagItemRenamed )
            [[watcher delegate] watcher:watcher observedNewFileAtPath:path];
        i++;
    }
}

@end
