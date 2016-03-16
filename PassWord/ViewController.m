//
//  ViewController.m
//  PassWord
//
//  Created by 谭伟 on 15/5/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "ViewController.h"
#import "UserDef.h"
#import "PwdData.h"
#import "AddAndShowDataTVC.h"
#import <MessageUI/MessageUI.h>
#import "MF_Base64Additions.h"

@interface ViewController ()<UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
MFMailComposeViewControllerDelegate,
UISearchBarDelegate,
UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) PwdData *data;
@property (nonatomic, retain) UISearchBar *searchBar;

@end

@implementation ViewController
-(PwdData*)data
{
    if (!_data)
    {
        _data = [[PwdData alloc] init];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                          target:self
                                                                          action:@selector(editTableView)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                         action:@selector(addRowForTableView)];
    
    [self.navigationItem setRightBarButtonItems:@[add, edit]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DataAdded)
                                                 name:@"NeedRefreshDataView"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)DataAdded
{
    [self.tableView reloadData];
}

-(void)editTableView
{
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

-(void)addRowForTableView
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAndShowDataTVC *vc = [board instantiateViewControllerWithIdentifier:@"AddAndShowDataTVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PwdData pwdList] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tip_cell" forIndexPath:indexPath];
    
    NSInteger index = IndexInPwdList(indexPath.row);
    PassWord *pw = [PwdData data][index];
    
    [cell.textLabel setText:pw.tip];
    [cell.detailTextLabel setText:pw.acc];
    
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAndShowDataTVC *vc = [board instantiateViewControllerWithIdentifier:@"AddAndShowDataTVC"];
    [vc setIndex:[NSNumber numberWithUnsignedInteger:IndexInPwdList(indexPath.row)]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PassWord *pw = [PwdData data][IndexInPwdList(indexPath.row)];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"确认删除？"
                                                     message:pw.tip
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
        [av setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        [av setTag:indexPath.row];
        [av setDelegate:self];
        [av show];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [PwdData moveRow:IndexInPwdList(sourceIndexPath.row)
               ToRow:IndexInPwdList(destinationIndexPath.row)];
}

#pragma mark -滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (!self.tableView.tableHeaderView && offset.y < 0)
    {
        [self initSearchBar];
    }
    else if (offset.y > 0)
    {
        [self.searchBar resignFirstResponder];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView.contentOffset;
    if (self.tableView.tableHeaderView && offset.y <= 0)
    {
        [self.searchBar becomeFirstResponder];
    }
}

#pragma mark -发邮件
- (IBAction)OnSendPwd:(UIBarButtonItem *)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"确认身份"
                                                 message:@""
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定", nil];
    [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [av setTag:-1];
    [av show];
    
    /*
    //添加数据
    NSString *textToShare = @"无数据";
    NSArray *pwdData = [NSKeyedUnarchiver unarchiveObjectWithFile:File_Path(@"com.tmp.catch")];
    if (pwdData)
    {
        NSString *outStr = @"";
        for (PassWord *pw in pwdData)
        {
            outStr = [outStr stringByAppendingString:pw.description];
            outStr = [outStr stringByAppendingString:@"\n"];
        }
        textToShare = [[outStr base64String] base64String];
    }
    
    UIImage *imageToShare = [UIImage imageNamed:@"bg"];
    NSArray *activityItems = @[imageToShare, textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypeOpenInIBooks,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToFacebook,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypePostToTencentWeibo];
    
    WEAK_SELF(weakself);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            STRONG_SELF(weakself, sself);
            //以模态的方式展现activityVC。
            [sself presentViewController:activityVC animated:YES completion:nil];
        });
    });
     */
}

-(void)SendMail
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    [mc setSubject:@"No.007 Comming!"];
    
    [mc setToRecipients:[NSArray arrayWithObjects:@"tanwei.rush@gmail.com", nil]];
//    [mc setCcRecipients:[NSArray arrayWithObject:@"xx"]];
//    [mc setBccRecipients:[NSArray arrayWithObject:@"xx@qq.com"]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [mc setMessageBody:[df stringFromDate:[NSDate date]] isHTML:NO];
    
    // 添加图片bg
    UIImage *addPic = [UIImage imageNamed:@"bg"];
    NSData *imageData = UIImageJPEGRepresentation(addPic, 0.1);
    [mc addAttachmentData:imageData mimeType:@"jpg" fileName:@"TakeCare.jpg"];
    
    //添加附件数据
    NSArray *pwdData = [NSKeyedUnarchiver unarchiveObjectWithFile:File_Path(@"com.tmp.catch")];
    if (pwdData)
    {
        NSString *outStr = @"";
        for (PassWord *pw in pwdData)
        {
            outStr = [outStr stringByAppendingString:pw.description];
            outStr = [outStr stringByAppendingString:@"\n"];
        }
        NSString *base64String = [[outStr base64String] base64String];
        [mc addAttachmentData:[base64String dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"file/catch" fileName:@"No.007_catch"];
    }
    
    [self presentViewController:mc animated:YES completion:^{
    }];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark -搜索
-(void)initSearchBar
{
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 40)];
    bar.placeholder = @"搜索:介绍、帐号";
    bar.delegate = self;
    bar.keyboardType = UIKeyboardTypeASCIICapable;
    [bar setSearchBarStyle:UISearchBarStyleMinimal];
    self.searchBar = bar;
    [self.tableView setTableHeaderView:bar];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        [searchBar setShowsCancelButton:NO animated:YES];
    }
    else
    {
        [searchBar setShowsCancelButton:YES animated:YES];
    }
    [PwdData searchPwdListWithKey:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [PwdData searchPwdListWithKey:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    [self searchBar:searchBar textDidChange:@""];
    [searchBar resignFirstResponder];
    [UIView animateWithDuration:0.333
                     animations:^{
                         [self.tableView setContentOffset:CGPointMake(0.0, 40.0)];
                     }];
}

#pragma mark -alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *tf = [alertView textFieldAtIndex:0];
    if (alertView.tag >= 0 && tf && [tf.text isEqualToString:@"8715"])
    {//删除
        [PwdData DeleteDataAtIndex:IndexInPwdList(alertView.tag)];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    else if (alertView.tag < 0)
    {
        UITextField *tf1 = [alertView textFieldAtIndex:1];
        if (tf1 && [tf.text isEqualToString:@"U"] && [tf1.text isEqualToString:@"f**kshit"])
        {
            [self SendMail];
        }
    }
}
@end
