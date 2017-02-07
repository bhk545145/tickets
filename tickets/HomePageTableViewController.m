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

@interface HomePageTableViewController ()
@property (nonatomic,strong)NSMutableArray *devicearray;
@end

@implementation HomePageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _devicearray = [[NSMutableArray alloc]init];
    NSArray *array = ticketsarray;
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
    NSString *CellIdentifier = @"Devicecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    titleLabel.text = _devicearray[indexPath.row][@"name"];
    UIImageView *ticketsimgeview = (UIImageView *)[cell viewWithTag:105];
    NSString *ticketsimageString = [NSString stringWithFormat:@"%@",_devicearray[indexPath.row][@"png"]];
    ticketsimgeview.image = [UIImage imageNamed:ticketsimageString];
    NSString *string = [NSString stringWithFormat:@"/%@-1.json",_devicearray[indexPath.row][@"code"]];
    NSString *URLString = [baseUrl stringByAppendingString:string];
    kaijiangGet *kaijiangget = [[kaijiangGet alloc]init];
    [kaijiangget apiplus:URLString completionHandler:^(NSDictionary *dic) {
        ticketsinfo *info = [[ticketsinfo alloc]init];
        info = [info initWithDict:dic];
        datainfo *Datainfo = [[datainfo alloc]init];
        for (int i = 0;i < info.rows;i++) {
            Datainfo = [Datainfo initWithdata:info.data rows:i];
        }
        UILabel *opencodeLabel = (UILabel *)[cell viewWithTag:102];
        opencodeLabel.text = [NSString stringWithFormat:@"%@",Datainfo.opencode];
        UILabel *expectLabel = (UILabel *)[cell viewWithTag:103];
        expectLabel.text = [NSString stringWithFormat:@"第%@期",Datainfo.expect];
        UILabel *opentimeLabel = (UILabel *)[cell viewWithTag:104];
        opentimeLabel.text =[NSString stringWithFormat:@"开奖时间 %@",Datainfo.opentime];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DocumentDetailView"]) {
        UIViewController *target = segue.destinationViewController;
        if ([target isKindOfClass:[PLFiveViewController class]]) {
            PLFiveViewController* deviceVC = (PLFiveViewController *)target;
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            NSString *name = _devicearray[path.row][@"name"];
            NSString *code = _devicearray[path.row][@"code"];
            deviceVC.name = name;
            deviceVC.code = code;
        }
    }
}


@end
