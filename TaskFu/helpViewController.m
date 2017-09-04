//
//  helpViewController.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/23.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "helpViewController.h"

@interface helpViewController ()

@end

@implementation helpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIFont *gothamBook = [UIFont fontWithName:@"Gotham-Book" size:12];
    UIFont *gothamBoldSmall = [UIFont fontWithName:@"Gotham-Bold" size:12];
    
    [self.description setFont:gothamBook] ;
    [self.link setFont:gothamBoldSmall] ;
    
    self.description.textColor = [self colorWithHexString:@"7e7567"] ;
    self.description.textAlignment = NSTextAlignmentJustified ;
    self.link.textColor = [self colorWithHexString:@"7e7567"] ;
    
    self.logo.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.logo.center.y);
    self.description.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.description.center.y);

    [self.link setUserInteractionEnabled:YES];
    UIGestureRecognizer *linkTap = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(linkTapping:)];
    [self.link addGestureRecognizer:linkTap];
    
}


-(void)linkTapping:(UIGestureRecognizer *)recognizer {
    
    NSURL *url = [NSURL URLWithString:@"http://www.joduplessis.com/"];
    

        
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
        
    }

    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
