//
//  taskPopupDetail.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/13.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.


#import "taskPopupDetail.h"
#import "taskPopupDetailOverlay.h"
#import "taskDetailTextInput.h"

@implementation taskPopupDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIColor *) colorWithHexString:(NSString *)str {
    NSScanner *scanner = [NSScanner scannerWithString:str] ;
    unsigned hex ;
    if (![scanner scanHexInt:&hex]) return nil ;
    int r = (hex >> 16) & 0xFF ;
    int g = (hex >> 8) & 0xFF ;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}



- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (int) updateBadgeNumber {
    
    int taskCounter = 0 ;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        NSNumber *seenalert = [info valueForKey:@"seenalert"] ;
        NSString *date = [info valueForKey:@"time"] ;
        
        if (![date isEqual: @"Anytime"]) {
            
            // Here we convert our date string to a date object
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"cccc, MMM d, hh:mm aa y";
            
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [formatter dateFromString:date];
            
            NSDate *todayDeadline = [NSDate date] ;
            NSDate *thenDeadline = dateFromString ;
            NSComparisonResult result = [todayDeadline compare:thenDeadline];
            
            // here we set notifcations for dates, only if they have no yet seen dates
            if ( result == NSOrderedDescending ) {
                
                if ( ([seenalert isEqualToNumber:[NSNumber numberWithInt:0]]) || (seenalert==nil) ) {
                    
                    taskCounter++ ;
                    
                }
                
            }
            
        }
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: taskCounter];
    
    return taskCounter ;
    
}



