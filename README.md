# roku registry manager

A small tool to fetch and delete registry sections from roku devices.
roRegistry is used to save persistent data (E.g. User information, etc.), This data stays וn the device even if the app is removed from  the device. 

## How to use:
1.	Install RegistryManager from your Eclipse or the device Development Application Installer (Side-load).
2.	Get a list of registry sections, and delete the entire section or specific keys by clicking OK on the desired item.
3.	Install your dev app again

It is possible to use RegistryManager for signed applications by signing RegistryManager with the same developer ID and password as the dev app. Follow [here](https://sdkdocs.roku.com/display/sdkdoc/Packaging+Roku+Channels#PackagingRokuChannels-PackagingwithEclipse) for more information



