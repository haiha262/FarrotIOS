//
//  OtherTimeViewController.m
//  FarrotC
//
//  Created by DevPc on 27/01/2016.
//  Copyright © 2016 SumMedia. All rights reserved.
//

#import "OtherTimeViewController.h"
#import "BackgroundLayer.h"
#import <UIKit/UIKit.h>
@interface OtherTimeViewController ()
{
    NSTimeInterval countDownInterval;
    int seconds;
}
@end
@implementation OtherTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    //set text color for picker'
    [[self timePicker] setValue:[UIColor whiteColor] forKeyPath:@"textColor"];

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
- (void)setTimeDataBack:(int)time
{
    [self.delegate setTimeBack:time];
}

- (IBAction)setTime:(id)sender {
    countDownInterval = (NSTimeInterval) [self timePicker].countDownDuration;
    int tmp = countDownInterval;
    seconds = countDownInterval - tmp%60;
    [self setTimeDataBack:seconds];
    NSLog(@"Time set is %i", seconds);
    [self dismissModalViewControllerAnimated:YES];
}
@end
