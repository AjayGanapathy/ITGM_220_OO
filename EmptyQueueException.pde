/*import statements go here*/

/**
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  1.1
*  @since    2015-08-21
*/

class EmptyQueueException extends QueueException{
  
  public EmptyQueueException(){
    super();
  }

  public EmptyQueueException(String message){
    super(message);
  }

}
