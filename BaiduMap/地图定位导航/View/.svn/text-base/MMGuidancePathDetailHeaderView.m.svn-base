//
//  MMGuidancePathDetailHeaderView.m
//  happyDot
//
//  Created by MM on 17/4/17.
//
//

#import "MMGuidancePathDetailHeaderView.h"
@interface MMGuidancePathDetailHeaderView()
@property(nonatomic, strong)UILabel *pathText;
@property(nonatomic, strong)UILabel *subText;
/**底部分割view*/
@property(nonatomic, strong)UIView *bottomView;
@end
@implementation MMGuidancePathDetailHeaderView
- (void)setTransitInfo:(BMKTransitRouteLine *)transitInfo
{
    _transitInfo = transitInfo;
    NSMutableString *tittle = [NSMutableString string];
    [transitInfo.steps enumerateObjectsUsingBlock:^(BMKTransitStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.stepType == 1 || obj.stepType == 0) {
            [tittle appendString:obj.vehicleInfo.title];
        }
    }];
    _pathText.text = tittle;
    _subText.text = [NSString stringWithFormat:@"%d公里%d米 | %d小时%d分钟", transitInfo.distance/1000,transitInfo.distance%1000,transitInfo.duration.hours, transitInfo.duration.minutes];
}
- (void)setDrivingInfo:(BMKDrivingRouteLine *)drivingInfo
{
    _drivingInfo = drivingInfo;
    _pathText.text = @"线路";
    _subText.text = [NSString stringWithFormat:@"%d公里%d米 | %d小时%d分钟", drivingInfo.distance/1000,drivingInfo.distance%1000,drivingInfo.duration.hours, drivingInfo.duration.minutes];
}
- (void)setWalkingInfo:(BMKWalkingRouteLine *)walkingInfo
{
    _walkingInfo = walkingInfo;
    //    NSMutableString *tittle = [NSMutableString string];
    //    [drivingInfo.steps enumerateObjectsUsingBlock:^(BMKDrivingStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //    }];
    _pathText.text = @"线路";
    _subText.text = [NSString stringWithFormat:@"%d公里%d米 | %d小时%d分钟", walkingInfo.distance/1000,walkingInfo.distance%1000,walkingInfo.duration.hours, walkingInfo.duration.minutes];
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    _pathText = [[UILabel alloc] init];
    _pathText.text = @"13号地铁线";
    _pathText.textColor = [UIColor darkGrayColor];
    _pathText.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_pathText];
    
    _subText = [[UILabel alloc] init];
    _subText.text = @"10分钟 | 1.8公里 | 步行982米";
    _subText.textColor = [UIColor lightGrayColor];
    _subText.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_subText];
    /**底部分割view*/
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_bottomView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_pathText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(5);
        make.left.mas_equalTo(self).with.offset(10);
    }];
    [_subText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pathText.mas_bottom).with.offset(5);
        make.left.mas_equalTo(_pathText);
    }];
    /**底部分割view*/
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];

}
@end
