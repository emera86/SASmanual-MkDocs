!!! check
    * [Here](https://support.sas.com/resources/papers/proceedings11/281-2011.pdf) are some examples of complex graphs.
    * [Here](http://support.sas.com/documentation/cdl/en/grstatproc/65235/HTML/default/viewer.htm#p07m2vpyq75fgan14m6g5pphnwlr.htm) there are instructions to play with the axis' attributes.
    * [Graphically speaking](http://blogs.sas.com/content/graphicallyspeaking/) blog with useful tips for graphics.

## Basic `ODS` Options

You need to add this command to get the plots displayed in the output:

```
ODS GRAPHICS ON;
[your code here]
ODS GRAPHICS OFF;
```

When you add the `ODS TRACE` statement, SAS writes a trace record to the log that includes information about each output object (name, label, template, path):

``` 
ODS TRACE ON;
[your code here]
ODS TRACE OFF;
```

You produce a list of the possible output elements in the log that you may specify in the `ODS SELECT/EXCLUDE` statement:

```
ODS SELECT output-name1 output-name2 output-name3;
[your code here]
ODS SELECT ALL;  /* Reset this option to the default */
```

Yo can keeps some of the outputs in SAS-data-sets:

```
ODS OUTPUT output-name1=generated-data-set1 output-name1=generated-data-set2 output-name1=generated-data-set3;
```

---

* Remove date and pagination from the automatic output header:
```
OPTIONS NODATE NONUMBER;
```

* Remove graph's external borders:
```
ODS GRAPHICS / NOBORDER;
```

## Plots

* Highlight a certain boxplot and get the plot narrower: 
```
proc sgplot data=sashelp.heart;
	/* The order matters: first thing defined goes to the back */
	refline 'Coronary Heart Disease' / axis=x 
    	lineattrs=(thickness=70 color=yellow) transparency=0.5 ;
	vbox cholesterol / category=deathcause;
	xaxis OFFSETMIN=0.25 OFFSETMAX=0.25 discreteorder=data;
    yaxis grid;
run;
```

* [Specify the colors of groups in SAS statistical graphics](http://blogs.sas.com/content/iml/2012/10/17/specify-the-colors-of-groups-in-sas-statistical-graphics.html)

## Miscellanea

### Available Colors at the SAS Registry

!!! note
   http://support.sas.com/documentation/cdl/en/lrcon/69852/HTML/default/viewer.htm#n1hpynpm51h88wn1izdahm5id5yw.htm#p1xtn4wjg933son1p6o6t8izxtrr
   
```
      AliceBlue=hex: F0,F8,FF
      AntiqueWhite=hex: FA,EB,D7
      Aqua=hex: 00,FF,FF
      Aquamarine=hex: 7F,FD,D4
      Azure=hex: F0,FF,FF
      Beige=hex: F5,F5,DC
      Bisque=hex: FF,E4,C4
      Black=hex: 00,00,00
      BlanchedAlmond=hex: FF,EB,CD
      Blue=hex: 00,00,FF
      BlueViolet=hex: 8A,2B,E2
      BR=hex: A5,2A,2A
      Brown=hex: A5,2A,2A
      Burlywood=hex: DE,B8,87
      CadetBlue=hex: 5F,9E,A0
      Chartreuse=hex: 7F,FF,00
      Chocolate=hex: D2,69,1E
      Coral=hex: FF,7F,50
      CornFlowerBlue=hex: 64,95,ED
      Cornsilk=hex: FF,F8,DC
      Crimson=hex: DC,14,3C
      Cyan=hex: 00,FF,FF
      DarkBlue=hex: 00,00,8B
      DarkCyan=hex: 00,8B,8B
      DarkGoldenrod=hex: B8,86,0B
      DarkGray=hex: A9,A9,A9
      DarkGreen=hex: 00,64,00
      DarkGrey=hex: A9,A9,A9
      DarkKhaki=hex: BD,B7,6B
      DarkMagenta=hex: 8B,00,8B
      DarkOliveGreen=hex: 55,6B,2F
      DarkOrange=hex: FF,8C,00
      DarkOrchid=hex: 99,32,CC
      DarkRed=hex: 8B,00,00
      DarkSalmon=hex: E9,96,7A
      DarkSeaGreen=hex: 8F,BC,8F
      DarkSlateBlue=hex: 48,3D,8B
      DarkSlateGray=hex: 2F,4F,4F
      DarkSlateGrey=hex: 2F,2F,2F
      DarkTurquoise=hex: 00,CE,D1
      DarkViolet=hex: 94,00,D3
      DeepPink=hex: FF,14,93
      DeepSkyBlue=hex: 00,BF,FF
      DimGray=hex: 69,69,69
      DimGrey=hex: 69,69,69
      DodgerBlue=hex: 1E,90,FF
      FireBrick=hex: B2,22,22
      FloralWhite=hex: FF,FA,F0
      ForestGreen=hex: 22,8B,22
      Fuchsia=hex: FF,00,FF
      G=hex: 00,80,00
      Gainsboro=hex: DC,DC,DC
      GhostWhite=hex: F8,F8,FF
      Gold=hex: FF,D7,00
      Goldenrod=hex: DA,A5,20
      Gray=hex: 80,80,80
      Green=hex: 00,80,00
      GreenYellow=hex: AD,FF,2F
      Grey=hex: 80,80,80
      Honeydew=hex: F0,FF,F0
      HotPink=hex: FF,69,B4
      IndianRed=hex: CD,5C,5C
      Indigo=hex: 4B,00,82
      Ivory=hex: FF,FF,F0
      Khaki=hex: F0,E6,8C
      Lavender=hex: E6,E6,FA
      LavenderBlush=hex: FF,F0,F5
      LawnGreen=hex: 7C,FC,00
      LemonChiffon=hex: FF,FA,CD
      LightBlue=hex: AD,D8,E6
      LightCoral=hex: F0,80,80
      LightCyan=hex: E0,FF,FF
      LightGoldenrodYellow=hex: FA,FA,D2
      lightGray=hex: D3,D3,D3
      LightGreen=hex: 90,EE,90
      LightGrey=hex: D3,D3,D3
      LightPink=hex: FF,B6,C1
      LightSalmon=hex: FF,A0,7A
      LightSeaGreen=hex: 20,B2,AA
      LightSkyBlue=hex: 87,CE,FA
      LightSlateGray=hex: 77,88,99
      LightSlateGrey=hex: 77,88,99
      LightSteelBlue=hex: B0,C4,DE
      LightYellow=hex: FF,FF,E0
      Lime=hex: 00,FF,00
      LimeGreen=hex: 32,CD,32
      Linen=hex: FA,F0,E6
      Magenta=hex: FF,00,FF
      Maroon=hex: 80,00,00
      MediumAquamarine=hex: 66,CD,AA
      MediumBlue=hex: 00,00,CD
      MediumOrchid=hex: BA,55,D3
      MediumPurple=hex: 93,70,DB
      MediumSeaGreen=hex: 3C,B3,71
      MediumSlateBlue=hex: 7B,68,EE
      MediumSpringGreen=hex: 00,FA,9A
      MediumTurquoise=hex: 48,D1,CC
      MediumVioletRed=hex: C7,15,85
      MidnightBlue=hex: 19,19,70
      MintCream=hex: F5,FF,FA
      MistyRose=hex: FF,E4,E1
      Moccasin=hex: FF,E4,B5
      NavajoWhite=hex: FF,DE,AD
      Navy=hex: 00,00,80
      O=hex: FF,A5,00
      Oldlace=hex: FD,F5,E6
      Olive=hex: 80,80,00
      OliveDrab=hex: 6B,8E,23
      Orange=hex: FF,A5,00
      OrangeRed=hex: FF,45,00
      Orchid=hex: DA,70,D6
      P=hex: 80,00,80
      PaleGoldenrod=hex: EE,E8,AA
      PaleGreen=hex: 98,FB,98
      PaleTurquoise=hex: AF,EE,EE
      PaleVioletRed=hex: DB,70,93
      PapayaWhip=hex: FF,EF,D5
      Peachpuff=hex: FF,DA,B9
      Peru=hex: CD,85,3F
      Pink=hex: FF,C0,CB
      Plum=hex: DD,A0,DD
      PowderBlue=hex: B0,E0,E6
      Purple=hex: 80,00,80
      Red=hex: FF,00,00
      RosyBrown=hex: BC,8F,8F
      RoyalBlue=hex: 41,69,E1
      SaddleBrown=hex: 8B,45,13
      Salmon=hex: FA,80,72
      SandyBrown=hex: F4,A4,60
      SeaGreen=hex: 2E,8B,57
      Seashell=hex: FF,F5,EE
      Sienna=hex: A0,52,2D
      Silver=hex: C0,C0,C0
      SkyBlue=hex: 87,CE,EB
      SlateBlue=hex: 6A,5A,CD
      SlateGray=hex: 70,80,90
      SlateGrey=hex: 70,80,90
      Snow=hex: FF,FA,FA
      SpringGreen=hex: 00,FF,7F
      SteelBlue=hex: 46,82,B4
      Tan=hex: D2,B4,8C
      Teal=hex: 00,80,80
      Thistle=hex: D8,BF,D8
      Tomato=hex: FF,63,47
      Turquoise=hex: 40,E0,D0
      Violet=hex: EE,82,EE
      Wheat=hex: F5,DE,B3
      White=hex: FF,FF,FF
      WhiteSmoke=hex: F5,F5,F5
      Yellow=hex: FF,FF,00
      YellowGreen=hex: 9A,CD,32
```
