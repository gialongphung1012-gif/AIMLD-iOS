#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SwiftUI/SwiftUI.h>
#import "AuthManager.h"
#import <mach-o/dyld.h>
#import <libkern/OSCacheControl.h>

@interface ModMenuViewController : UIViewController
@end

static UIWindow *overlayWindow;
static UIButton *floatingBtn;

static BOOL isEspEnabled = NO;
static BOOL isAimbotEnabled = NO;
static BOOL isNoRecoilEnabled = NO;
static BOOL isCarSpeedEnabled = NO;

// Hàm lấy Base Address của game
uintptr_t getBaseAddress() {
    return _dyld_get_image_vmaddr_slide(0); 
}

// Hàm cập nhật trạng thái từ Web Server (Chạy ngầm)
void fetchSettings() {
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.207:3000/api/get_settings"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [[NSURLSession.sharedSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            isAimbotEnabled = [json[@"aimbot"] boolValue];
            isEspEnabled = [json[@"esp"] boolValue];
            isNoRecoilEnabled = [json[@"fast_fire"] boolValue]; // Tạm map fast_fire sang No Recoil
            
            // Khi có dữ liệu mới, bạn có thể gọi hàm patch memory tại đây
            // Ví dụ:
            // if (isCarSpeedEnabled) patchMemory(0x114, "00 00 80 3F"); 
        }
    }] resume];
}

%hook UnityFramework

- (void)applicationDidBecomeActive:(id)arg1 {
    %orig;
    
    // Bắt đầu luồng lấy dữ liệu từ server mỗi 1 giây
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    
    // Hiển thị Menu UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!overlayWindow) {
            overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            overlayWindow.windowLevel = UIWindowLevelAlert + 1;
            overlayWindow.backgroundColor = [UIColor clearColor];
            overlayWindow.rootViewController = [[ModMenuViewController alloc] init];
            [overlayWindow makeKeyAndVisible];
            
            floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            floatingBtn.frame = CGRectMake(20, 100, 50, 50);
            [floatingBtn setTitle:@"A" forState:UIControlStateNormal];
            floatingBtn.backgroundColor = [UIColor purpleColor];
            floatingBtn.layer.cornerRadius = 25;
            [floatingBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [floatingBtn addGestureRecognizer:pan];
            
            [overlayWindow addSubview:floatingBtn];
        }
    });
}

- (void)timerTick {
    fetchSettings();
}

- (void)showMenu {
    overlayWindow.rootViewController.view.hidden = NO;
    floatingBtn.hidden = YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:overlayWindow];
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:overlayWindow];
}

%end