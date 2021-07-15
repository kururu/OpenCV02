//
//  opencv002.m
//  OpenCV02
//
//  Created by RUI KONDO on 2021/07/13.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "opencv002.h"

@implementation opencv002
+(void)load{
    puts("これはOjective-C++です。");
}

+(int)testInt{
    return 123;
}

+(void)testMethod{
    puts("これはOjective-C++のメソッドです。");
}

+(UIImage *)grayScale:(UIImage *)image {
    // UIImageからMatを作成
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    // グレースケール変換
    cv::Mat gray;
    cv::cvtColor(mat, gray, cv::COLOR_BGR2GRAY);
    
    // MatからUIImageを作成
    UIImage *grayImg = MatToUIImage(gray);
    
    return grayImg;
}


@end
