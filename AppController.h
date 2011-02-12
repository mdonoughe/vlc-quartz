//
//  AppController.h
//  video
//
//  Created by Matthew Donoughe on 2011-02-12.
//  Copyright __MyCompanyName__ 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface AppController : NSObject 
{
    IBOutlet QCView* qcView;
	IBOutlet NSWindow* window;
}

- (QCView*)qcView;

@end
