
int xsize = 352;
int ysize = 288;

String filebase = "self";
String filetype = "png";
int startfile = 0;
int endfile = 189;
int extrazeroes = 1; // Number of extra zeroes in the endfile's name (e.g. "00150.png" has 2)

int boxwidth = 11;
int boxheight = 11;

int lineboxwidth = 3;
int lineboxheight = 3;
int linethreshold = 20;
color tlinecolor = color(2, 2, 10);

color[] boxarr = new color[boxwidth * boxheight];
float[] alphas = new float[boxwidth * boxheight];
float[] reds = new float[boxwidth * boxheight];
float[] greens = new float[boxwidth * boxheight];
float[] blues = new float[boxwidth * boxheight];
int boxoffx = floor(boxwidth / 2);
int boxoffy = floor(boxheight / 2);
int boxhalf = floor((boxwidth * boxheight) / 2);

color[] lineboxarr = new color[lineboxwidth * lineboxheight];
float[] linealphas = new float[lineboxwidth * lineboxheight];
float[] linereds = new float[lineboxwidth * lineboxheight];
float[] linegreens = new float[lineboxwidth * lineboxheight];
float[] lineblues = new float[lineboxwidth * lineboxheight];
int lineboxoffx = floor(lineboxwidth / 2);
int lineboxoffy = floor(lineboxheight / 2);
int lineboxhalf = floor((lineboxwidth * lineboxheight) / 2);

PImage img;

color getLinePixel(int px, int py, color[] matrix) {
  
  int boxx = 0;
  for (int bx = px - lineboxoffx; bx <= (px + lineboxoffx); bx++) {
    
    int xset = bx;
    if (xset < 0) {
      xset = 0;
    } else if (xset >= xsize) {
      xset = xsize - 1;
    }
    
    int boxy = 0;
    for (int by = py - lineboxoffy; by <= (py + lineboxoffy); by++) {
      
      int yset = by;
      if (yset < 0) {
        yset = 0;
      } else if (yset >= ysize) {
        yset = ysize - 1;
      }
      
      lineboxarr[floor(lineboxwidth * boxy) + boxx] = matrix[(xsize * yset) + xset];
      
      boxy++;
      
    }
    
    boxx++;
    
  }
  
  for (int i = 0; i < lineboxarr.length; i++) {
    linealphas[i] = alpha(lineboxarr[i]);
    linereds[i] = red(lineboxarr[i]);
    linegreens[i] = green(lineboxarr[i]);
    lineblues[i] = blue(lineboxarr[i]);
  }
  
  linealphas = sort(linealphas);
  linereds = sort(linereds);
  linegreens = sort(linegreens);
  lineblues = sort(lineblues);
  
  float[] totals = new float[lineboxarr.length];
  for (int j = 0; j < lineboxarr.length; j++) {
    totals[j] = (linereds[j] + linegreens[j] + lineblues[j]) / 3;
  }
  totals = sort(totals);
  
  float totaldiff = totals[totals.length - 1] - totals[0];
  if (totaldiff > linethreshold) {
    //return color(linereds[0], linegreens[0], lineblues[0]);
    //return color(linereds[linereds.length - 1], linegreens[linegreens.length - 1], lineblues[lineblues.length - 1]);
    return tlinecolor;
  }
  
  return pixels[(xsize * py) + px];
  
}

color getMedianPixel(int px, int py, color[] matrix) {
  
  int boxx = 0;
  for (int bx = px - boxoffx; bx <= (px + boxoffx); bx++) {
    
    int xset = bx;
    if (xset < 0) {
      xset = 0;
    } else if (xset >= xsize) {
      xset = xsize - 1;
    }
    
    int boxy = 0;
    for (int by = py - boxoffy; by <= (py + boxoffy); by++) {
      
      int yset = by;
      if (yset < 0) {
        yset = 0;
      } else if (yset >= ysize) {
        yset = ysize - 1;
      }
      
      boxarr[floor(boxwidth * boxy) + boxx] = matrix[(xsize * yset) + xset];
      
      boxy++;
      
    }
    
    boxx++;
    
  }
  
  for (int i = 0; i < boxarr.length; i++) {
    alphas[i] = alpha(boxarr[i]);
    reds[i] = red(boxarr[i]);
    greens[i] = green(boxarr[i]);
    blues[i] = blue(boxarr[i]);
  }
  
  alphas = sort(alphas);
  reds = sort(reds);
  greens = sort(greens);
  blues = sort(blues);
  
  return color(reds[boxhalf], greens[boxhalf], blues[boxhalf], alphas[boxhalf]);
  
}

void setup() {
  size(xsize, ysize);
}

void draw() {
  
  for (int fnum = startfile; fnum <= endfile; fnum++) {
    
    String zbuff = "";
    int zeroes = 0;
    while (zeroes < (extrazeroes + (str(endfile).length() - str(fnum).length()))) {
      zbuff = zbuff + "0";
      zeroes++;
    }
    
    String loadname = filebase + zbuff + str(fnum) + "." + filetype;
    String savename = filebase + "_out_" + zbuff + str(fnum) + ".png";
    
    img = loadImage(loadname);
    img.loadPixels();
    set(0, 0, img);
    loadPixels();
    
    for (int x = 0; x < xsize; x++) {
      for (int y = 0; y < ysize; y++) {
        pixels[(xsize * y) + x] = getMedianPixel(x, y, img.pixels);
        pixels[(xsize * y) + x] = getLinePixel(x, y, img.pixels);
      }
    }
    updatePixels();
    
    saveFrame("data/" + savename);
    println(savename);
    
  }
  
  exit();
  
}
