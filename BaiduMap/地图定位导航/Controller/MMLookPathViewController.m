//
//  MMLookPathViewController.m
//  happyDot
//
//  Created by MM on 17/4/14.
//
//

#import "MMLookPathViewController.h"
#import "MMLoopPathTopView.h"
#import "MMLookPathTableViewCell.h"
#import "MMGuidancePathViewController.h"

@interface MMLookPathViewController ()<UITableViewDataSource, UITableViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate,MMLoopPathTopViewDelegate>
@property(nonatomic, strong)MMLoopPathTopView *topView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *pathArr;
@property(nonatomic, strong)BMKLocationService* locService;
@property(nonatomic, strong)BMKRouteSearch* routesearch;
//表示选择的哪个0公交、1开车、2步行
@property(nonatomic, assign)NSInteger type;
@end

@implementation MMLookPathViewController
#pragma mark - 懒加载
- (MMLoopPathTopView *)topView
{
    if (_topView == nil) {
        _topView = [[MMLoopPathTopView alloc] initWithFrame:CGRectMake(0, 64, ViewWidth, 150)];
        _topView.delegate = self;
    }
    return _topView;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+150, ViewWidth, ViewHight-64-150) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSMutableArray *)pathArr
{
    if (_pathArr == nil) {
        _pathArr = [NSMutableArray array];
    }
    return _pathArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //默认公交
    _type = 0;
    
    [self setupNav];
    
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.tableView];
    
    [self getLocation];
    [self getPath];
    
}

- (void)getLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
- (void)getPath
{
    _routesearch = [[BMKRouteSearch alloc]init];
}
- (void)setupNav
{
    [self.navigationController setTitle:@"查看路线"];
//    [naBar setTitle:@"查看路线" withColor:[UIColor whiteColor]];
//    naBar.backgroundColor=RGB(255, 163, 0);
//    //左侧button
//    UIButton *backBtn = [CustomNavigationBar createBtnTitle:nil image:@"35x35(1)" target:self selector:@selector(naviBackBtnAction)];
//    [naBar setLeftBtn:backBtn];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [SharedAppDelegate.tabBar tabBarHiddenYesOrNo:YES];
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;

}

-(void)viewWillDisappear:(BOOL)animated {
    _locService.delegate = nil;
    _routesearch.delegate = nil; // 不用时，置nil
}
#pragma mark 返回
-(void)naviBackBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource\delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pathArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMLookPathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MMLookPathTableViewCell class])];
    if (cell == nil) {
        cell = [[MMLookPathTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MMLookPathTableViewCell class])];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (_type) {
        case 0:
            cell.transitInfo = self.pathArr[indexPath.row];
            break;
        case 1:
            cell.pathText.text = [NSString stringWithFormat:@"线路：%ld", (long)indexPath.row];
            cell.drivingInfo = self.pathArr[indexPath.row];
            break;
        case 2:
            cell.pathText.text = [NSString stringWithFormat:@"线路：%ld", (long)indexPath.row];
            cell.walkingInfo = self.pathArr[indexPath.row];
            break;
        default:
            break;
    }
    cell.LeftNum.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMGuidancePathViewController *guidanceVC = [[MMGuidancePathViewController alloc] init];
    guidanceVC.type = _type;
    switch (_type) {
        case 0:
            guidanceVC.transitPath = self.pathArr[indexPath.row];
            break;
        case 1:
            guidanceVC.drivingPath = self.pathArr[indexPath.row];
            break;
        case 2:
            guidanceVC.walkingPath = self.pathArr[indexPath.row];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:guidanceVC animated:YES];
}
#pragma mark - MMLoopPathTopViewDelegate
- (void)clickTrafficBtnOnMMLoopPathTopView:(MMLoopPathTopView *)view index:(NSInteger)pathIndex start:(NSString *)startAddress end:(NSString *)endAddress
{
    _type = pathIndex;
    switch (pathIndex) {
        case 0:
        {
            [self getTransitPathWithStart:startAddress end:endAddress city:view.cityName];
        }
            break;
        case 1:
        {
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.name = startAddress;
            start.cityName = view.cityName;
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.name = endAddress;
            end.cityName = view.cityName;
            
            BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
            drivingRouteSearchOption.from = start;
            drivingRouteSearchOption.to = end;
            drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
            BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
            if(flag)
            {
                NSLog(@"car检索发送成功");
            }
            else
            {
                NSLog(@"car检索发送失败");
            }

        }
            break;
        case 2:
        {
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.name = startAddress;
            start.cityName = view.cityName;
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.name = endAddress;
            end.cityName = view.cityName;
            
            
            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
            walkingRouteSearchOption.from = start;
            walkingRouteSearchOption.to = end;
            BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
            if(flag)
            {
                NSLog(@"walk检索发送成功");
            }
            else
            {
                NSLog(@"walk检索发送失败");
            }
        }
            break;
        default:
            break;
    }
}
- (void)getTransitPathWithStart:(NSString *)startAddress end:(NSString *)endAddress city:(NSString *)city
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = startAddress;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = endAddress;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= city;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"heading is %@, tittle is %@, subTittle is %@",userLocation.heading,userLocation.title,userLocation.subtitle);
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (placemark != nil) {
                NSDictionary *add = placemark.addressDictionary;
                NSMutableString *startStr = [NSMutableString stringWithFormat:@"%@%@%@", add[@"SubLocality"],add[@"Street"],add[@"Name"]];
                _topView.startStr = startStr;
                _topView.cityName = add[@"City"];
                //找到了当前位置城市后就关闭服务
                [_locService stopUserLocationService];
                [self getTransitPathWithStart:_topView.startStr end:_topView.endAddress.text city:_topView.cityName];
            }
        }
    }];
}
#pragma mark - BMKRouteSearchDelegate

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    DLog(@"Transit%@", result);
    [self.pathArr removeAllObjects];
    [self.pathArr addObjectsFromArray:result.routes];
    [self.tableView reloadData];
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    DLog(@"Driving%@", result);
    [self.pathArr removeAllObjects];
    [self.pathArr addObjectsFromArray:result.routes];
    [self.tableView reloadData];
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    DLog(@"Walking%@", result);
    [self.pathArr removeAllObjects];
    [self.pathArr addObjectsFromArray:result.routes];
    [self.tableView reloadData];
    
}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    DLog(@"Riding%@", result);
}

/**
 *返回公共交通路线检索结果（new）
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKMassTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetMassTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKMassTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    DLog(@"Transit%@", result);
}

- (void)dealloc {
    if (_routesearch != nil) {
        _routesearch = nil;
    }
    if (_locService) {
        _locService = nil;
    }
}
@end
