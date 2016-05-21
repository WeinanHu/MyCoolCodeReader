//
//  WHFileListController.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/14.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHFileListController.h"
#import "WHFileListTool.h"
#import "SourceViewController.h"
#import "ZipArchive.h"
#import "MBProgressHUD+KR.h"
@interface WHFileListController ()<UITableViewDataSource,UITableViewDelegate,SSZipArchiveDelegate>
@property(nonatomic,strong) NSArray *filesArray;
@property(nonatomic,strong) WHFile *unZipFile;

@end

@implementation WHFileListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    [self setUpNavigation];
    if(self.index >0){
        [self setUpButtons];
    }
    // Do any additional setup after loading the view.
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"filesArray"]) {
        
//        self.filesArray = change[@"new"];
        [self.tableView reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.filesArray = nil;
    [self.tableView reloadData];
    [self addObserver:self forKeyPath:@"filesArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self removeObserver:self forKeyPath:@"filesArray"];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"%f",[UIScreen mainScreen ].bounds.size.width);
    self.tableView.frame = [UIScreen mainScreen].bounds;
    
}

-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(void)setUpNavigation{
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:0.241 green:0.293 blue:1.000 alpha:1.000]}];
    self.navigationItem.title = [self.currentPath lastPathComponent];
}

-(void)setUpButtons{
    NSString *upStr = NSLocalizedString(@"folderUp", nil);
    UIBarButtonItem *barButton =[[UIBarButtonItem alloc]initWithTitle:upStr style:UIBarButtonItemStylePlain target:self action:@selector(upFolder)];
    [barButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButton;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editFile)];
    
}
-(void)upFolder{
    if (self.index == 0) {
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        self.index--;
    }
}
-(void)editFile{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filesArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"fileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    WHFile *file = self.filesArray[indexPath.row];
    NSString *fileImage = file.isDirectory?@"📁":([file.fileName.pathExtension isEqualToString:@"zip"]?@"📚":@"📄");
    cell.textLabel.text = [fileImage stringByAppendingString:[file.fileName lastPathComponent]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WHFile *file = self.filesArray[indexPath.row];
    if (file.isDirectory) {
        WHFileListController *fileListController = [WHFileListController new];
        
        fileListController.index = self.index+1;
        fileListController.currentPath = file.fileName;
        
        [self.navigationController pushViewController:fileListController animated:YES];
        
    }else if([[file.fileName pathExtension]isEqualToString:@"zip"]){
        
        self.unZipFile = file;
        NSString *info =[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"unZip", nil),file.fileName.lastPathComponent];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:info message:NSLocalizedString(@"unZipTheFile", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), NSLocalizedString(@"yesAndCreateFolder", nil),nil];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        [alertView show];
        
    }else {
        SourceViewController *sourceController = [[SourceViewController alloc]init];
        sourceController.filePath = file.fileName;
//        NSError *error = nil;
//        NSString *code = [NSString stringWithContentsOfFile:sourceController.filePath encoding:NSUTF8StringEncoding error:&error];
//        [sourceController loadCode:code];
        sourceController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sourceController animated:YES];
    }
    
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WHFile *file =self.filesArray[indexPath.row];
        NSString *filePath = file.fileName;
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            self.filesArray = nil;
//            [self.tableView reloadData];
        }
    }
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    WHFile *file = self.unZipFile;
    NSString *fileDirectory = [file.fileName stringByDeletingLastPathComponent];
    switch (buttonIndex) {
        case 0:
            NSLog(@"cancel zip");
            break;
        case 1:
            [SSZipArchive unzipFileAtPath:file.fileName toDestination:fileDirectory delegate:self];
            break;
        default:
            fileDirectory = [fileDirectory stringByAppendingPathComponent:[file.fileName stringByDeletingPathExtension].lastPathComponent];
            [SSZipArchive unzipFileAtPath:file.fileName toDestination:fileDirectory delegate:self];
            
            break;
    }
    
}
#pragma mark - SSZipArchiveDelegate

-(void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo{
    NSLog(@"-------%ld%ld%ld",zipInfo.number_entry,zipInfo.number_disk_with_CD,zipInfo.size_comment);
    
}
-(void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total{
    NSLog(@"%f",1.0*loaded/total);
}
-(void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath{
    NSLog(@"+++%ld%ld%ld",zipInfo.number_entry,zipInfo.number_disk_with_CD,zipInfo.size_comment);
    [MBProgressHUD showSuccess:@"zip finished"];
    self.filesArray = nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *)filesArray {
	if(_filesArray == nil) {
		_filesArray = [[WHFileListTool shareFileListTool]getFilesAtPath:self.currentPath];
	}
	return _filesArray;
}



@end
