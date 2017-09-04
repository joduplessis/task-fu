//
//  taskNode.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/14.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "taskNode.h"
#import "addNode.h"
#import "nodeTitleTextInput.h"
#import "colorPallete.h"
#import "imagePallete.h" 

@implementation taskNode {
    float nodeSize ;
    float nodeSizeHeight ;
    float screenSize ;
}


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self checkIfCurrentNode] ;
        self.radius_add = 0;
        
    }
    
    return self;
    
}

- (UIImage *) imageWithSize:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;
    return newImage ;
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
    
    
    screenSize = [UIScreen mainScreen].bounds.size.width ;
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGSize shadowSize = CGSizeMake(0, 0);
    CGContextSetShadow(contex, shadowSize, 5);
    
    // For some reason setNeedsDisplay doesnt clear the images
    
    for (UIImageView* subview in self.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    
    
    
    
    
    
    if ( [UIScreen mainScreen].bounds.size.width > 500 ) {
        
        // IPAD
        // ************************************************************************
        // ************************************************************************
        // ************************************************************************
        // ************************************************************************
        // ************************************************************************
        
        nodeSize = 500 ;
        nodeSizeHeight = 1000 ;
        
        UIFont *gothamBold = [UIFont fontWithName:@"Gotham-Bold" size:25];
        UIFont *gothamBoldSmall = [UIFont fontWithName:@"Gotham-Bold" size:23];
        UIFont *gothamBook = [UIFont fontWithName:@"Gotham-Book" size:13];
        
        UIGraphicsPushContext(contex);
        
        NSString *titleText = self.heading ;
        
        int radius = ( nodeSize-100 ) / 2 ;
        
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
        
        // Draw the circle
        
        CGContextBeginPath(contex);
        CGContextSetLineWidth(contex, 8.0);
        CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"f6f6ee"].CGColor);
        
        UIColor *myPattern = [UIColor colorWithPatternImage:[self imageWithSize:[UIImage imageNamed:self.background] scaledToSize:CGSizeMake(320*2, 568*2)]];
        
        CGColorRef color = [myPattern CGColor] ;
        CGColorSpaceRef colorSpace = CGColorGetColorSpace(color);
        CGContextSetFillColorSpace(contex, colorSpace) ;
        CGFloat alpha = 1.0f ;
        CGContextSetFillPattern(contex, CGColorGetPattern(color), &alpha);
        
        CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor);
        CGContextAddArc(contex, nodeSize/2, screenSize/2, radius-10, 0, 2*M_PI, YES);
        CGContextDrawPath(contex, kCGPathFillStroke);
        
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
                
                if (self.taskNodeID == nodeID) {
                    if ( result == NSOrderedDescending ) {
                        if ( (seenalert==[NSNumber numberWithInt:0]) || (seenalert==nil)) {
                            taskCounter++ ;
                        }
                    }
                }
                
            }
            
        }
        
        if (taskCounter!=0) {
            
            
            CGContextBeginPath(contex);
            CGContextSetLineWidth(contex, 2);
            CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"aa0000"].CGColor);
            CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor);
            CGContextAddArc(contex, 400, 270, 25, 0, 2*M_PI, YES);
            CGContextDrawPath(contex, kCGPathFillStroke);
            
            CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"ffffff"].CGColor);
            
            UIFont *gothamBoldSmallA = [UIFont fontWithName:@"Gotham-Bold" size:20];
            CGRect alertBox = CGRectMake(0,0,40, 40);
            alertBox.origin.x = 380 ;
            alertBox.origin.y = 261;
            NSNumber *alertNumber = [NSNumber numberWithInt:taskCounter] ;
            NSString *alertString = [alertNumber stringValue];
            [alertString drawInRect:alertBox withFont:gothamBoldSmallA lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
            
            
            
            
        }
        
        
        // --------------------------------------------------------------------------
        // --------------------------------------------------------------------------
        // --------------------------------------------------------------------------
        
        // Draw the text
        
        CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(contex, transform);
        if ( ![self.theme isEqualToString:@"darkgrey"] ) {
            CGContextSetFillColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor);
        } else {
            CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"666666"].CGColor);
        }
        CGContextSetLineWidth(contex, 10.0);
        CGContextSetCharacterSpacing(contex, 0);
        CGContextSetTextDrawingMode(contex, kCGTextFill);
        
        CGRect titleBoxSmall = CGRectMake(0,625,nodeSize, 400);
        [titleText drawInRect:titleBoxSmall withFont:gothamBoldSmall lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
        
        CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"7e7567"].CGColor);
        
        
        
        int number = [self getTaskNumber] ;
        
        NSString *alertText;
        
        if (number==0) {
            alertText = [NSString stringWithFormat:@" There are no tasks in this board.", number] ;
        } else if (number==1) {
            alertText = [NSString stringWithFormat:@" There is %i task in this board.", number] ;
        } else {
            alertText = [NSString stringWithFormat:@" There are %i tasks in this board.", number] ;
        }
        
        CGRect alertTextBox = CGRectMake(0,655,nodeSize, 400);
        [alertText drawInRect:alertTextBox withFont:gothamBook lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
        
        
        
        // edit icon
        
        UIImage *iconEdit = [UIImage imageNamed:@"title.png"];
        UIImageView *iconEditObject = [[UIImageView alloc] initWithImage:iconEdit] ;
        iconEditObject.frame = CGRectMake(0,0,30,30);
        iconEditObject.center = CGPointMake(150,750);
        [iconEditObject setUserInteractionEnabled:YES];
        UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapping:)];
        [editTap setNumberOfTapsRequired:1];
        [iconEditObject addGestureRecognizer:editTap];
        [self addSubview:iconEditObject] ;
        
        CGAffineTransform transforma = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(contex, transforma);
        CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"ffffff"].CGColor);
        CGContextSetLineWidth(contex, 10.0);
        CGContextSetCharacterSpacing(contex, 0);
        CGContextSetTextDrawingMode(contex, kCGTextFill);
        
        // color icon
        
        UIImage *iconColor = [UIImage imageNamed:@"color.png"];
        UIImageView *iconColorObject = [[UIImageView alloc] initWithImage:iconColor] ;
        iconColorObject.frame = CGRectMake(0,0,30,30);
        iconColorObject.center = CGPointMake(216,750);
        [iconColorObject setUserInteractionEnabled:YES];
        UITapGestureRecognizer *colorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapping:)];
        [colorTap setNumberOfTapsRequired:1];
        [iconColorObject addGestureRecognizer:colorTap];
        [self addSubview:iconColorObject] ;
        
        // background icon
        
        UIImage *iconBackground = [UIImage imageNamed:@"background.png"];
        UIImageView *iconBackgroundObject = [[UIImageView alloc] initWithImage:iconBackground] ;
        iconBackgroundObject.frame = CGRectMake(0,0,30,30);
        iconBackgroundObject.center = CGPointMake(282,750);
        [iconBackgroundObject setUserInteractionEnabled:YES];
        UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapping:)];
        [backgroundTap setNumberOfTapsRequired:1];
        [iconBackgroundObject addGestureRecognizer:backgroundTap];
        [self addSubview:iconBackgroundObject] ;
        
        // delete icon
        
        UIImage *iconDelete = [UIImage imageNamed:@"delete.png"];
        UIImageView *iconDeleteObject = [[UIImageView alloc] initWithImage:iconDelete] ;
        iconDeleteObject.frame = CGRectMake(0,0,30,30);
        iconDeleteObject.center = CGPointMake(350,750);
        [iconDeleteObject setUserInteractionEnabled:YES];
        UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTapping:)];
        [deleteTap setNumberOfTapsRequired:1];
        [iconDeleteObject addGestureRecognizer:deleteTap];
        [self addSubview:iconDeleteObject] ;
        
        UIGraphicsPopContext();
        
        
        
    } else {
        
        // IPHONE
        // ************************************************************************
        // ************************************************************************
        // ************************************************************************
        // ************************************************************************
        // ************************************************************************
        
        nodeSize = 300 ;
        nodeSizeHeight = 500 ;
        
        UIFont *gothamBold = [UIFont fontWithName:@"Gotham-Bold" size:20];
        UIFont *gothamBoldSmall = [UIFont fontWithName:@"Gotham-Bold" size:18];
        UIFont *gothamBook = [UIFont fontWithName:@"Gotham-Book" size:10];
        
        UIGraphicsPushContext(contex);
        
        NSString *titleText = self.heading ;
        
        int radius = ( nodeSize-100 ) / 2 ;
        
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
        
        // Draw the circle
        
        CGContextBeginPath(contex);
        CGContextSetLineWidth(contex, 8.0);
        CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"f6f6ee"].CGColor);
        
        UIColor *myPattern = [UIColor colorWithPatternImage:[self imageWithSize:[UIImage imageNamed:self.background] scaledToSize:CGSizeMake(320*2, 568*2)]];
        
        CGColorRef color = [myPattern CGColor] ;
        CGColorSpaceRef colorSpace = CGColorGetColorSpace(color);
        CGContextSetFillColorSpace(contex, colorSpace) ;
        CGFloat alpha = 1.0f ;
        CGContextSetFillPattern(contex, CGColorGetPattern(color), &alpha);
        
        CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor);
        CGContextAddArc(contex, nodeSize/2, screenSize/2, radius-10, 0, 2*M_PI, YES);
        CGContextDrawPath(contex, kCGPathFillStroke);
        
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
                
                if (self.taskNodeID == nodeID) {
                    if ( result == NSOrderedDescending ) {
                        if ( (seenalert==[NSNumber numberWithInt:0]) || (seenalert==nil)) {
                            taskCounter++ ;
                        }
                    }
                }
                
            }
            
        }
        
        if (taskCounter!=0) {
            
            CGContextBeginPath(contex);
            CGContextSetLineWidth(contex, 2);
            CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"aa0000"].CGColor);
            CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor);
            CGContextAddArc(contex, 220, 100, 18, 0, 2*M_PI, YES);
            CGContextDrawPath(contex, kCGPathFillStroke);
            
            CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"ffffff"].CGColor);
            
            UIFont *gothamBoldSmallA = [UIFont fontWithName:@"Gotham-Bold" size:18];
            CGRect alertBox = CGRectMake(0,0,40, 40);
            alertBox.origin.x = 200 ;
            alertBox.origin.y = 91;
            NSNumber *alertNumber = [NSNumber numberWithInt:taskCounter] ;
            NSString *alertString = [alertNumber stringValue];
            [alertString drawInRect:alertBox withFont:gothamBoldSmallA lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
            
        }
        
        
        // --------------------------------------------------------------------------
        // --------------------------------------------------------------------------
        // --------------------------------------------------------------------------
        
        // Draw the text
        
        CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(contex, transform);
        if ( ![self.theme isEqualToString:@"darkgrey"] ) {
            CGContextSetFillColorWithColor(contex, [self colorWithHexString:userHexForTheme].CGColor);
        } else {
            CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"666666"].CGColor);
        }
        CGContextSetLineWidth(contex, 10.0);
        CGContextSetCharacterSpacing(contex, 0);
        CGContextSetTextDrawingMode(contex, kCGTextFill);
        
        CGRect titleBoxSmall = CGRectMake(0,310,nodeSize, 435);
        [titleText drawInRect:titleBoxSmall withFont:gothamBoldSmall lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
        
        CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"7e7567"].CGColor);
        
        
        
        int number = [self getTaskNumber] ;
        
        NSString *alertText;
        
        if (number==0) {
            alertText = [NSString stringWithFormat:@" There are no tasks in this board.", number] ;
        } else if (number==1) {
            alertText = [NSString stringWithFormat:@" There is %i task in this board.", number] ;
        } else {
            alertText = [NSString stringWithFormat:@" There are %i tasks in this board.", number] ;
        }
        
        CGRect alertTextBox = CGRectMake(0,330,nodeSize, 440);
        [alertText drawInRect:alertTextBox withFont:gothamBook lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter] ;
        
        
        
        // edit icon
        
        UIImage *iconEdit = [UIImage imageNamed:@"title.png"];
        UIImageView *iconEditObject = [[UIImageView alloc] initWithImage:iconEdit] ;
        iconEditObject.frame = CGRectMake(0,0,30,30);
        iconEditObject.center = CGPointMake(75,440);
        [iconEditObject setUserInteractionEnabled:YES];
        UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapping:)];
        [editTap setNumberOfTapsRequired:1];
        [iconEditObject addGestureRecognizer:editTap];
        [self addSubview:iconEditObject] ;
        
        CGAffineTransform transforma = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(contex, transforma);
        CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"ffffff"].CGColor);
        CGContextSetLineWidth(contex, 10.0);
        CGContextSetCharacterSpacing(contex, 0);
        CGContextSetTextDrawingMode(contex, kCGTextFill);
        
        // color icon
        
        UIImage *iconColor = [UIImage imageNamed:@"color.png"];
        UIImageView *iconColorObject = [[UIImageView alloc] initWithImage:iconColor] ;
        iconColorObject.frame = CGRectMake(0,0,30,30);
        iconColorObject.center = CGPointMake(125,440);
        [iconColorObject setUserInteractionEnabled:YES];
        UITapGestureRecognizer *colorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapping:)];
        [colorTap setNumberOfTapsRequired:1];
        [iconColorObject addGestureRecognizer:colorTap];
        [self addSubview:iconColorObject] ;
        
        // background icon
        
        UIImage *iconBackground = [UIImage imageNamed:@"background.png"];
        UIImageView *iconBackgroundObject = [[UIImageView alloc] initWithImage:iconBackground] ;
        iconBackgroundObject.frame = CGRectMake(0,0,30,30);
        iconBackgroundObject.center = CGPointMake(175,440);
        [iconBackgroundObject setUserInteractionEnabled:YES];
        UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapping:)];
        [backgroundTap setNumberOfTapsRequired:1];
        [iconBackgroundObject addGestureRecognizer:backgroundTap];
        [self addSubview:iconBackgroundObject] ;
        
        // delete icon
        
        UIImage *iconDelete = [UIImage imageNamed:@"delete.png"];
        UIImageView *iconDeleteObject = [[UIImageView alloc] initWithImage:iconDelete] ;
        iconDeleteObject.frame = CGRectMake(0,0,30,30);
        iconDeleteObject.center = CGPointMake(225,440);
        [iconDeleteObject setUserInteractionEnabled:YES];
        UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTapping:)];
        [deleteTap setNumberOfTapsRequired:1];
        [iconDeleteObject addGestureRecognizer:deleteTap];
        [self addSubview:iconDeleteObject] ;
        
        UIGraphicsPopContext();
        
    }
    
    

    

    
    
    [self checkIfCurrentNode] ;
    
}

