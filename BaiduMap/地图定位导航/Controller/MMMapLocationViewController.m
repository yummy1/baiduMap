//
//  MMMapLocationViewController.m
//  happyDot
//
//  Created by MM on 17/4/13.
//
//

#import "MMMapLocationViewController.h"
#import "MMLookPathViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface MMMapLocationViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
//地图
@property(nonatomic, strong)BMKMapView* mapView;
@property(nonatomic, strong)BMKGeoCodeSearch* geocodesearch;
//返回按钮
@property(nonatomic, strong)UIButton *leftBtn;
//店铺信息及线路导航按钮
@property(nonatomic, strong)UIView *bottomView;
@property(nonatomic, strong)UILabel *storeName;
@property(nonatomic, strong)UILabel *storeAddress;
@property(nonatomic, strong)UIButton *pathButton;

@property (nonatomic, strong)NSString *lng;//经度
@property (nonatomic, strong)NSString *lat;//纬度
@end

@implementation MMMapLocationViewController
#pragma mark - 懒加载
- (BMKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHight-110)];
        [_mapView setZoomLevel:14];
    }
    return _mapView;
}
- (BMKGeoCodeSearch *)geocodesearch
{
    if (_geocodesearch == nil) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
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
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewHight-110, ViewWidth, 110)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _storeName = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, ViewWidth-24, 25)];
        _storeName.text = @"U味儿";
        _storeName.textColor = [UIColor darkGrayColor];
        _storeName.font = [UIFont systemFontOfSize:14];
        [_bottomView addSubview:_storeName];
        _storeAddress = [[UILabel alloc] initWithFrame:CGRectMake(12, 38, ViewWidth-24, 25)];
        _storeAddress.text = @"朝阳区北三环东路22号";
        _storeAddress.textColor = [UIColor lightGrayColor];
        _storeAddress.font = [UIFont systemFontOfSize:12];
        [_bottomView addSubview:_storeAddress];
        _pathButton = [[UIButton alloc] initWithFrame:CGRectMake(ViewWidth/2-80, 68, 160, 35)];
        [_pathButton setTitle:@"查看线路" forState:UIControlStateNormal];
        [_pathButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_pathButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _pathButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_pathButton addTarget:self action:@selector(lookPath) forControlEvents:UIControlEventTouchUpInside];
        _pathButton.layer.borderWidth = 1.0;
        _pathButton.layer.cornerRadius = 2;
        _pathButton.clipsToBounds = YES;
        [_bottomView addSubview:_pathButton];
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lng = @"116.44098444025113";
    _lat = @"39.9648856731541";
    
    [self.view addSubview:self.mapView];
    
//    [self.view addSubview:self.leftBtn];
    
    [self.view addSubview:self.bottomView];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    [self onClickGeocode];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    [SharedAppDelegate.tabBar tabBarHiddenYesOrNo:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.geocodesearch.delegate = nil; // 不用时，置nil

}

-(void)naviBackBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 查看线路
- (void)lookPath
{
    MMLookPathViewController *lookPathVC = [[MMLookPathViewController alloc] init];
    [self.navigationController pushViewController:lookPathVC animated:YES];
}
#pragma mark - 发送反geo检索
-(void)onClickGeocode
{
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (_lng != nil && _lat != nil) {
        pt = (CLLocationCoordinate2D){[_lat floatValue], [_lng floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
    }
}

#pragma mark - BMKMapViewDelegate
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

@end
