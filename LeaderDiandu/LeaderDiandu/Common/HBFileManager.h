//
//  TFFileManager.h
//  LediKWB
//
//  Created by ChunGuo on 15/12/11.
//  Copyright © 2016年 huxijun. All rights reserved.
//

/**
 *沙盒下的路径
 */
typedef NS_ENUM(NSInteger, SANDBOXPATH) {
    EDocuments  = 0,
    ETemp       = 1,
};

@interface TFFileManager : NSObject

/***************************** directory handle **************************************/
/**
 * 获取应用程序Home路径
 * @return NSString:Home路径.
 */
+ (NSString *)getHomePath;

/**
 * 获取应用程序Document路径
 * @return NSString:Document路径.
 */
+ (NSString *)getDocumentsPath;

/**
 * 获取应用程序tmp路径
 * @return NSString:tmp路径.
 */
+ (NSString *)getTempPath;

/**
 * 获取应用程序cache路径
 * @return NSString:cache路径.
 */
+ (NSString *)getCachePath;

/**
 * 获取文件在资源中的路径
 * @return NSString:文件在资源中的路径.
 */
+ (NSString *)getBundlePath:(NSString *)fileName;

/**
 * 获取某个文件路径
 * @param parentPath 文件路径的上一级路径，
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @param filename 文件名称
 * @return NSString:文件路径，nil(表示不存在).
 */
+ (NSString *)getFilePathWithParentPath:(NSString *) parentPath fileName:(NSString *) fileName;

/**
 * 判断 文件/文件夹 是否存在
 * @param path:文件目录
 * @param isDir:是否为路径
 * @return BOOL值:YES存在，NO不存在.
 */
+ (BOOL)fileExistsAtPath:(NSString*)path isDirectory:(BOOL)isDir;

/**
 * 沙盒路径下创建文件
 * @param fileName:文件名称
 * @param sbPath:枚举类型sandBoxPath
 * @return BOOL:yes创建成功，no创建失败.
 */
+ (BOOL)createFile:(NSString *)fileName AtsandBox:(SANDBOXPATH)sbPath;

/**
 * 沙盒路径下创建文件
 * @param filePath:文件路径
 * @return BOOL:YES创删除成功，NO删除失败.
 */
+ (BOOL)createFileAtPath:(NSString *)filePath;

/**
 *	@brief	复制文件
 *
 *	@param 	srcPath 	源路径
 *	@param 	toPath 	目标路径
 *
 *	@return	返回拷贝是否成功 YES成功 NO不成功
 */
+ (BOOL)copyFile:(NSString *)srcPath toPath:(NSString *)toPath;

/**
 * 删除沙盒路径下的文件
 * @param fileName:文件名
 * @param sbPath 枚举类型sandBoxPath
 * @return BOOL:YES创删除成功，NO删除失败.
 */
+ (BOOL)deleteFile:(NSString *)fileName AtsandBox:(SANDBOXPATH)sbPath;

/**
 * 删除沙盒路径下的文件/文件夹
 * @param filePath:文件路径
 * @return BOOL:YES创删除成功，NO删除失败.
 */
+ (BOOL)deleteFileAtPath:(NSString *)filePath;

/**
 * 创建文件夹
 * @param folderPath:文件夹路径
 * @return BOOL:YES成功，NO失败
 */
+ (BOOL)createFolder:(NSString *)folderPath;

/**
 * 创建文件夹
 * @param folderName:文件夹名称
 * @param parentPath:文件夹所在路径的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @return BOOL:YES成功，NO失败
 */
+ (BOOL)createFolder:(NSString *)folderName atParentPath:(NSString *)parentPath;

/**
 * 删除文件夹.
 * @param path:文件夹路径.
 * @return BOOL:YES创删除成功，NO删除失败.
 */
+ (BOOL)deleteDirectory:(NSString *)path;

/**
 * 获得文件夹下全部文件
 * @param folderPath:文件夹路径
 * @return NSArray:文件夹下的所有文件.
 */
+ (NSArray *)getAllFilesAtFolder:(NSString *)folderPath;

/**
 * 获得文件属性
 * @param path:文件路径
 * @return NSDictionary:文件属性.
 */
+ (NSDictionary *)getAttributesAtPath:(NSString *)path;

/**
 * 获得文件大小
 * @param filePath 文件路径.
 * @return long long:文件大小.
 */
+ (long long)fileSizeAtPath:(NSString*)filePath;

/**
 * 获得文件修改日期
 * @param filePath 文件路径.
 * @return NSDate:文件修改日期
 */
+ (NSDate *)fileModificationDateAtPath:(NSString*)filePath;

/**
 * 获得文件夹大小
 * @param folderPath:文件夹路径
 * @return long long:文件夹大小.
 */
