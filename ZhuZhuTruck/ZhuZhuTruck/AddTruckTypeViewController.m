//
//  AddTruckTypeViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "AddTruckTypeViewController.h"
#import "DOPDropDownMenu.h"

@interface AddTruckTypeViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) DOPDropDownMenu *menu;
@property (nonatomic, copy  ) NSString *truckType;
@property (nonatomic, copy  ) AddtypeCallBack callBackHandler;
@end

@implementation AddTruckTypeViewController

- (instancetype)initWithInfoDict:(NSDictionary*)infoDict andCallback:(AddtypeCallBack)callBack
{
    self = [super init];
    if (self) {
        self.callBackHandler = callBack;
        self.truckType = [infoDict stringForKey:@"photoname"];
    }
    return self;
}

- (instancetype)initWithInfoModel:(PersonInfoModel*)model andCallback:(AddtypeCallBack)callBack{
    self = [super init];
    if (self) {
        self.callBackHandler = callBack;
        self.truckType = model.photoName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.title = @"选择车型";
    self.dataArray = @[@"请选择车型",@"金杯车",@"4.2米",@"6.8米",@"7.6米",@"9.6前四后四",@"9.6前四后八",@"12.5米",@"14.7米",@"16.5米",@"17.5米"];
    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [addButton addTarget:self action:@selector(saveType) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"保存" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [naivHeader addRightButton:addButton];
    
    [self initSeletedView];
}

- (void)initSeletedView{
    NSInteger index = 0;
    if (![self.truckType isEmpty]) {
        for (int i = 0; i<self.dataArray.count; i++) {
            NSString *typeString = [self.dataArray objectAtIndex:i];
            if ([self.truckType isEqualToString:typeString]) {
                index = i;
                break;
            }
        }
    }
    
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, SYSTITLEHEIGHT) andHeight:50];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    self.menu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.menu];
    
    [self.menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:index]];
    
}
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return self.dataArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return [self.dataArray objectAtIndex:indexPath.row];
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    NSString *type = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        _truckType = @"";
    }else{
        _truckType = type;
    }
}
- (void)saveType{
    if (self.callBackHandler) {
        if ([self.truckType isEmpty]) {
            self.callBackHandler(@"");
        }else{
            self.callBackHandler(self.truckType);
        }
    }
    [self naviBack];
}


- (void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
