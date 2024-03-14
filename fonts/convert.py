import os
from math import pow
from PIL import Image

def main():
    
    print("Path of font image?")
    pathPic = input()
    pic = Image.open(pathPic)
    picWidth,picHeight = pic.size
    
    print("Character height in 8×8 tiles? ([1],2,3,4)")
    charHeight = int(input() or "1")*8
    charQuantityY = int(picHeight/charHeight)
    
    print("Character width in 8×8 tiles? ([1],2,3,4)")
    charWidth = int(input() or "1")*8
    charQuantityX = int(picWidth/charWidth)
    
    fileWidths = "widths.bin"
    fileGfx = "gfx.bin"
    fileIndices = "indices.bin"
    chars = []
    totalChars = 0
    totalGfxSize = 0
    
    with open(fileWidths,'wb') as ioWidths, open(fileGfx,'wb') as ioGfx, open(fileIndices,'wb') as ioIndices :
    
        ioGfx.write(b'\x00') # dummy byte for proper barrel shift reading
    
        for picYHi in range(0,charQuantityY):
            for picXHi in range(0,charQuantityX):
            
                char = {"width":0,"gfx":[],"index":None}
                
                for picXLo in range(0,charWidth):
                    for picYLo in range(0,int(charHeight/4)):

                        singleByte = 0
                        
                        for i in range(0,4):
                            posX = picXHi*charWidth+picXLo
                            posY = picYHi*charHeight+picYLo*4+i
                            halfnibble = pic.getpixel((posX,posY))
                            singleByte = singleByte+halfnibble*int(pow(2,2*i))
                        
                        char["gfx"].append(singleByte)
                            
                        if singleByte!=0 : char["width"] = picXLo+1
                
                char["gfx"] = char["gfx"][:int(char["width"]*charHeight/4)]
                char["index"] = totalGfxSize
                chars.append(char)
                
                ioWidths.write(char["width"].to_bytes(1,"little"))
                ioGfx.write(bytes(char["gfx"]))
                ioIndices.write(char["index"].to_bytes(2,"little"))
                
                totalGfxSize += len(char["gfx"])
                totalChars += 1
            
    print("Successfully processed "+str(totalChars)+" characters ("+str(totalGfxSize)+" bytes of graphics).")

if __name__ == "__main__":
    main()