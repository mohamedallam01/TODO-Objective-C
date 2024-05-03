//
//  DetailsViewController.h
//  TODO
//
//  Created by Mac on 17/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property Task *oldTask;
@property BOOL isEditingTask;
@property NSString *segmentedFlag;
@property NSInteger screenNumber;


@end

NS_ASSUME_NONNULL_END