+ (long long)folderSizeAtPath:(NSString *) folderPath;

/***************************** file handle **************************************/

/**
 * 从父路径下读取数据
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @param fileName 文件名
 * @return 返回数据.
 */
+ (NSData *)readDataFromParentPath:(NSString *) parentPath fileName:(NSString *) fileName;

/**
 * 根据路径读取数据
 * @param filePath 文件路径
 * @return 返回数据.
 */
+ (NSData *)readDataFromPath:(NSString *) filePath;

/**
 * 从父路径下读取数组
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @param fileName 文件名
 * @return NSArray实例.
 */
+ (NSArray *)readArrayFromParentPath:(NSString *) parentPath fileName:(NSString *) fileName;

/**
 * 根据路径读取数组
 * @param filePath 文件路径
 * @return NSArray实例.
 */
+ (NSArray *)readArrayFromPath:(NSString *) filePath;

/**
 * 从父路径下读取字典
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @param fileName 文件名
 * @return  NSDictionary实例.
 */
+ (NSDictionary *)readDictionaryFromParentPath:(NSString *) parentPath fileName:(NSString *) fileName;

/**
 * 根据路径读取字典
 * @param filePath 文件路径
 * @return NSDictionary实例.
 */
+ (NSDictionary *)readDictionaryFromPath:(NSString *) filePath;

/**
 * 从父路径下读取数据
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @param fileName 文件名
 * @return UIImage实例.
 */
+ (UIImage *)readUIImageFromParentPath:(NSString *) parentPath fileName:(NSString *) fileName;

/**
 * 根据路径读取数据
 * @param filePath 文件路径
 * @return UIImage实例
 */
+ (UIImage *)readUIImageFromPath:(NSString *) filePath;

/**
 * 写数据到路径下，如路径下文件不存在会自动创建文件,默认写入格式为XML
 * @param data 要写入的数据
 * @param fileName 文件名
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeData:(NSData *)data toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName;

/**
 * 写数据到路径下，如路径下文件不存在会自动创建文件,默认写入格式为XML
 * @param data 要写入的数据
 * @param filePath 文件路径
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeData:(NSData *)data toPath:(NSString *)filePath;

/**
 * 写数组到路径下，如路径下文件不存在会自动创建文件,默认写入格式为XML
 * @param array 要写入的数据
 * @param fileName 文件名
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeArray:(NSArray *)array toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName;

/**
 * 写数组到路径下，如路径下文件不存在会自动创建文件,默认写入格式为XML
 * @param array 要写入的数据
 * @param filePath 文件路径
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeArray:(NSArray *)array toPath:(NSString *)filePath;

/**
 * 写字典到路径下，如路径下文件不存在会自动创建文件,默认写入格式为XML
 * @param dictionary 要写入的数据
 * @param fileName 文件名
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeDictionary:(NSDictionary *)dictionary toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName;

/**
 * 写字典到路径下，如路径下文件不存在会自动创建文件,默认写入格式为XML
 * @param dictionary 要写入的数据
 * @param filePath 文件路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeDictionary:(NSDictionary *)dictionary toPath:(NSString *)filePath;

/**
 * 写图片数据到路径下，如路径下文件不存在会自动创建文件
 * @param UIImage 要写入的数据，默认采用JPEGRepresentation,压缩质量默认1.0
 * @param fileName 文件名
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeUIImage:(UIImage *)image toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName;

/**
 * 写图片数据到路径下，如路径下文件不存在会自动创建文件
 * @param UIImage 要写入的数据，默认采用JPEGRepresentation,压缩质量默认1.0
 * @param filePath 文件路径
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeUIImage:(UIImage *)image toPath:(NSString *)filePath;

/**
 * 写图片数据到路径下，如路径下文件不存在会自动创建文件
 * @param UIImage 要写入的数据，默认采用JPEGRepresentation
 * @param fileName 文件名
 * @param parentPath 文件所在的上一级路径
 例如：文件在Documents路径下可为 /Users/dlgenius/Library/Application Support/iPhone Simulator/6.1/Applications/3B915C7D-3A96-43A2-BD5A-EFCBFCF2AA93/Documents
 * @param compQuality 压缩质量
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeUIImage:(UIImage *)image toParentPath:(NSString *)parentPath withFileName:(NSString *)fileName compressionQuality:(CGFloat)compQuality;

/**
 * 写图片数据到路径下，如路径下文件不存在会自动创建文件
 * @param UIImage 要写入的数据，默认采用JPEGRepresentation
 * @param filePath 文件路径
 * @param compQuality 压缩质量
 * @return BOOL: YES 写入成功，NO 写入失败.
 */
+ (BOOL)writeUIImage:(UIImage *)image toPath:(NSString *)filePath compressionQuality:(CGFloat)compQuality;

@end

