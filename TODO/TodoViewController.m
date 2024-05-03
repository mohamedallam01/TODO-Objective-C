//
//  TodoViewController.m
//  TODO
//
//  Created by Mac on 17/04/2024.
//

#import "TodoViewController.h"
#import "DetailsViewController.h"
#import "Task.h"
#import "TodoTableViewCell.h"
#import "Utils.h"

@interface TodoViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *todoSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableViewTodo;
@property NSMutableArray<Task * > *allTodoTasks;
@property NSArray *decodedTasks;
@property NSUserDefaults *defaults;
@property NSMutableArray<Task *>*tempList;
@property  BOOL displaySection;
@end

@implementation TodoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableViewTodo registerNib:[UINib nibWithNibName:@"TodoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.displaySection=YES;
      self.tableViewTodo.dataSource = self;
      self.tableViewTodo.delegate = self;
    self.todoSearchBar.delegate = self;
      self.defaults = [NSUserDefaults standardUserDefaults];
    [self refreshData];
    [self.tableViewTodo reloadData];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.tabBarController.navigationItem.rightBarButtonItem setHidden:NO];
    NSInteger index = 0;
    while (index < _allTodoTasks.count) {
        if (!_allTodoTasks[index].state == 0) {
            [_allTodoTasks removeObjectAtIndex:index];
            [self.tableViewTodo reloadData];
        } else {
            index++;
            [self refreshData ];
        }
    }
    
    [self refreshData];
}
- (IBAction)btnFilter:(id)sender {
    
    self.displaySection=!self.displaySection;
      
        [self.tableViewTodo reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    if(!self.displaySection){
        switch (section) {
            case 0:
                for (Task *task in self.allTodoTasks) {
                    if (task.priority == 0) {
                        rowCount++;
                    }
                }
                break;
            case 1:
                for (Task *task in self.allTodoTasks) {
                    if (task.priority == 1) {
                        rowCount++;
                    }
                }
                break;
            case 2:
                for (Task *task in self.allTodoTasks) {
                    if (task.priority == 2) {
                        rowCount++;
                    }
                }
                break;
            default:
                break;
        }
        return rowCount;
    }
    else{
        return _allTodoTasks.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.displaySection){
        return 1;
    }
    else{
        return 3;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.displaySection) {
        return nil;
    } else {
        switch (section) {
            case 0:
                return @"Low";
            case 1:
                return @"Medium";
            case 2:
                return @"High";
            default:
                return nil;
        }
    }
}
-(void) refreshData{
    NSData *encodedTasksFromUD = [self.defaults objectForKey:@"Task"];
    self.decodedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksFromUD];
  if (self.decodedTasks &&[self.decodedTasks isKindOfClass:[NSArray class]]) {
      self.allTodoTasks = [NSMutableArray arrayWithArray:self.decodedTasks];
  }
    [self.tableViewTodo reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Task *task = self.decodedTasks[indexPath.row];
    NSInteger state = task.state;
    if (state == 0) {
        cell.titleLabel.text = task.title;
    }
    
   

    NSInteger priority = task.priority;
    switch (priority) {
        case 0:
            cell.priorityImageView.image = [Utils lowPriorityImage];
            break;
        case 1:
            cell.priorityImageView.image = [Utils mediumPriorityImage];
            break;
        case 2:
            cell.priorityImageView.image = [Utils highPriorityImage];
            break;
        default:
            cell.priorityImageView.image = [Utils lowPriorityImage];
            break;
    }
    NSLog(@"Title: %@", task.title);

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *selectedTask = self.decodedTasks[indexPath.row];
    
    DetailsViewController *detailsScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"details_screen"];
    detailsScreen.oldTask = selectedTask;
    detailsScreen.oldTask.index = indexPath.item;
    detailsScreen.isEditingTask = YES;
    detailsScreen.screenNumber = 0;
    detailsScreen.segmentedFlag = @"todo";
    [self.navigationController pushViewController:detailsScreen animated:YES];
    [self.tableViewTodo reloadData];
    [self refreshData];
    NSLog(@"Index: %ld",indexPath.item);
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self handleDeleteActionForRowAtIndexPath:indexPath tableView:tableView];
        [self refreshData];
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
        [self.allTodoTasks removeObjectAtIndex:indexPath.row];
        NSLog(@"Index: %ld",indexPath.row);
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:_allTodoTasks];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedArray forKey:@"Task"];
        [defaults synchronize];\
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }];
    
    [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:nil];
    NSLog(@"Index: %ld",indexPath.item);

    [self refreshData];
    
}


-(void) reloadTableViewData{
    NSData *encodedTasksFromUD = [self.defaults objectForKey:@"Task"];
    self.decodedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksFromUD];
  if (self.decodedTasks &&[self.decodedTasks isKindOfClass:[NSArray class]]) {
      self.allTodoTasks = [NSMutableArray arrayWithArray:self.decodedTasks];
  }
    [self.tableViewTodo reloadData];

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length ==0) {
        [self reloadTableViewData];
    }else{
        [self reloadTableViewData];
        _tempList = [NSMutableArray new];
        for (int i = 0; i<_allTodoTasks.count; i++) {
            NSString *temp = _allTodoTasks[i].title.lowercaseString;
            if ([temp containsString:searchText.lowercaseString]) {
                [_tempList addObject: _allTodoTasks[i]];
                NSLog(@"have list of size = %lu",_tempList.count);
            }else{
                NSLog(@"listIsEmpty %lu",_tempList.count);
            }
        }
        _allTodoTasks = [_tempList mutableCopy];
    }
    [self.tableViewTodo reloadData];
   
    
}
@end