- (int) getTaskNumber {
    
    int count =0 ;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        // start of the object pulled out of data
        
        if ( [[info valueForKey:@"node"] doubleValue] == self.taskNodeID ) {
            count++;
        }
    }
    
    return count ;
    
}

    


-(void)checkIfCurrentNode {
    
    int radius = nodeSize/2 + self.radius_add ;
    
    for (UIView* subview in self.subviews) {
        if ( [subview isKindOfClass:[UIImageView class]] ) {
            subview.hidden = YES ;
        }
    }
    
    if (self.frame.origin.x == ( [UIScreen mainScreen].bounds.size.width / 2 - radius ) ) {
        for (UIView* subview in self.subviews) {
            if ( [subview isKindOfClass:[UIImageView class]] ) {

                
                    subview.alpha = 0   ;
                subview.hidden = NO ;
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.5];
                    [UIView setAnimationDelay:0];
                    subview.alpha = 1 ;
                    [UIView commitAnimations];
                    
                    for (addNode* subvieww in self.superview.subviews) {
                        if ( [subvieww isKindOfClass:[addNode class]] ) {
                            subvieww.centerObject = self.taskNodeIDOrder ;
                            [subvieww makeTheCenterObjectCenterOnStage];
                        }
                    }
                
                
            }
        }
    }
}




