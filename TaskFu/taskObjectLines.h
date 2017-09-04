//
//  taskObjectLines.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/12.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface taskObjectLines : UIView

@property (nonatomic) BOOL lines ;

- (CGPoint) getObjectPoint:(NSNumber*)objectID ;
    
@end
