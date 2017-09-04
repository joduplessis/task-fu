//
//  colorPallete.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/15.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "colorPallete.h"
#import "taskNode.h"

@implementation colorPallete

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    for (UIView* subview in self.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
    CGRect frame = CGRectMake(0, 0, self.superview.frame.size.width,44 );

    self.frame = frame;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:frame];
    
    scroll.backgroundColor=[UIColor clearColor];
    scroll.pagingEnabled=YES;
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*1.9, 44);
    scroll.showsHorizontalScrollIndicator=NO;
    
    colors = [NSArray arrayWithObjects:@"blue.png",@"brown.png", @"darkgrey.png",@"green.png", @"pink.png", @"purple.png", @"red.png", @"npurple.png", @"ngreen.png",@"nyellow.png",@"norange.png",@"nred.png",@"npink.png",@"nblue.png",nil];
    
    CGFloat x=0;
    
    for(int i=0;i<14;i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x+0, 0, 44, 44)];
        image.contentMode = UIViewContentModeCenter ;
        UIImage *original = [UIImage imageNamed:[colors objectAtIndex:i]];
        UIImage *scaled = [UIImage imageWithCGImage:[original CGImage] scale:(original.scale*11.5) orientation:(original.imageOrientation)] ;
        
        UITapGestureRecognizer *setColorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setColor:)];
        
        NSString *imageName = [colors objectAtIndex:i];
        NSString *selectedTheme = [[imageName lastPathComponent] stringByDeletingPathExtension] ;
        
        // if iphone
        if ([UIScreen mainScreen].bounds.size.width<500) {
            if ( [selectedTheme isEqualToString:self.current] ) {
                image.backgroundColor = [UIColor darkGrayColor];
                if (i>7) {
                    [scroll setContentOffset:CGPointMake(([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width*1.9)*-1, 0) animated:YES] ;
                } else {
                    [scroll setContentOffset:CGPointMake(i*30, 0) animated:YES] ;
                }
            }
        } else {
            if ( [selectedTheme isEqualToString:self.current] ) {
                image.backgroundColor = [UIColor darkGrayColor];
            }
        }
        
        [setColorTap setNumberOfTapsRequired:1];
        [image addGestureRecognizer:setColorTap];
        [image setImage:scaled];
        [image setTag:i];
        [image setUserInteractionEnabled:YES];
        
        [scroll addSubview:image];
        
        x+=44;
    }
    
    // if ipad
    if ([UIScreen mainScreen].bounds.size.width>500) {
        [scroll setContentOffset:CGPointMake(-80, 0) animated:YES] ;
    }
    
    [self addSubview:scroll];
    [self moveit] ;
    
}

-(void)moveit {
    
    // first we move the thing down
    
    for (UIView* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[colorPallete class]]) {
            CGRect frame = subview.frame;
            frame.origin.y = self.superview.frame.size.height ;
            frame.size.width = self.superview.frame.size.width ;
            subview.frame = frame;
        }
    }
    
    [self setNeedsDisplay] ;
    
    // and then up
    
    for (UIView* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[colorPallete class]]) {
            
            CGRect frame = subview.frame;
            
            frame.origin.y = frame.origin.y ;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            
            frame.origin.y = self.superview.frame.size.height - 44 ;
            subview.frame = frame;
            
            [UIView commitAnimations];
            
        }
    }
    
}

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
    
}

-(void)setColor:(UITapGestureRecognizer *)gesture {
    
    
    
    
    
    
    
    
    
    
    // start animation for the drag
    
    CGFloat start_x = gesture.view.transform.a;
    CGFloat start_y = gesture.view.transform.d;
    
    CGAffineTransform start = CGAffineTransformMakeScale(start_x, start_y);
    
    CGFloat end_x = gesture.view.transform.a - 0.5;
    CGFloat end_y = gesture.view.transform.d - 0.5;
    
    CGAffineTransform end = CGAffineTransformMakeScale(end_x, end_y);
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)gesture.view];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    gesture.view.transform = end;
    [UIView commitAnimations];
    
    // end animation for the drag
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)gesture.view];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    gesture.view.transform = start;
    [UIView commitAnimations];
    
    
    
    
    
    gesture.view.alpha = 0.1 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    gesture.view.alpha = 0.2 ;
    [UIView commitAnimations];
    
    gesture.view.alpha = 0.2 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    gesture.view.alpha = 1.0 ;
    [UIView commitAnimations];
    
    
    
    
    
    
    
    gesture.view.backgroundColor = [UIColor darkGrayColor];
    UIImageView *imageFile = (UIImageView *)gesture.view;
    NSString *imageName = [colors objectAtIndex:imageFile.tag];
    NSString *selectedTheme = [[imageName lastPathComponent] stringByDeletingPathExtension] ;
    

    
    for (taskNode* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskNode class]]) {
            if ( subview.taskNodeID == self.taskNodeID ) {
                
                NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Node"];
                NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                
                for (NSManagedObject *info in tasks) {
                    double temp = [[info valueForKey:@"id"] doubleValue] ;
                    if (self.taskNodeID == temp) {
                        [info setValue:selectedTheme forKey:@"theme"];
                        subview.theme = selectedTheme ;
                    }
                }
                
                NSError *error = nil;
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
                
                [subview setNeedsDisplay] ;
                
            }
        }
    }
    
    gesture.view.alpha = 0.2 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    gesture.view.alpha = 1.0 ;
    [UIView commitAnimations];
    
   [self removeFromSuperview];
    
}


@end
