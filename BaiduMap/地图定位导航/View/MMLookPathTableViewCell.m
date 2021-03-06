//
//  MMLookPathTableViewCell.m
//  happyDot
//
//  Created by MM on 17/4/14.
//
//

#import "MMLookPathTableViewCell.h"
@interface MMLookPathTableViewCell()

@property(nonatomic, strong)UILabel *subText;
/**底部分割view*/
@property(nonatomic, strong)UIView *bottomView;
@end
@implementation MMLookPathTableViewCell
- (void)setTransitInfo:(BMKTransitRouteLine *)transitInfo
{
    _transitInfo = transitInfo;
    NSMutableString *tittle = [NSMutableString string];
    [transitInfo.steps enumerateObjectsUsingBlock:^(BMKTransitStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.stepType == 1 || obj.stepType == 0) {
            if ([tittle isEqual:@""]) {
                [tittle appendString:obj.vehicleInfo.title];
            }else{
                [tittle appendString:[NSString stringWithFormat:@" - %@", obj.vehicleInfo.title]];
            }
        }
    }];
    _pathText.text = tittle;
    _subText.text = [NSString stringWithFormat:@"%d公里%d米 | %d小时%d分钟",transitInfo.distance/1000,transitInfo.distance%1000,transitInfo.duration.hours, transitInfo.duration.minutes];
}
- (void)setDrivingInfo:(BMKDrivingRouteLine *)drivingInfo
{
    _drivingInfo = drivingInfo;
//    NSMutableString *tittle = [NSMutableString string];
//    [drivingInfo.steps enumerateObjectsUsingBlock:^(BMKDrivingStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        DLog(@"%@", obj.instruction);
//    }];
//    _pathText.text = @"途径；；；；；";
    _subText.text = [NSString stringWithFormat:@"%d公里%d米 | %d小时%d分钟", drivingInfo.distance/1000,drivingInfo.distance%1000,drivingInfo.duration.hours, drivingInfo.duration.minutes];
}
- (void)setWalkingInfo:(BMKWalkingRouteLine *)walkingInfo
{
    _walkingInfo = walkingInfo;
    //    NSMutableString *tittle = [NSMutableString string];
    //    [drivingInfo.steps enumerateObjectsUsingBlock:^(BMKDrivingStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //    }];
//    _pathText.text = @"途径++++";
    _subText.text = [NSString stringWithFormat:@"%d公里%d米 | %d小时%d分钟", walkingInfo.distance/1000,walkingInfo.distance%1000,walkingInfo.duration.hours, walkingInfo.duration.minutes];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    _LeftNum = [[UILabel alloc] init];
    _LeftNum.textColor = [UIColor orangeColor];
    _LeftNum.text = @"01";
    _LeftNum.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_LeftNum];
    
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
    [_LeftNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(@12);
    }];
    [_pathText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(5);
        make.left.mas_equalTo(_LeftNum.mas_right).with.offset(10);
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
