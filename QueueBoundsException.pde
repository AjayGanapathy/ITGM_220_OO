/*import statements go here*/

/**
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  Major.Minor
*  @since    2015-08-22
*/

class QueueBoundsException extends QueueException{
  
  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param queueMaxLength queueMaxLength determines how long the queue can get. Increasing the maximum length increases the amount of memory provisioned for storing the queue elements
  *  @return  Queue The Queue object stores elements inside an internal array, and provides accessor methods that give the internal array the behaviors of a queue, without sacrificing the performance of an array
  */
  public QueueMaxLengthException(){
    super();
  }

  /**
  *  short, 1 line description.
  *  <p>
  *  longer description if needed
  *  this description can be multi-line
  *  
  *  @param queueMaxLength queueMaxLength determines how long the queue can get. Increasing the maximum length increases the amount of memory provisioned for storing the queue elements
  *  @return  Queue The Queue object stores elements inside an internal array, and provides accessor methods that give the internal array the behaviors of a queue, without sacrificing the performance of an array
  */  
  public QueueMaxLengthException(String message){
    super(message);
  }

}