- (void)drawRect:(CGRect)rect
{
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * wtf_id = [f numberFromString:self.wtf];
    

    // Here we set the alert to seen - we also need to remove it from notifications
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSNumber *alert = [NSNumber numberWithInt:1] ;
    
    for (NSManagedObject *info in tasks) {
        double temp = [[info valueForKey:@"node"] doubleValue] ;
        if ( (self.nodeID == temp) && ([wtf_id isEqualToNumber:[info valueForKey:@"id"]]) ) {
            [info setValue:alert forKey:@"seenalert"];
            [self updateBadgeNumber];
        }
    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    /* ******************************************************************************** */
    

    
  
    
    
    
    
    
    float screenSize = [UIScreen mainScreen].bounds.size.width ;
    float width ;
    float height ;
    float padding_x ;
    float origin_y ;
    
    if ( [UIScreen mainScreen].bounds.size.width > 500 ) {
        width = [UIScreen mainScreen].bounds.size.width - 300  ;
        height = [UIScreen mainScreen].bounds.size.height - 400  ;
        padding_x = ( [UIScreen mainScreen].bounds.size.width - width ) / 2;
        origin_y = ( [UIScreen mainScreen].bounds.size.height - height ) / 2;
    } else {
        width = [UIScreen mainScreen].bounds.size.width - 50  ;
        height = [UIScreen mainScreen].bounds.size.height - 160  ;
        padding_x = ( [UIScreen mainScreen].bounds.size.width - width ) / 2;
        origin_y = 70 ;
    }
    
    
    
    
    

    
    // centre the frame
    /* ******************************************************************************** */
    
    CGRect frame = self.frame ;
    frame.origin.x = padding_x ;
    frame.origin.y = origin_y ;
    self.frame = frame ;
    
    // drop shadow
    /* ******************************************************************************** */
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(contex);
    CGContextBeginPath(contex);
    CGContextSetRGBStrokeColor(contex, 1, 1, 1, 1) ;
    CGContextSetRGBFillColor(contex, 1, 1, 1, 1);
    
    // Draw the rectangle
    /* ******************************************************************************** */
    
    CGRect backing = CGRectMake(0,0, width, height) ;
    [[UIColor whiteColor] set] ;
    UIRectFill(backing);
    
    // draw the heading rectangle
    /* ******************************************************************************** */
    
    NSString *userHexForTheme = @"b8ac64" ;
    
    if ([self.theme isEqual: @"blue"]) { userHexForTheme = @"46bfec" ; }
    if ([self.theme isEqual: @"brown"]) { userHexForTheme = @"b8ac64" ; }
    if ([self.theme isEqual: @"darkgrey"]) { userHexForTheme = @"333333" ; }
    if ([self.theme isEqual: @"green"]) { userHexForTheme = @"65874a" ; }
    if ([self.theme isEqual: @"pink"]) { userHexForTheme = @"e3675f" ; }
    if ([self.theme isEqual: @"purple"]) { userHexForTheme = @"7a77ae" ; }
    if ([self.theme isEqual: @"red"]) { userHexForTheme = @"b95030" ; }
    
    if ([self.theme isEqual: @"nblue"]) { userHexForTheme = @"3a699d" ; }
    if ([self.theme isEqual: @"nyellow"]) { userHexForTheme = @"fac823" ; }
    if ([self.theme isEqual: @"norange"]) { userHexForTheme = @"ee7f01" ; }
    if ([self.theme isEqual: @"ngreen"]) { userHexForTheme = @"a3bb12" ; }
    if ([self.theme isEqual: @"npink"]) { userHexForTheme = @"912c48" ; }
    if ([self.theme isEqual: @"npurple"]) { userHexForTheme = @"5e496d" ; }
    if ([self.theme isEqual: @"nred"]) { userHexForTheme = @"a31719" ; }
    
    CGRect heading = CGRectMake(0,0, width, 100) ;
    [[self colorWithHexString:userHexForTheme] set] ;
    UIRectFill(heading);
    
    // Draw the text
    /* ******************************************************************************** */
    
    UIFont *gothamBold = [UIFont fontWithName:@"Gotham-Bold" size:20];
    UIFont *gothamBook = [UIFont fontWithName:@"Gotham-Book" size:10];
    UIFont *gothamBoldLink = [UIFont fontWithName:@"Gotham-Bold" size:10];
    UIFont *gothamBookPara = [UIFont fontWithName:@"Gotham-Book" size:16];
    
    CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(contex, transform);
    CGContextSetRGBFillColor(contex, 1, 1, 1, 1.0);
    CGContextSetLineWidth(contex, 10.0);
    CGContextSetCharacterSpacing(contex, 0);
    CGContextSetTextDrawingMode(contex, kCGTextFill);
    

    
    
    
    
    // Date box ---------------------------------------------------------------
    /* ******************************************************************************** */
    
    CGRect dateBox = CGRectMake(60,15,width-60, 45);
    [self.date drawInRect:dateBox withFont:gothamBoldLink lineBreakMode:NSLineBreakByWordWrapping alignment:UITextAlignmentLeft] ;

    
    
    // Title box & tap ---------------------------------------------------------------
    /* ******************************************************************************** */
    
    CGRect titleBox = CGRectMake(60,27,width-60, 60);
    [self.title drawInRect:titleBox withFont:gothamBold lineBreakMode:NSLineBreakByWordWrapping alignment:UITextAlignmentLeft] ;

    
    
    CGContextSetRGBFillColor(contex, 0.6, 0.6, 0.6, 1);
    
    
    
    
    /* ******************************************************************************** */
    // Text box ---------------------------------------------------------------
    /* ******************************************************************************** */
    
    CGRect textBox = CGRectMake(20,115,width-50, 190);
    [self.notes drawInRect:textBox withFont:gothamBookPara lineBreakMode:NSLineBreakByWordWrapping alignment:UITextAlignmentLeft] ;
    UIView *textView = [[UIView alloc] initWithFrame:textBox];

    
    
    
    // Link Box ---------------------------------------------------------------
    /* ******************************************************************************** */
    
    
    if ( [self.link isEqualToString:@""] ) {
        link = @"Task Fu website" ;
    } else {
        link = self.link ;
    }
    
    CGRect linkBox = CGRectMake(20,height-80,width-20, 30);
    
    [link drawInRect:linkBox withFont:gothamBoldLink lineBreakMode:NSLineBreakByWordWrapping alignment:UITextAlignmentLeft] ;
    
    UIView *linkView = [[UIView alloc] initWithFrame:linkBox];
    [linkView setUserInteractionEnabled:YES];
    UIGestureRecognizer *linkTap = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(linkTapping:)];
    [linkView addGestureRecognizer:linkTap];
    [self addSubview:linkView] ;
    
    
    
    /* ******************************************************************************** */
    // main icon
    /* ******************************************************************************** */
    
    UIImage *iconFile = [UIImage imageNamed:self.icon];
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:iconFile] ;
    iconImage.frame = CGRectMake(0,0,50,50);
    CGRect frameIcon = iconImage.frame;
    frameIcon.origin.x = 5 ;
    frameIcon.origin.y = 10 ;
    iconImage.frame = frameIcon;
    [self addSubview:iconImage] ;
    
    self.alpha = 0 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.alpha = 1.0 ;
    [UIView commitAnimations];
    
    /* ******************************************************************************** */
    // confirm icon
    /* ******************************************************************************** */
    
    UIImage *editFile = [UIImage imageNamed:@"check_light.png"];
    UIImageView *editImage = [[UIImageView alloc] initWithImage:editFile] ;
    editImage.frame = CGRectMake(0,0,35,35);
    CGRect frameIconEdit = editImage.frame;
    frameIconEdit.origin.x = 20 ;
    frameIconEdit.origin.y = height-50 ;
    editImage.frame = frameIconEdit;
    
    [editImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *acceptTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptTapping:)];
    [acceptTap setNumberOfTapsRequired:1];
    [editImage addGestureRecognizer:acceptTap];
    
    [self addSubview:editImage] ;
    
    
    /* ******************************************************************************** */
    // close icon
    /* ******************************************************************************** */
    
    UIImage *closeFile = [UIImage imageNamed:@"edit_light.png"];
    UIImageView *closeImage = [[UIImageView alloc] initWithImage:closeFile] ;
    closeImage.frame = CGRectMake(0,0,35,35);
    CGRect frameIconClose = closeImage.frame;
    frameIconClose.origin.x = 70 ;
    frameIconClose.origin.y = height-50 ;
    closeImage.frame = frameIconClose;
    
    [closeImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapping:)];
    [closeTap setNumberOfTapsRequired:1];
    [closeImage addGestureRecognizer:closeTap];    
    
    [self addSubview:closeImage] ;
    
    /* ******************************************************************************** */
    // twitter test
    /* ******************************************************************************** */
    
    UIImage *tFile = [UIImage imageNamed:@"twitter.png"];
    UIImageView *tImage = [[UIImageView alloc] initWithImage:tFile] ;
    tImage.frame = CGRectMake(0,0,35,35);
    CGRect frameTClose = tImage.frame;
    frameTClose.origin.x = 120 ;
    frameTClose.origin.y = height-50 ;
    tImage.frame = frameTClose;
    
    [tImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tTapping:)];
    [tTap setNumberOfTapsRequired:1];
    [tImage addGestureRecognizer:tTap];
    
    [self addSubview:tImage] ;
    
    /* ******************************************************************************** */
    // fb test
    /* ******************************************************************************** */
    
    UIImage *sFile = [UIImage imageNamed:@"facebook.png"];
    UIImageView *sImage = [[UIImageView alloc] initWithImage:sFile] ;
    sImage.frame = CGRectMake(0,0,35,35);
    CGRect frameSClose = sImage.frame;
    frameSClose.origin.x = 170 ;
    frameSClose.origin.y = height-50 ;
    sImage.frame = frameSClose;
    
    [sImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *sTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sTapping:)];
    [sTap setNumberOfTapsRequired:1];
    [sImage addGestureRecognizer:sTap];
    
    [self addSubview:sImage] ;
    
}

