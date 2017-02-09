//
//  HomePageTableViewController.m
//  cn.com.broadlink.CP
//
//  Created by 白洪坤 on 2017/1/22.
//  Copyright © 2017年 白洪坤. All rights reserved.
//



#import "HomePageTableViewController.h"
#import "ticketsinfo.h"
#import "bhkCommon.h"
#import "PLFiveViewController.h"
#import "kaijiangGet.h"
#import "datainfo.h"
#import <MJRefresh/MJRefresh.h>

@interface HomePageTableViewController ()
@property (nonatomic,strong)NSMutableArray *devicearray;
@property (nonatomic,strong)NSMutableArray *ticketsDataarray;
@end

@implementation HomePageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _devicearray = [[NSMutableArray alloc]init];
    _ticketsDataarray = [[NSMutableArray alloc]init];
    //数组转模型
    NSArray *array = ticketsarray;
    for (int i = 0; i < array.count; i++) {
        ticketsinfo *info = [[ticketsinfo alloc]init];
        info.name = array[i][@"name"];
        info.png = array[i][@"png"];
        info.code = array[i][@"code"];
        [_devicearray addObject:info];
    }
    //刷新
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshDeviceList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshDeviceList
{
    [self reloadTicketsData];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

- (void)reloadTicketsData{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_devicearray];
    for (int i = 0; i < _devicearray.count; i++) {
        ticketsinfo *info = _devicearray[i];
        NSString *string = [NSString stringWithFormat:@"/%@-1.json",info.code];
        NSString *URLString = [baseUrl stringByAppendingString:string];
        kaijiangGet *kaijiangget = [[kaijiangGet alloc]init];
        [kaijiangget apiplus:URLString  completionHandler:^(NSDictionary *dic) {
            ticketsinfo *ticinfo = [[ticketsinfo alloc]init];
            ticinfo = [ticinfo initWithDict:dic];
            info.rows = ticinfo.rows;
            info.dataarray = ticinfo.dataarray;
            [array addObject:info];
        }];
        
    }
    [_devicearray removeAllObjects];
    [_devicearray addObjectsFromArray:array];

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
    return _devicearray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ticketsinfo *info = _devicearray[indexPath.row];
    NSString *CellIdentifier = @"Devicecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    titleLabel.text = info.name;
    UIImageView *ticketsimgeview = (UIImageView *)[cell viewWithTag:105];
    NSString *ticketsimageString = [NSString stringWithFormat:@"%@",info.png];
    ticketsimgeview.image = [UIImage imageNamed:ticketsimageString];
    datainfo *Datainfo = info.dataarray[0];
    UILabel *opencodeLabel = (UILabel *)[cell viewWithTag:102];
    opencodeLabel.text = [NSString stringWithFormat:@"%@",Datainfo.opencode];
    UILabel *expectLabel = (UILabel *)[cell viewWithTag:103];
    expectLabel.text = [NSString stringWithFormat:@"第%@期",Datainfo.expect];
    UILabel *opentimeLabel = (UILabel *)[cell viewWithTag:104];
    opentimeLabel.text =[NSString stringWithFormat:@"开奖时间 %@",Datainfo.opentime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DocumentDetailView"]) {
        UIViewController *target = segue.destinationViewController;
        if ([target isKindOfClass:[PLFiveViewController class]]) {
            PLFiveViewController* deviceVC = (PLFiveViewController *)target;
            deviceVC.hidesBottomBarWhenPushed = YES;
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            ticketsinfo *info = _devicearray[path.row];
            deviceVC.name = info.name;
            deviceVC.code = info.code;
        }
    }
}


@end
