//
//  ViewController.h
//  FarrotC
//
//  Created by Michael on 22/01/2016.
//  Copyright © 2016 SumMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewProtocol

- (void) setTimeBack:(int)time;
- (void) setSoundBack:(NSString *) soundName;
- (void) setVibrateBack:(BOOL)value;
@end
@interface ViewController : UIViewController  <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *f15min;
@property (strong, nonatomic) IBOutlet UIButton *f30min;
@property (strong, nonatomic) IBOutlet UIButton *f1hour;
@property (strong, nonatomic) IBOutlet UIButton *f2hours;
@property (strong, nonatomic) IBOutlet UIButton *f4hours;
@property (strong, nonatomic) IBOutlet UIButton *fOther;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *timeLayout;
@property (strong, nonatomic) IBOutlet UIButton *startStopButton;
@property (strong, nonatomic) IBOutlet UIView *timeSetLayout;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIView *remindLayout;
@property (weak, nonatomic) IBOutlet UIPickerView *remindPicker1;
@property (weak, nonatomic) IBOutlet UIPickerView *remindPicker2;


-(void) playSound;
+(void) stopSound;
+(void) updateTimer;
+(int) getTimeCountDown;
+(void) setTimeCountDown:(int) time;
-(id)initWithCoder:(NSCoder *)aDecoder;
- (IBAction)btnAction:(id)sender;
@end

