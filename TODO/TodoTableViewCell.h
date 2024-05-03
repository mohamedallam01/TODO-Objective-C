//
//  TodoTableViewCell.h
//  TODO
//
//  Created by Mac on 17/04/2024.
//

#import <UIKit/UIKit.h>


@interface TodoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *priorityImageView;



@end

