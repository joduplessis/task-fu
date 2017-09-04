//
//  taskPopup.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/13.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "taskPopup.h"
#import "taskPopupDetail.h"
#import "taskPopupDetailOverlay.h"

@implementation taskPopup

@synthesize delegate ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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

- (void)drawRect:(CGRect)rect
{
    
    for (UIView* subview in self.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(contex);
    
    NSString *userHexForTheme ;
    
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
    
    if ([self alertUserToObject] == YES) {
        userHexForTheme = @"ee0000" ;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = 43 ;
    frame.origin.x = 0 ;
    frame.size.width = self.superview.frame.size.width ;
    self.frame = frame;
 
    UIFont *gothamBold = [UIFont fontWithName:@"Gotham-Bold" size:15];
    UIFont *gothamBook = [UIFont fontWithName:@"Gotham-Book" size:8];
    UIFont *gothamBoldSmall = [UIFont fontWithName:@"Gotham-Bold" size:10];
    
    // Draw the rectangle
    
    CGContextBeginPath(contex);
    CGContextSetRGBStrokeColor(contex, 1, 1, 1, 1) ;
    CGContextSetFillColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor);

    
    CGRect backing = CGRectMake(0,0, self.superview.frame.size.width, 53) ;
    backing.origin.y = backing.origin.y ;
    [[self colorWithHexString:userHexForTheme] set] ;
    UIRectFill(backing);
        

    
    // draw the arrow
    
    CGContextSetLineWidth(contex, 5.0);
    CGContextSetLineWidth(contex, 0);
    CGContextMoveToPoint(contex, 10, 0);
    CGContextAddLineToPoint(contex, 0, 10);
    CGContextAddLineToPoint(contex, 10, 20);
    CGContextAddLineToPoint(contex, 10, 0);
    CGContextDrawPath(contex, kCGPathFillStroke);
    UIGraphicsPopContext();
    
    // Draw the icon
        
    UIImage *iconFile = [UIImage imageNamed:@"settings_white.png"];
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:iconFile] ;
    [iconImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *detailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapping:)];
    [detailTap setNumberOfTapsRequired:1];
    [iconImage addGestureRecognizer:detailTap];
    iconImage.frame = CGRectMake(0,0,35,35);
    CGRect frameIcon = iconImage.frame;
    frameIcon.origin.x = self.superview.frame.size.width-50 ;
    frameIcon.origin.y = 10 ;
    iconImage.frame = frameIcon;
    [self addSubview:iconImage] ;
    
    
    

    
    // Draw the text
    
    CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(contex, transform);
    CGContextSetRGBFillColor(contex, 1, 1, 1, 1.0);
    CGContextSetLineWidth(contex, 10.0);
    CGContextSetCharacterSpacing(contex, 0);
    CGContextSetTextDrawingMode(contex, kCGTextFill);
    
    // Draw the link icon
    
    if ( ![self.link isEqualToString:@""] ) {
        
        CGRect dateBoxSmall = CGRectMake(10,35,self.superview.frame.size.width-70, 50);
        [self.link drawInRect:dateBoxSmall withFont:gothamBoldSmall lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft] ;
        
    }
    
    // text
    
    CGRect titleBoxSmall = CGRectMake(10,10,self.superview.frame.size.width-70, 50);
    [self.title  drawInRect:titleBoxSmall withFont:gothamBold lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft] ;
    
    CGRect dateBoxSmall = CGRectMake(10,25,self.superview.frame.size.width-70, 50);
    [self.date drawInRect:dateBoxSmall withFont:gothamBook lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft] ;
    
    // start animation for the drag

    self.alpha = 0.0 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.alpha = 1.0 ;
    [UIView commitAnimations];

    
    

}

