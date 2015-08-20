/*
  Requirements:
  Written description of concept includes all features to be implemented, visual references and sketches are included
  At least 1 base class is defined
  At least 2 child classes are defined
  Code is commented
  Documentation contains all required elements
  Generated Sketch resembles initial concept
  Sketch uses mouse OR keyboard input
*/

/*
This code uses a buffer of mouse positions to determine the location, rotation, and shape of a 'pac man' and a trace line
*/

/*
PARAMETERS

numberOfFramesToRemember determines the length of the trace line. The trace line follows the mouse, connecting the dots between the current frame and all the frames in memory
translateFrameDelay controls the lag between moving the mouse on the screen, and the movement of the 'pac man'. The lag in the original pac man was what made the game difficult, so it seemed natural to include it in this homage.
NumberOfGhosts doesn't actually make pac man 'ghosts' on the screen. Instead, it determines how much to onion skin pac man into the past. It's useful for viewing the squash and stretch on Pac Man as he moves around the screen.
*/
int numberOfFramesToRemember = 100;
int translateFrameDelay = 10;
int numberOfGhosts = 90;

/*
GLOBALS

Do not change these! It will mess up the code!

This code uses an array of a fixed length, with a pointer that advances along the array with each frame to create a queue. It's much more efficient than using a linked list. Also, since processing does not have a queue
data structure built into it, we have to code our own queue.
*/

//PShape[] deltaArray = new PShape[numberOfFramesToRemember]; - this is an optimization that I have yet to add - rather than recalculating the pshapes every frame, just cache them and calculate one per frame
float[] xMouseArray = new float[numberOfFramesToRemember];
float[] yMouseArray = new float[numberOfFramesToRemember];
float rotationValue = 0;
int currentArrayStartIndex = 0;



