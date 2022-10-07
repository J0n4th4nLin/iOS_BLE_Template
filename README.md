# iOS_BLE_Template
There are basic BLE fetures and view in this project.  
### Enviroment / Version 
1. macOS Monterey 12.4, Xcode 13.4.1, iOS15 (Available)
2. macOS Monterey 12.6, Xcode 14, iOS16 (Available)
### BLE Features     
1. Scan peripherals.   
2. Connect peripheral.  
3. Receive data from BLE.  
4. Decode data which it from BLE. //One is raw data which don't split, another is split.
### View
1. summaryView // print data which received from BLE.  
2. scanView // list all peripherals when central scanning.  
### Note: 
  This template data is received temperature from my BLE device, so my code I gonna use "receiveTemp", "tempForSummary" as a name of the parameter. You can modify by you.  
### The code you need to modify by you(Just two)   
  #### Model: bleModel   
   UUID： Adjust to your specifications   
  #### Extensions: blePeripheralExtensions   
   Decode: Adjust to your packets specifications  
  #### Flow after you decode:    
  After you already decode, you can right click "receiveTemp" and click "jump to definition", you gonna back to bleModel, you can right click "tempForSummary" and click "jump to definition", you gonna jump to summaryViewModel, this part of connection bleModel and summaryView. This part you don't need to modify the code, I just wanna let you know data flow, so you can go to summaryView directly which demonstrate your data.  

### View on iPhone  
SummaryView // Your main view. 
![IMG_9198](https://user-images.githubusercontent.com/43193762/188367451-0d811236-54f2-4f60-b345-97d75abb86c0.PNG)
ScanView gonna pop up when u click "Summary" of top word.
![IMG_9199](https://user-images.githubusercontent.com/43193762/188368208-cb349c43-33e1-42f1-92c8-8c3646130957.PNG)
