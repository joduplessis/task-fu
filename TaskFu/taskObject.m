//
//  taskObject.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/04.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "taskObject.h"
#import "taskObjectLines.h"
#import "taskPopup.h"
#import "taskPopupDetail.h"
#import <QuartzCore/QuartzCore.h>

@implementation taskObject

- (void) baseInit
{
    self.radiusOne = 65;
    self.radiusTwo = 30 ;
    self.radiusThree = 20;
    self.lines = NO ;
    dragging = NO ;
}

- (id) initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        [self baseInit] ;
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

-(void) shake {
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setToValue:[NSNumber numberWithFloat:0.0f]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/16]]; // rotation angle
    [anim setDuration:0.1];
    [anim setRepeatCount:NSUIntegerMax];
    [anim setAutoreverses:YES];
    [self.layer addAnimation:anim forKey:@"iconShake"];
    
}

-(void) drawRect:(CGRect)rect
{
    

    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    //CGSize shadowSize = CGSizeMake(0, 0);
    //CGContextSetShadow(contex, shadowSize, 5);
    
    UIGraphicsPushContext(contex);
    
    NSString *dateText = self.date;
    NSString *titleText = self.title ;
    NSString *titleTextSmall = self.title ;
    
    NSString *shortTitle ;
    if (self.title.length >= 6) {
        shortTitle = [self.title substringToIndex:6];
    } else {
        shortTitle = self.title ;
    }
    NSString *dotTitle = [shortTitle stringByAppendingString:@"..."];
    

    NSString *iconNameWhite = self.icon  ;
    NSString *iconColorcode ;
    
    if ([self.theme isEqual: @"blue"]) { iconColorcode = @"b" ; }
    if ([self.theme isEqual: @"brown"]) { iconColorcode = @"br" ; }
    if ([self.theme isEqual: @"darkgrey"]) { iconColorcode = @"dg" ; }
    if ([self.theme isEqual: @"green"]) { iconColorcode = @"g" ; }
    if ([self.theme isEqual: @"pink"]) { iconColorcode = @"p" ; }
    if ([self.theme isEqual: @"purple"]) { iconColorcode = @"pu" ; }
    if ([self.theme isEqual: @"red"]) { iconColorcode = @"r" ; }
    
    if ([self.theme isEqual: @"nyellow"]) { iconColorcode = @"ny" ; }
    if ([self.theme isEqual: @"nred"]) { iconColorcode = @"nr" ; }
    if ([self.theme isEqual: @"npurple"]) { iconColorcode = @"npp" ; }
    if ([self.theme isEqual: @"npink"]) { iconColorcode = @"np" ; }
    if ([self.theme isEqual: @"norange"]) { iconColorcode = @"no" ; }
    if ([self.theme isEqual: @"ngreen"]) { iconColorcode = @"ng" ; }
    if ([self.theme isEqual: @"nblue"]) { iconColorcode = @"nb" ; }
    
    NSString *iconName = [iconColorcode stringByAppendingString:iconNameWhite];
    
    UIFont *gothamBold = [UIFont fontWithName:@"Gotham-Bold" size:15];
    UIFont *gothamBoldSmall = [UIFont fontWithName:@"Gotham-Bold" size:20];
    UIFont *gothamBoldSmall2 = [UIFont fontWithName:@"Gotham-Bold" size:16];
    UIFont *gothamBook = [UIFont fontWithName:@"Gotham-Book" size:10];
    
    if ([self.primeObject integerValue] == [[NSNumber numberWithInt:1] integerValue]) {
        
        
        // For some reason setNeedsDisplay doesnt clear the images
        
        for (UIImageView* subview in self.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                [subview removeFromSuperview];
            }
        }
        
        int radius = self.radiusOne - 5 ;
        
        // Draw the circle
        
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
        
        CGContextBeginPath(contex);

        
        if ([self alertUserToObject] == YES) {
            
            CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor) ;
            
        } else {
            
            CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:@"ee0000"].CGColor) ;
            [self shake] ;
            
        }
    
        CGContextSetFillColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor);
        CGContextSetLineWidth(contex, 5);
        CGContextAddArc(contex, self.radiusOne, self.radiusOne-5, radius-5, 0, 2*M_PI, YES);
        CGContextDrawPath(contex, kCGPathFillStroke);
        
        UIGraphicsPopContext();
        
        CGSize shadowSize = CGSizeMake(0, 0);
        CGContextSetShadow(contex, shadowSize, 5);
        
        // Draw the text
        
        CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(contex, transform);
        CGContextSetRGBFillColor(contex, 1.0, 1.0, 1.0, 1.0);
        CGContextSetLineWidth(contex, 0.0);
        CGContextSetCharacterSpacing(contex, 0);
        CGContextSetTextDrawingMode(contex, kCGTextFill);
        

        CGRect titleBox = CGRectMake(10,self.radiusOne-18,self.radiusOne*2-20, self.radiusOne*2);
        [titleText drawInRect:titleBox withFont:gothamBold lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter] ;
        
        
        if ( [self.date isEqualToString:@"Anytime"] ) {
            
            CGRect timeBox = CGRectMake(0,self.radiusOne*2-33,self.radiusOne*2, self.radiusOne*2);
            [self.date drawInRect:timeBox withFont:gothamBook lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter] ;
            
        } else if ( [self.date isEqualToString:@"ANYTIME"] ) {
            
            CGRect timeBox = CGRectMake(0,self.radiusOne*2-33,self.radiusOne*2, self.radiusOne*2);
            [self.date drawInRect:timeBox withFont:gothamBook lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter] ;
            
        } else {
            
            NSArray *stringArray = [self.date componentsSeparatedByString:@","];
            NSString *first = [stringArray objectAtIndex:0] ;
            
            CGRect timeBox = CGRectMake(0,self.radiusOne*2-33,self.radiusOne*2, self.radiusOne*2);
            [first drawInRect:timeBox withFont:gothamBook lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter] ;
            
        }
        
        
        
        

        
        // Draw the icon
        
        UIImage *iconFile = [UIImage imageNamed:iconNameWhite];
        UIImageView *iconImage = [[UIImageView alloc] initWithImage:iconFile] ;
        iconImage.frame = CGRectMake(0,0,30,30);
        iconImage.center = CGPointMake(self.radiusOne,30);
        [self addSubview:iconImage] ;
        
        
        
        
        
        

        
        
        
    } else {
        
        
        
        
        if ( [self.attachedObjectID isEqualToNumber:[self getPrimeObjectID]] ) {
            
            CGSize shadowSize = CGSizeMake(0, 0);
            CGContextSetShadow(contex, shadowSize, 0);
            
            // For some reason setNeedsDisplay doesnt clear the images
            
            for (UIImageView* subview in self.subviews) {
                if ([subview isKindOfClass:[UIImageView class]]) {
                    [subview removeFromSuperview];
                }
            }
            
            self.transform = CGAffineTransformMakeScale(0.55, 0.55);
         
            int radius = self.radiusOne - 5 ;
            
            // Draw the circle
            
            CGContextBeginPath(contex);
            CGContextSetRGBFillColor(contex, 1, 1, 1, 1.0);
            
            // outline color for alerts
            if ([self alertUserToObject] == YES) {
                CGContextSetRGBStrokeColor(contex, 1, 1, 1, 1) ;
            } else {
                CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:@"ee0000"].CGColor) ;
                [self shake] ;
            }
            
            CGContextAddArc(contex, self.radiusOne, self.radiusOne, radius, 0, 2*M_PI, YES);
            CGContextSetLineWidth(contex, 5);
            CGContextDrawPath(contex, kCGPathFillStroke);
            UIGraphicsPopContext();
            
            
            // Draw the link icon
            
            if ( ![self.link isEqualToString:@""] ) {
                
                UIImage *linkFile = [UIImage imageNamed:@"dgclip.png"];
                UIImageView *linkImage = [[UIImageView alloc] initWithImage:linkFile] ;
                linkImage.frame = CGRectMake(0,0,20,20);
                CGRect linkIcon = linkImage.frame;
                linkIcon.origin.x = self.radiusOne-10 ;
                linkIcon.origin.y = self.radiusOne+37 ;
                linkImage.frame = linkIcon;
                linkImage.alpha = 0.3;
                [self addSubview:linkImage] ;
                
            }
            
            // Draw the text
            
            CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
            CGContextSetTextMatrix(contex, transform);
            CGContextSetRGBFillColor(contex, 0.7, 0.7, 0.7, 1.0);
            CGContextSetLineWidth(contex, 10.0);
            CGContextSetCharacterSpacing(contex, 0);
            CGContextSetTextDrawingMode(contex, kCGTextFill);
            
            if ( [self.date isEqualToString:@"Anytime"] ) {
                
                CGRect titleBoxSmall = CGRectMake(0,self.radiusOne+20,self.radiusOne*2, self.radiusOne*2);
                [self.date  drawInRect:titleBoxSmall withFont:gothamBoldSmall2 lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
                
            } else if ( [self.date isEqualToString:@"Anytime"] ) {
                
                CGRect titleBoxSmall = CGRectMake(0,self.radiusOne+20,self.radiusOne*2, self.radiusOne*2);
                [self.date  drawInRect:titleBoxSmall withFont:gothamBoldSmall2 lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
                
            } else {
                
                NSArray *stringArray = [self.date componentsSeparatedByString:@","];
                NSString *first = [stringArray objectAtIndex:0] ;
                
                CGRect titleBoxSmall = CGRectMake(0,self.radiusOne+23,self.radiusOne*2, self.radiusOne*2);
                [first drawInRect:titleBoxSmall withFont:gothamBoldSmall2 lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
                
            }
            
            // Draw the icon
            
            UIImage *iconFile = [UIImage imageNamed:iconName];
            UIImageView *iconImage = [[UIImageView alloc] initWithImage:iconFile] ;
            iconImage.frame = CGRectMake(0,0,65,65);
            iconImage.center = CGPointMake(self.radiusOne,50);
            [self addSubview:iconImage] ;
            
        } else {
            
            CGSize shadowSize = CGSizeMake(0, 0);
            CGContextSetShadow(contex, shadowSize, 0);
            
            // For some reason setNeedsDisplay doesnt clear the images
            
            for (UIImageView* subview in self.subviews) {
                if ([subview isKindOfClass:[UIImageView class]]) {
                    [subview removeFromSuperview];
                }
            }
            
            self.transform = CGAffineTransformMakeScale(0.4, 0.4);
            
            int radius = self.radiusOne - 5 ;
            
            // Draw the circle
            
            CGContextBeginPath(contex);
            
            // outline color for alerts
            if ([self alertUserToObject] == YES) {
                CGContextSetRGBStrokeColor(contex, 1, 1, 1, 1) ;
            } else {
                CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:@"ee0000"].CGColor) ;
                [self shake] ;
            }
            
            CGContextSetRGBFillColor(contex, 1, 1, 1, 1);
            CGContextAddArc(contex, self.radiusOne, self.radiusOne, radius, 0, 2*M_PI, YES);
            CGContextSetLineWidth(contex, 5);
            CGContextDrawPath(contex, kCGPathFillStroke);
            UIGraphicsPopContext();
            
            if ( ![self.link isEqualToString:@""] ) {
                
                UIImage *linkFile = [UIImage imageNamed:@"dgclip.png"];
                UIImageView *linkImage = [[UIImageView alloc] initWithImage:linkFile] ;
                linkImage.frame = CGRectMake(0,0,30,30);
                CGRect linkIcon = linkImage.frame;
                linkIcon.origin.x = self.radiusOne + 22 ;
                linkIcon.origin.y = self.radiusOne + 18;
                linkImage.frame = linkIcon;
                linkImage.alpha = 0.3;
                [self addSubview:linkImage] ;
                
            }
            
            // Draw the icon
            
            UIImage *iconFile = [UIImage imageNamed:iconName];
            UIImageView *iconImage = [[UIImageView alloc] initWithImage:iconFile] ;
            iconImage.frame = CGRectMake(0,0,65,65);
            iconImage.center = CGPointMake(self.radiusOne,65);
            [self addSubview:iconImage] ;
        }
        
    }
    

    
    

    
    
    
    [self updateLines] ;
    
}