void setup(){
  /*sanitize our Parameters so that we don't get array out of bounds errors*/
  numberOfFramesToRemember = abs(numberOfFramesToRemember);
  translateFrameDelay = translateFrameDelay%numberOfFramesToRemember;
  numberOfGhosts = (numberOfGhosts-1)%numberOfFramesToRemember+1;
  /*set up some defaults for drawing on the canvas*/
  size(500,500);
  background(#123456);
  noFill();
  stroke(#efefef);
  /*initialize the array, so as to avoid null pointer exceptions*/
  for(int index=0; index<numberOfFramesToRemember; index++){
    xMouseArray[index]=mouseX;
    yMouseArray[index]=mouseY;
  };
};

void draw(){
  /*clear the background with every frame*/
  background(#123456);
  /*advance the pointer down the array, so as to actuate the queue mechanism*/
  currentArrayStartIndex+=1;
  currentArrayStartIndex = currentArrayStartIndex%numberOfFramesToRemember;
  /*populate the array with the current mouse values*/
  xMouseArray[currentArrayStartIndex]=mouseX;
  yMouseArray[currentArrayStartIndex]=mouseY;
  /*use the array of current and past mouse values to determine the drawing of the shapes*/
  drawMouseFollowingCurve();
  drawMouseFollowingShape();
};

/*
The custom shape has parameters that can be used to modify it. Eccentricity changes the curvature along one of the shape's edges, while inflection changes the concaviy on the other
*/
void makeCustomShape(int inflection, int eccentricity, int horizontalSpan, int verticalSpan){
  /*sanitize parameters*/
  if(horizontalSpan/2 == 0 || verticalSpan/2 ==0){
    return;
  }
  else{
    int anchorX = 0;
    int anchorY = 0;
    verticalSpan = Math.abs(verticalSpan);
    horizontalSpan = Math.abs(horizontalSpan);
    inflection = inflection%horizontalSpan;
  if(inflection<0){
    horizontalSpan = horizontalSpan+inflection;
    anchorX = anchorX-inflection;
  }
  eccentricity = eccentricity%(verticalSpan/2);
  /*now draw the shape*/
  beginShape();
  vertex(                                                                                                           anchorX+inflection,     anchorY);
  bezierVertex(anchorX+inflection,     anchorY,                  anchorX,                 anchorY-verticalSpan/2,   anchorX,                anchorY-verticalSpan/2);
  bezierVertex(anchorX,                anchorY-verticalSpan/2,   anchorX+horizontalSpan,  anchorY-eccentricity,     anchorX+horizontalSpan, anchorY);
  bezierVertex(anchorX+horizontalSpan, anchorY+eccentricity,     anchorX,                 anchorY+verticalSpan/2,   anchorX,                anchorY+verticalSpan/2);
  bezierVertex(anchorX,                anchorY+verticalSpan/2,   anchorX+inflection,      anchorY,                  anchorX+inflection,     anchorY);
  endShape();
  }
};

/*this draws the trace line*/
void drawMouseFollowingCurve(){
  beginShape();
  /*iterate through the queue and connect the dots between the mouse positions*/
  for(int i=0; i<numberOfFramesToRemember; i++){
    curveVertex(xMouseArray[wrapIndex(currentArrayStartIndex-i)],yMouseArray[wrapIndex(currentArrayStartIndex-i)]);
  };
  endShape();
};


/*this helper function is critical to making the arrays and advancing pointer work as a queue. It makes sure that negative index values get wrapped to the array bounds correctly. It fills in the gaps that modulo leaves behind*/
int wrapIndex(int indexIn){
  if(indexIn<0){
    while(abs(indexIn)>numberOfFramesToRemember){
      indexIn +=numberOfFramesToRemember;
    };
    return numberOfFramesToRemember + indexIn;
  }
  else{
    return indexIn;
  }
};

/*this draws the pac man shape*/
void drawMouseFollowingShape(){ 
  /*first, figure out the rotation of the shape - this makes sure the shape is pointing in the direction that the tracer line is moving*/
  float opposite = 0;
  float adjacent = 0;
  float hypotenuse = 0;
    for(int i=0; i<numberOfGhosts; i++){
      adjacent = xMouseArray[wrapIndex(currentArrayStartIndex-i-translateFrameDelay)]-xMouseArray[wrapIndex(currentArrayStartIndex-i-translateFrameDelay-1)];
      opposite = yMouseArray[wrapIndex(currentArrayStartIndex-i-translateFrameDelay)]-yMouseArray[wrapIndex(currentArrayStartIndex-i-translateFrameDelay-1)];
      if(opposite == 0 || adjacent == 0){
        if(opposite == 0){
          if(adjacent<0){
            rotationValue = PI;
          }
          else{
            rotationValue = 0;
          };
        }
        else{
          if(opposite<0){
            rotationValue=.5*PI;
          }
          else{
            rotationValue=1.5*PI;
          };
        };
      }
      else{
          hypotenuse = sqrt(sq(opposite)+sq(adjacent));
          if(opposite<0){
            if(adjacent<0){
              //third quadrant - use tangent and add PI
              rotationValue = PI+atan(opposite/adjacent);
            }
            else{
              //fourth quadrant - use 2*PI - sin
              rotationValue = 2*PI-asin(opposite/hypotenuse);
            };
          }
          else{
            if(adjacent<0){
              //second quadrant use PI - sin
              rotationValue = PI-asin(opposite/hypotenuse);
            }
            else{
              //first quadrant - use tangent
              rotationValue = atan(opposite/adjacent);
            };
          };
        };
      //drawShape
      pushMatrix();
      translate(xMouseArray[wrapIndex(currentArrayStartIndex-i-translateFrameDelay)],yMouseArray[wrapIndex(currentArrayStartIndex-i-translateFrameDelay)]);
      rotate(rotationValue);
      pushStyle();
      stroke(#efefef, 255-int(255/numberOfGhosts*(numberOfGhosts-i)));
      makeCustomShape(50,int(99-hypotenuse),75,100);
      popStyle();
      popMatrix();
  };
};
