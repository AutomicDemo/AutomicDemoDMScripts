# GCP Deployment Manager scripts for Automic CDA-CDD Demo environment.
The template scripts in this repository provision 4 machines with the current releases of the Automic Automation Engine, Automic Continuous Delivery Automation, and Automic Continous Delivery Director. A full Jenkins build environment, artifact storage environment, and other tools are also included.
The templates deploy the following machines.:  

| Machine Name | Type | Purpose |
| ---- | ---- | ---- |
| AEMAIN-V# | Windows | Primary Jump Server into environment. AE 12.3.1, CDA 12.3.1, AE Analytics, Automic Infrastructure Manager, AWI(Automic Web Interface), CA Test Data Manager, CA Service Virtualization, CA Agile Requirements Designer, Putty, Python 3.8 with GCP SDK, Terraform |
| AEJENKINS-V# | Windows | Jenkins, Helm Charts, Eclipse|
| AECDD2-V# | Linux | CDD, CDI, Docker, Tomcat |
| AECDD1-V# | Linux | CDD and CDI Repository (Postgres and MongoDB) |

The system is fully available about 8-10 minutes after the deployment is kicked off.

### Deployment of Environment

To execute the template you will need-
+ A GCP account and project space.
+ The easiest option is to use the [Google Cloud Shell](https://cloud.google.com/shell/docs/). You can also execute this locally using the [Google Cloud SDK](https://cloud.google.com/sdk/docs/) installed
+ Access to the private demo images on the Broadcom ESD demo project.

  - **For Broadcom Employees**: e-mail or IM **Marc Carkeek** your "Google APIs Service Agent" member account. This can be found in the [IAM Gui](https://console.cloud.google.com/iam-admin/iam). You must use your **broadcom.com** e-mail for this request.
  - **For Partners**: Contact your primary Broadcom contact.
  - I'll grant you access as soon as I am able and let you know by e-mail.
+ The following API's enabled (This is done automatically in step 4 below. ):
  - [Deployment Manager V2 API](https://console.cloud.google.com/apis/library/deploymentmanager.googleapis.com?q=deploy)
  - [Cloud DNS API](https://console.cloud.google.com/apis/library/dns.googleapis.com?q=cloud%20dns)
  - [Compute API](https://console.cloud.google.com/apis/library/compute.googleapis.com?q=compute)

##### To execute these deployment scripts in your own GCP project:

1. Log into the [Google cloud](https://cloud.google.com/) and go to the [GCP Console] (https://console.cloud.google.com/home/dashboard).

2. Click the Activate Cloud Shell button (looks like '**>\_**') in the upper right of the console window.

2. Set the active project for you session:
   `gcloud config set project <<Project ID>>`
   Eample:
   `gcloud config set project `

3. From the command line copy this repository to a location where you can run the gcloud command:  
   `git clone https://github.com/AutomicDemo/AutomicDemoDMScripts`

4. `cd` to the **AutomicDemoDMScripts/aemain-v1/templates** directory of the copied repository and execute:  
   `bash ./init-gcp-aedemo.sh`

5. Edit the **properties:** section in aemain-v1-config.yaml to deploy in your preferred region and zone. The **'stamp'** value allows you to personalize all the base-names of the objects created. You can also specify an single IP, **'myip'**, that will have RDP and SSH permissions to the boxes. See the **Set Firewall Rules** section below for more info.  

6. In the Google Cloud SDK environment execute (note: only use lowercase letters and the '-' symbol in the name):  

   `bash ./preview_deployment.sh <my-deployment-name>`

7. A preview of the environment will be generated that you can review in the [Deployment Manager GUI](https://console.cloud.google.com/dm/deployments)

8. You can deploy or cancel the environment once you have reviewed the deployment:  
  * **Deploy option 1** - Executing the gcloud command:  
     `bash ./finish_deployment.sh`
  * **Deploy option 2** - In the [Deployment Manager GUI](https://console.cloud.google.com/dm/deployments):  
    click on the right arrow next to Deploy in the Deployment preview/detail window
  * **Cancel option 1** - Execute the gcloud command:  
     `bash ./delete_deployment.sh`
  * **Cancel option 2** - Clicking on the trash icon on the Deployment preview/detail window)

### Post-Deployment Steps and Information:

##### Set firewall rules to allow access. . . but not too much access
RDP and SSH firewall rules only permit internal IP addresses from the newly created subnetwork by default. It is recommended that you add **ONLY** your personal IPV4 address(es) or a **VERY LIMITED** CIDR Block. (Ex: 192.168.1.1/32 gives access to only that IP address. 192.168.1.1/24 gives access the range 192.168.1.1 - 192.168.1.255)
1. Determine your IP by going to [What Is My IP Address](https://whatismyipaddress.com/). You will need the IPV4 address.
2. Add this the "aemain-allow-rdp-???" and "aemain-allow-ssh-???" firewall rule. **Note:** A fully defined IP address needs to have /32 at the end of it.  

- Additional notes:  
   - To access the linux machines you will need to add an ssh key to the VM profile.  
   - Passwords are the same as the default passwords for the master environment for now.  

##### Add your GCP project credentials to Automic
You will need to add your service account credentials to Automic so it can provision temporary VM's for deployments.  
To get your credentials:  
1. Go to [Create service account key](https://console.cloud.google.com/apis/credentials/serviceaccountkey) on GCP.  
2. Select your **"Compute Engine default service account"**.  
3. Select **JSON** for the key type and click **Create**.
4. In the AWI open the **Release Automation** perspective.  
5. Navigate to Provisioning > Infrastructure Providers
6. Click the Add button in the toolbar.
7. In the dialog, enter an infrastructure provider name (EX: GCP_MYDEMO).
8. Select **Google Cloud** for type and click **Next**.  
9. In the next dialog select the JSON file you downloaded in step 3 and click **ADD**.

##### Update GCP project setting variables.
1. In the AWI client click in the search box in the upper right and type **VARA.GCP.INFO**
2. Click on the Vara object it finds to edit it.
3. Update the IM_PROVIDER row so it matches the name of the Infra. Provider you created in the previous section. ALL OTHER VALUES WILL AUTOMATICALLY UPDATE THE FIRST TIME YOU RUN THE DEMO.   

##### Working with the demo system.

The 'automic' user on AEMAIN-V1 can be used to access AWI/CDA, CDD, Jenkins, Github, and Rally. User names and passwords are saved in the Chrome browser and links to all the applications are in the Bookmarks Bar.

Starting the demo:  
- In Jenkins build the DigitalBankingAppPayment app. This will start the Release in CDD when it is finished.
- You can set up your own Github user and repoint the DigitalBankingAppPayment to that. You can then trigger the build with a code change.

##### Deleting your deployment

**WARNING: All objects created by your deployment will be permanently deleted with this process. Any changes will be lost"**

If you want to delete all the resources for a deployment:  
1. Click the Activate Cloud Shell button (looks like '**>\_**') in the upper right of the console window.
2. `cd` to the **AutomicDemoDMScripts/aemain-v1/templates** directory and execute:
    `bash .\delete_deployment.sh`
3. Select the deployment you with to delete.

Note: If you try to delete an Automic Demo deployment from the Deployment Manger GUI not all the objects will be removed. Currently Deployment Manager is unable to remove DNS Record sets.

###Appendix
####Appendix I: VARA.GCP.INFO Variable
| Variable | Desc | Value |
| ------------ | ------------- | ------------- |
| IM_PROVIDER| Infra. Provider (CDA) | Provider name created in step 7 of previous section (EX: GCP_MYDEMO) |
| PROJECT | GCP Project Name | Can be displayed by executing the following command on AEMAIN VM:  `curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"` |
| REGION | GCP Region of Deployed Demo | Ex: 'us-east1'. Can be displayed by executing the following command on AEMAIN VM:  `curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google"` |
| SERVICEACCOUNT | GCP "Compute Engine default service account" | This is your GCP Project Number with the suffix *'-compute@developer.gserviceaccount.com'*. Can be displayed by executing the following command on AEMAIN VM:  `curl "http://metadata.google.internal/computeMetadata/v1/project/numeric-project-id" -H "Metadata-Flavor: Google"` |
| SUBNETWORK | Subnetwork of deployed demo system | Set by deployment: aemain-v1-subnet-**STAMP VALUE** (Ex: aemain-v1-subnet-mine) |
| ZONE | GCP Zone of Deployed Demo | Ex: 'us-east1-c'. Can be displayed by executing the following command on AEMAIN VM:  `curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google"` |
