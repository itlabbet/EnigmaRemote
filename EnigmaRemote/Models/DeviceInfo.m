//
//  DeviceInfo.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 07/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "DeviceInfo.h"

@interface DeviceInfo ()

@property (nonatomic, copy, readwrite) NSString *enigmaVersion;
@property (nonatomic, copy, readwrite) NSString *imageVersion;
@property (nonatomic, copy, readwrite) NSString *webifVersion;
@property (nonatomic, copy, readwrite) NSString *fpVersion;
@property (nonatomic, copy, readwrite) NSString *deviceName;
@property (nonatomic, copy, readwrite) NSString *tunerName;
@property (nonatomic, copy, readwrite) NSString *tunerModel;
@property (nonatomic, copy, readwrite) NSString *interfaceName;
@property (nonatomic, copy, readwrite) NSString *macAddress;
@property (nonatomic, readwrite) BOOL dhcpEnabled;
@property (nonatomic, copy, readwrite) NSString *ipAddress;
@property (nonatomic, copy, readwrite) NSString *gateway;
@property (nonatomic, copy, readwrite) NSString *netmask;
@property (nonatomic, copy, readwrite) NSString *hddModel;
@property (nonatomic, copy, readwrite) NSString *hddCapacity;
@property (nonatomic, copy, readwrite) NSString *hddFree;


@end

@implementation DeviceInfo


- (instancetype)initWith:(NSString *)enigmaVersion
            imageVersion:(NSString *)imageVersion
            webifVersion:(NSString *)webifVersion
               fpVersion:(NSString *)fpVersion
              deviceName:(NSString *)deviceName
               tunerName:(NSString *)tunerName
              tunerModel:(NSString *)tunerModel
            intefaceName:(NSString *)interfaceName
              macAddress:(NSString *)macAddress
                    dchpEnabled:(BOOL)dhcpEnabled
               ipAddress:(NSString *)ipAddress
               gateway:(NSString *)gateway
                 netmask:(NSString *)netmask
                hddModel:(NSString *)hddModel
             hddCapacity:(NSString *)hddCapacity
                 hddFree:(NSString *)hddFree
{
    self = [super init];
    
    if (self)
    {
        _enigmaVersion = enigmaVersion;
        _imageVersion = imageVersion;
        _webifVersion = webifVersion;
        _fpVersion = fpVersion;
        _deviceName = deviceName;
        _tunerName = tunerName;
        _tunerModel = tunerModel;
        _interfaceName = interfaceName;
        _macAddress = macAddress;
        _dhcpEnabled = dhcpEnabled;
        _ipAddress = ipAddress;
        _gateway = gateway;
        _netmask = netmask;
        _hddModel = hddModel;
        _hddCapacity = hddCapacity;
        _hddFree = hddFree;
    }
    
    return self;
}

@end
