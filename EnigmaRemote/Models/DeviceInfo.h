//
//  DeviceInfo.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 07/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: add comment
@interface DeviceInfo : NSObject

@property (nonatomic, copy, readonly) NSString *enigmaVersion;
@property (nonatomic, copy, readonly) NSString *imageVersion;
@property (nonatomic, copy, readonly) NSString *webifVersion;
@property (nonatomic, copy, readonly) NSString *fpVersion;
@property (nonatomic, copy, readonly) NSString *deviceName;
@property (nonatomic, copy, readonly) NSString *tunerName;
@property (nonatomic, copy, readonly) NSString *tunerModel;
@property (nonatomic, copy, readonly) NSString *interfaceName;
@property (nonatomic, copy, readonly) NSString *macAddress;
@property (nonatomic, readonly) BOOL dhcpEnabled;
@property (nonatomic, copy, readonly) NSString *ipAddress;
@property (nonatomic, copy, readonly) NSString *gateway;
@property (nonatomic, copy, readonly) NSString *netmask;
@property (nonatomic, copy, readonly) NSString *hddModel;
@property (nonatomic, copy, readonly) NSString *hddCapacity;
@property (nonatomic, copy, readonly) NSString *hddFree;


- (instancetype)initWith:(NSString *)enigmaVersion
            imageVersion:(NSString *)imageVersion
            webifVersion:(NSString *)webifVersion
               fpVersion:(NSString *)fpVersion
              deviceName:(NSString *)deviceName
               tunerName:(NSString *)tunerName
              tunerModel:(NSString *)tunerModel
            intefaceName:(NSString *)interfaceName
              macAddress:(NSString *)macAddress
                    dchpEnabled:(BOOL)dchp
               ipAddress:(NSString *)ipAddress
               gateway:(NSString *)gateway
                 netmask:(NSString *)netmask
                hddModel:(NSString *)hddModel
             hddCapacity:(NSString *)hddCapacity
                 hddFree:(NSString *)hddFree;
@end
