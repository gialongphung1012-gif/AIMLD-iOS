#import "AuthManager.h"
@implementation AuthManager
+ (instancetype)shared {
    static AuthManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ shared = [[AuthManager alloc] init]; });
    return shared;
}
- (void)validateKey:(NSString *)key completion:(void(^)(BOOL, BOOL))completion {
    // ĐỔI IP NÀY THÀNH IP MÁY TÍNH CỦA BẠN (Xem hướng dẫn bên dưới)
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.207:3000/api/validate"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *body = @{@"key": key};
    [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:body options:0 error:nil]];
    
    [[NSURLSession.sharedSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([json[@"status"] isEqualToString:@"success"]) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AIMLD_Activated"];
                    if ([json[@"isAdmin"] boolValue]) {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AIMLD_Admin"];
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    completion(YES, [json[@"isAdmin"] boolValue]);
                    return;
                }
            }
            completion(NO, NO);
        });
    }] resume];
}
@end