//
//  WHChooseStyleController.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/6/1.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHChooseStyleController.h"
#import "WHChangeCssColor.h"
#import "UIColor+WHColor.h"
#import "WHColorSelectController.h"

@interface WHChooseStyleController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *styleSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *whiteStyleArray;
@property(nonatomic,strong) NSArray *blackStyleArray;
@property(nonatomic,strong) NSArray *customStyleArray;
@property(nonatomic,assign) NSInteger highlightStyle;
@property(nonatomic,strong) NSMutableArray *colorArray;
@property(nonatomic,strong) WHColorSelectController *colorSelectController;
@property(nonatomic,strong) NSString *filePath;
@end

@implementation WHChooseStyleController
- (IBAction)styleChange:(UISegmentedControl *)sender {
    self.highlightStyle = sender.selectedSegmentIndex+1;
    [[NSUserDefaults standardUserDefaults]setInteger:self.highlightStyle forKey:@"highlightStyle"];
    NSString *path = [[NSBundle mainBundle]resourcePath];
    NSString *path0 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/html/prettify/desert.css"];
    NSString *path1 = [path stringByAppendingPathComponent:@"html/prettify/desert1.css"];
    NSString *path2 = [path stringByAppendingPathComponent:@"html/prettify/desert2.css"];
    NSString *path3 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/html/prettify/desert3.css"];
    NSError *error = nil;
    [self refreshColorList];
//    self.colorArray = [[WHChangeCssColor getCssColorWithPath:path0]mutableCopy];
//    [self.tableView reloadData];
//    if (sender.selectedSegmentIndex == 0) {
//        self.tableView.allowsSelection = NO;
//        
//        NSString *str = [NSString stringWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:&error];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            if (!error) {
//                [str writeToFile:path0 atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            }
//            [self removeCachesAndCookies];
//            self.colorArray = [[WHChangeCssColor getCssColorWithPath:path0]mutableCopy];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        });
//    }else if(sender.selectedSegmentIndex == 1){
//        self.tableView.allowsSelection = NO;
//        NSString *str = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:&error];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            if (!error) {
//                [str writeToFile:path0 atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            }
//            [self removeCachesAndCookies];
//            self.colorArray = [[WHChangeCssColor getCssColorWithPath:path0]mutableCopy];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        });
//    }else {
//        self.tableView.allowsSelection = YES;
//        NSString *str = [NSString stringWithContentsOfFile:path3 encoding:NSUTF8StringEncoding error:&error];
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            if (!error) {
//                [str writeToFile:path0 atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            }
//            [self removeCachesAndCookies];
//            self.colorArray = [[WHChangeCssColor getCssColorWithPath:path0]mutableCopy];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        });
//    }
    if (sender.selectedSegmentIndex < 2) {
        self.tableView.allowsSelection = NO;
        
    }else{
        self.tableView.allowsSelection = YES;
        
    }
//    self.colorArray = [[WHChangeCssColor getCssColorWithPath:path0]mutableCopy];
//    [self.tableView reloadData];
    
}
-(void)removeCachesAndCookies{

    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.styleSegment.selectedSegmentIndex == 2) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *path3 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/html/prettify/desert3.css"];
            
            [WHChangeCssColor changeCssFileAtPath:path3 withArray:self.colorArray];
//            NSError *error = nil;
//            NSString *str = [NSString stringWithContentsOfFile:[self filePath] encoding:NSUTF8StringEncoding error:&error];
//            
//            if (!error) {
//                [str writeToFile:path3 atomically:YES encoding:NSUTF8StringEncoding error:&error];
//            }
        });
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.styleSegment setTitle:NSLocalizedString(@"segment1", nil) forSegmentAtIndex:0];
    [self.styleSegment setTitle:NSLocalizedString(@"segment2", nil) forSegmentAtIndex:1];
    [self.styleSegment setTitle:NSLocalizedString(@"segment3", nil) forSegmentAtIndex:2];
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"highlightStyle"]) {
        self.highlightStyle = [[NSUserDefaults standardUserDefaults]integerForKey:@"highlightStyle"];
    }else{
        self.highlightStyle =2;
        [[NSUserDefaults standardUserDefaults]setInteger:self.highlightStyle forKey:@"highlightStyle"];
    }
    self.styleSegment.selectedSegmentIndex = self.highlightStyle-1;
    [self styleChange:self.styleSegment];
    
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *filePath = [path stringByAppendingPathComponent:@"Preferences/html/prettify/desert.css"];
//
////    self.filePath = filePath;
//    self.colorArray = [[WHChangeCssColor getCssColorWithPath:filePath]mutableCopy];
    [self refreshColorList];
    self.colorSelectController = [[WHColorSelectController alloc]initWithBlock:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)refreshColorList{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *filePath = [path stringByAppendingPathComponent:@"Preferences/html/prettify/desert.css"];
    
    NSInteger style = self.styleSegment.selectedSegmentIndex+1;
    NSString *filePath = [path stringByAppendingPathComponent:@"Preferences/html/prettify"];
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"desert%ld.css",style]];
    self.colorArray = [[WHChangeCssColor getCssColorWithPath:filePath]mutableCopy];
    [self.tableView reloadData];
    
}
-(NSString*)filePath{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"Preferences/html/prettify/desert.css"];
    return filePath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.colorArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"color", nil),indexPath.row +1];
    cell.detailTextLabel.text = self.colorArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"colorA"];
    cell.imageView.backgroundColor=[UIColor colorWithHexColor:cell.detailTextLabel.text];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.styleSegment.selectedSegmentIndex == 2) {
        
        __weak typeof(self)safe = self;
        self.colorSelectController.sendColor = ^(UIColor *selectedColor) {
            safe.colorArray[indexPath.row] = [UIColor hexStringWithColor:selectedColor];
            [safe.tableView reloadData];
        };
        self.colorSelectController.defaultColor = [UIColor colorWithHexColor:self.colorArray[indexPath.row]];
        [self presentViewController:self.colorSelectController animated:YES completion:nil];
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

- (NSMutableArray *)colorArray {
	if(_colorArray == nil) {
		_colorArray = [[NSMutableArray alloc] init];
	}
	return _colorArray;
}

@end
