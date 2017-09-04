//
//  editViewController.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/13.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITextField *heading ;
@property (nonatomic,strong) IBOutlet UITextField *notes ;
@property (nonatomic,strong) IBOutlet UITextField *link ;
@property (nonatomic,strong) IBOutlet UITextField *icon ;

- (IBAction)deleteAction:(id)sender ;
- (IBAction)saveAction:(id)sender ;

@end
