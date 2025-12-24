import { LightningElement, track, api } from 'lwc';
import isEmailRegistered from '@salesforce/apex/CheckMemberStatusController.isEmailRegistered';

export default class CheckMemberStatus extends LightningElement {
    @api cardTitle = "Check Member Status";
    @track email = '';
    @track statusMessage = '';

    handleEmailChange(event) {
       
        this.email = event.target.value.replace(/\s+/g, '').trim().toLowerCase();
        this.statusMessage = '';
    }

    validateEmail(email) {
      
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    checkStatus() {
        if (!this.email) {
            this.statusMessage = 'Please enter an email address.';
            return;
        }

        if (!this.validateEmail(this.email)) {
            this.statusMessage = 'Please enter a valid email.';
            return;
        }

       
        isEmailRegistered({ email: this.email })
            .then((status) => {
                if (status === 'Empty') {
                    this.statusMessage = 'Please enter an email.';
                } else if (status === 'Not_Found') {
                    this.statusMessage = 'No member found with this email.';
                } else {
                    this.statusMessage = 'Member status: ' + status;
                }
            })
            .catch((error) => {
                console.error('Error checking status: ', error);
                this.statusMessage = 'Error checking status. Please try again later.';
            });
    }

    resetForm() {
        this.email = '';
        this.statusMessage = '';
    }
}