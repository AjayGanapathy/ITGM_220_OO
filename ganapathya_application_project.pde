/*import statements go here*/

/*
  Requirements:
  Written description of concept includes all features to be implemented, visual references and sketches are included
  Code is commented
  Documentation contains all required elements
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
int translateFrameDelay = 60;

/**
*  translateFrameDelay controls the lag between moving the mouse on the screen, and the movement of the 'pac man'. The lag in the original pac man was what made the game difficult, so it seemed natural to include it in this homage.
*/
int currentFrame = 0;

/**
*  Contains the last numberOfFramesToRemember mouse positions
*/
Queue<float[]> mousePosQueue;

/**
*  Contains the last numberOfFramesToRemember mouse positions
*/
Queue<PShape> customShapeQueue;

/*setup goes here*/

/**
*  This code uses a buffer of mouse positions to determine the location, rotation, and shape of a 'pac man' and a trace line
*  <p>
*  tell me how the different things that are being initialized work together
*  this description can be multi-line
*/
void setup(){
  //sanitize parameters
  numberOfFramesToRemember = abs(numberOfFramesToRemember);
  translateFrameDelay = abs(translateFrameDelay);
  //set up some defaults for drawing on the canvas
  size(500,500, OPENGL);
  background(#123456);
//  fill(#ffffff);
//  stroke(#efefef);
  shapeMode(CORNER);
  //initialize queues
//  float[] mousePosArray = new float[2];
//  mousePosArray[0] = mouseX;
//  mousePosArray[1] = mouseY;
//  mousePosQueue = new Queue(mousePosArray);
  customShapeQueue = new Queue(pacManShape(50,25,75,100)); //for now I am using magic numbers, I will send these to a string store later
};


/*draw loop goes here*/

/**
*  Tell me what will result from from the draw loop
*  <p>
*  give me the sequence of events to achieve the result
*  this description can be multi-line
*/
void draw(){
//  shape(pacManShape(50,20,100,100));
  //enqueue shapes to draw
//  int currentFrameMouseX = mouseX;
//  int currentFrameMouseY = mouseY;
  enqueueCustomShape();
  if(currentFrame > translateFrameDelay){
    //clear the background with every frame
    background(#123456);
    println("queue length is "+customShapeQueue.getQueueLength());
    for(int drawIndex=0; drawIndex < customShapeQueue.getQueueLength(); drawIndex++){
      try{
        shape(customShapeQueue.peekAtHead());
        customShapeQueue.cycleForward(1);
//        println("just drew a shape");
      }
      catch(EmptyQueueException e){
        println("throwing an empty queue exception");
        break;
      }
    }
  }
  if(currentFrame > numberOfFramesToRemember){
    //dequeue oldest frame
    try{
      customShapeQueue.dequeue();
    }
    catch(EmptyQueueException E){
      println("the queue is empty!!");
    }
////    customShapeQueue.dequeue();
//    for(int drawIndex=0; drawIndex < numberOfFramesToRemember; drawIndex++){
//      try{
//        shape(customShapeQueue.peekAtHead());
//      }
//      catch(EmptyQueueException e){
//        break;
//      }
//      customShapeQueue.cycleForward(1);
//    }
  }
  //count the number of frames that have been drawn
  currentFrame++;
}

/*methods goes here*/

/**
*  short, 1 line description.
*  <p>
*  longer description if needed
*  this description can be multi-line
*  
*  @param inflection changes the concavity on the other
*  @param eccentricity changes the curvature along one of the shape's edges
*  @param horizontalSpan
*  @param verticalSpan
*/
//void drawMouseFollowingCurve(){
//  beginShape();
//  /*iterate through the queue and connect the dots between the mouse positions*/
//  for(int i=0; i<numberOfFramesToRemember; i++){
//    curveVertex(xMouseArray[wrapIndex(currentArrayStartIndex-i)],yMouseArray[wrapIndex(currentArrayStartIndex-i)]);
//  };
//  endShape();
//};
//
////TODO refactor this function into queue
//int wrapIndex(int indexIn){
//  if(indexIn<0){
//    while(abs(indexIn)>numberOfFramesToRemember){
//      indexIn +=numberOfFramesToRemember;
//    };
//    return numberOfFramesToRemember + indexIn;
//  }
//  else{
//    return indexIn;
//  }
//};

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
void enqueueCustomShape(){
  //first, use asin, acos, and atan to figure out the rotation of the shape
  float rotationValue = PI/2;
  float opposite = mouseY-pmouseY;
  float adjacent = mouseX-pmouseX;  
  float hypotenuse = sqrt(sq(opposite)+sq(adjacent));
  if(hypotenuse == 0){
    //then mouse cursor hasn't changed position, and the shape should be the duplicate of whatever it was last time
    customShapeQueue.cycleBackward(1);
    try{
      customShapeQueue.enqueue(customShapeQueue.peekAtHead());
    }
    catch(EmptyQueueException e){
      //do nothing for now
    }
    customShapeQueue.cycleForward(1);
  }
  else{
    if(opposite < 0){
      //then rotation is in quadrants 3 or 4 - use value of arccos + PI
      rotationValue = acos(adjacent/hypotenuse)+PI;
    }
    else{
      //then rotation is in quadrants 1 or 2 - use value of arccos
      rotationValue = acos(adjacent/hypotenuse);
    }
  }
  float anchorX = 0;
  float anchorY = 0;
  int verticalSpan = 100;
  int horizontalSpan = 100;
  int eccentricity = (int)(99-hypotenuse);
  int inflection = 50;
  PShape pacManInstance = createShape();
  pacManInstance.translate(mouseX,mouseY);
  pacManInstance.rotate(rotationValue);
  pacManInstance.beginShape();
  pacManInstance.fill(#ffffff);
  pacManInstance.stroke(#000000);
  pacManInstance.strokeWeight(2);
  pacManInstance.vertex(                                                                                                           anchorX+inflection,     anchorY);
  pacManInstance.bezierVertex(anchorX+inflection,     anchorY,                  anchorX,                 anchorY-verticalSpan/2,   anchorX,                anchorY-verticalSpan/2);
  pacManInstance.bezierVertex(anchorX,                anchorY-verticalSpan/2,   anchorX+horizontalSpan,  anchorY-eccentricity,     anchorX+horizontalSpan, anchorY);
  pacManInstance.bezierVertex(anchorX+horizontalSpan, anchorY+eccentricity,     anchorX,                 anchorY+verticalSpan/2,   anchorX,                anchorY+verticalSpan/2);
  pacManInstance.bezierVertex(anchorX,                anchorY+verticalSpan/2,   anchorX+inflection,      anchorY,                  anchorX+inflection,     anchorY);
  pacManInstance.endShape(CLOSE);
  customShapeQueue.enqueue(pacManInstance);
};

PShape pacManShape(int inflection, int eccentricity, int horizontalSpan, int verticalSpan){
//    PShape temp = createShape(RECT, 50,50,currentFrame,currentFrame);
//    return temp;
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
  
  PShape pacManInstance = createShape();
  pacManInstance.beginShape();
  pacManInstance.vertex(                                                                                                           anchorX+inflection,     anchorY);
  pacManInstance.bezierVertex(anchorX+inflection,     anchorY,                  anchorX,                 anchorY-verticalSpan/2,   anchorX,                anchorY-verticalSpan/2);
  pacManInstance.bezierVertex(anchorX,                anchorY-verticalSpan/2,   anchorX+horizontalSpan,  anchorY-eccentricity,     anchorX+horizontalSpan, anchorY);
  pacManInstance.bezierVertex(anchorX+horizontalSpan, anchorY+eccentricity,     anchorX,                 anchorY+verticalSpan/2,   anchorX,                anchorY+verticalSpan/2);
  pacManInstance.bezierVertex(anchorX,                anchorY+verticalSpan/2,   anchorX+inflection,      anchorY,                  anchorX+inflection,     anchorY);
  pacManInstance.endShape();
  return pacManInstance;
}

