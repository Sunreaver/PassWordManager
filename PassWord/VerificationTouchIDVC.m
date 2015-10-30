//
//  VerificationTouchIDVC.m
//  PassWord
//
//  Created by 谭伟 on 15/5/25.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "VerificationTouchIDVC.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface VerificationTouchIDVC ()
@property (weak, nonatomic) IBOutlet UIImageView *bg_img;

@end

@implementation VerificationTouchIDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self OnStartVerification:nil];
}

- (IBAction)OnStartVerification:(UITapGestureRecognizer *)sender
{
    LAContext *context = [LAContext new];
    NSError *error;
    context.localizedFallbackTitle = @"";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                             error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:NSLocalizedString(@"进入查看密码们", nil)
                          reply:^(BOOL success, NSError *error) {
                              if (success)
                              {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self animateUnlock];
                                  });
                              }
                              else
                              {
                              }
                          }];
    }
    else
    {
        [self animateUnlock];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)animateUnlock{
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.bg_img setTransform:CGAffineTransformScale(self.bg_img.transform, 1.5, 1.5)];
                         [self.bg_img setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO
                                                  completion:^{}];
                     }];
}

@end
