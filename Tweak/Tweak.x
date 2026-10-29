#import <UIKit/UIKit.h>
#import "AuthManager.h"

// Khai báo class UI bằng Obj-C
@interface ModMenuViewController : UIViewController
@end

static UIWindow *overlayWindow;

%hook UnityFramework
- (void)applicationDidBecomeActive:(id)arg1 {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!overlayWindow) {
            overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            overlayWindow.windowLevel = UIWindowLevelAlert + 1;
            overlayWindow.backgroundColor = [UIColor clearColor];
            
            // Gọi trực tiếp class Obj-C
            overlayWindow.rootViewController = [[ModMenuViewController alloc] init];
            overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
            [overlayWindow makeKeyAndVisible];
        }
    });
}
%end