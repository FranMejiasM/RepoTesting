
public with sharing Class OperationsInLoops {
    public void messageInsideOfLoop2() {
        if(3==3)  {
            system.debug('issue 1');
        }
        if('Pepe'!= 'pepe')  {
            system.debug('issue 2');
        }
        if('Pepe' > 'Pepe')  {
            system.debug('issue 3');
        }
        String x;
        if(x <= x)  {
            system.debug('issue 3');
        }
        String pepe = 'hola quiero ver si salta el issue';
    }
}