import { LightningElement, track, wire } from 'lwc';
import saveRegistrationWithFile from '@salesforce/apex/CommunityRegistrationController.saveRegistrationWithFile';
import checkDuplicateEmail from '@salesforce/apex/CommunityRegistrationController.checkDuplicateEmail';
import checkDuplicateMobile from '@salesforce/apex/CommunityRegistrationController.checkDuplicateMobile';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Schema imports
import GENDER from '@salesforce/schema/Community_Member_Registration_Form__c.Gender__c';
import SALUTATION from '@salesforce/schema/Community_Member_Registration_Form__c.Salutation__c';
import COUNTRY from '@salesforce/schema/Community_Member_Registration_Form__c.Country__c';
import STATE from '@salesforce/schema/Community_Member_Registration_Form__c.State__c';
import OCCUPATION from '@salesforce/schema/Community_Member_Registration_Form__c.Occupation__c';
import PROOFOFIDENTITY from '@salesforce/schema/Community_Member_Registration_Form__c.Proof_of_Identity__c';

export default class CommunityRegistrationFormWithFile extends LightningElement {

    // 1. form fields
    @track form = {
        firstName: '',
        lastName: '',
        mobileNumber: '',
        email: '',
        confirmEmail: '',
        annualIncome: '',
        zipcode: '',
        addressLine1: '',
        addressLine2: '',
        salutation: '',
        gender: '',
        country: '',
        state: '',
        occupation: '',
        proofOfIdentity: '',
        city: ''
    };

    // 2. picklist options
    @track salutationOptions = [];
    @track genderOptions = [];
    @track countryOptions = [];
    @track stateOptions = [];
    @track occupationOptions = [];
    @track proofOfIdentityOptions = [];

    // 3. errors
    @track errors = { email: '', confirmEmail: '', mobileNumber: '' };
    isEmailDuplicate = false;
    isMobileDuplicate = false;

    // 4. file upload
    @track fileData; // base64, filename, type
    @track fileName;
    @track isFileLoading = false;

