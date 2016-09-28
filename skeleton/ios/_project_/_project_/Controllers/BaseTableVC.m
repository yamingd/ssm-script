//
//  BaseTableVC.m
//  _project_
//
//  Created by Yaming on 11/16/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import "BaseTableVC.h"
#import "UMMobClick/MobClick.h"

@interface BaseTableVC (){
    UITapGestureRecognizer* tap;
}
@end

@implementation BaseTableVC

- (void)dealloc
{
    if (tap) {
        LOG(@"dealloc gesture recognizer");
        [self.tableView removeGestureRecognizer:tap];
        [self.navigationController.navigationBar removeGestureRecognizer:tap];
    }
    PRINT_DEALLOC
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dataSource == nil) {
        self.dataSource = [NSMutableArray new];
    }
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setNavBarTint];
    
    // set back item title
    [self initUIBarButtonLeft];
    [self initUIBarButtonRight];
    [self initBgView:[self getBgColor]];
    
    [self removeTableViewExtraSpace];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (UIColor*)getBgColor{
    return kViewBGColor;
}

- (void)initHideKeyBoardEvent{
    LOG(@"initHideKeyBoardEvent");
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBorad)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tap];
    
    //[self.navigationController.navigationBar addGestureRecognizer:tap];
}

- (void)hideKeyBorad {
    if (self && self.view) {
        [self.view endEditing:YES];
    }
}

- (void)setSystomGroupTableStyle
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundView = nil;
}

- (void)removeTableViewExtraSpace
{
    if (IOS7_OR_LATER)
    {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, .1f)];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, .1f)];
    }
}

- (void)initBgView:(UIColor*)bgcolor{
    UIView *bgView = [UIView new];
    bgView.backgroundColor = bgcolor;
    self.tableView.backgroundView = bgView;
    
    if (self.tableView.tableFooterView == nil) {
        self.tableView.tableFooterView = [UIView new];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UMeng

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavStyle];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self resetNavStyle];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
