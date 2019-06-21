# CSYE 6225 - Summer 2019

## Team Information

| Name | NEU ID | Email Address |
| --- | --- | --- |
| Cassian Gonsalves | 001475176 | gonsalves.c@husky.neu.edu |
| Dhanashri Palodkar | 001357556 | palodkar.d@husky.neu.edu |
| Karun Kesavadas | 001475574 | kesavadas.k@husky.neu.edu |


Please follow the steps to create AWS AMI using packer
1. Install packer
2. Configure your AWS credentials
3. Run the command packer build centos.json in terminal
4. To ssh into your AMI, create an instance of the AMI into the aws console EC2 service
5. use command ssh -i /path/my-key-pair.pem ec2-user@ec2-198-51-100-1.compute-1.amazonaws.com where ec2-user is your user name and the part ahead of @ symbol is your public DNS