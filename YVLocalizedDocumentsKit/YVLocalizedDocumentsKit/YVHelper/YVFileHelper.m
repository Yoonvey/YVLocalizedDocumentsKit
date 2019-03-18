//
//  YVFileHelper.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/14.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVFileHelper.h"

#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>

@implementation YVFileHelper

+ (UIImage *)getImageWithVideoPath:(NSString *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

+ (double)getDurationWithViedeoPath:(NSString *)videoPath
{
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    CMTime audioDuration = audioAsset.duration;
    double audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

+ (NSString *)sizeExplain:(float)size
{
    NSString *unit = @"B";
    float tSize = size;
    if (size >= 1024 && size < (1024*1024))
    {
        tSize = size/1024;
        unit = @"KB";
    }
    else if(size >= (1024*1024))
    {
        tSize = size/1024/1024;
        unit = @"MB";
    }
    return [NSString stringWithFormat:@"%.2f%@", tSize, unit];
}

+ (NSString *)getDateStringForTodayWithDateFormat:(NSString *)dateFormart
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:dateFormart];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)conversionTimeWithSecond:(NSInteger)times
{
    NSInteger seconds = times % 60;
    NSInteger minutes = (times / 60) % 60;
    NSInteger hours = (times / 3600);
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    }
    else
    {
        return [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
    }
}

@end
