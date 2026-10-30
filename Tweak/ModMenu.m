#import <UIKit/UIKit.h>
#import "AuthManager.h"

@interface ModMenuViewController : UIViewController
@end

@implementation ModMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.1 alpha:0.95];
    
    BOOL isActivated = [[NSUserDefaults standardUserDefaults] boolForKey:@"AIMLD_Activated"];
    if (!isActivated) {
        [self setupLoginUI];
    } else {
        [self setupMenuUI];
    }
}

- (void)setupLoginUI {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 50)];
    titleLabel.text = @"AIMLD";
    titleLabel.textColor = [UIColor purpleColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:40];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UITextField *keyField = [[UITextField alloc] initWithFrame:CGRectMake(40, 200, self.view.bounds.size.width - 80, 50)];
    keyField.placeholder = @"Nhập Key (AIMLD-XXXX-XXXX)";
    keyField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    keyField.textColor = [UIColor whiteColor];
    keyField.borderStyle = UITextBorderStyleRoundedRect;
    keyField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    keyField.tag = 100;
    [self.view addSubview:keyField];
    
    UIButton *activateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    activateBtn.frame = CGRectMake(40, 270, self.view.bounds.size.width - 80, 50);
    [activateBtn setTitle:@"Kích Hoạt" forState:UIControlStateNormal];
    [activateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    activateBtn.backgroundColor = [UIColor purpleColor];
    activateBtn.layer.cornerRadius = 8;
    [activateBtn addTarget:self action:@selector(activateKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activateBtn];
}

- (void)activateKey {
    UITextField *field = (UITextField *)[self.view viewWithTag:100];
    NSString *key = field.text;
    
    [[AuthManager shared] validateKey:key completion:^(BOOL success, BOOL isAdmin) {
        if (success) {
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self setupMenuUI];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lỗi" message:@"Sai Key!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)setupMenuUI {
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 40)];
    menuLabel.text = @"AIMLD MENU";
    menuLabel.textColor = [UIColor purpleColor];
    menuLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:menuLabel];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AIMLD_Admin"]) {
        UILabel *adminLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 80, 30)];
        adminLabel.text = @" ADMIN ";
        adminLabel.textColor = [UIColor whiteColor];
        adminLabel.backgroundColor = [UIColor redColor];
        adminLabel.textAlignment = NSTextAlignmentCenter;
        adminLabel.layer.cornerRadius = 4;
        adminLabel.clipsToBounds = YES;
        [self.view addSubview:adminLabel];
    }
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width - 40, 30)];
    descLabel.text = @"ESP • Aimbot • FastFire";
    descLabel.textColor = [UIColor grayColor];
    [self.view addSubview:descLabel];
}

@end