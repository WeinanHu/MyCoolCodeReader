//
//  WHSettingTableViewController.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/30.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHSettingTableViewController.h"
#import "WHChooseStyleController.h"
@interface WHSettingTableViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *helpCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *styleCell;
@property (weak, nonatomic) IBOutlet UISwitch *helpSwitch;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@end

@implementation WHSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpLabel.text = NSLocalizedString(@"showHelpOnce", nil);
    self.styleLabel.text = NSLocalizedString(@"codeHighlightStyle", nil);
    self.navigationItem.title = NSLocalizedString(@"setting", nil);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    BOOL didShowedHelp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isShowedHelp"];
    
    if (didShowedHelp) {
        [self.helpSwitch setOn:NO];
    }else{
        [self.helpSwitch setOn:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.helpCell;
    }else {
        return self.styleCell;
    }
}

- (IBAction)helpSwitchChanged:(UISwitch *)sender {
    
    if (sender.isOn) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isShowedHelp"];
//        [sender setOn:NO animated:YES];
        
    }else{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isShowedHelp"];
//        [sender setOn:YES animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        WHChooseStyleController *chooseContoller = [[WHChooseStyleController alloc]initWithNibName:@"WHChooseStyleController" bundle:nil];
        chooseContoller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chooseContoller animated:YES];
    }
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
