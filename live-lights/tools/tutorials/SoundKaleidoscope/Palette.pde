//=============================================================================================================
interface Palette {
  color nextColor();
  void reset();
}
 
//=============================================================================================================
class RandomPalette implements Palette {
  color nextColor() {
    return color(random(TWO_PI), random(1), random(1));
  }
   
  void reset() {
  }
}
 
//=============================================================================================================
class RandomBrightPalette implements Palette {
  color nextColor() {
    return color(random(TWO_PI), 1, 1);
  }
   
  void reset() {
  }
}
 
//=============================================================================================================
class ColorWheelPalette implements Palette {
  static final float BLACK_PROBABILITY = 0.4;
  float[] hueOffsets;
  float blackProbability;
  float whiteProbability;
  float saturatedProbability;
  float hueValue;
   
  ColorWheelPalette(float[] hueOffsets) {
    this.hueOffsets = hueOffsets;
  }
   
  color nextColor() {
    float h = (hueValue + hueOffsets[(int)random(hueOffsets.length)]) % TWO_PI;
    float s;
    float b;
    float r = random(1);
    if (r < blackProbability) {
      s = 0;
      b = 0;
    } else if (r < blackProbability+whiteProbability) {
      s = 0;
      b = 1;
    } else if (r < blackProbability+whiteProbability+saturatedProbability) {
      s = 1;
      b = 1;
    } else {
      if (random(1) < 0.5) {
        s = random(1);
        b = 1;
      } else {
        s = 1;
        b = random(1);
      }
    }
    return color(h, s, b);
  }
   
  void reset() {   
    hueValue = random(TWO_PI);
    blackProbability = 0;
    whiteProbability = 0;
    saturatedProbability = 0;
    float r = random(1);
    if (random(1) < 0.3) {
      // Only saturated
      saturatedProbability = 1;
    } else if (random(1) < 0.4) {
      // saturated + black
      blackProbability = 1.0/(1+hueOffsets.length);
      saturatedProbability = 1 - blackProbability;
    } else if (random(1) < 0.5) {
      // saturated + white
      whiteProbability = 1.0/(1+hueOffsets.length);
      saturatedProbability = 1 - whiteProbability;
    } else if (random(1) < 0.6) {
      // saturated + black + white
      blackProbability = 1.0/(2+hueOffsets.length);
      whiteProbability = 1.0/(2+hueOffsets.length);
      saturatedProbability = 1 - blackProbability - whiteProbability;
    } else {
      // Unsaturated
    }
  }
}
 
//=============================================================================================================
Palette allPalettes[] = {
  new RandomPalette(),
  new RandomBrightPalette(), new RandomBrightPalette(), new RandomBrightPalette(), // Extra probability for random bright palette
  // Following palettes are based on color scheme described by ColorJack (http://www.colorjack.com/articles/color_formulas.html)
  new ColorWheelPalette(new float[]{0}), // Monochrome
  new ColorWheelPalette(new float[]{0, PI}), // Complementaty
  new ColorWheelPalette(new float[]{0, TWO_PI/12*5, TWO_PI/12*7}), // Split-Complementary
  new ColorWheelPalette(new float[]{0, TWO_PI/3, TWO_PI/3*2}), // Triadic
  new ColorWheelPalette(new float[]{0, TWO_PI/4, TWO_PI/4*2, TWO_PI/4*3}), // Tetradic
  new ColorWheelPalette(new float[]{0, TWO_PI/6, TWO_PI/6*3, TWO_PI/6*4}), // Four-tone
  new ColorWheelPalette(new float[]{0, TWO_PI/72*23, TWO_PI/72*31, TWO_PI/72*41, TWO_PI/72*49}), // Five-tone
  new ColorWheelPalette(new float[]{0, TWO_PI/12, TWO_PI/12*4, TWO_PI/12*5, TWO_PI/12*8, TWO_PI/12*9}), // Six-tone
  new ColorWheelPalette(new float[]{0, TWO_PI/24, TWO_PI/24*2, TWO_PI/24*3, TWO_PI/24*4, TWO_PI/24*5}) // Neutral
};
 
Palette getRandomPalette() {
  Palette palette = allPalettes[(int)random(allPalettes.length)];
  palette.reset();
  return palette;
}

