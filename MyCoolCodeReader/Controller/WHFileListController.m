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
@interface WHFileListController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSArray *filesArray;

@end

@implementation WHFileListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    [self setUpNavigation];
    [self setUpButtons];
    // Do any additional setup after loading the view.
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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:0.241 green:0.293 blue:1.000 alpha:1.000]}];
    self.navigationItem.title = [self.currentPath lastPathComponent];
}

-(void)setUpButtons{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"up" style:UIBarButtonItemStylePlain target:self action:@selector(upFolder)];
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
    NSString *fileImage = file.isDirectory?@"📁":@"📄";
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
        
    }else {
        SourceViewController *sourceController = [[SourceViewController alloc]init];
        sourceController.filePath = file.fileName;
//        NSError *error = nil;
//        NSString *code = [NSString stringWithContentsOfFile:sourceController.filePath encoding:NSUTF8StringEncoding error:&error];
//        [sourceController loadCode:code];
        [self.navigationController pushViewController:sourceController animated:YES];
    }
    
    
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
