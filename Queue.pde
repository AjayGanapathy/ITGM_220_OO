/*import statements go here*/


/**
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  Major.Minor
*  @since    2015-08-21
*  @param    <T> any non-primitive class
*/
class Queue<T extends Object>{ //we have to explicitly state that T extends object in order to give the compiler enough information to appropriately size the internal array for type T

  
  /*vars go here*/

  /**
  *  internalArray stores all of the objects that are currently in the queue. 
  */
  private T[] internalArray;
  
  /**
  *  beginningIndex maintains the starting position of the queue. Changing the beginning index changes which element in the internal array is first in the queue, without actually changing that element's index in the array.
  */
  private int beginningIndex = 0;
  
  /**
  * queueLength maintains a count of how many elements are currently in the queue. It can range from zero elements, to the maximum length of the queue.
  */
  private int queueLength = 0; 
  
  
  /*constructor goes here*/

  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param queueMaxLength queueMaxLength determines how long the queue can get. Increasing the maximum length increases the amount of memory provisioned for storing the queue elements
  *  @return  Queue The Queue object stores elements inside an internal array, and provides accessor methods that give the internal array the behaviors of a queue, without sacrificing the performance of an array
  */
  Queue(int queueMaxLength) throws EmptyQueueException{
    try{
//      internalArray = new T[queueMaxLength]; //you cannot initialize a generic array in Java for some odd reason - see http://stackoverflow.com/questions/2927391/whats-the-reason-i-cant-create-generic-array-types-in-java for more information.
      internalArray = (T[]) new Object[queueMaxLength]; //for now, use this hack, which casts object as T ... technically it's sound on a compiler level, since this generic T inherits from Object, and all types inherit from objects, but this might cause problems at runtime
    }
    catch(NegativeArraySizeException e){
      throw new EmptyQueueException((Integer)queueMaxLength+" is negative. Queues must be initialized with a maximum size of greater than or equal to 1");
    }
    if(queueMaxLength == 0){
      throw new EmptyQueueException((Integer)queueMaxLength+" is zero. Queues must be initialized with a maximum size of greater than or equal to 1");
    } 
  }
  
  
  /*public methods go here*/

  /**
  *  Enqueue adds an element to the back of the queue
  *  <p>
  *  Enqueue calculates the index on internalArray that represents the end of the queue, and inserts the element at that index.
  *  In the case that more elements have been enqueued than the maximum length of the queue, Enqueue will overwrite the first element in the queue with the current element, and then increment the beginningIndex to
  *  cycle all elements forward. It will do this silently, without raising an exception or otherwise alerting the object that called it.
  *  <p>  
  *  TODO: automatically resize the queue with a threaded Array Copy, so that silent overwriting never occurs
  *  TODO: throw an exception if the queue cannot be resized
  *
  *  @param elementIn elementIn is the element to be added to the end of the queue
  */
  void enqueue(T elementIn){
    
  }

  /**
  *  Dequeue removes the first element from the front of the queue, and cycles all elements forward.
  *  <p>
  *  Dequeue increments the beginningIndex and decrements the queueLength. In the case that the queue length is zero, dequeue returns null
  *  <p>
  *  TODO: throw an exception if the queue length is zero, rather than returning a null pointer
  *  
  *  @return Description of the returned type goes here
  */
//  T dequeue(){} //temporarily commented so that project will compile
  
  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param index Description of genericType goes here
  *  @return Description of the returned type goes here
  */
  T getValue(int index) throws EmptyQueueException{
    //wrap the index to the length of the queue
    try{
      index %= queueLength;
    }
    catch(ArithmeticException e){
      throw new EmptyQueueException("this queue is empty");
    }
    //next, add the index to the offset of the beginning index
    index += beginningIndex;
    //finally, wrap the beginning index value to the length of the queue and fetch the value
    index %= internalArray.length;
    return internalArray[index];
  }
  
  
  /*private methods go here*/
  
  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param numberOfQueueElementsToCycle Description of numberOfQueueElementsToCycle goes here
  */
  private void cycleForward(int numberOfQueueElementsToCycle){}
  
  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param numberOfQueueElementsToCycle Description of numberOfQueueElementsToCycle goes here
  */
  private void cycleBackward(int numberOfQueueElementsToCycle){}
//  int queueLength(){}
  int maxLength(){
    return internalArray.length;
  }

}