-(void)sTapping:(UIGestureRecognizer *)recognizer {
    
    recognizer.view.alpha = 0.1 ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    recognizer.view.alpha = 1.0 ;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterAnimationS:finished:context:)] ;
    [UIView commitAnimations];
    


}

- (void) afterAnimationS:(NSString*)animationID finished:(NSNumber *)finished context:(void *)context {
    
    for (taskPopup* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            [subview facebookLoaderMain:self.title];
        }
    }
    
    for (taskPopupDetailOverlay* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopupDetailOverlay class]]) {
            [subview removeFromSuperview];
        }
    }
    
    for (taskPopup *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            [subview removePopups] ;
        }
    }
    
    [self removeFromSuperview];
    
}


-(void)tTapping:(UIGestureRecognizer *)recognizer {
    
    recognizer.view.alpha = 0.1 ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    recognizer.view.alpha = 1.0 ;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterAnimationT:finished:context:)] ;
    [UIView commitAnimations];
    

    
}

- (void) afterAnimationT:(NSString*)animationID finished:(NSNumber *)finished context:(void *)context {
    
    for (taskPopup* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            [subview twitterLoaderMain:self.title];
        }
    }
    
    for (taskPopupDetailOverlay* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopupDetailOverlay class]]) {
            [subview removeFromSuperview];
        }
    }
    
    for (taskPopup *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            [subview removePopups] ;
        }
    }
    
    [self removeFromSuperview];
    
}

