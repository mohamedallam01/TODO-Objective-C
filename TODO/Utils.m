//
//  Utils.m
//  TODO
//
//  Created by Mac on 18/04/2024.
//

#import "Utils.h"
#import "UIKit/UIKit.h"

@implementation Utils

+ (UIImage *)lowPriorityImage {
    return [UIImage imageNamed:@"low-priority-icon"];
}

+ (UIImage *)mediumPriorityImage {
    return [UIImage imageNamed:@"medium-priority-icon"];
}

+ (UIImage *)highPriorityImage {
    return [UIImage imageNamed:@"high-priority-icon"];
}

@end
