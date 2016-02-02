//
//  SplashViewController.m
//  FarrotC
//
//  Created by DevPc on 29/01/2016.
//  Copyright © 2016 SumMedia. All rights reserved.
//

#import "SplashViewController.h"
#import "BackgroundLayer.h"
#import "ViewController.h"
@interface SplashViewController ()

@end

@implementation SplashViewController
{
    NSTimer *timer;
    int durationSplash;
    float curAlpha;
    float stepAlpha;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    //make continue blink
    self.pressCont.alpha = curAlpha= 1;
    stepAlpha = 0.1;
    durationSplash = 2; //2s
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(updateTimer)
                                               userInfo:nil
                                                repeats:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) updateTimer
{
    if (curAlpha<=0) {
        stepAlpha = 0.1;
    }
    else if (curAlpha>=1) {
        stepAlpha = -0.1;
    }
    curAlpha += stepAlpha;
    self.pressCont.alpha = curAlpha;
    
    durationSplash--;
    if(durationSplash < 0)
    {
        //ViewController *viewController = [[ViewController alloc] init];
      //[self presentViewController:viewController animated:YES completion:nil];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@""
//                                                             bundle:nil];
//        ViewController *viewController = (ViewController *) [storyboard instantiateViewControllerWithIdentifier:@"splashView"];
//        [self presentViewController:viewController animated:YES completion:nil];
        

        
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
-(void)viewDidAppear
{
}
@end
