//
//  DoneViewController.m
//  TODO
//
//  Created by Mac on 18/04/2024.
//

#import "DoneViewController.h"
#import "Task.h"
#import "Utils.h"
#import "DetailsViewController.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *doneTableView;
@property NSMutableArray<Task *> *allDoneTasks;
@property NSArray *decodedTasks;
@property NSUserDefaults *defaults;
@property NSArray *doneTasks;

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self reloadTableViewData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state == 2"];
    self.doneTasks = [self.decodedTasks filteredArrayUsingPredicate:predicate];
    self.allDoneTasks = [NSMutableArray arrayWithArray:self.doneTasks];
    return self.allDoneTasks.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneCell"];
    Task *doneTasks = self.doneTasks[indexPath.row];
    NSInteger state = doneTasks.state;
    if (state == 2) {
        cell.textLabel.text = doneTasks.title;
    }
    NSInteger priority = doneTasks.priority;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *selectedTask = self.decodedTasks[indexPath.row];
    
    DetailsViewController *detailsScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"details_screen"];
    detailsScreen.oldTask = selectedTask;
    detailsScreen.oldTask.index = indexPath.item;
    detailsScreen.isEditingTask = YES;
    detailsScreen.screenNumber = 2;
    detailsScreen.segmentedFlag = @"done";
    [self.navigationController pushViewController:detailsScreen animated:YES];
    [self.doneTableView reloadData];
    [self reloadTableViewData];
    NSLog(@"Index: %ld",indexPath.item);
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.tabBarController.navigationItem.rightBarButtonItem setHidden:YES];
    NSInteger index = 0;
    while (index < _allDoneTasks.count) {
        if (!_allDoneTasks[index].state == 2) {
            [_allDoneTasks removeObjectAtIndex:index];
            [self.doneTableView reloadData];
        } else {
            index++;
            [self reloadTableViewData ];
        }
    }
    
    [self reloadTableViewData];
}

-(void) reloadTableViewData{
    NSData *encodedTasksFromUD = [self.defaults objectForKey:@"doneTask"];
    NSLog(@"Encoded tasks from UserDefaults: %@", encodedTasksFromUD);
    self.decodedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksFromUD];
      self.allDoneTasks = [NSMutableArray arrayWithArray:self.decodedTasks];
    NSLog(@"Decoded tasks: %@", self.decodedTasks);
    [self.doneTableView reloadData];

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
        [self.allDoneTasks removeObjectAtIndex:indexPath.row];
        self.decodedTasks = [NSArray arrayWithArray:self.allDoneTasks];
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:self.decodedTasks];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedArray forKey:@"doneTask"];
        [defaults synchronize];
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
