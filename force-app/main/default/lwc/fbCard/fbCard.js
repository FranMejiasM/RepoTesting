// MODIFICADA en fb-cleanup-test
import { LightningElement } from 'lwc';
export default class FbCard extends LightningElement {
    connectedCallback() {
        var unused = 1;
        console.log('MODIFICADO');
        eval('1 + 1');
    }
}
