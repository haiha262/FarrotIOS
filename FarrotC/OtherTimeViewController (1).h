//
//  OtherTimeViewController.h
//  FarrotC
//
//  Created by DevPc on 27/01/2016.
//  Copyright © 2016 SumMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface OtherTimeViewController : UIViewController

    @property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
    @property (nonatomic, weak) id<ViewProtocol> delegate;


    - (IBAction)setTime:(id)sender;
@end
