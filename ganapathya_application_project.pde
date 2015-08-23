/*import statements go here*/

/**
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  1.0 
*  @since    2015-08-20
*/


/*vars go here*/

/**
*  numberOfFramesToRemember determines the length of the trace line. The trace line follows the mouse, connecting the dots between the current frame and all the frames in memory
*/
int numberOfFramesToRemember = 300;

/**
*  translateFrameDelay controls the lag between moving the mouse on the screen, and the movement of the 'pac man'. The lag in the original pac man was what made the game difficult, so it seemed natural to include it in this homage.
*/
int translateFrameDelay = 60;

/**
*  CurrentFrame is an index of how many frames processing has rendered. It is a global variable that is used internally by the code, and is not to be changed.
*/
int currentFrame = 0;

/**
*  Contains the last numberOfFramesToRemember mouse positions
*/
Queue<PShape> customShapeQueue;

/*setup goes here*/

/**
*  This code uses a queue of PShapes to draw a sequence of 'pac mans' following the mouse
*  <p>
*  This code initializes a queue of PShapes, calculates a PShape given mouse velocity, and then enqueues the PShape. It retreives it later to draw on screen.
*/
void setup(){
  //sanitize parameters
  numberOfFramesToRemember = abs(numberOfFramesToRemember);
  translateFrameDelay = abs(translateFrameDelay);
  //set up some defaults for drawing on the canvas
  size(500,500, OPENGL);
  background(#123456);
  shapeMode(CORNER);
  //initialize queues
  customShapeQueue = new Queue(pacManShape(50,25,75,100)); //for now I am using magic numbers, I will send these to a string store later
};


/*draw loop goes here*/

/**
*  The draw loop calculates and adds one new PShape to the queue with each frame. It also draws all previous PShapes available in the queue
*/
void draw(){
  enqueueCustomShape();
  if(currentFrame > translateFrameDelay){
    //clear the background with every frame
    background(#123456);
    println("queue length is "+customShapeQueue.getQueueLength());
    for(int drawIndex=0; drawIndex < customShapeQueue.getQueueLength(); drawIndex++){
      try{
        shape(customShapeQueue.peekAtHead());
        customShapeQueue.cycleForward(1);
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
  }
  currentFrame++;
}

/**
*  this enqueues the pac man shape
*  <p>
*  it transforms the pac man shape according to the direction and position of mouse movement
*/
void enqueueCustomShape(){
  //first, use asin, acos, and atan to figure out the rotation of the shape
  float rotationValue = PI/2;
  float opposite = mouseY-pmouseY;
  float adjacent = mouseX-pmouseX;  
  float hypotenuse = sqrt(sq(opposite)+sq(adjacent));
  if(hypotenuse == 0){
    return; //hack that prevents memory leak from occuring
//    //then mouse cursor hasn't changed position, and the shape should be the duplicate of whatever it was last time
//    customShapeQueue.cycleBackward(1);
//    try{
//      PShape toDuplicate = customShapeQueue.peekAtHead();
//      customShapeQueue.cycleForward(1);
//      customShapeQueue.enqueue(toDuplicate);
////      customShapeQueue.enqueue(customShapeQueue.peekAtHead());
//    }
//    catch(EmptyQueueException e){
//      //do nothing for now
//    }
////    customShapeQueue.cycleForward(1);
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
  PShape pacManInstance = pacManShape(50,(int)(99-hypotenuse),100,100);
  pacManInstance.translate(mouseX,mouseY);
  pacManInstance.rotate(rotationValue);
  customShapeQueue.enqueue(pacManInstance);
};

/**
*  this draws the pac man shape
*  <p>
*  it uses processing's bezier functions and the PShape class to store a vertex buffer that can be drawn with hardware acceleration
*  
*  @param inflection changes the concavity of the pac man's mouth
*  @param eccentricity changes the curvature along othe pac man's back
*  @param horizontalSpan changes the width of the pac man
*  @param verticalSpan changes the height of the pac man
*  @return PShape returns the shape to be enqueued
*/
PShape pacManShape(int inflection, int eccentricity, int horizontalSpan, int verticalSpan){
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

