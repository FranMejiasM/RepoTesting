public class TestPopup{
    public boolean DisplayPopup {get; set;}    
     
    public void ClosePopup() {       
        DisplayPopup = false;   
    }
  
    public void ShowPopup() {       
        DisplayPopup = true;   
    }
  }