import { LightningElement, track,api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import pdfsignLibrary from '@salesforce/resourceUrl/pdfsign';
import fabricLibrary from '@salesforce/resourceUrl/fabric3';
import generatePDF from '@salesforce/apex/docuSignController.generatePDF'; 
import loadPreview from '@salesforce/apex/docuSignController.loadPreview'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DocuSign extends LightningElement {
    @track showModal = false;
    @api currentPngOut = "";
    @track templateDoc = '';
    @track templateId = '00X1x000001OdCt';
    @api recordId;
    @track step1 = true;
    @track step2 = false;
    @track error;
    @api vfApiName = '';
    @api docLabel = '';
    urlIframe = '';

    connectedCallback() {
        this.urlIframe = '/apex/' + this.vfApiName + '?Id=' + this.recordId;

        Promise.all([            
            //LoadScript(this, pdfsignLibrary + "/forge-patched.min.js"),
            loadScript(this, pdfsignLibrary + "/pdfjs.parser.js"),
            loadScript(this, pdfsignLibrary + "/pdfsign.js"),
            //loadScript(this, pdfnetLibrary + "/modernizr.custom.min.js"),
            //loadScript(this, pdfnetLibrary + "/FileSaver.min.js"),
        ]).then(() => {            
            window.console.log('Carga bien');
        })
        .catch(function(error) {
            window.console.log('Error loading scripts:');
            window.console.log(error);
        }); 
               
    }
    
    handleClick(event) {
        this.step1 = true;
        this.step2 = false;
        this.showModal = true;        
        
        loadPreview({ temp: this.templateId})
            .then(resp => {
                if (resp!='') {
                    //this.templateDoc = resp.replace(/<img .*?>/g,"");
                    this.templateDoc = resp;

                    this.template.querySelector('.previewHtml').innerHTML =this.templateDoc; 
                } else {
                    window.console.log(resp);
                }                
            })
            .catch(erro => {
                window.console.log(erro);
            })
        
    }
    
    closeModal(event) {
        this.showModal = false;
    }
    
    finish(event) {
        this.showModal = false;

        if (this.recordId)
            window.location = '/' + this.recordId;
        else
            eval("$A.get('e.force:refreshView').fire();");
    }

    submitDetails(event) {
        const button = event.target;
        button.disabled = true;

        this.currentPngOut = this.getCanvas().currentCanvasPng;
        
        generatePDF({ vfApiName: this.vfApiName, idx: this.recordId, sign: this.currentPngOut, docLabel: this.docLabel})
            .then(resp => {
                if (resp !== '') {
                    window.console.log('Success');
                    this.step1 = false;
                    this.step2 = true;                           
                } else {
                    window.console.log(resp);
                }
                
            })
            .catch(erro => {
                window.console.log(erro);
                button.disabled = false;
            });
    }

    handleSaveCanvas(event) {

    }

    getCanvas() {
        return this.template.querySelector(".da-canvas");
    }

    encodeBase64(input) {
        var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";       
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;
        while (i < input.length) {
            chr1 = input[i++];
            chr2 = input[i++];
            chr3 = input[i++];
     
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;
     
            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }
            output = output + keyStr.charAt(enc1) + keyStr.charAt(enc2) + keyStr.charAt(enc3) + keyStr.charAt(enc4);
        }
        return output;
    }
    
    decodeBase64(input) {
        var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";       
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;
        var size = 0;
                
        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
    
        var uint8 = new Uint8Array(input.length);
    
        while (i < input.length) {
    
            enc1 = keyStr.indexOf(input.charAt(i++));
            enc2 = keyStr.indexOf(input.charAt(i++));
            enc3 = keyStr.indexOf(input.charAt(i++));
            enc4 = keyStr.indexOf(input.charAt(i++));
    
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;
    
            uint8[size++] = (chr1 & 0xff);
            if (enc3 !== 64) {
                uint8[size++] = (chr2 & 0xff);
            }
        if (enc4 !== 64) {
                uint8[size++] = (chr3 & 0xff);
        }
    
        }
        return uint8.subarray(0,size);
    }

    convertDataURIToBinary(dataURI) {
        var BASE64_MARKER = ';base64,';
        var base64Index = dataURI.indexOf(BASE64_MARKER) + BASE64_MARKER.length;
        var base64 = dataURI.substring(base64Index);
        return this.decodeBase64(base64);
    }
}