-(void)editTapping:(UIGestureRecognizer *)recognizer {
    
    CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width,44 );
    nodeTitleTextInput *input = [[nodeTitleTextInput alloc] initWithFrame: frame];
    input.taskNodeID = self.taskNodeID ;
    
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
    [UIView commitAnimations];

    [self.superview addSubview:input];
    
}

-(void)colorTapping:(UIGestureRecognizer *)recognizer {
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,44 );
    colorPallete *colors = [[colorPallete alloc] initWithFrame: frame];
    colors.taskNodeID = self.taskNodeID ;
    colors.current = self.theme ;

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
    [UIView commitAnimations];
    
    
    
    

    [self clearModules] ;
    [self.superview addSubview:colors];
    
}

-(void)backgroundTapping:(UIGestureRecognizer *)recognizer {
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width,150 );
    imagePallete *images = [[imagePallete alloc] initWithFrame: frame];
    images.taskNodeID = self.taskNodeID ;
    images.current = self.background ;
    
    
    
    
    
    
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
    [UIView commitAnimations];
    
    
    
    
    [self clearModules] ;
    [self.superview addSubview:images];
    
}

-(void) clearModules {
    
    for (colorPallete* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[colorPallete class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
    for (imagePallete* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[imagePallete class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
}

- (void)moveRight {
    CGRect frame = self.frame;
    frame.origin.x += screenSize / 2 ;
    self.frame = frame;
    [self checkIfCurrentNode] ;
}

-(void) moveLeft {
    CGRect frame = self.frame;
    frame.origin.x -= screenSize / 2 ;
    self.frame = frame;
    [self checkIfCurrentNode] ;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void) deleteTasks {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    int val = 0 ;
    
    for (NSManagedObject *info in tasks) {
        double temp = [[info valueForKey:@"node"] doubleValue] ;
        if (self.taskNodeID == temp) {
            val++ ;
            [managedObjectContext deleteObject:info];
        }
    }
    
    NSLog(@"%i were deleted", val) ;
    
    NSError *saveError = nil;
    
    [managedObjectContext save:&saveError];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0){
        
        // Core Data deleting - delete the object with the same id as this node
        
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Node"];
        NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        
        for (NSManagedObject *info in tasks) {
            
            double temp = [[info valueForKey:@"id"] doubleValue] ;
            if (self.taskNodeID == temp) {
                
                // now that we've deleted the node, we need to go through the
                // tasks and delete everything so we dont clog memory
                
                [self deleteTasks] ;
                [managedObjectContext deleteObject:info];
                

            }
            
        }
        
        NSError *saveError = nil;
        
        [managedObjectContext save:&saveError];
        
        // removing from the stage
        
        for (taskNode* subview in self.superview.subviews) {
            if ([subview isKindOfClass:[taskNode class]]) {
                if ( subview.taskNodeIDOrder > self.taskNodeIDOrder ) {
                    
                    CGRect frame = subview.frame;
                    
                    frame.origin.x = frame.origin.x ;
                    
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5];
                    [UIView setAnimationDelay:0];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                    
                    frame.origin.x = frame.origin.x - screenSize ;
                    subview.frame = frame;
                    
                    [UIView commitAnimations];
                    
                    [subview checkIfCurrentNode] ;
                    
                }
            }
        }
        
        for (UIView* subview in self.superview.subviews) {
            if ([subview isKindOfClass:[addNode class]]) {
                
                CGRect frame = subview.frame;
                
                frame.origin.x = frame.origin.x ;
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationDelay:0];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                
                frame.origin.x = frame.origin.x - screenSize ;
                subview.frame = frame;
                
                [UIView commitAnimations];
                
            }
        }
        
        [self removeFromSuperview];
    }
}

-(void)deleteTapping:(UIGestureRecognizer *)recognizer {
    
    
    
    
    
    
    
    
    
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
    [UIView commitAnimations];
    
    
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                    message:@"You won't get them back."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Nope", nil];
    
    [alert show];
    
    
}

@end
