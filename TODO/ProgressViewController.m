//
//  ProgressViewController.m
//  TODO
//
//  Created by Mac on 18/04/2024.
//

#import "ProgressViewController.h"
#import "Task.h"
#import "Utils.h"
#import "DetailsViewController.h"

@interface ProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *progressTableView;
@property NSMutableArray<Task *> *allInProgressTasks;
@property NSArray *decodedTasks;
@property NSUserDefaults *defaults;
@property NSArray *inProgressTasks;

@end

@implementation ProgressViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"Test viewDidLoad");
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self reloadTableViewData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Test numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state == 1"];
    self.inProgressTasks = [self.decodedTasks filteredArrayUsingPredicate:predicate];
    self.allInProgressTasks = [NSMutableArray arrayWithArray:self.inProgressTasks];
    return self.allInProgressTasks.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"progressCell"];
    Task *progressTasks = self.inProgressTasks[indexPath.row];
    NSInteger state = progressTasks.state;
    if (state == 1) {
        cell.textLabel.text = progressTasks.title;
    }
    NSLog(@"progress state: %ld", state);
    NSInteger priority = progressTasks.priority;
    switch (priority) {
        case 0:
            cell.imageView.image = [Utils lowPriorityImage];
            break;
        case 1:
            cell.imageView.image = [Utils mediumPriorityImage];
            break;
        case 2:
            cell.imageView.image = [Utils highPriorityImage];
            break;
        default:
            cell.imageView.image = [Utils lowPriorityImage];
            break;
    }
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.tabBarController.navigationItem.rightBarButtonItem setHidden:YES];
    NSInteger index = 0;
    while (index < _allInProgressTasks.count) {
        if (!_allInProgressTasks[index].state == 1) {
            [_allInProgressTasks removeObjectAtIndex:index];
            [self.progressTableView reloadData];
        } else {
            index++;
            [self reloadTableViewData ];
        }
    }
    
    [self reloadTableViewData];
}

-(void) reloadTableViewData{
    NSData *encodedTasksFromUD = [self.defaults objectForKey:@"progressTask"];
    NSLog(@"Encoded tasks from UserDefaults: %@", encodedTasksFromUD);
    self.decodedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksFromUD];
      self.allInProgressTasks = [NSMutableArray arrayWithArray:self.decodedTasks];
    NSLog(@"Decoded tasks: %@", self.decodedTasks);
    [self.progressTableView reloadData];

}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self handleDeleteActionForRowAtIndexPath:indexPath tableView:tableView];
    }];
  
    return @[deleteAction];
}


- (void)handleDeleteActionForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm Deletion"
                                                                             message:@"Delete this item?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction * _Nonnull action) {
        [self.allInProgressTasks removeObjectAtIndex:indexPath.row];
        // Update self.decodedTasks
        self.decodedTasks = [NSArray arrayWithArray:self.allInProgressTasks];
        // Archive and store updated tasks
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:self.decodedTasks];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedArray forKey:@"progressTask"];
        [defaults synchronize];
        // Delete row from table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *selectedTask = self.decodedTasks[indexPath.row];
    
    DetailsViewController *detailsScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"details_screen"];
    detailsScreen.oldTask = selectedTask;
    detailsScreen.oldTask.index = indexPath.item;
    detailsScreen.isEditingTask = YES;
    detailsScreen.screenNumber = 1;
    detailsScreen.segmentedFlag = @"progress";
    [self.navigationController pushViewController:detailsScreen animated:YES];
    [self.progressTableView reloadData];
    [self reloadTableViewData];
    NSLog(@"Index: %ld",indexPath.item);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
