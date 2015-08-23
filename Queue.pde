/*import statements go here*/

/**
*  Encapsulates a custom linked list, wrapped into a circular buffer. It moves head and tail pointers, rather than list nodes, to improve performance.
*
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  Major.Minor
*  @since    2015-08-21
*  @param    <V> any non-primitive class, or autoboxed primitive
*/
class Queue<V>{

  
  /*vars go here*/
  
  /**
  *  Maintains a reference to the element that is at the beginning of the queue
  */
  private QueueElement<V> headPointer;
  
  
  /*constructor goes here*/

  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @return Queue The Queue object stores elements inside an internal circular buffer, which allows for quick cycling, enqueueing and dequeueing of queue elements
  */
  Queue(V firstValue){ //TODO: add a constructor that accepts an iterable as an argument
    //create an intentionally empty queue (the queue value is null
    headPointer = new QueueElement(firstValue);
  }
  
  
  /*public methods go here*/

  /**
  *  Enqueue adds an element to the back of the queue
  *  <p>
  *  describe how it achieves this effect
  *  <p>  
  *
  *  @param elementIn elementIn is the element to be added to the end of the queue
  */
  void enqueue(V valueIn){
    if(headPointer.getThisElementValue() != null){
      headPointer.insertValueBefore(valueIn);
    }
    else{
      headPointer.setThisElementValue(valueIn);
    }
  }

  /**
  *  Dequeue removes the first element from the front of the queue, and cycles all elements forward.
  *  <p>
  *  Dequeue increments the beginningIndex and decrements the queueLength. In the case that the queue length is zero, dequeue returns null
  *  <p>
  *  TODO: throw an exception if the queue length is zero, rather than returning a null pointer
  *  
  *  @return returns the value that was just dequeued;
  */
  V dequeue() throws EmptyQueueException{
    try{
      V toReturn = headPointer.getThisElementValue();
      QueueElement toRemove = headPointer;
      try{
        headPointer = headPointer.getNextElement();
        toRemove.removeSelf();
      }
      catch(QueueBoundsException e){
        //in this case, make an empty queue;
        println("this queue is empty!!");
        headPointer.setThisElementValue(null);
      }
      return toReturn;
    }
    catch(NullPointerException e){
      throw new EmptyQueueException("there are no values left in the queue");
    }
  }

  /**
  *  Dequeue removes the first element from the front of the queue, and cycles all elements forward.
  *  <p>
  *  Dequeue increments the beginningIndex and decrements the queueLength. In the case that the queue length is zero, dequeue returns null
  *  <p>
  *  TODO: throw an exception if the queue length is zero, rather than returning a null pointer
  *  
  *  @return returns the value that was just dequeued;
  */
  V peekAtHead() throws EmptyQueueException{
    try{
      V toReturn = headPointer.getThisElementValue();
      return toReturn;
    }
    catch(NullPointerException e){
      throw new EmptyQueueException("this queue is empty");
    }
  }
  /**
  *  Moves the first element in the queue to the end of the queue
  *  
  *  @param numberOfQueueElementsToCycle the number of elements to move from the beginning of the queue to the end of the queue
  */
  public void cycleForward (int numberOfQueueElementsToCycle){
    QueueElement initialHeadPointer = headPointer;
    for(int elementIndex=0; elementIndex<numberOfQueueElementsToCycle%this.getQueueLength(); elementIndex++){
      try{      
        headPointer = headPointer.getNextElement();
      }
      catch(QueueBoundsException e){
        println("queue bounds exception");
        break;
//        //if the circular buffer is broken, fix it
//        relinkQueueCircularBuffer();
//        //then reset the head pointer and try again
//        headPointer = initialHeadPointer;
//        this.cycleForward(numberOfQueueElementsToCycle);
      }
    }
  }
  
  /**
  *  Moves the last element in the queue to the beginning of the queue
  *  
  *  @param numberOfQueueElementsToCycle the number of elements to move from the end of the queue to the beginning of the queue
  */
  public void cycleBackward(int numberOfQueueElementsToCycle){
    QueueElement initialHeadPointer = headPointer;
    for(int elementIndex=0; elementIndex<numberOfQueueElementsToCycle%this.getQueueLength(); elementIndex++){
      try{      
        headPointer = headPointer.getPreviousElement();
      }
      catch(QueueBoundsException e){
        break;
//        //if the circular buffer is broken, fix it
//        relinkQueueCircularBuffer();
//        //then reset the head pointer and try again
//        headPointer = initialHeadPointer;
//        this.cycleBackward(numberOfQueueElementsToCycle);
      }
    }
  }
  
  /**
  *  Accessor for the number of elements in a queue. This works by actually counting the number of elements in the queue every time it is called. 
  *  <p>
  *  There is no corresponding 'setQueueLength' method because the length of the queue changes as elements are enqueued
  *  <p>
  *  TODO: keep an index of the length of the queue, and update it on enqueue and dequeue
  *  
  *  @return number of elements currently in queue
  */
  public int getQueueLength(){
    QueueElement currentElement = headPointer;
    int toReturn = 0;
    if(headPointer.getThisElementValue() != null){
      do{
        try{
          currentElement = currentElement.getNextElement();
          toReturn++;
        }
        catch(QueueBoundsException e){
          return 1; //this is a hack that assumes that the queue will never be empty. TODO: fix this hack
//          //fix the circular buffer
//          relinkQueueCircularBuffer();
//          //then try this same method again
//          this.getQueueLength();
        }
      }
      while(currentElement != headPointer);
    }
    return toReturn;
  }
    
    
  /*private methods go here*/
//  private void relinkQueueCircularBuffer(){
//    return; //will finish this method later
//  }

}