-(void)detailTapping:(UIGestureRecognizer *)recognizer {
    
    // start animation for the drag
    
    CGFloat start_x = recognizer.view.transform.a;
    CGFloat start_y = recognizer.view.transform.d;
    
    CGAffineTransform start = CGAffineTransformMakeScale(start_x, start_y);
    
    CGFloat end_x = recognizer.view.transform.a - 0.5;
    CGFloat end_y = recognizer.view.transform.d - 0.5;
    
    CGAffineTransform end = CGAffineTransformMakeScale(end_x, end_y);
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)recognizer.view];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    recognizer.view.transform = end;
    [UIView commitAnimations];
    
    // end animation for the drag
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)recognizer.view];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    recognizer.view.transform = start;
    [UIView commitAnimations];
    
    
    
    
    
    recognizer.view.alpha = 0.1 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    recognizer.view.alpha = 0.2 ;
    [UIView commitAnimations];
    
    recognizer.view.alpha = 0.2 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    recognizer.view.alpha = 1.0 ;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterAnimationCreatePopup:finished:context:)] ;
    [UIView commitAnimations];

    
    

}

- (void) afterAnimationCreatePopup:(NSString*)animationID finished:(NSNumber *)finished context:(void *)context {
    
    [self createPopupDetail:self.taskID] ;
    
}

-(void) createPopupDetail:(NSNumber*)popupID {
    
    // Draw the rectangle
    
    CGRect overlayRect = CGRectMake(0,0, self.superview.frame.size.width, self.superview.frame.size.height) ;
    
    taskPopupDetailOverlay *overlay = [[taskPopupDetailOverlay alloc] initWithFrame:overlayRect];
    
    overlay.backgroundColor = [UIColor clearColor];
    overlay.alpha = 0.7 ;
    
    [self.superview addSubview:overlay];
    
    // Draw the popup
    
    CGRect popupFrame = CGRectMake(0, 0,self.superview.frame.size.width,self.superview.frame.size.height);
    
    taskPopupDetail *popup = [[taskPopupDetail alloc] initWithFrame:popupFrame];
    
    popup.backgroundColor = [UIColor clearColor];
    
    NSString *hero = [self.taskID stringValue] ;
    
   // popup.taskID = self.taskID ; <- enable this when doing the last edit screen, it crashes
    popup.theme = self.theme ;
    popup.icon = self.icon ;
    popup.title = self.title ;
    popup.date = self.date ;
    popup.notes = self.notes ;
    popup.link = self.link ;
    popup.nodeID = self.nodeID ;
    popup.wtf = hero ;
    
    

    [self.superview addSubview:popup];
    
}

-(void) removePopups {
   
    [delegate removePopups];
    
}

-(void) appLoaderMain {
    
    [delegate appLoader];
    
}

-(void) facebookLoaderMain:(NSString*)post {
    
    [delegate createFacebook:post];
}

-(void) twitterLoaderMain:(NSString*)post {
    
    [delegate createTwitter:post];
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(BOOL) alertUserToObject {
    
    // draw the alert circle
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    
    int taskCounter = 0 ;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        NSNumber *seenalert = [info valueForKey:@"seenalert"] ;
        NSNumber *thisTaskID = [info valueForKey:@"id"] ;
        NSString *date = [info valueForKey:@"time"] ;
        double nodeID = [[info valueForKey:@"node"] doubleValue] ;
        
        if (![date isEqual: @"Anytime"]) {
            
            // Here we convert our date string to a date object
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"cccc, MMM d, hh:mm aa y";
            
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [formatter dateFromString:date];
            
            NSDate *todayDeadline = [NSDate date] ;
            NSDate *thenDeadline = dateFromString ;
            NSComparisonResult result = [todayDeadline compare:thenDeadline];
            
            if ([self.taskID isEqualToNumber:thisTaskID]) {
                if (self.nodeID == nodeID) {
                    if ( result == NSOrderedDescending ) {
                        if ( ([seenalert isEqualToNumber:[NSNumber numberWithInt:0]]) || (seenalert==nil)) {
                            taskCounter++ ;
                        }
                    }
                }
            }
            
        }
        
    }
    
    if (taskCounter>0) {
        
        return YES ;
        
    } else {
        
        return NO;
        
    }
    
    
    
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    
}

- (void) moveEditBoard {
    
    NSNumber* newNumber = self.taskID ;
    
   [delegate editTask:newNumber];
    
}


@end
