import { LightningElement,api,wire,track } from 'lwc';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import getNotifications from '@salesforce/apex/NotificationBarController.getNotifications';
import buttonAction from '@salesforce/apex/NotificationBarController.buttonAction';
import { loadStyle } from 'lightning/platformResourceLoader';
import cssNotificationBar from '@salesforce/resourceUrl/cssNotificationBar';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class NotificationsBar extends LightningElement {
    @api recordId;
    @track notifications = [];    

    renderedCallback() {
        loadStyle(this, cssNotificationBar);        
    }

    connectedCallback() {
        getNotifications({idx:this.recordId}).then(result=>{            
            if(result){
                this.notifications = result; 
            }else{
                //show error
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: result,
                        variant: 'error'
                    })
                );   
            }            
        }).catch(error => {
            //error 
            window.console.log(error);          
        });
    }

    handleClick(ev){      
        buttonAction({idx: ev.target.name,recId:this.recordId}).then(result=>{            
            if(result.success==true){
                switch (result.buttonType) {
                    case 'Updatefield':
                        getRecordNotifyChange([{recordId: this.recordId}]);                        
                        this.notifications = result.notifications;
                        break;
                    case 'Link':
                        window.open(result.link, "_blank");
                        break;                
                    default:
                        break;
                }
            }else{
                //show error
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: result.errorMessage,
                        variant: 'error'
                    })
                );   
            }            
        }).catch(error => {
            //show error
            window.console.log(error);
        });
    }

}