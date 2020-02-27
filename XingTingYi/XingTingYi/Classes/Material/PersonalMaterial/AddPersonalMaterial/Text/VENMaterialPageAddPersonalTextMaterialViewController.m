//
//  VENMaterialPageAddPersonalTextMaterialViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/31.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialPageAddPersonalTextMaterialViewController.h"

@interface VENMaterialPageAddPersonalTextMaterialViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *textFieldMuArr;
@property (nonatomic, strong) UIImage *tempImage;

@end

@implementation VENMaterialPageAddPersonalTextMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.addTextView.layer.cornerRadius = 24.0f;
    self.addTextView.layer.masksToBounds = YES;
    
    self.submitButton.layer.cornerRadius = 24.0f;
    self.submitButton.layer.masksToBounds = YES;
    
    
    
    
    
    
    
    // 段落文本
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 82)];
    [self.addTextView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kMainScreenWidth - 20 * 2, 17)];
    label.text = @"段落文本01";
    label.textColor = UIColorFromRGB(0x222222);
    label.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 82 - 48, kMainScreenWidth - 20 * 2, 48)];
    textField.placeholder = @"请输入段落文章";
    [view addSubview:textField];
    
    [self.textFieldMuArr addObject:textField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 81, kMainScreenWidth - 20, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [view addSubview:lineView];
    
    self.addTextViewHeightLayoutConstraint.constant = 82.0f;
}

#pragma mark - 添加段落
- (IBAction)addTextButtonClick:(id)sender {
    
    CGFloat y = self.addTextViewHeightLayoutConstraint.constant;
    
    UIView *view = [self getTextView];
    view.frame = CGRectMake(0, y, kMainScreenWidth, 82);
    [self.addTextView addSubview:view];
    
    self.addTextViewHeightLayoutConstraint.constant += 82;
}

- (UIView *)getTextView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kMainScreenWidth - 20 * 2, 17)];
    label.text = [NSString stringWithFormat:@"段落文本%02d", self.textFieldMuArr.count + 1];
    label.textColor = UIColorFromRGB(0x222222);
    label.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 82 - 48, kMainScreenWidth - 20 * 2, 48)];
    textField.placeholder = @"请输入段落文章";
    [view addSubview:textField];
    
    [self.textFieldMuArr addObject:textField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 81, kMainScreenWidth - 20, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [view addSubview:lineView];
    
    return view;
}

#pragma mark - 素材封面图
- (IBAction)addCoverButtonClick:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
        
        UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *undeterminedAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:appropriateAction];
        [alert addAction:undeterminedAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - 提交
- (IBAction)submitButtonClick:(id)sender {
    if ([VENEmptyClass isEmptyString:self.titleTextField.text]) {
        [MBProgressHUD showText:@"请输入文章标题"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.titleTextField.text forKey:@"title"];
    
    NSMutableArray *tempMuArr = [NSMutableArray array];
    for (UITextField *textField in self.textFieldMuArr) {
        [tempMuArr addObject:textField.text];
    }
    
    for (NSInteger i = 0; i < tempMuArr.count; i++) {
        [parameters setValue:tempMuArr[i] forKey:[NSString stringWithFormat:@"content[%ld]", i]];
    }
    
    [[VENNetworkingManager shareManager] uploadImageWithUrlString:@"userSource/uploadSourceText" parameters:parameters images:self.tempImage ? @[self.tempImage] : @[] keyName:@"image" successBlock:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadMaterialSuccess" object:nil userInfo:@{@"type" : @"3"}];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)textFieldMuArr {
    if (!_textFieldMuArr) {
        _textFieldMuArr = [NSMutableArray array];
    }
    return _textFieldMuArr;
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    self.tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self.addCoverButton setImage:self.tempImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
