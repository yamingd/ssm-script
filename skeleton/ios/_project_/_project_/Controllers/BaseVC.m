//
//  BaseViewController.m
//  _project_
//
//  Created by Yaming on 11/16/15.
//  Copyright © 2015 _project_.com. All rights reserved.
//

#import "BaseVC.h"
#import "UMMobClick/MobClick.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)dealloc
{
    PRINT_DEALLOC
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBarTint];
    
    // set back item title
    [self initUIBarButtonLeft];
    [self initUIBarButtonRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyBorad {
    [self.view endEditing:YES];
}

- (void)initHideKeyBoardEvent{
    LOG(@"initHideKeyBoardEvent");
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBorad)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)configTableView:(UITableView*)tableView bgcolor:(UIColor*)bgcolor{
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, .1f)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, .1f)];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = bgcolor;
    tableView.backgroundView = bgView;
    
    if (tableView.tableFooterView == nil) {
        tableView.tableFooterView = [UIView new];
    }
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

@end
