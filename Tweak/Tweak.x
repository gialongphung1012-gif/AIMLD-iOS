#import <UIKit/UIKit.h>
#import <SwiftUI/SwiftUI.h>
#import "AuthManager.h"

// Gọi class từ Swift sang Obj-C
@interface MenuController : NSObject
+ (UIViewController *)getView;
@end

static UIWindow *overlayWindow;

%hook UnityFramework
- (void)applicationDidBecomeActive:(id)arg1 {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!overlayWindow) {
            overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            overlayWindow.windowLevel = UIWindowLevelAlert + 1;
            overlayWindow.rootViewController = [MenuController getView];
            overlayWindow.backgroundColor = [UIColor clearColor];
            overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
            [overlayWindow makeKeyAndVisible];
        }
    });
}
%end