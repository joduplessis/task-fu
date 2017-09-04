//
//  ViewController.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/04.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "taskObjectLines.h"
#import "taskObject.h"
#import "taskPopupDetail.h" 
#import "taskPopup.h" 

@interface ViewController : UIViewController <CustomClassDelegateEdit,UITextFieldDelegate>  {
    int layerCounter  ;
    float allDragX ;
    float allDragY ;
    NSNumber *taskEditID ;
    double taskNodeID ;
    int stageHasLoaded ;
    BOOL areTherePopupsOpen ;
    BOOL isLandscape ;
}

@property (nonatomic,strong) NSNumber *objectCounter ;
@property (weak, nonatomic) IBOutlet UIImageView *drawImage;
@property (weak, nonatomic) IBOutlet UIView *objectHolder;
@property (nonatomic, strong) IBOutlet UITextField *taskTitle ;
@property (nonatomic, strong) IBOutlet UIToolbar *keyboardToolbar ;
@property (nonatomic) taskObjectLines *linesView ;
@property (nonatomic,strong) NSString* boardTitle ;
@property (nonatomic,strong) NSString* boardTheme ;
@property (nonatomic,strong) NSString* boardBackground ;
@property (assign) double boardID ;
@property (assign) int centerObject ;




- (IBAction)quoteButtonTapped:(id)sender ;
- (BOOL) textFieldShouldReturn:(UITextField *) quoteTextField ;
- (void) updateLines ;
- (NSNumber *) getPrimeObjectID ;
- (NSNumber*)getHighestTaskIDOnStage ;
- (void) populateTasks ;
- (void) editTask:(NSNumber*)task;
-(void) appLoader;
- (int) updateBadgeNumber ;
//- (void) createPopup:(taskObject *) obj ;
-(void) createTwitter:(NSString*)post ;
-(void) createFacebook:(NSString*)post ;
//-(void) shakeIt:(taskObject*)obj;
@end
