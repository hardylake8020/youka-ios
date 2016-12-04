//
//  TenderDetailTableDataModel.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2016/12/4.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "TenderDetailTableDataModel.h"

@implementation TenderDetailTableDataModel
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTenderDetails];
    }
    return self;
}
- (void)initTenderDetails{
    
    TenderDetailCellModel *model = [[TenderDetailCellModel alloc]init];
    model.title = @"车辆要求";
    model.isLight = YES;
    model.subTitle = @"金杯车 1 辆";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"合计";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = @"12箱/ 200千克/ 4立方米";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"注意事项";
    model.isLight = NO;
    model.subTitle = @"轻拿轻放";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"发标方";
    model.isLight = YES;
    model.subTitle = @"京东";
    [self.dataArray addObject:model];
    
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"联系人";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = @"王五";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"联系电话";
    model.isLight = NO;
    model.subTitle = @"1324789787";
    model.isPhone = YES;
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"提货时间";
    model.isLight = YES;
    model.subTitle = @"08月17日 16:00 ~ 08月18日 16:00";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"提货地址";
    model.isLight = NO;
    model.subTitle = @"成都第三方聚少离多快解放路口是放假了看电视机房里看电视成都第三方聚少离多快解放路口是放假了看电视机房里看电视成都第三方聚少离多快解放路口是放假了看电视机房里看电视";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"交货时间";
    model.isLight = YES;
    model.subTitle = @"08月17日 16:00 ~ 08月18日 16:00";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"交货地址";
    model.isLight = NO;
    model.subTitle = @"成都第三方聚少离多快解放路口是放假了看电视机房里看电视成都第三方聚少离多快解放路口是放假了看电视机房里看电视成都第三方聚少离多快解放路口是放假了看电视机房里看电视";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"支付方式";
    model.isLight = YES;
    model.subTitle = @"首付 + 尾款 + 回单";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"首付";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = @"50% （50% 现金 + 50% 油卡）";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"尾款";
    model.isLight = NO;
    model.noBottomLine = YES;
    model.subTitle = @"40% （现金支付）";
    [self.dataArray addObject:model];
    
    model = [[TenderDetailCellModel alloc]init];
    model.title = @"回单";
    model.isLight = NO;
    model.subTitle = @"10% （现金支付）";
    [self.dataArray addObject:model];
    
}
@end
