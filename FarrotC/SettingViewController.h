//
//  SettingViewController.h
//  FarrotC
//
//  Created by DevPc on 27/01/2016.
//  Copyright © 2016 SumMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
    @property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UISwitch *switchVibrate;
    @property (nonatomic, weak) id<ViewProtocol> delegate;
    @property (nonatomic, retain) NSString *currentSound;
    @property BOOL currentIsVibrate;
    - (IBAction)actionBtn:(id)sender;

- (IBAction)switchChange:(id)sender;

@end
