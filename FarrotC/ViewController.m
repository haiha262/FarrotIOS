//
//  ViewController.m
//  FarrotC
//
//  Created by Michael on 22/01/2016.
//  Copyright © 2016 SumMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "SettingViewController.h"
#import "OtherTimeViewController.h"
#import "ViewController.h"
#import "BackgroundLayer.h"

const int TIME15P = 15*60;
const int TIME30P = 30*60;
const int TIME1H = 60*60;
const int TIME2H = 2 * 60*60;
const int TIME4H = 4 * 60 *60;
static AVAudioPlayer  *player;
static NSTimer *vibrateTimer;
static int timeInSecond;
@interface ViewController ()

@end
@implementation ViewController
{
    int numberReminder; // number of reminder
    
    int secondsCount;
    NSTimer *timer;
    BOOL isTimerRunning;
    int TimeDebug;
    AVAudioPlayer  *playerHint;
    AVAudioPlayer  *playerScroll;
    NSString *phoneNumberString;
    NSString *soundNamePlaying;
    BOOL isVibrate;
    NSArray *_pickerData;
    NSMutableArray *arrayout;
    NSMutableArray *arrHour;
    NSMutableArray *arrMin;
    
    NSMutableArray  * picker1,*picker2;
    UIAlertView *alert;
    int timePicker1;
    int timePicker2;
    UILocalNotification *localNotification;
    
    Boolean isDebug;
}

//get back data from child
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* controller = [segue destinationViewController];
    if ([controller isKindOfClass:[OtherTimeViewController class]])
    {
        OtherTimeViewController* otherTimeView = (OtherTimeViewController *)controller;
        otherTimeView.delegate = self;
    }
    if ([controller isKindOfClass:[SettingViewController class]])
    {
        SettingViewController* settingView = (SettingViewController *)controller;
        settingView.delegate = self;
        settingView.currentSound = soundNamePlaying;
        settingView.currentIsVibrate = isVibrate;
    }
}

-(void) setTimeBack:(int)time
{
    timeInSecond = time;
    [self initRemindPicker];
    NSLog(@"ViewController setTimeBack is %i", time);
}

-(void) setSoundBack:(NSString *)soundName
{
    NSLog(@"ViewController soundNamePlaying is %@", soundName);
    
    soundNamePlaying = soundName;
}

-(void) setVibrateBack:(BOOL)value
{
    NSLog(@"ViewController isVibrate is %@", value?@"TRUE":@"FALSE");
    
    isVibrate = value;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self initial];
    
}


