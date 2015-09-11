//
//  AddAndShowDataTVC.m
//  PassWord
//
//  Created by 谭伟 on 15/5/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "AddAndShowDataTVC.h"
#import "PwdData.h"
#import "UserDef.h"

@interface AddAndShowDataTVC ()
@property (weak, nonatomic) IBOutlet UITextField *tf_tip;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;
@property (weak, nonatomic) IBOutlet UITextField *tf_acc;

@end

@implementation AddAndShowDataTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.index)
    {
        PassWord *pw = [PwdData data][[self.index unsignedIntegerValue]];
        
        [self.tf_tip setText:pw.tip];
        [self.tf_pwd setText:pw.pwd];
        [self.tf_acc setText:pw.acc];
        [self setTitle:@"修改"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 0)
    {//确定
        if (self.tf_tip.text.length == 0)
        {
            [self.tf_tip becomeFirstResponder];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else if (self.tf_pwd.text.length == 0)
        {
            [self.tf_pwd becomeFirstResponder];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else
        {
            if (!self.index)
            {
                [PwdData AddDataWithTip:self.tf_tip.text
                               PassWord:self.tf_pwd.text
                                Account:self.tf_acc.text];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [PwdData EditDataWithTip:self.tf_tip.text
                                PassWord:self.tf_pwd.text
                                 Account:self.tf_acc.text
                                   Index:[self.index unsignedIntegerValue]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
 
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
