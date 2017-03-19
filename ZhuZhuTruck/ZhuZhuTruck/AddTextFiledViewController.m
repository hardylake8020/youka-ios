//
//  AddTextFiledViewController.m
//  ZhuZhuTruck
//
//  Created by CongCong on 2017/3/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "AddTextFiledViewController.h"

@interface AddTextFiledViewController ()<UITextFieldDelegate>{
    UITextField *_textFiled;
    CGFloat _topHight;
    UIView *view_back;
}
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *textString;
@property (nonatomic, copy) AddTextCallBack callBackHandler;
@end

@implementation AddTextFiledViewController

- (instancetype)initWithInfoDict:(NSDictionary *)infoDict andCallBack:(AddTextCallBack)callBack
{
    self = [super init];
    if (self) {
        self.callBackHandler = callBack;
        self.textString = [infoDict stringForKey:@"photoname"];
        self.pageTitle = [infoDict stringForKey:@"title"];
    }
    return self;
}
- (instancetype)initWithInfoModel:(PersonInfoModel *)model andCallBack:(AddTextCallBack)callBack{
    self = [super init];
    if (self) {
        self.callBackHandler = callBack;
        self.textString = model.photoName;
        self.pageTitle = model.title;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    view_back = [[UIView alloc]initWithFrame:CGRectMake(0, SYSTITLEHEIGHT, SYSTEM_WIDTH, SYSTEM_HEIGHT-SYSTITLEHEIGHT)];
    view_back.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:view_back];
    
    self.title = self.pageTitle;
    CCNaviHeaderView *naivHeader  = [[CCNaviHeaderView alloc]newInstance:self.title andBackGruondColor:[UIColor naviBlackColor]];
    [naivHeader addBackButtonWithTarget:self action:@selector(naviBack)];
    [self.view addSubview:naivHeader];
    
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [addButton addTarget:self action:@selector(saveText) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"保存" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [naivHeader addRightButton:addButton];
    
    [self initTextFiled];
    
}

- (void)initTextFiled{
    _topHight = 0;
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, _topHight, SYSTEM_WIDTH, 50)];
    [view_back addSubview:addView];
    addView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 50)];
    tipLabel.font = fontBysize(16);
    tipLabel.text = self.title;
    [addView addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, 0.5, 50)];
    lineView.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView];
    
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(140,0, SYSTEM_WIDTH-140, 50)];
    _textFiled.delegate = self;
    _textFiled.clearButtonMode = UITextFieldViewModeAlways;
    [_textFiled setPlaceholder:[NSString stringWithFormat:@"请输入%@",self.title]];
    _textFiled.font = fontBysize(16);
    [addView addSubview:_textFiled];
    
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SYSTEM_WIDTH, 0.5)];
    lineView1.backgroundColor = [UIColor customGrayColor];
    [addView addSubview:lineView1];

    
    _textFiled.text = self.textString;
}

- (void)saveText{
    
    if ([self.title isEqualToString:@"车牌号"]) {
        if (![_textFiled.text validateCarNo]) {
            toast_showInfoMsg(@"请输入正确的车牌号", 400);
            return;
        }else{
            _textFiled.text = [_textFiled.text uppercaseString];
        }
        
    }
    
    if (self.callBackHandler) {
        self.callBackHandler(_textFiled.text);
    }
    [self naviBack];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