- (void) initial
{
    isDebug = false;
    numberReminder = 1;
    isTimerRunning = NO;
    
    TimeDebug = TIME15P;
    timeInSecond = TimeDebug;
    self.timeLayout.alpha = 0; //set disappear
    self.timeSetLayout.alpha = 1;
    self.remindLayout.alpha = 1;
    soundNamePlaying = @"awesomemorning_alarm";
    isVibrate = true;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    //set Time default press
    [self.f15min setBackgroundImage:[UIImage imageNamed:@"f15ppress.png"] forState:(UIControlStateNormal)];
    
    [self initRemindPicker];
    
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
//    localNotification =[[UILocalNotification alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//all buttons method
- (IBAction)btnAction:(id)sender {
    if (sender == self.startStopButton) {
        [self countDownTimer ];
    }
    
    else if(sender == self.settingBtn)
    {
        //  SettingViewController *settingController = [[SettingViewController alloc] init];
        //  [self presentViewController:settingController animated:YES completion:nil];
    }
    else
    {
        [self setTimer:sender];
    }
    
    //play sound when touch
    [playerHint stop];
    [playerHint prepareToPlay];
    [playerHint setNumberOfLoops:0];
    [playerHint play];
}// end btn Action

-(void) setTimer:(id)sender
{
    [self changeBackGroundImage:self.f15min withImage:[UIImage imageNamed:@"f15p.png"]];
    [self changeBackGroundImage:self.f30min withImage:[UIImage imageNamed:@"f30p.png"]];
    [self changeBackGroundImage:self.f1hour withImage:[UIImage imageNamed:@"f1h.png"]];
    [self changeBackGroundImage:self.f2hours withImage:[UIImage imageNamed:@"f2h.png"]];
    [self changeBackGroundImage:self.f4hours withImage:[UIImage imageNamed:@"f4h.png"]];
    [self changeBackGroundImage:self.fOther withImage:[UIImage imageNamed:@"other.png"]];
    
    
    if (sender == self.f15min) {
        timeInSecond = TIME15P;
        [self changeBackGroundImage:self.f15min withImage:[UIImage imageNamed:@"f15ppress.png"]];
    } else if (sender == self.f30min) {
        timeInSecond = TIME30P;
        [self changeBackGroundImage:self.f30min withImage:[UIImage imageNamed:@"f30ppress.png"]];
    } else if (sender == self.f1hour) {
        timeInSecond = TIME1H;
        [self changeBackGroundImage:self.f1hour withImage:[UIImage imageNamed:@"f1hpress.png"]];
    } else if (sender == self.f2hours) {
        timeInSecond = TIME2H;
        [self changeBackGroundImage:self.f2hours withImage:[UIImage imageNamed:@"f2hpress.png"]];
    } else if (sender == self.f4hours) {
        timeInSecond = TIME4H;
        [self changeBackGroundImage:self.f4hours withImage:[UIImage imageNamed:@"f4hpress.png"]];
    } else if (sender == self.fOther) {
        [self changeBackGroundImage:self.fOther withImage:[UIImage imageNamed:@"otherpress.png"]];
    }
    [self initRemindPicker];
    
}
- (void) changeBackGroundImage: (UIButton *) aButton withImage:(UIImage *) image
{
    [aButton setBackgroundImage:image forState:(UIControlStateNormal)];
}
- (void) countDownTimer
{
    // to set secondCount
    secondsCount = timeInSecond;
    int hours = timeInSecond / 3600;
    int minutes = (timeInSecond % 3600) / 60;
    int seconds = timeInSecond % 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
    
    
    if (isTimerRunning == YES) { //is standby
        
        [self alarmSetOff];
        self.timeLayout.alpha = 0; //set disappear
        self.timeSetLayout.alpha = 1;
        self.remindLayout.alpha = 1;
        
        [self changeBackGroundImage:self.startStopButton withImage:[UIImage imageNamed:@"start.png"]];
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        self.timeLabel.text = @"00:00:00";

        
        [[self class] stopSound];
        [timer invalidate];
        timer = nil;
        
    } else {
        
        NSLog(@"Star - @ time %i sound: %@ isVibrate %@",secondsCount, soundNamePlaying,isVibrate?@"TRUE":@"FALSE");
        
        self.timeLayout.alpha = 1; //set appear
        self.timeSetLayout.alpha = 0;
        self.remindLayout.alpha = 0;
        
        [self changeBackGroundImage:self.startStopButton withImage:[UIImage imageNamed:@"stop.png"]];
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        [self initSound];
        if(isDebug)
        {
            secondsCount = 15;
            [self alarmSetOn:secondsCount withMessage:@"TIME UP"];
            [self alarmSetOn:secondsCount-10 withMessage:@"TIME UP 2"];
        }
        else{
            [self alarmSetOn:secondsCount withMessage:@"TIME UP: Move Your Car Now"];
        }
        
        
        timePicker1 = [self getNumberSecond:picker1];
        timePicker2 = [self getNumberSecond:picker2];
        
        if (timePicker1>0) {
            numberReminder++;
            [self alarmSetOn:secondsCount-timePicker1 withMessage:@"Remind your time"];
        }
        if (timePicker1 != timePicker2) {
            if (timePicker2>0) {
                numberReminder++;
                [self alarmSetOn:secondsCount-timePicker2 withMessage:@"Remind your time"];
            }
            
        }
    
        if (timer == nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(updateTimer)
                                                   userInfo:nil
                                                    repeats:YES];

//            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//            [[NSRunLoop currentRunLoop] run];
        }
        
    }
    
    isTimerRunning = !isTimerRunning;
}
+ (void) setTimeCountDown:(int) time
{
    timeInSecond = time;
}

+ (int) getTimeCountDown
{
    return timeInSecond;
}

