/*import statements go here*/

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

/**
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  1.0 
*  @since    2015-08-20
*/


/*vars go here*/

/**
*  numberOfFramesToRemember determines the length of the trace line. The trace line follows the mouse, connecting the dots between the current frame and all the frames in memory
*/
int numberOfFramesToRemember = 100;

/**
*  translateFrameDelay controls the lag between moving the mouse on the screen, and the movement of the 'pac man'. The lag in the original pac man was what made the game difficult, so it seemed natural to include it in this homage.
*/
int translateFrameDelay = 10;

/**
*  NumberOfGhosts doesn't actually make pac man 'ghosts' on the screen. Instead, it determines how much to onion skin pac man into the past. It's useful for viewing the squash and stretch on Pac Man as he moves around the screen.
*/
int numberOfGhosts = 90;


//PShape[] deltaArray = new PShape[numberOfFramesToRemember]; - this is an optimization that I have yet to add - rather than recalculating the pshapes every frame, just cache them and calculate one per frame

/**
*  Description of xMouseArray goes here
*/
float[] xMouseArray = new float[numberOfFramesToRemember];

/**
*  Description of yMouseArray goes here
*/
float[] yMouseArray = new float[numberOfFramesToRemember];

/**
*  Description of rotationValue goes here
*/
float rotationValue = 0;

/**
*  Description of currentArrayStartIndex goes here
*/
int currentArrayStartIndex = 0;


/*setup goes here*/

/**
*  This code uses a buffer of mouse positions to determine the location, rotation, and shape of a 'pac man' and a trace line
*  <p>
*  tell me how the different things that are being initialized work together
*  this description can be multi-line
*/
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


/*draw loop goes here*/

/**
*  Tell me what will result from from the draw loop
*  <p>
*  give me the sequence of events to achieve the result
*  this description can be multi-line
*/
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

/*methods goes here*/

/**
*  short, 1 line description.
*  <p>
*  longer description if needed
*  this description can be multi-line
*  
*  @param inflection changes the concaviy on the other
*  @param eccentricity changes the curvature along one of the shape's edges
*  @param horizontalSpan
*  @param verticalSpan
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

/**
*  short, 1 line description.
*  <p>
*  longer description if needed
*  this description can be multi-line
*  
*  @param inflection changes the concaviy on the other
*  @param eccentricity changes the curvature along one of the shape's edges
*  @param horizontalSpan
*  @param verticalSpan
*/
void drawMouseFollowingCurve(){
  beginShape();
  /*iterate through the queue and connect the dots between the mouse positions*/
  for(int i=0; i<numberOfFramesToRemember; i++){
    curveVertex(xMouseArray[wrapIndex(currentArrayStartIndex-i)],yMouseArray[wrapIndex(currentArrayStartIndex-i)]);
  };
  endShape();
};

//TODO refactor this function into queue
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

/**
*  this draws the pac man shape
*  <p>
*  longer description if needed
*  this description can be multi-line
*  
*  @param inflection changes the concaviy on the other
*  @param eccentricity changes the curvature along one of the shape's edges
*  @param horizontalSpan
*  @param verticalSpan
*/
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
