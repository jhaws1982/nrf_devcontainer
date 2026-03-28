# nrf_devcontainer
VS Code development container for NordicRF development. Contains nRF Connect Extensions installed for VS Code.

## Usage
1. Clone this repository to .devcontainer in your project folder.
1. Copy 49-segger.rules to /etc/udev/rules.d to get SEGGER USB devices tagged with the correct group.
1. Open your project in VS Code in a DevContainer. This will install the nRF Command Line Tools and included SEGGER tools.
1. When the container opens, go to the nRF Connect extension to install the desired SDK and toolchain (do BOTH).
1. When these are done installing, you are ready to start developing.

## Troubleshooting
* I ran into some issues getting flashing to work. The current setup has all the necessary tools, but sometimes the devices would not show up in the connected list. I fought this for a whlie, then left for a few hours and came back and everything was working like normal. Not sure if VSCode and the extension just needed time, but everything was okay after I let it sit. Not a good answer, but that's all I know right now...
