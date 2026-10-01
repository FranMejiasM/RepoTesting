// TRAMPA - acaba igual que fbCard.js
import { LightningElement } from 'lwc';
export default class ScorefbCard extends LightningElement {
    connectedCallback() {
        var unused = 1;
        console.log('debug');
        eval('1 + 1');
    }
}
