/*import statements go here*/

/**
*  Encapsulates a custom linked list, wrapped into a circular buffer. It moves head and tail pointers, rather than list nodes, to improve performance.
*
*  @author   Ajay Ganapathy <lets.talk@designbyajay.com>
*  @version  1.1
*  @since    2015-08-22
*  @param    <E> any non-primitive class, or autoboxed primitive
*/
class QueueElement<V>{
  
  
  /*vars go here*/

  /**
  *  Maintains a reference to the previous element in the queue
  */
  private QueueElement previousQueueElement;

  /**
  *  Maintains a reference to the next element in the queue
  */
  private QueueElement nextQueueElement;
  
  /**
  *  Stores the value associated with this element in the queue
  */  
  private V storedValue;
  
  
  /*constructor goes here*/

  /**
  *  Creates a queue element, and links it into an existing linked list
  *  <p>
  *  This constructor is called internally when using the insertValueBefore() and insertValueAfter() methods
  *  It can be called externally, and be used to manually create queue elements, and link those elements into an existing list. However, this effect is achieved with the aformentioned methods.
  *  
  *  @param valueIn the value to store in this element
  *  @param elementPrevious the queueElement that comes before this element 
  *  @param elementNext the queueElement that comes after this element
  */
  QueueElement(V valueIn, QueueElement elementPrevious, QueueElement elementNext){
    storedValue = valueIn;
    previousQueueElement = elementPrevious;
    nextQueueElement = elementNext;
  }

  /**
  *  Creates a monad that can grow into a circular doubly linked list
  *  <p>
  *  The monad's previous and next linked list items point back to itself
  *  
  *  @param valueIn the value to store in this element
  */  
  QueueElement(V valueIn){
    storedValue = valueIn;
    previousQueueElement = this;
    nextQueueElement = this;
  }
  
  
  /*public methods go here*/

  /**
  *  Encapsulates a value inside a queue element, and then inserts that element before this element
  *
  *  @param valueToInsert the value of type <V> that will be encapsulated
  */
  public void insertValueBefore(V valueToInsert){
    QueueElement elementBefore = new QueueElement(valueToInsert, previousQueueElement, this);
    previousQueueElement.nextQueueElement = elementBefore;
    previousQueueElement = elementBefore;
  }

  /**
  *  Encapsulates a value inside a queue element, and then inserts that element after this element
  *
  *  @param valueToInsert the value of type <V> that will be encapsulated
  */
  public void insertValueAfter(V valueToInsert){
    QueueElement elementAfter = new QueueElement(valueToInsert, nextQueueElement, this);
    nextQueueElement.previousQueueElement = elementAfter;
    nextQueueElement = elementAfter;
  }
  
  /**
  *  Removes this element from the queue. Does NOT delete this element. Remember to update any pointers to this element manually to avoid accidentally unlinking the queue
  */
  public void removeSelf(){
    nextQueueElement.previousQueueElement = this.previousQueueElement;
    previousQueueElement.nextQueueElement = this.nextQueueElement;
    //run two self-reference checks
    if(previousQueueElement == this){
      println("this is the first element in the queue");
      //then this element is the first element in the queue
      nextQueueElement.previousQueueElement = nextQueueElement;
    }
    if(nextQueueElement == this){
      println("this is the last element in the queue");
      //then this element is the last element in the queue
      previousQueueElement.nextQueueElement = previousQueueElement;
    }
    //remove references from previous and next elements from this element to allow for garbage collection of those elements later on
    previousQueueElement = null;
    nextQueueElement = null;
    println("element removed");
  }
  
  /**
  *  Changes the value stored inside this linked list element
  */
  public void setThisElementValue(V valueToStore){
    storedValue = valueToStore;
  }
  
  /**
  *  On instantiation, each queue element gets a value of type V to store inside it. This accessor gets that value.
  *
  *  @return V value currently stored inside this element
  */
  public V getThisElementValue(){
    return storedValue;
  }
  
  /**
  *  Returns a pointer to the previous queue element. Throws a QueueBoundsException if this is the first element in the queue
  *
  *  @return QueueElement pointer to previous queue element
  *  @see QueueBoundsException
  */
  public QueueElement getPreviousElement() throws QueueBoundsException{
    if(previousQueueElement == this || previousQueueElement == null){
      throw new QueueBoundsException("this is the first element in the queue. There are no previous elements.");
    }
    else{
      return previousQueueElement;
    }
  }
  
  /**
  *  Returns a pointer to the next queue element. Throws a QueueBoundsException if this is the last element in the queue
  *
  *  @return QueueElement pointer to next queue element
  *  @see QueueBoundsException
  */
  public QueueElement getNextElement() throws QueueBoundsException{
    if(nextQueueElement == this || nextQueueElement == null){
      throw new QueueBoundsException("this is the last element in the queue. There are no next elements.");
    }
    else{
      return nextQueueElement;
    }
  }
  
  
  /*private methods go here*/
}

