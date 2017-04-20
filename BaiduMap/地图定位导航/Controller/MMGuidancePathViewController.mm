//
//  MMGuidancePathViewController.m
//  happyDot
//
//  Created by MM on 17/4/14.
//
//

#import "MMGuidancePathViewController.h"
#import "MMGuidancePathDetailTableView.h"

#import "RouteAnnotation.h"
#import <BaiduMapAPI_Base/BMKTypes.h>


@interface MMGuidancePathViewController ()<BMKMapViewDelegate>
//地图
@property(nonatomic, strong)BMKMapView* mapView;
//返回按钮
@property(nonatomic, strong)UIButton *leftBtn;

@property(nonatomic, strong)MMGuidancePathDetailTableView *tableView;
@end

@implementation MMGuidancePathViewController
#pragma mark - 懒加载
- (BMKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHight)];
        _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        [_mapView setZoomLevel:15];
    }
    return _mapView;
}
-(UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 28, 35, 35)];
        [_leftBtn setImage:[UIImage imageNamed:@"35x35(1)"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(naviBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.backgroundColor = [UIColor blackColor];
        _leftBtn.alpha = 0.4;
        _leftBtn.layer.cornerRadius = 17.5;
        _leftBtn.clipsToBounds = YES;
    }
    return _leftBtn;
}
- (MMGuidancePathDetailTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[MMGuidancePathDetailTableView alloc] initWithFrame:CGRectMake(0, ViewHight-280, ViewWidth, 280) style:UITableViewStylePlain];
        _tableView.type = _type;
        switch (_type) {
            case 0:
                _tableView.transitPath = _transitPath;
                break;
            case 1:
                _tableView.drivingPath = _drivingPath;
                break;
            case 2:
                _tableView.walkingPath = _walkingPath;
                break;
            default:
                break;
        }
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.leftBtn];
    
    [self.view addSubview:self.tableView];
    
    switch (_type) {
        case 0:
            [self setupTransitPath];
            break;
        case 1:
            [self setupDrivingPath];
            break;
        case 2:
            [self setupWalkingPath];
            break;
        default:
            break;
    }
        
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.mapView viewWillAppear];
//    [SharedAppDelegate.tabBar tabBarHiddenYesOrNo:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    
}
-(void)naviBackBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupTransitPath
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    BMKTransitRouteLine* plan = _transitPath;
    // 计算路线方案中的路段数目
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
            
        }
        if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.title = @"终点";
            item.type = 1;
            [_mapView addAnnotation:item]; // 添加起点标注
        }
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        item.coordinate = transitStep.entrace.location;
        item.title = transitStep.instruction;
        item.type = 3;
        [_mapView addAnnotation:item];
        
        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }
    
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];

}
- (void)setupDrivingPath
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    BMKDrivingRouteLine * plan = _drivingPath;
    // 计算路线方案中的路段数目
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
            
        }
        if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.title = @"终点";
            item.type = 1;
            [_mapView addAnnotation:item]; // 添加起点标注
        }
        //添加annotation节点
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        item.coordinate = transitStep.entrace.location;
        item.title = transitStep.entraceInstruction;
        item.degree = transitStep.direction * 30;
        item.type = 4;
        [_mapView addAnnotation:item];
        
        NSLog(@"%@   %@    %@", transitStep.entraceInstruction, transitStep.exitInstruction, transitStep.instruction);
        
        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }
    // 添加途经点
    if (plan.wayPoints) {
        for (BMKPlanNode* tempNode in plan.wayPoints) {
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item = [[RouteAnnotation alloc]init];
            item.coordinate = tempNode.pt;
            item.type = 5;
            item.title = tempNode.name;
            [_mapView addAnnotation:item];
        }
    }
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];

}
-(void)setupWalkingPath
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    BMKWalkingRouteLine* plan = _walkingPath;
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
            
        }
        if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.title = @"终点";
            item.type = 1;
            [_mapView addAnnotation:item]; // 添加起点标注
        }
        //添加annotation节点
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        item.coordinate = transitStep.entrace.location;
        item.title = transitStep.entraceInstruction;
        item.degree = transitStep.direction * 30;
        item.type = 4;
        [_mapView addAnnotation:item];
        
        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }
    
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];

}
//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = RGB(0, 189, 250);
        polylineView.strokeColor = RGB(0, 189, 250);
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

@end
