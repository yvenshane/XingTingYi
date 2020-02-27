//
//  VENMaterialPageAddPersonalAudioVideoMaterialViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/31.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialPageAddPersonalAudioVideoMaterialViewController.h"

@interface VENMaterialPageAddPersonalAudioVideoMaterialViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImage *tempImage;
@property (nonatomic, strong) NSURL *videoURL;

@end

@implementation VENMaterialPageAddPersonalAudioVideoMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.uploadButton.layer.cornerRadius = 24.0f;
    self.uploadButton.layer.masksToBounds = YES;
    
    self.submitButton.layer.cornerRadius = 24.0f;
    self.submitButton.layer.masksToBounds = YES;
    
    
    
    
    if (![VENEmptyClass isEmptyString:self.name]) {
        self.titleTextField.text = self.name;
    }
    
    if (![VENEmptyClass isEmptyString:self.picture]) {
        [self.addCoverButton sd_setImageWithURL:[NSURL URLWithString:self.picture] forState:UIControlStateNormal];
        self.tempImage = self.addCoverButton.imageView.image;
    }
}

#pragma mark - 上传
- (IBAction)uploadButtonClick:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
        
        UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"音频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.type = @"1";
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            //            imagePickerController.videoMaximumDuration = 1.0; // 视频最长长度
            imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium; // 视频质量
            imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
            imagePickerController.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        
        UIAlertAction *undeterminedAction = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.type = @"2";
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
//            imagePickerController.videoMaximumDuration = 1.0; // 视频最长长度
            imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium; // 视频质量
            imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
            imagePickerController.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:appropriateAction];
        [alert addAction:undeterminedAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    });
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
    
    if ([VENEmptyClass isEmptyString:self.type]) {
        [MBProgressHUD showText:@"请上传音频/视频素材"];
        return;
    }
    
    NSDictionary *parameters = @{};
    if (![VENEmptyClass isEmptyString:self.name]) {
        parameters = @{@"title" : self.titleTextField.text,
                       @"type" : self.type,
                       @"user_source_id" : self.user_source_id,
                       @"images" : self.picture};
    } else {
        parameters = @{@"title" : self.titleTextField.text,
                       @"type" : self.type};
    }
    
    [[VENNetworkingManager shareManager] uploadImageWithUrlString:@"userSource/uploadSource" parameters:parameters images:self.tempImage ? @[self.tempImage] : @[] keyName:@"image" successBlock:^(id responseObject) {
        
        NSString *key = [NSString stringWithFormat:@"%@", responseObject[@"content"][@"userSourceId"]];
        
        [[VENTempDataManager shareManager] setValue:self.videoURL forKey:key];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadMaterialSuccess" object:nil userInfo:@{@"type" : self.type}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPersonalMaterialDetailPage" object:nil userInfo:@{@"url" : self.videoURL}];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"]){
        self.videoURL = info[UIImagePickerControllerMediaURL];
        self.uploadSuccessView.hidden = NO;
    } else {
        self.tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.addCoverButton setImage:self.tempImage forState:UIControlStateNormal];
    }
    
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
