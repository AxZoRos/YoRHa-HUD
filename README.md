
 ![image](contents/hud.png)

<h1 align="center">YoRHa HUD</h1>

<p align="center">
  A minimal, dynamic system monitor for KDE Plasma 6.
</p>

<p align="center">
<img width="544" height="337" alt="yorhahud2" src="https://github.com/user-attachments/assets/d5489789-085d-4825-aa83-03fa2c7effa0" />
</p>

## Plasmoid view in full rice:

<img width="1920" height="1080" alt="изображение" src="https://github.com/user-attachments/assets/9824309e-5f6e-4e37-839d-3d19eb0b9e8e" />


##  Current Status
Most of the HUD text is currently **decorative** in nature to maintain NieR's tactical aesthetic.

**Currently, real-time telemetry is implemented for:**
* `CPU_LOAD`
* `RAM_USE`
* `GPU_LOAD`
* `BATTERY / VRAM_USED`

##  Future Plans
The goal is to replace all decorative elements with functional system information while maintaining NieR's aesthetic.


# Installation

Currently, the widget is installed manually:
1. Download the com.axzoros.yorhahud.tar.gz from the [Latest Release](https://github.com/AxZoRos/YoRHa-HUD/releases/latest)
2. Download the plasmoid either through edit mode or with the following command in the terminal:
<pre>
kpackagetool6 --type Plasma/Applet --install com.axzoros.yorhahud.tar.gz
</pre>
