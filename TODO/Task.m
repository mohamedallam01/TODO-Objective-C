//
//  Task.m
//  TODO
//
//  Created by Mac on 17/04/2024.
//

#import "Task.h"

@implementation Task

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"Title"];
    [coder encodeObject:self.desc forKey:@"Desc"];
    [coder encodeInteger:self.priority forKey:@"Priority"];
    [coder encodeInteger:self.state forKey:@"State"];
    [coder encodeObject:self.date forKey:@"Date"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if ((self = [super init])) {
        self.title= [coder decodeObjectForKey:@"Title"];
        self.desc = [coder decodeObjectForKey:@"Desc"];
        self.priority = [coder decodeIntForKey:@"Priority"];
        self.state = [coder decodeIntForKey:@"State"];
        self.date = [coder decodeObjectForKey:@"Date"];
    }
    return self;
}

@end
