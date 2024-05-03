//
//  Task.h
//  TODO
//
//  Created by Mac on 17/04/2024.
//

#import <Foundation/Foundation.h>


@interface Task : NSObject<NSCoding>

@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *desc;
@property(nonatomic) NSInteger priority;
@property(nonatomic) NSInteger state;
@property(strong,nonatomic) NSDate *date;
@property NSInteger index;

@end

