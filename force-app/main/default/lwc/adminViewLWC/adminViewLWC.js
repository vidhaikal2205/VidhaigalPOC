import { LightningElement, wire } from 'lwc';
import getCommunityMembers from '@salesforce/apex/CommunityMemberController.getCommunityMembers';
import convertRegistrationToContact from '@salesforce/apex/CommunityMemberConversionService.convertRegistrationToContact';
import updateStatus from '@salesforce/apex/CommunityMemberController.updateStatus';
import getFileDetails from '@salesforce/apex/IdPreviewController.getFileDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class AdminViewLWC extends LightningElement 
{
    records;
    wiredResult;
    isLoading = true;
    error;

    isModalOpen = false;
    isDetailsModalOpen = false;
    isApproveModalOpen = false;
    isRejectModalOpen = false;

    contentVersionId;
    selectedRecordId;
    approveReason = '';
    rejectReason = '';

    columns = [
        { label: 'Name', fieldName: 'First_Name__c' },
        { label: 'Status', fieldName: 'Approval_Status__c' },
        { label: 'Email', fieldName: 'Email__c' },
        { label: 'Mobile Number', fieldName: 'Mobile_Number__c' },
        { label: 'Created Date', fieldName: 'CreatedDate' },
        {
            type: 'button',
            typeAttributes: {
                label: 'Preview ID',
                name: 'PreviewID'
            }
        },
        {
            type: 'button',
            typeAttributes: {
                label: 'View Details',
                name: 'ViewDetails'
            }
        },
        {
            type: 'button',
            typeAttributes: {
                label: 'Approve',
                name: 'approved',
                variant: 'brand'
            }
        },
        {
            type: 'button',
            typeAttributes: {
                label: 'Reject',
                name: 'rejected',
                variant: 'destructive'
            }
        }
    ];

    @wire(getCommunityMembers)
    wiredMembers(result) {
        this.wiredResult = result;
        if (result.data) {
            this.records = result.data;
            this.isLoading = false;
        } else if (result.error) {
            this.error = result.error.body.message;
            this.isLoading = false;
        }
    }

    // IMAGE PREVIEW 
    get fileUrl() {
        return this.contentVersionId
            ? `/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=${this.contentVersionId}`
            : '';
    }

    async handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'PreviewID') {
            try {
                this.contentVersionId = await getFileDetails({ recordId: row.Id });
                this.isModalOpen = true;
            } catch {
                this.showToast('Error', 'Unable to load ID proof', 'error');
            }
            return;
        }   

        if (actionName === 'ViewDetails') {
            this.selectedRecordId = row.Id;
            this.isDetailsModalOpen = true;
        }

        if (actionName === 'approved') {
            this.selectedRecordId = row.Id;
            this.isApproveModalOpen = true;
        }

        if (actionName === 'rejected') {
            this.selectedRecordId = row.Id;
            this.isRejectModalOpen = true;
        }
    }

    handleReasonChange(event) 
    
    {
        this.approveReason = event.target.value;
        this.rejectReason = event.target.value;
    }

    /*closeModal() {
        this.isModalOpen = false;
    } */

    async confirmApprove()
    {
        // If selected RecordId exists, treat it as approval
        if (this.selectedRecordId) 
        {
            const recordId = this.selectedRecordId;

            try {
                 //Convert registration to Contact
                const contactId = await convertRegistrationToContact({ registrationId: recordId });
	            console.log('Contact created with Id:', contactId);

    
            /*{
                if (!this.approveReason) 
                    {
                        this.showToast('Error', 'Approval reason is required', 'error');
                        return; 
                } */

        
            await updateStatus({
                recordId: this.selectedRecordId,
                status: 'Approved',
                approveReason: this.approveReason
            });

            //Show message
            this.showToast('Success', 'Record Approved & Contact Created', 'success');
            //this.showToast('Success', 'Community Member Approved', 'success');


            this.records = this.records.filter(r => r.Id !== this.selectedRecordId);
            await refreshApex(this.wiredResult);
            this.closeApproveModal();

        } catch (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }
    }
    
    

    async confirmReject() 
    {
        if (!this.rejectReason) {
            this.showToast('Error', 'Rejection reason is required', 'error');
            return;
        }

        try {
            await updateStatus({
                recordId: this.selectedRecordId,
                status: 'Rejected',
                rejectReason: this.rejectReason
            });

            this.showToast('Success', 'Community Member Rejected', 'success');

            this.records = this.records.filter(r => r.Id !== this.selectedRecordId);
            refreshApex(this.wiredResult);
            this.closeRejectModal();
        } catch (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }


    closeModal() {
        this.isModalOpen = false;
    }

    closeDetailsModal() {
        this.isDetailsModalOpen = false;
    }

    closeApproveModal() {
        this.isApproveModalOpen = false;
        this.approveReason = '';
        this.selectedRecordId = null;
    }

    closeRejectModal() {
        this.isRejectModalOpen = false;
        this.rejectReason = '';
        this.selectedRecordId = null;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}