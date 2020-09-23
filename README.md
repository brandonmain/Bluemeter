[![License: MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

# Bluemeter
<div style="display: flex;">
<img src="/img/5.8-inch-Screenshot-1.jpg" alt="screenshot" height="350" />
<img src="/img/5.8-inch-Screenshot-2.jpg" alt="screenshot" height="350" />
<img src="/img/5.8-inch-Screenshot-3.jpg" alt="screenshot" height="350" />
<img src="/img/5.8-inch-Screenshot-4.jpg" alt="screenshot" height="350" />
</div>

***

Bluemeter is a Bluetooth enabled multimeter iOS application that allows a user to send Bluetooth data from a device and graph it in real time. It was developed to be a cost-efficient replacement to an oscilloscope or scopemeter.

## Features

-	Real time graphing accurate to the 1ms
-	Screen capture of graph auto formatted and saved to photos
-	Pause and continue functionality of receiving and displaying measurements
-	BLE 4/5 compatible
-	Light and dark mode UI auto change based on users iOS display settings

***

<img src="img/FB28503E-07B1-4D53-A4D1-8E08312F8C82_2_0_a.gif" alt="" height="500" margin="0 auto">

Screenrecording of measurements being recieved and displayed.


## Installation
1. Download or clone this repository.
2. Navigate to the project directory and run:
`pod install`
3. Open in Xcode and run on your machine!

Important: You must have an Apple Developer account to deploy the app to your device. This [link](https://codewithchris.com/deploy-your-app-on-an-iphone/) has some good info on how to do this.

## Usage
1. To actually obtain measurements the app must be ran on an iOS 13+ device with BLE 4/5. 
2. Connect your iOS device and select it as the target.
3. Press the build and run button and the app will start running on your device. 
4. In the app, press: `Menu Icon > Devices > <Name_Of_Your_Device>`. This will connect your phone to your bluetooth device. A modal alert will pop up if you connect successfully.
5. 
