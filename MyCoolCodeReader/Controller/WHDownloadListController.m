//
//  WHDownloadListController.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/18.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHDownloadListController.h"
#import "WHDownloadTool.h"
#import "AFNetworking.h"
@interface WHDownloadListController ()
@property(nonatomic,strong) NSArray *downloadArray;
@property(nonatomic,strong) NSArray *progressArray;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation WHDownloadListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(200, 400);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.alpha = 0.8;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshDownload) userInfo:nil repeats:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)refreshDownload{
    self.downloadArray = nil;
    self.progressArray = nil;

    [self.tableView reloadData];
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
    return self.downloadArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"downloadCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor colorWithRed:0.510 green:0.695 blue:1.000 alpha:1.000];
        cell.detailTextLabel.textColor = [UIColor grayColor];
//        cell.accessoryType = UITableViewCellAccessoryDetailButton;
//        [cell.accessoryView addSubview:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"download"]]];
    }
    for (UIView *view in cell.subviews) {
        if (view.tag>=1000) {
            [view removeFromSuperview];
        }
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(cell.frame.size.width-66, 11, 44, 22);
    [button addTarget:self action:@selector(cacelDownload:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:1.000 green:0.520 blue:0.519 alpha:1.000] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitle:NSLocalizedString(@"delete", nil) forState:UIControlStateNormal];
    button.tag = 1000+indexPath.row;
    [cell addSubview:button];
    
    WHDownloadFile *file = self.downloadArray[indexPath.row];
    cell.textLabel.text = file.fileName;
    NSProgress *progress = self.progressArray[indexPath.row];
    switch (file.fileStatus) {
        case READY_TO_DOWNLOAD:
            cell.detailTextLabel.text = @"准备下载";
            break;
        case IS_DOWNLOADING:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%g%%",progress.fractionCompleted*100];
            break;
        case FINISH_DOWNLOAD:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"下载完成"];
    }
    return cell;
}
-(void)cacelDownload:(UIButton*)sender{
    NSInteger index = sender.tag-1000;
    [[WHDownloadTool sharedWHDownloadTool]removeManagerAtIndex:index];
    [[WHDownloadTool sharedWHDownloadTool].progressArray removeObjectAtIndex:index];
    [[WHDownloadTool sharedWHDownloadTool].downloadList removeObjectAtIndex:index];
    self.downloadArray = nil;
    self.progressArray = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];

}
-(void)dealloc{
    [self.timer invalidate];
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

- (NSArray *)progressArray {
	if(_progressArray == nil) {
        _progressArray = [[WHDownloadTool sharedWHDownloadTool]getProgressList];
	}
	return _progressArray;
}

- (NSArray *)downloadArray {
	if(_downloadArray == nil) {
		_downloadArray = [[WHDownloadTool sharedWHDownloadTool]getDownloadList];
	}
	return _downloadArray;
}

@end
