# aws-Infa
created infra using terrafrom.
Prerequisite:
----------------
1) aws account && Need to configure the aws account with your Access key and Secret key.
2) terrafrom need to installed.
3) GIT Client.

# Steps to Create AWS Infra
--------------------------

1) Clone the Repo. You will get 2 directories: 1. code (application) 2. terraform (infra)
   git clone git@github.com:josepbasil/aws-Infra.git
   
2) Navigate to terrafrom directory 

3) Run the terrafrom init  command, it will Initialize the provider plugin.
       terraform init

4) Run the terrrafrom apply commad to create the infra 
        terraform apply

# Note: Using terrrafrom I am creating the aws code commit repository in AWS. So Kinldy clone the 'demo' repo.
5) Clone the 'demo' repo from AWS code commit repository. You can find it in AWS code commit tab.

6) Copy all the files from the 'code' directory (available from step 1) to 'demo' repo of step 5.

7) Push the above code which will trigger a codepipeline.



 