- (void) resizeCreate {
    
    
    
    // start animation for the drag
    
    CGFloat start_x = self.transform.a;
    CGFloat start_y = self.transform.d;
    
    CGAffineTransform start = CGAffineTransformMakeScale(start_x, start_y);
    
    CGFloat end_x = self.transform.a - 0.8;
    CGFloat end_y = self.transform.d - 0.8;
    
    CGAffineTransform end = CGAffineTransformMakeScale(end_x, end_y);
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    self.transform = end;
    [UIView commitAnimations];
    
    // end animation for the drag
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    self.transform = start;
    [UIView commitAnimations];
    
    
    [self setNeedsDisplay] ;
    
    
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
            
            if ([self.thisObjectID isEqualToNumber:thisTaskID]) {
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
    
    if (taskCounter==0) {
        
        return YES ;
        
    } else {
        
        return NO;
        
    }
    
    
    
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    // --------------------------------------------------------------------------
    
}

-(NSNumber*) getPrimeObjectID {
    NSNumber *objectID = [NSNumber numberWithInt:0] ;
    for (taskObject *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskObject class]]) {
            NSLog(@"[NSNumber numberWithInt:1] > %@ ", [NSNumber numberWithInt:1]);
            NSLog(@"subview.primeObject > %@ ", subview.primeObject);
            if ([subview.primeObject integerValue] == [[NSNumber numberWithInt:1] integerValue]) {
                NSLog(@"TRUE");
                objectID = subview.thisObjectID ;
            }
        }
    }
    return objectID ;
}

- (void)updateLines {
    
    for (UIView* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskObjectLines class]]) {
            [subview setNeedsDisplay];
        }
    }
    
}




@end
