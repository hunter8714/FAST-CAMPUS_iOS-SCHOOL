//
//  ViewController.m
//  LoginPage
//
//  Created by Mijeong Jeon on 5/23/16.
//  Copyright © 2016 Mijeong Jeon. All rights reserved.
//

#import "ViewController.h"
#import "DataCenter.h"
#import "MainPageViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageGoogle;
@property (nonatomic, weak) IBOutlet UIImageView *imageUser;
@property (nonatomic, weak) IBOutlet UIButton *buttonLogin;
@property (nonatomic, weak) IBOutlet UIView *view1;
@property (nonatomic, weak) IBOutlet UITextField *idField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _idField.delegate = self;
    _idField.tag = 1;
    _passwordField.delegate = self;
    _passwordField.tag = 2;
    
    if (!([[DataCenter userDefaults] objectForKey:@"autoId"] == nil)) {
    _idField.text = [[DataCenter userDefaults] objectForKey:@"autoId"];
    }
    [self displayMemberInfo];
    [self.navigationController setNavigationBarHidden:YES];
}

// 메인화면으로 이동하는 세그
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"LoginToMain"]) {
        if (_idField.text.length > 0 && _passwordField.text.length > 0) {
            if ([[DataCenter sharedInstance] isCheckLoginwithID:_idField.text userPW:_passwordField.text]) {
                [[DataCenter userDefaults] setObject:_idField.text forKey:@"autoId"];
                [[DataCenter userDefaults] setBool:YES forKey:@"autoBool"];
                return YES;
            } else {
                [self showAlert:@"Login Fail" andMessage:@"Invalid User Information" andidField:_idField andVC:self];
                return NO;
            }
        } else {
            [self showAlert:@"Insert Field" andMessage:@"Inserd ID and PW" andidField:_idField andVC:self];
        }
    } else {
    }
        return YES;
}

// ID입력후 엔터 누르면 다음칸으로 이동, PW입력후 엔터 누르면 버튼 클릭
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag ==1 && _idField.text.length > 0) {
        [_passwordField becomeFirstResponder];
        return YES;
    }
    if (textField.tag == 2 && _passwordField.text.length > 0) {
        if ([self shouldPerformSegueWithIdentifier:@"LoginToMain" sender:self]) {
            [self performSegueWithIdentifier:@"LoginToMain" sender:self];
        }
    }
    return YES;
}

// 알림 표시

- (void)showAlert:(NSString *)failTitle andMessage:(NSString *)failMessage andidField:(UITextField *)idField  andVC:(UIViewController *)VC{
    id block = ^(UIAlertAction * _Nonnull action) {
        
        if ([action.title isEqualToString:@"Try Agian"]) {
            [idField becomeFirstResponder];
        }
    };
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:failTitle
                                          message:failMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tryAgainction = [UIAlertAction actionWithTitle:@"Try Again"
                                                            style:UIAlertActionStyleDefault
                                                          handler:block];
    [alertController addAction:tryAgainction];
    [VC presentViewController:alertController animated:YES completion:^(void) {[idField becomeFirstResponder];}];
}


//  가입 id 화면에 표시
- (void)displayMemberInfo {
    NSArray *infoArray = [NSArray arrayWithContentsOfFile:[[DataCenter sharedInstance] findUserInfoPath]];
    for (NSDictionary *infoDic in infoArray) {
        NSLog(@"registered id : %@",[infoDic objectForKey:@"id"]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