    // 5. get picklist values
    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: SALUTATION })
    wiredSal({ data }) { if (data) this.salutationOptions = data.values; }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: GENDER })
    wiredGender({ data }) { if (data) this.genderOptions = data.values; }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: COUNTRY })
    wiredCountry({ data }) { if (data) this.countryOptions = data.values; }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: STATE })
    wiredState({ data }) { if (data) this.stateOptions = data.values; }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: OCCUPATION })
    wiredOccupation({ data }) { if (data) this.occupationOptions = data.values; }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: PROOFOFIDENTITY })
    wiredProof({ data }) { if (data) this.proofOfIdentityOptions = data.values; }

    // 6. handle input change (generic)
    handleChange(event) {
        const field = event.target.dataset.field;
        this.form[field] = event.target.value?.trim(); // save value
        this.clearFieldError(field); // remove error if any

        // simple zipcode validation
        if(field === 'zipcode') {
            const zip = this.form.zipcode;
            if(/\D/.test(this.form.zipcode)) {
                this.setFieldError('zipcode', 'Zipcode must be numbers only');
            }
           
            // Max length check (example: more than 6 digits)
            if (zip.length > 6) {
            this.setFieldError('zipcode', 'Zipcode cannot exceed 6 digits');
            return;
    }
        }
    }

        // 7. email validation
         handleEmailChange(event) { 
            this.form.email = event.target.value.trim().toLowerCase();
            this.clearFieldError('email');
            this.isEmailDuplicate = false;
        }

        handleEmailBlur() {
        const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const allowedDomains = ['gmail.com','yahoo.com','outlook.com','hotmail.com'];
        const email = this.form.email;

        if(!EMAIL_REGEX.test(email)) {
            this.setFieldError('email','Invalid email format');
            this.isEmailDuplicate = true;
            return;
        }

        const parts = email.split('@');
        if(parts.length !== 2 || !allowedDomains.includes(parts[1].toLowerCase())) {
            this.setFieldError('email','Email domain not allowed');
            this.isEmailDuplicate = true;
            return;
        }

        checkDuplicateEmail({ email })
            .then(result => {
                if(result){
                    this.setFieldError('email','Email already registered');
                    this.isEmailDuplicate = true;
                } else {
                    this.clearFieldError('email');
                    this.isEmailDuplicate = false;
                }
            })
            .catch(err => console.error(err));
    }

    handleConfirmEmailChange(event) {
        this.form.confirmEmail = event.target.value.trim().toLowerCase();
        this.clearFieldError('confirmEmail');
    }

    handleConfirmEmailBlur() {
        if(this.form.confirmEmail !== this.form.email){
            this.setFieldError('confirmEmail','Confirm Email does not match');
        } else {
            this.clearFieldError('confirmEmail');
        }
    }

    // 8. mobile validation
    handleMobileChange(event) {
        this.form.mobileNumber = event.target.value.trim();
        this.clearFieldError('mobileNumber');
        this.isMobileDuplicate = false;
    }

    handleMobileBlur() {
        const REGEX = /^[0-9]{10}$/;
        const mobile = this.form.mobileNumber;

        if(!REGEX.test(mobile)){
            this.setFieldError('mobileNumber','Mobile must be 10 digits');
            this.isMobileDuplicate = true;
            return;
        }

        checkDuplicateMobile({ mobileNumber: mobile })
            .then(result => {
                if(result){
                    this.setFieldError('mobileNumber','Mobile already registered');
                    this.isMobileDuplicate = true;
                } else {
                    this.clearFieldError('mobileNumber');
                    this.isMobileDuplicate = false;
                }
            })
            .catch(err => console.error(err));
    }

    // 9. set and clear errors
    setFieldError(field,msg){
        this.errors[field] = msg;
        const input = this.template.querySelector(`[data-field="${field}"]`);
        if(input){ input.setCustomValidity(msg); input.reportValidity(); }
    }

    clearFieldError(field){
        this.errors[field] = '';
        const input = this.template.querySelector(`[data-field="${field}"]`);
        if(input){ input.setCustomValidity(''); input.reportValidity(); }
    }

    // 10. file upload
    handleFileChange(event){
        const file = event.target.files[0];
        if(file){
            if(file.size > 5*1024*1024){
                this.showToast('Error','File cannot exceed 5MB','error');
                this.fileName = null;
                this.fileData = null;
                return;
            }
            this.fileName = file.name;

            const reader = new FileReader();
            reader.onload = () => {
                const base64 = reader.result.split(',')[1];
                this.fileData = { base64, filename: file.name, type: file.type };
            }
            reader.readAsDataURL(file);
        }
    }

    removeFile(){
        this.fileData = null;
        this.fileName = null;
        this.template.querySelector('input[type="file"]').value = null;
    }

    // 11. disable submit button logic
    get disableSubmit(){
        const f = this.form;
        return this.isFileLoading || !(
            f.firstName && f.lastName && f.email && f.confirmEmail &&
            f.mobileNumber && f.gender && f.occupation && f.state &&
            f.country && f.city && f.zipcode &&
            f.proofOfIdentity && f.addressLine1 && f.salutation &&
            this.fileData
        ) || this.errors.email || this.errors.confirmEmail || this.errors.mobileNumber ||
            this.isEmailDuplicate || this.isMobileDuplicate;
    }

    // 12. submit form
    handleSubmit(){
        if(this.disableSubmit){
            this.showToast('Error','Fill all fields correctly and upload ID Proof','error');
            return;
        }

        saveRegistrationWithFile({
            fileName: this.fileData.filename,
            base64Data: this.fileData.base64,
            contentType: this.fileData.type,
            salutation: this.form.salutation,
            firstName: this.form.firstName,
            lastName: this.form.lastName,
            mobileNumber: this.form.mobileNumber,
            email: this.form.email,
            confirmEmail: this.form.confirmEmail,
            gender: this.form.gender,
            occupation: this.form.occupation,
            state: this.form.state,
            annualIncome: this.form.annualIncome,
            country: this.form.country,
            city: this.form.city,
            zipcode: this.form.zipcode,
            proofOfIdentity: this.form.proofOfIdentity,
            addressLine1: this.form.addressLine1,
            addressLine2: this.form.addressLine2,
            approvalStatus: 'Pending'
        })
        .then(()=> {
            this.showToast('Success','Registration Successful','success');
            this.resetForm();
        })
        
        .catch(err => {
            console.error(err);
            this.showToast('Error','Error saving registration','error');
        });
    }

    // 13. reset form
    resetForm(){
        Object.keys(this.form).forEach(key => this.form[key]='');
        Object.keys(this.errors).forEach(key => this.errors[key]='');
        this.isEmailDuplicate = false;
        this.isMobileDuplicate = false;
        this.removeFile();
    }

    // 14. toast helper
    showToast(title,message,variant){
        this.dispatchEvent(new ShowToastEvent({title,message,variant}));
    }
}