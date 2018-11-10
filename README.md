
## LedConfigurator 

Introduction:
The Led Konfigurator is used to play around with the led inside the raspberry pi or connected to it.

Requirements:
The script requires a raspberry pi.

How it works:
1. At the start, the script will list all the led available inside the raspberry pi
2. Just enter what led you want to use by the number next to the name.
3. Next it will display the led menu for the specific led you have selected.
4. There will be 6 options, each option will do different things.
  - Option 1: Turn on
      This will turn on the led that you have chosen.
  - Option 2: Turn off
      This will turn off the led that you have chosen.
  - Option 3: Associate with a system event
      There is a file in the led called trigger, it will display the options you have within the trigger file.
  - Option 4: Associate with the performance of a process
      You can monitor a process you want, and the led will blink according to the usage.
        When you select this option:
          1. It will ask for a name for the process you want to monitor. If there is multiple process with the same name, it will give an option of which one you want to monitor.
          2. It will ask to monitor the cpu or memory usage
          3. Then it will return back to the led menu
  - Option 5: Stop associate with the performance of a process
      This will stop the led from monitoring the process.      
      
      
      
      
Configuration:
Must be in sudo in order for the script to work
      
      
      