- (int) getNumberSecond:(NSMutableArray *) array
{
    long total;
    if ([array count]==1) {
        total = ([[array objectAtIndex:0] integerValue])*60;
    }
    else
    {
        total = ([[array objectAtIndex:0] integerValue])*3600 + ([[array objectAtIndex:1] integerValue])*60;
    }
    return (int) total;
}
- (void) updateTimer {
    
    secondsCount--;
    int hours = secondsCount / 3600;
    int minutes = (secondsCount % 3600) / 60;
    int seconds = secondsCount % 60;
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
    NSLog(@" updateTimer %@", self.timeLabel.text);
    if (isDebug) {
        if(secondsCount == 10)
        {
            [self openNotificationAlert ];
        }
    }
    if((secondsCount == timePicker1 && timePicker1 != 0)|| (secondsCount == timePicker2 && timePicker2 != 0))
    {
        
        [self openNotificationAlert ];
    }
    if (secondsCount <= 0) {
        
        [self openNotificationAlert ];
        [timer invalidate];
        timer = nil;
        
        
    }
    
}

-(void) openNotificationAlert
{
    [self playSound];
    
    
}

-(void)vibratePhone {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//sound setting
- (void) playSound
{
    if(isVibrate)
    {
        vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(vibratePhone) userInfo:nil repeats:YES];
    }
    /*
     ////using with AudioToolbox
     SystemSoundID toneSSID = toneSSIDs[0];
     //    AudioServicesPlaySystemSound(toneSSID);
     AudioServicesPlayAlertSound(toneSSID);
     */
    NSLog(@" playSound %@", soundNamePlaying);
    [[self class] stopSound];
    [player prepareToPlay];
   
    [player setNumberOfLoops:100];
    [player play];
}
+(void) stopSound
{
    
    /*
     ////using with AudioToolbox
     SystemSoundID toneSSID = toneSSIDs[0];
     //    AudioServicesPlaySystemSound(toneSSID);
     AudioServicesPlayAlertSound(toneSSID);
     */
    if (player != nil)
    {
        if (player.isPlaying == YES)
        {
            [player stop];
             player.currentTime =0;//fix:reset current player
            [vibrateTimer invalidate];
        }
    }
    
}
-(void) initSound
{
    NSString *path;
    NSError *error;
    path = [[NSBundle mainBundle] pathForResource:soundNamePlaying ofType:@"mp3"];
    NSLog(@"set sound %@", path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
        player.volume = 1.0f;
        //fix make sound play in background
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        //end
    }
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        /*
         //using with AudioToolbox
         phoneNumberString = [[NSString alloc] init];
         
         //for(int count = 0; count < 14; count++){
         NSString *toneFilename = [NSString stringWithFormat:@"iphone_6_plus_remix"];
         
         NSURL *toneURLRef = [[NSBundle mainBundle] URLForResource:toneFilename
         withExtension:@"mp3"];
         SystemSoundID toneSSID = 0;
         
         AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain(toneURLRef),&toneSSID);
         toneSSIDs[0] = toneSSID;
         //}
         */
        
        NSString *path;
        NSError *error;
        if(playerHint == nil)
        {
            path = [[NSBundle mainBundle] pathForResource:@"hint" ofType:@"mp3"];
            NSLog(@"set sound %@", path);
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                playerHint = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
                playerHint.volume = 1.0f;
            }
            
        }
        if(playerScroll == nil)
        {
            path = [[NSBundle mainBundle] pathForResource:@"scroll_sound" ofType:@"mp3"];
            NSLog(@"set sound %@", path);
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                playerScroll = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
                playerScroll.volume = 1.0f;
            }
            
        }
    }
    
    return self;
}
- (void)presentMessage:(NSString *)message {
    
    alert = [[UIAlertView alloc]
             initWithTitle:@"Hello!"
             message:message
             delegate:self
             cancelButtonTitle:@"Dismiss"
             otherButtonTitles: nil,nil];
    
    [alert show];
    
}