-(void)linkTapping:(UIGestureRecognizer *)recognizer {
    
    recognizer.view.alpha = 0.1 ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    recognizer.view.alpha = 1.0 ;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterAnimationLink:finished:context:)] ;
    [UIView commitAnimations];
    
      
}

- (void) afterAnimationLink:(NSString*)animationID finished:(NSNumber *)finished context:(void *)context {
    
    
    NSURL *url ;
    
    if ([link isEqual: @"Task Fu website"]) {
        
        url = [NSURL URLWithString:@"http://www.weareavalanche.com/taskfu"];
        
    } else {
        
        
        NSString *searchString = [link substringToIndex:3];
        
        if (![searchString isEqual: @"www"]) {
            url = [NSURL URLWithString: link];
        } else {
            NSString *ht = @"http://" ;
            NSString *as = [ht stringByAppendingString:link];
            url = [NSURL URLWithString:as];
        }
        
        
        
    }
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
        
    }
    
}

// Here we close delete the task

-(void)closeTapping:(UIGestureRecognizer *)recognizer {
    
    recognizer.view.alpha = 0.1 ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    recognizer.view.alpha = 1.0 ;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterAnimationClose:finished:context:)] ;
    [UIView commitAnimations];
    
}

- (void) afterAnimationClose:(NSString*)animationID finished:(NSNumber *)finished context:(void *)context {
    
    for (taskPopupDetailOverlay* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopupDetailOverlay class]]) {
            [subview removeFromSuperview];
        }
    }
    
    int count = 1 ;
    
    for (taskPopup* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            if (count==1) {
                [subview moveEditBoard];
                count = 0 ;
            }
        }
    }
    
    for (taskPopup *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            [subview removePopups] ;
        }
    }
    
    
    
    [self removeFromSuperview];
    
}

// Here we close the window

-(void)acceptTapping:(UIGestureRecognizer *)recognizer {
    
    recognizer.view.alpha = 0.1 ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    recognizer.view.alpha = 1.0 ;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterAnimationAccept:finished:context:)] ;
    [UIView commitAnimations];


}

- (void) afterAnimationAccept:(NSString*)animationID finished:(NSNumber *)finished context:(void *)context {
    
    for (taskPopup* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            [subview appLoaderMain];
        }
    }
    
    for (taskPopupDetailOverlay* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopupDetailOverlay class]]) {
            [subview removeFromSuperview];
        }
    }
    
    for (taskPopup *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            [subview removePopups] ;
        }
    }
    
    [self removeFromSuperview];
    
}



@end
