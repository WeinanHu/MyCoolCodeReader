//
//  WHWebsiteListController.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/16.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHWebsiteListController.h"
#import "WHWebViewController.h"
@interface WHWebsiteListController ()
@property(nonatomic,strong) NSArray *websArray;
@property(nonatomic,strong) WHWebViewController *webController;
@end

@implementation WHWebsiteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"downloadFromWeb", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"myFile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(goToMyfiles)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goToMyfiles{
    self.tabBarController.selectedIndex = 0;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.websArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"webCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.websArray[indexPath.row];
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.webController = [[WHWebViewController alloc]init];
    self.webController.URL = [NSURL URLWithString:self.websArray[indexPath.row]];
    self.webController.hidesBottomBarWhenPushed = YES;
    self.webController.fromController = self;
    [self.navigationController pushViewController:self.webController animated:YES];
}
-(void)showBackButton{
    if (self.navigationItem.rightBarButtonItem) {
        return;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%@>",NSLocalizedString(@"back", nil)] style:UIBarButtonItemStylePlain target:self action:@selector(backToWeb)];
}
-(void)backToWeb{
    [self.navigationController pushViewController:self.webController animated:YES];
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

- (NSArray *)websArray {
	if(_websArray == nil) {
		_websArray = @[@"https://github.com",@"https://github.com/search"];
	}
	return _websArray;
}

@end
