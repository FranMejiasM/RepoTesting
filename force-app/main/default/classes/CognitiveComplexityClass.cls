/**
 * @description DummyClass
 */
public with sharing class CognitiveComplexityClass {    
    /**
    * @description dummy Method
    */   
    public void cognitiveComplexityMethod() {
        int x = 0; 
        int y = 1; 
        int z = 2; 
        int t = 2;
        boolean a = false; 
        boolean b = true;
        boolean c = false; 
        boolean d = true;
        
        if (a && b || b && d) {
          if (y == z) {
            x = 2;
          } else if (y == t && !d) {
            x = 2;
          } else {
            x = 2;
          }
        } else if (c && d) {
          while (z < y) {
            x = 2;
          }
        } else {
          for (int n = 0; n < t; n++) {
            x = 2;
          }
        }
    }
}