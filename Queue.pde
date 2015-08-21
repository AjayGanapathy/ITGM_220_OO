/*import statements go here*/

/**
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  Major.Minor
*  @since    2015-08-21
*/
class Queue<T>{

  
  /*vars go here*/

  /**
  *  Description of internalArray goes here
  */
  private T[] internalArray;
  /**
  *  Description of beginningIndex goes here
  */
  private int beginningIndex = 0;
  /**
  *  Description of endIndex goes here
  */
  private int endIndex = 0; 
  
  
  /*constructor goes here*/

  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param queueMaxLength Description of queueMaxLength goes here
  *  @return Queue Description of the queue object goes here
  */
  Queue(int queueMaxLength){
    internalArray = T[arrayLength];
  }
  
  
  /*public methods go here*/

  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param objectIn Description of objectIn goes here
  */
  void enqueue(T objectIn){
  
  }

  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @return Description of the returned type goes here
  */
  T dequeue(){}

  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param numberOfQueueElementsToCycle Description of numberOfQueueElementsToCycle goes here
  */
  void cycleForward(int numberOfQueueElementsToCycle){}
  
  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param numberOfQueueElementsToCycle Description of numberOfQueueElementsToCycle goes here
  */
  void cycleBackward(int numberOfQueueElementsToCycle){}
  int queueLength(){}
  int maxLength(){
    return internalArray.length;
  }
  
  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param index Description of genericType goes here
  *  @return Description of the returned type goes here
  */
  T getValue(int index){
    //wrap the index when getting the value
  }
  
  
  /*private methods go here*/


}

