//
//  main.m
//  LockOnDisconnect
//
//  Created by Eddie Kelley on 10/15/13.
//  Copyright (c) 2013 Kelley Computing. All rights reserved.
//
//	This file is part of LockOnDisconnect.
//
//    LockOnDisconnect is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Foobar is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with LockOnDisconnect.  If not, see <http://www.gnu.org/licenses/>.

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
