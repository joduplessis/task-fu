//
//  backgroundCollectionView.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/14.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "backgroundCollectionView.h"

@interface backgroundCollectionView ()

@end

@implementation backgroundCollectionView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	backgrounds = [NSArray arrayWithObjects:@"02.jpg", @"03.jpg", nil] ;
    NSLog(@"%s","ed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return backgrounds.count ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identifier = @"Cell" ;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath] ;
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[backgrounds objectAtIndex:indexPath.row]];                          
    
}

@end
