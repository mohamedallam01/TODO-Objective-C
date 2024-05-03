//
//  DetailsViewController.m
//  TODO
//
//  Created by Mac on 17/04/2024.
//

#import "DetailsViewController.h"
#import "Task.h"
#import "Utils.h"
#import "TodoViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSaveOrEdit;


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlState;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlPriority;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPriority;
@property (weak, nonatomic) IBOutlet UITextView *textViewDesc;
@property (strong, atomic) NSUserDefaults *defaults;
@property TodoViewController *todo;
@property          NSMutableArray *mutableTasks;
@property          NSMutableArray *mutableProgressTasks;

@end

@implementation DetailsViewController
- (IBAction)btnSaveOrEditAction:(id)sender {
    NSString *title = self.textFieldTitle.text;
    NSString *desc = self.textViewDesc.text;
    NSInteger priority = self.segmentedControlPriority.selectedSegmentIndex;
    NSInteger state = self.segmentedControlState.selectedSegmentIndex;
    NSDate *date = self.datePicker.date;
    NSInteger index = self.oldTask.index;
    
    
    self.defaults = [NSUserDefaults standardUserDefaults];

    if (self.isEditingTask) {
        
        Task *newTask = [[Task alloc] init];
        newTask.title = title;
        newTask.desc = desc;
        newTask.priority = priority;
        newTask.state = state;
        newTask.date = date;
        
        NSData *encodedTasksArray = [self.defaults dataForKey:@"Task"];
        NSData *encodedTasksArrayDone = [self.defaults dataForKey:@"doneTask"];
        NSData *encodedTasksArrayProgress = [self.defaults dataForKey:@"progressTask"];
        
        if (encodedTasksArray && encodedTasksArrayDone && encodedTasksArrayProgress) {
            if (self.screenNumber == 0) {
                if (state ==0) {
                   
                    
                    NSMutableArray *tasksArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArray];
                    [tasksArray replaceObjectAtIndex:index withObject:newTask];
                    encodedTasksArray = [NSKeyedArchiver archivedDataWithRootObject:tasksArray];
                    [self.defaults setObject:encodedTasksArray forKey:@"Task"];
                    [self.defaults synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"Updated Successfully");
                }
                else if (state == 1){
                        NSMutableArray *tasksArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArray];
                        NSMutableArray *tasksArrayProgress = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArrayProgress]];
                        [tasksArray removeObjectAtIndex:index];
                        [tasksArrayProgress addObject:newTask];
                        encodedTasksArray = [NSKeyedArchiver archivedDataWithRootObject:tasksArray];
                        [self.defaults setObject:encodedTasksArray forKey:@"Task"];
                        [self.defaults synchronize];
                        encodedTasksArrayProgress = [NSKeyedArchiver archivedDataWithRootObject:tasksArrayProgress];
                        [self.defaults setObject:encodedTasksArrayProgress forKey:@"progressTask"];
                        [self.defaults synchronize];
                        [self.navigationController popViewControllerAnimated:YES];
                        NSLog(@"Updated Successfully");
                    }
                
                else{
                    
                    NSMutableArray *tasksArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArray];
                    NSMutableArray *tasksArrayDone = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArrayDone]];
                    [tasksArray removeObjectAtIndex:index];
                    [tasksArrayDone addObject:newTask];
                    encodedTasksArray = [NSKeyedArchiver archivedDataWithRootObject:tasksArray];
                    [self.defaults setObject:encodedTasksArray forKey:@"Task"];
                    [self.defaults synchronize];
                    encodedTasksArrayDone = [NSKeyedArchiver archivedDataWithRootObject:tasksArrayDone];
                    [self.defaults setObject:encodedTasksArrayDone forKey:@"doneTask"];
                    [self.defaults synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }

                    
                }
            
            else if (self.screenNumber == 1){
                 if (state == 1){
                    NSMutableArray *tasksArrayProgress = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArrayProgress];
                    [tasksArrayProgress replaceObjectAtIndex:index withObject:newTask];
                     encodedTasksArrayProgress = [NSKeyedArchiver archivedDataWithRootObject:tasksArrayProgress];
                    [self.defaults setObject:encodedTasksArrayProgress forKey:@"progressTask"];
                    [self.defaults synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                  
                    }
                
                else{
                    
                    NSMutableArray *tasksArrayProgress = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArrayProgress];
                    NSMutableArray *tasksArrayDone = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArrayDone]];
                    [tasksArrayProgress removeObjectAtIndex:index];
                    [tasksArrayDone addObject:newTask];
                    encodedTasksArrayProgress = [NSKeyedArchiver archivedDataWithRootObject:tasksArrayProgress];
                    [self.defaults setObject:encodedTasksArrayProgress forKey:@"progressTask"];
                    [self.defaults synchronize];
                    encodedTasksArrayDone = [NSKeyedArchiver archivedDataWithRootObject:tasksArrayDone];
                    [self.defaults setObject:encodedTasksArrayDone forKey:@"doneTask"];
                    [self.defaults synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"Updated Successfully");
                    
                }
                
            }else{
                NSMutableArray *tasksArrayDone = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArrayDone];
                [tasksArrayDone replaceObjectAtIndex:index withObject:newTask];
                 encodedTasksArrayDone = [NSKeyedArchiver archivedDataWithRootObject:tasksArrayDone];
                [self.defaults setObject:encodedTasksArrayDone forKey:@"doneTask"];
                [self.defaults synchronize];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
                }
            }
            

            
        
        
       

    

    
    else{
        
        if ([title  isEqual: @""]) {
            [self showEmptyTitleAlert];
        }
        else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save Task?"
                                                                                     message:@"Do you want to save this task?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   
                Task *task = [Task new];
                task.title = title;
                task.desc = desc;
                task.priority = priority;
                task.state = state;
                task.date = date;

                NSData *encodedTasksArray = [self.defaults dataForKey:@"Task"];
                 if (encodedTasksArray) {
                     NSArray *tasksArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasksArray];
                     if (tasksArray && [tasksArray isKindOfClass:[NSArray class]]) {
                         self.mutableTasks = [NSMutableArray arrayWithArray:tasksArray];
                     } else {
                         self.mutableTasks = [NSMutableArray array];
                     }
                 } else {
                     self.mutableTasks = [NSMutableArray array];
                 }
                [self.mutableTasks addObject:task];
                encodedTasksArray = [NSKeyedArchiver archivedDataWithRootObject:self.mutableTasks];
                   [self.defaults setObject:encodedTasksArray forKey:@"Task"];
                   [self.defaults synchronize];
                [self.navigationController popViewControllerAnimated:YES];
                NSLog(@"Saved Successfully");
                                                               }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            
            [alertController addAction:saveAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.textViewDesc.layer.cornerRadius = 5.0;
    
    
    
        if (self.isEditingTask) {
        [self.btnSaveOrEdit setTitle:@"Edit" forState:UIControlStateNormal];
        self.textFieldTitle.text = self.oldTask.title;
        self.textViewDesc.text = self.oldTask.desc;
        self.segmentedControlPriority.selectedSegmentIndex = self.oldTask.priority;
        self.segmentedControlState.selectedSegmentIndex = self.oldTask.state;
        self.datePicker.date = self.oldTask.date;
            
            [self.segmentedControlState setEnabled:YES forSegmentAtIndex:1];
            [self.segmentedControlState setEnabled:YES forSegmentAtIndex:2];
        
        
        NSInteger priority = _oldTask.priority;
        switch (priority) {
            case 0:
                self.imageViewPriority.image = [Utils lowPriorityImage];
                break;
            case 1:
                self.imageViewPriority.image = [Utils mediumPriorityImage];
                break;
            case 2:
                self.imageViewPriority.image = [Utils highPriorityImage];
                break;
            default:
                self.imageViewPriority.image = [Utils lowPriorityImage];
                break;
        }
        
    }
    else{
        [self.btnSaveOrEdit setTitle:@"Save" forState:UIControlStateNormal];
        [self.segmentedControlState setEnabled:NO forSegmentAtIndex:1];
        [self.segmentedControlState setEnabled:NO forSegmentAtIndex:2];
    

    }
    
    self.datePicker.minimumDate = [NSDate date];


}

- (void)viewWillAppear:(BOOL)animated{
    if (self.screenNumber == 1) {
        [self.segmentedControlState setEnabled:NO forSegmentAtIndex:0];
        NSLog(@"screen number progress: %ld", (long)self.screenNumber);
    }
    else if ([self.segmentedFlag isEqualToString:@"done"]){
        [self.segmentedControlState setEnabled:NO forSegmentAtIndex:0];
        [self.segmentedControlState setEnabled:NO forSegmentAtIndex:1];
        NSLog(@"screen number done: %ld", (long)self.screenNumber);


    }
}

- (void)showEmptyTitleAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:@"Title text field can't be empty."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         [alertController dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
