//
//  SettingViewController.m
//  FarrotC
//
//  Created by DevPc on 27/01/2016.
//  Copyright © 2016 SumMedia. All rights reserved.
//

#import "SettingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BackgroundLayer.h"

@interface SettingViewController ()
{
    NSArray *listSound;
    NSArray *arrSound;
    NSString *soundNameTemp;
    BOOL vibrateTemp;
    AVAudioPlayer  *player;

}
@end

@implementation SettingViewController
@synthesize currentSound, currentIsVibrate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self intial];
}

-(void) intial
{
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    NSLog(@"Setting intial current sound %@",currentSound);
    listSound = [NSArray arrayWithObjects:@"Awesome morning", @"Best wake up", @"Cockatoo bird", @"Elegant ringtone", @"Extreme clock alarm", @"iphone 6 plus remix",@"Iphone Alarm",@"Nuclear alarm",@"Store door shime",@"Cockatoo normal",@"Cockatoo warning", nil];
    
    arrSound = [NSArray arrayWithObjects:@"awesomemorning_alarm",@"best_wake_up_sound",@"cockatoo_bird",@"elegant_ringtone",@"extreme_clock_alarm" ,@"iphone_6_plus_remix",@"iphone_alarm",@"nuclear_alarm",@"store_door_chime",@"white_cockatoo_normal",@"white_cockatoo_warning", nil];
    NSLog(@"currentIsVibrate %@ ",currentIsVibrate?@"True":@"False");
    [[self switchVibrate ] setOn:currentIsVibrate];
    soundNameTemp = currentSound;
    vibrateTemp = currentIsVibrate;
    
    
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

- (IBAction)actionBtn:(id)sender {
    if (sender == self.setBtn) {
        [self.delegate setSoundBack:soundNameTemp];
        [self.delegate setVibrateBack:vibrateTemp];
    }
   
    [self dismissModalViewControllerAnimated: YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listSound count];
}

//Setting table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor blackColor];
    cell.textColor =[UIColor whiteColor];
    cell.textLabel.text = [listSound objectAtIndex:indexPath.row];
    NSLog(@"SettingView %@", cell.text);
    if([arrSound objectAtIndex:indexPath.row] == currentSound)
    {
    cell.imageView.image = [UIImage imageNamed:@"ic_action_checked.png"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
 
    [self playChoiceSound:[arrSound objectAtIndex:indexPath.row]];
}
-(void) playChoiceSound:(NSString *)soundName
{
    soundNameTemp = soundName;
    
    NSString *path;
    NSError *error;
    path = [[NSBundle mainBundle] pathForResource:soundNameTemp ofType:@"mp3"];
    NSLog(@"set sound %@", path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
        player.volume = 1.0f;
    }
    [self playSound];
}
//sound setting
- (void) playSound
{
    [self stopSound];
    [player prepareToPlay];
    [player setNumberOfLoops:0];
    [player play];
}
-(void) stopSound
{

    if (player != nil)
    {
        if (player.isPlaying == YES)
            [player stop];
    }
    
}

- (IBAction)switchChange:(id)sender {
    if([sender isOn]){
        vibrateTemp = true;
         AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        NSLog(@"Switch is ON");
    } else{
        NSLog(@"Switch is OFF");
        vibrateTemp = false;
    }}
@end
