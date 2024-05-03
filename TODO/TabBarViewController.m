//
//  TabBarViewController.m
//  TODO
//
//  Created by Mac on 17/04/2024.
//

#import "TabBarViewController.h"
#import "DetailsViewController.h"

@interface TabBarViewController () 


@end

@implementation TabBarViewController
- (IBAction)btnAddTask:(id)sender {
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details_screen"];
    [self.navigationController pushViewController:details animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  self.tabBarController.delegate = self;
    
    
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    if ([viewController isMemberOfClass: [InProgressViewController class]]) {
//        self.tabBarController.navigationItem.rightBarButtonItem.hidden = YES;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
