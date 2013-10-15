//
//  main.m
//  LockOnDisconnect
//
//  Created by Eddie Kelley on 10/15/13.
//  Copyright (c) 2013 Kelley Computing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/NSWorkspace.h>

@interface LockOnDisconnect : NSObject {
	BOOL isBeingAssisted;
}

@end

@implementation LockOnDisconnect

- (id) init{
	if(self = [super init]){
		isBeingAssisted = FALSE;
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:@"com.apple.remotedesktop.beingObserved" object:nil];
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:@"com.apple.remotedesktop.menuClosing" object:nil];
	}
	return self;
}

- (void) notificationReceived:(NSNotification*)notification{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
	if ([[notification name] isEqualToString:@"com.apple.remotedesktop.menuClosing"] && isBeingAssisted) {
		NSLog(@"Starting screensaver...");
		isBeingAssisted = FALSE;
		[[NSWorkspace sharedWorkspace] launchApplication:@"/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"];
	}
	else if ([[notification name] isEqualToString:@"com.apple.remotedesktop.beingObserved"] && !isBeingAssisted) {
		NSLog(@"%s set isBeingAssisted", __PRETTY_FUNCTION__);
		isBeingAssisted = TRUE;
	}
	else{
		NSLog(@"%s Error: unknown state or notification:%@ isBeingAssisted:%d", __PRETTY_FUNCTION__, notification, isBeingAssisted);
	}
}

@end


int main(int argc, const char * argv[])
{

	@autoreleasepool {
	    
	    // insert code here...
		[[LockOnDisconnect alloc] init];
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
	}
    return 0;
}
