//
//  AboutViewController.m
//  Farrot
//
//  Created by DevPc on 3/02/2016.
//  Copyright © 2016 SumMedia. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.credit.text = [NSString stringWithFormat:NSLocalizedString(@"CREDIT", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)faceButton:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/SumMedia-131927873851946/?ref=hl"];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated: YES];
}
@end
