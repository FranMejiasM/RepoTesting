import { LightningElement, wire, track } from 'lwc';
import getParams from '@salesforce/apex/FeatureParameterTableCtrl.getParams';
import updateValues from '@salesforce/apex/FeatureParameterTableCtrl.updateValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FeatureParameterList extends LightningElement {
    @track rows = [];
    draftValues = [];
    sortedBy = 'packageName';
    sortedDirection = 'asc';

    columns = [
        { label: 'Package', fieldName: 'packageName', type: 'text', sortable: true },
        { label: 'Version', fieldName: 'versionNumber', type: 'text', sortable: true },
        { label: 'Beta', fieldName: 'isBeta', type: 'boolean', sortable: true },
        { label: 'Feature', fieldName: 'featureFullName', type: 'text', sortable: true, wrapText: true },
        // Editable checkbox:
        { label: 'Value', fieldName: 'sfFma__Value__c', type: 'boolean', editable: true },
        { label: 'Lead Name', fieldName: 'leadName', type: 'text', sortable: true },
        { label: 'Company', fieldName: 'company', type: 'text', sortable: true, wrapText: true },
        { label: 'Subscriber Org ID', fieldName: 'subscriberOrgId', type: 'text', sortable: true },
        { label: 'Sandbox', fieldName: 'isSandbox', type: 'boolean', sortable: true },
        { label: 'Org Type', fieldName: 'orgType', type: 'text', sortable: true },
        { label: 'License Status', fieldName: 'licenseStatus', type: 'text', sortable: true }
    ];

    @wire(getParams)
    wiredParams({ data, error }) {
        if (data) {
            // Aplanar relaciones para la datatable
            this.rows = data.map(r => ({
                Id: r.Id,
                sfFma__Value__c: r.sfFma__Value__c,
                featureFullName: r.sfFma__FeatureParameter__r?.sfFma__FullName__c,
                packageName: r.sfFma__License__r?.sfLma__Package_Version__r?.sfLma__Package__r?.Name,
                versionNumber: r.sfFma__License__r?.sfLma__Package_Version__r?.sfLma__Version_Number__c,
                isBeta: r.sfFma__License__r?.sfLma__Package_Version__r?.sfLma__Is_Beta__c,
                leadName: r.sfFma__License__r?.sfLma__Lead__r?.Name,
                company: r.sfFma__License__r?.sfLma__Lead__r?.Company,
                subscriberOrgId: r.sfFma__License__r?.sfLma__Subscriber_Org_ID__c,
                isSandbox: r.sfFma__License__r?.sfLma__Is_Sandbox__c,
                orgType: r.sfFma__License__r?.sfLma__Lead__r?.sfLma__Subscriber_Org_Type__c,
                licenseStatus: r.sfFma__License__r?.sfLma__Status__c
            }));
            // Orden inicial opcional
            this.sortData(this.sortedBy, this.sortedDirection);
        } else if (error) {
            this.toast('Error', this.normalizeError(error), 'error');
        }
    }

    handleSave(evt) {
        const updates = evt.detail.draftValues.map(d => ({
            Id: d.Id,
            sfFma__Value__c: d.sfFma__Value__c
        }));

        updateValues({ rows: updates })
            .then(() => {
                this.toast('Saved', 'Changes saved successfully', 'success');
                // Aplicar cambios localmente sin recargar:
                const byId = new Map(this.rows.map(r => [r.Id, r]));
                updates.forEach(u => {
                    if (byId.has(u.Id)) byId.get(u.Id).sfFma__Value__c = u.sfFma__Value__c;
                });
                this.rows = Array.from(byId.values());
                this.draftValues = [];
            })
            .catch(err => {
                this.toast('Error saving', this.normalizeError(err), 'error');
            });
    }

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortedDirection);
    }

    sortData(field, direction) {
        const isAsc = direction === 'asc';
        this.rows = [...this.rows].sort((a, b) => {
            const v1 = a[field];
            const v2 = b[field];
            if (v1 === v2) return 0;
            // manejo de boolean/text
            if (v1 === undefined || v1 === null) return 1;
            if (v2 === undefined || v2 === null) return -1;
            return (v1 > v2 ? 1 : -1) * (isAsc ? 1 : -1);
        });
    }

    toast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    normalizeError(error) {
        return (error?.body?.message || error?.message || 'Unknown error');
    }
}
