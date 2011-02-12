//
//  AppController.m
//  video
//
//  Created by Matthew Donoughe on 2011-02-12.
//  Copyright __MyCompanyName__ 2011 . All rights reserved.
//

#import "AppController.h"
#include <vlc/vlc.h>

static unsigned char *pixels;
static NSImage *lastImage = nil;
static NSAutoreleasePool *pool = nil;

static void *lock(void *data, void **p_pixels)
{
	*p_pixels = pixels;
	return NULL;
}

static void unlock(void *data, void *id, void * const *p_pixels)
{
	if (pool == nil)
		pool = [[NSAutoreleasePool alloc] init];
	if (lastImage != nil)
		[lastImage release];
	AppController *self = (AppController *)data;
	NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(640, 480)];
	NSImageRep *irep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&pixels pixelsWide:640 pixelsHigh:480 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:640 * 4 bitsPerPixel:32];
	[image addRepresentation:irep];
	[irep release];
	
	[[self qcView] setValue:image forInputKey:@"Image"];
	lastImage = image;
}

static void display(void *data, void *id)
{
}

@implementation AppController
 
- (void) awakeFromNib
{
	if(![qcView loadCompositionFromFile:[[NSBundle mainBundle] pathForResource:@"composition" ofType:@"qtz"]]) {
		NSLog(@"Could not load composition");
	}
	lastImage = nil;
	pixels = malloc(640 * 480 * 4);
	libvlc_instance_t * inst;
	libvlc_media_player_t *mp;
	libvlc_media_t *m;
	
	/* Load the VLC engine */
	inst = libvlc_new (0, NULL);
	
	/* Create a new item */
	m = libvlc_media_new_path (inst, "file://localhost/Users/mdonoughe/Downloads/sintel-1280-surround.mp4");
	
	/* Create a media player playing environement */
	mp = libvlc_media_player_new_from_media (m);
	libvlc_media_release(m);

	libvlc_video_set_callbacks(mp, lock, unlock, display, self);
	libvlc_video_set_format(mp, "RGBA", 640, 480, 640 * 4);
	libvlc_media_player_play(mp);
	[window setStyleMask:NSBorderlessWindowMask];
	[window setFrame:[[NSScreen mainScreen] frame] display:YES];
	[window setLevel:CGShieldingWindowLevel()];
}

- (void)windowWillClose:(NSNotification *)notification 
{
	[NSApp terminate:self];
}

- (QCView*)qcView
{
	return qcView;
}

@end
