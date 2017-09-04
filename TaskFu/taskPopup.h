//
//  taskPopup.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/13.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomClassDelegateEdit <NSObject>
- (void) editTask:(NSNumber*)task;
- (void) removePopups ;
- (void) appLoader;
- (void) createTwitter:(NSString*)post ;
- (void) createFacebook:(NSString*)post ;

@end

@interface taskPopup : UIView

@property (nonatomic, assign) id<CustomClassDelegateEdit> delegate;

@property (nonatomic) CGPoint point ;
@property (nonatomic,strong) NSString *title ;
@property (nonatomic,strong) NSString *date ;
@property (nonatomic,strong) NSString *theme ;
@property (nonatomic,strong) NSString *icon ;
@property (nonatomic,strong) NSString *notes;
@property (nonatomic,strong) NSString *link ;
@property (nonatomic,strong) NSNumber *taskID ;
@property (assign) double nodeID ;

-(void) removePopups ;
-(void) createPopupDetail:(NSNumber*)popupID ;
- (void) moveEditBoard ;
-(void) appLoaderMain ;
-(void) twitterLoaderMain:(NSString*)post ;
-(void) facebookLoaderMain:(NSString*)post ;

@end
