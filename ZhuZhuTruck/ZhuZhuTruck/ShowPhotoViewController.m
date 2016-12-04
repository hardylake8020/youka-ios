//
//  ShowPhotoViewController.m
//  ZhengChe
//
//  Created by CongCong on 16/9/18.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "ShowPhotoViewController.h"

@interface ShowPhotoViewController ()<UIScrollViewDelegate>{
    UIImageView *imageView;
}
@property (nonatomic, copy)DeletedFileCallBack callBackHandler;
@property (nonatomic, copy)NSString *fileName;
@property (nonatomic, assign)BOOL isCanEdit;
@end

@implementation ShowPhotoViewController

- (instancetype)initWithEditFileName:(NSString *)fileName editCallBack:(DeletedFileCallBack)callBack
{
    self = [super init];
    if (self) {
        self.isCanEdit = YES;
        self.fileName = fileName;
        self.callBackHandler = callBack;
    }
    return self;
}
- (instancetype)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        self.fileName = fileName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self addNaviHeaderViewWithTitle:@"照片详情"];
    [self.naviHeaderView addBackButtonWithTarget:self action:@selector(naviBack)];
    if (self.isCanEdit) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [button addTarget:self action:@selector(deletedThisFile) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.naviHeaderView addRightButton:button];
    }
    [self initShowPageView];
}
- (void)deletedThisFile{
    NSString *imageDir = filePathByName([NSString stringWithFormat:@"%@.jpg", _fileName]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:imageDir error:nil];
    if (self.callBackHandler) {
        self.callBackHandler(_fileName);
    }
    [self naviBack];
}
- (void)initShowPageView{
    UIScrollView *imageScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,SYSTITLEHEIGHT, self.view.frame.size.width, self.view.frame.size.height-SYSTITLEHEIGHT)];
    imageScrollView.contentSize = CGSizeMake(self.view.frame.size.width,  self.view.frame.size.height-SYSTITLEHEIGHT);
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,  self.view.frame.size.height-SYSTITLEHEIGHT)];
    NSString* filePath=filePathByName([NSString stringWithFormat:@"%@.jpg", _fileName]);
    // NSLog(@"filepath: %@",filePath);
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:imageData];
    imageView.image = image;
    imageView.hidden = NO;
    imageView.image = image;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageScrollView addSubview:imageView];
    //设置代理scrollview的代理对象
    imageScrollView.delegate=self;
    //设置最大伸缩比例
    imageScrollView.maximumZoomScale=3.0;
    //设置最小伸缩比例
    imageScrollView.minimumZoomScale=1;
    [self.view addSubview:imageScrollView];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}



#pragma mark ---> 返回 其他
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