- (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate withMessage: (NSString *) message {
    
    
    localNotification =[[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = message;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
//    localNotification.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber++;
    localNotification.applicationIconBadgeNumber =0;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)alarmSetOn:(int) inSecond withMessage: (NSString *) message
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"DD/MM/YY HH:mm:ss"];
    //    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    //    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    //    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    NSString *dateTimeString = [dateFormatter stringFromDate:now];
    NSLog(@"Alarm Set before: %@", dateTimeString);
    
    NSDate *correctDate = [NSDate dateWithTimeInterval:(double)inSecond sinceDate:now];
    dateTimeString = [dateFormatter stringFromDate:correctDate];
    NSLog(@"Alarm Set after : %@", dateTimeString);
    
    [self scheduleLocalNotificationWithDate:correctDate withMessage:message];
    NSLog(@"Alarm On");
    //[self presentMessage:@"Alarm ON!"];
    
    
}

- (void)alarmSetOff {
    NSLog(@"Alarm Off");
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //[self presentMessage:@"Alarm OFF!"];
}

-(void) initRemindPicker
{
    //update reminder timer
    int hours = timeInSecond / 3600;
    int minutes = (timeInSecond % 3600) / 60;
    if (hours == 0) {
        [self initRemindPicker:0 :minutes];
    }else if (hours >=1)
    {
        [self initRemindPicker:hours :60];
    }
}

//For Picker reminder
- (void) initRemindPicker:(int)hour :(int)minutes
{
    NSLog(@"initRemindPicker %i %i", hour, minutes);
    NSString *fullnameMinute = @"min";
    arrayout = [[NSMutableArray alloc] init];        // alloc here
    
    arrHour = [[NSMutableArray alloc] init];
    if(hour > 0)
    {
        for(int i=0;i<=hour;i++)
        {
            NSString *h =  [NSString stringWithFormat:@"%ih", i];
            [arrHour insertObject:h  atIndex:i];
        }
        
        fullnameMinute =@"";
        [arrayout addObject:arrHour];
    }
    
    arrMin = [[NSMutableArray alloc] init];
    for(int i=0;i<minutes;i++)
    {
        NSString *min =  [NSString stringWithFormat:@"%i %@", i,fullnameMinute];
        [arrMin insertObject:min  atIndex:i];
    }
    [arrayout addObject:arrMin];
    
    // set reminder
    if(hour>0)
    {
        picker1 = [[NSMutableArray alloc] initWithObjects:@0,@0,nil];
        picker2 = [[NSMutableArray alloc] initWithObjects:@0,@0,nil];
    }else
    {
        picker1 = [[NSMutableArray alloc] initWithObjects:@0,nil];
        picker2 = [[NSMutableArray alloc] initWithObjects:@0,nil];
    }
    // Connect data:
    self.remindPicker1.delegate = self;
    self.remindPicker1.dataSource = self;
    // Connect data:
    self.remindPicker2.delegate = self;
    self.remindPicker2.dataSource = self;
    
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return (int)[arrayout count];
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([arrHour count] >0)
    {
        if (component==0)
        {
            return (int)[arrHour count];
        }
        else if (component==1)
        {
            return (int)[arrMin count];
        }
    }
    else{
        return (int)[arrMin count];
    }
    return (int)nil;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([arrHour count] >0)
    {
        switch (component)
        {
            case 0:
                return [arrHour objectAtIndex:row];
                break;
            case 1:
                return [arrMin objectAtIndex:row];
                break;
                
        }
    }
    else
    {
        return [arrMin objectAtIndex:row];
    }
    return nil;
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    NSString *rowSelect =  [NSString stringWithFormat:@"%i", (int)row];
    if(pickerView == [self remindPicker1])
    {
        if(component==0)
            [picker1 replaceObjectAtIndex:0 withObject:rowSelect];
        else
            [picker1 replaceObjectAtIndex:1 withObject:rowSelect];
    }
    else  if(pickerView == [self remindPicker2])
    {
        if(component==0)
            [picker2 replaceObjectAtIndex:0 withObject:rowSelect];
        else
            [picker2 replaceObjectAtIndex:1 withObject:rowSelect];
    }
    [playerScroll stop];
    [playerScroll prepareToPlay];
    [playerScroll setNumberOfLoops:0];
    [playerScroll play];
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{NSString *rowSelect;
    if([arrHour count] >0)
    {
        if (component==0)
        {
            rowSelect =  [NSString stringWithFormat:@"%@",[arrHour objectAtIndex:row]];
        }
        else if (component==1)
        {
            rowSelect =  [NSString stringWithFormat:@"%@",[arrMin objectAtIndex:row]];
        }
    }
    else{
        rowSelect =  [NSString stringWithFormat:@"%@",[arrMin objectAtIndex:row]];
        
    }
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:rowSelect attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}
@end
