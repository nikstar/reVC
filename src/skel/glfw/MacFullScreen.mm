#import <AppKit/AppKit.h>
#define GLFW_INCLUDE_NONE
#define GLFW_EXPOSE_NATIVE_COCOA
#include <GLFW/glfw3.h>
#include <GLFW/glfw3native.h>
#include "MacFullScreen.h"

void
MacSetFullScreen(GLFWwindow *window, bool fullScreen)
{
	NSWindow *nativeWindow = glfwGetCocoaWindow(window);
	if (!!(nativeWindow.styleMask & NSWindowStyleMaskFullScreen) != fullScreen)
		[nativeWindow toggleFullScreen:nil];
}

void
MacObserveFullScreen(GLFWwindow *window, void (*changed)(bool))
{
	static id didEnter, didExit;
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	if (didEnter) {
		[center removeObserver:didEnter];
		[center removeObserver:didExit];
		didEnter = didExit = nil;
	}
	if (!window)
		return;

	NSWindow *nativeWindow = glfwGetCocoaWindow(window);
	didEnter = [center addObserverForName:NSWindowDidEnterFullScreenNotification
		object:nativeWindow queue:nil usingBlock:^(NSNotification *) { changed(true); }];
	didExit = [center addObserverForName:NSWindowDidExitFullScreenNotification
		object:nativeWindow queue:nil usingBlock:^(NSNotification *) { changed(false); }];
}
