import { LightningElement, api, track, wire } from 'lwc';
import getAttachedImages from '@salesforce/apex/CarouselRecordImagesController.getAttachedImagesByType';
import getSObjectLabel from '@salesforce/apex/CarouselRecordImagesController.getSObjectLabel';

export default class CarouselRecordImages extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api fileTypes;
    @track hola;

    @track images = [];
    imagePointer = -1;
    intervalId;

    get image() {
        return this.images[this.imagePointer];
    }

    queryDone = false;
    sObjectLabel = '';

    @wire(getAttachedImages, { recordId: "$recordId", fileTypes: "$fileTypes" })
    getImages({ error, data }) {
        if (data) {
            this.parseImages(data);
            this.initLoop();
        } else {
            this.error = error;
            if (this.recordId)
                console.log('error getAttachedImages: ' + JSON.stringify(error));
        }
    }

    parseImages(docLinks) {
        this.images = docLinks.map(docLink => {
            const doc = docLink.ContentDocument.LatestPublishedVersion;
            
            return {
                id: doc.Id,
                url: doc.FileType == 'LINK' ? (doc.ContentUrl): ('/sfc/servlet.shepherd/version/download/' + doc.Id),
                title: doc.Title,
                description: doc.Description,
                fileType: doc.FileType,
                href: '/' + docLink.ContentDocumentId,
                class: 'transparent'
            }
        });
    }

    initLoop() {
        this.queryDone = true;
        this.nextImage();
        this.play();
    }

    play() {
        this.intervalId = setInterval(this.nextImage.bind(this), 10000);
    }

    pause() {
        clearInterval(this.intervalId);
        this.intervalId = null;
    }

    changeImage(event) {
        this.pause();

        const button = event.target.name;

        if (button === 'rightButton')
            this.nextImage();
        else if (button === 'leftButton')
            this.previousImage();
    }

    nextImage() {
        if (this.images.length) {
			this.hideImg();
            this.incrementPointer();
            this.showImg();
        }
    }

    incrementPointer() {
        this.imagePointer++;

        if (this.imagePointer === this.images.length)
            this.imagePointer = 0;
    }

    previousImage() {
        if (this.images.length) {
			this.hideImg();
            this.decrementPointer();
            this.showImg();
        }
    }

    decrementPointer() {
        --this.imagePointer;

        if (this.imagePointer < 0)
			this.imagePointer = this.images.length - 1;
    }
	
	hideImg() {
        if (this.image)
            this.image.class = 'transparent';
	}

	showImg() {
        if (this.image)
            this.image.class = 'opaque';
	}

    @wire(getSObjectLabel, { sObjectApiName: "$objectApiName" })
    getSObjectLabel({ error, data }) {
        if (data) {
            this.sObjectLabel = data;
        } else if (error) {
            console.log("error getSObjectLabel: " + JSON.stringify(error));
            this.sObjectLabel = this.objectApiName;
        }
	}
}