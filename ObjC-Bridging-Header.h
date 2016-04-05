//
//  ObjC-Bridging-Header.h
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

#ifndef ObjC_Bridging_Header_h
#define ObjC_Bridging_Header_h

#import "Pods/RESideMenu/RESideMenu/RESideMenu.h"

// Card IO
#import "CardIO.h"
@import AudioToolbox;
@import AVFoundation;
@import CoreMedia;
@import CoreVideo;
@import MobileCoreServices;

// Used for IP location of Device
#include <arpa/inet.h>
#include <sys/socket.h>
#include <ifaddrs.h>

// Used for Custom Checkbox UI
#import "Pods/BEMCheckBox/classes/BEMCheckBox.h"

#endif /* ObjC_Bridging_Header_h */
