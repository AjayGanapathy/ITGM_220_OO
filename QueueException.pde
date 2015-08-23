/*import statements go here*/
import java.lang.Exception;

/**
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  1.1
*  @since    2015-08-22
*/

class QueueException extends Exception{
  
  public QueueException(){
    super();
  }

  public QueueException(String message){
    super(message);
  }

}
