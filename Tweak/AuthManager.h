#import <Foundation/Foundation.h>
@interface AuthManager : NSObject
+ (instancetype)shared;
- (void)validateKey:(NSString *)key completion:(void(^)(BOOL success, BOOL isAdmin))completion;
@end